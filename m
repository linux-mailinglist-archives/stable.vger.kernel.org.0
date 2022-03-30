Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B7A4EC2C6
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 14:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344259AbiC3MBN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 08:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344453AbiC3L4D (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:56:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4CE6626F;
        Wed, 30 Mar 2022 04:54:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A62CE615E7;
        Wed, 30 Mar 2022 11:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D04C340EE;
        Wed, 30 Mar 2022 11:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641245;
        bh=TjnvLi83cOFFJf6NtahCnNbN2EUZK9664M/61JhVXLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A8dkv29HAscXL091jZOtUt0iIxvnXD7qgVJ+WD6UTl54T0FmLMD9Xy3ulrZabE6N+
         d5SzaIVMPeeTV5HosUylbIZ2FnTsBaJpvPjDjTqchg6W7agVO1Q4YxM3qYipv/uOrt
         A7WE7d5ckzoa0yRmw60QIapkCsmDpAG2SMl6zEgdJ/XS09uWvDcwO8FTf2wGJQ0qLk
         8hBwhcYW6Rl+lKs2+coXXADPi4ijU9/NseccOfDgjWelmV2g0NNCq1m8fHxAuKmFqK
         XRlSpsyjX6RiMn7pQgaTMVFQPphKPcDTe9G9Js9QsaKjYTWd5TwyHOTwPLHodbQY1C
         84/No33KKEcFw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 19/20] mmc: host: Return an error when ->enable_sdio_irq() ops is missing
Date:   Wed, 30 Mar 2022 07:53:35 -0400
Message-Id: <20220330115336.1672930-19-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115336.1672930-1-sashal@kernel.org>
References: <20220330115336.1672930-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit d6c9219ca1139b74541b2a98cee47a3426d754a9 ]

Even if the current WARN() notifies the user that something is severely
wrong, we can still end up in a PANIC() when trying to invoke the missing
->enable_sdio_irq() ops. Therefore, let's also return an error code and
prevent the host from being added.

While at it, move the code into a separate function to prepare for
subsequent changes and for further host caps validations.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20220303165142.129745-1-ulf.hansson@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/host.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 3740fb0052a4..4da2bcfd0649 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -401,6 +401,16 @@ struct mmc_host *mmc_alloc_host(int extra, struct device *dev)
 
 EXPORT_SYMBOL(mmc_alloc_host);
 
+static int mmc_validate_host_caps(struct mmc_host *host)
+{
+	if (host->caps & MMC_CAP_SDIO_IRQ && !host->ops->enable_sdio_irq) {
+		dev_warn(host->parent, "missing ->enable_sdio_irq() ops\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /**
  *	mmc_add_host - initialise host hardware
  *	@host: mmc host
@@ -413,8 +423,9 @@ int mmc_add_host(struct mmc_host *host)
 {
 	int err;
 
-	WARN_ON((host->caps & MMC_CAP_SDIO_IRQ) &&
-		!host->ops->enable_sdio_irq);
+	err = mmc_validate_host_caps(host);
+	if (err)
+		return err;
 
 	err = device_add(&host->class_dev);
 	if (err)
-- 
2.34.1

