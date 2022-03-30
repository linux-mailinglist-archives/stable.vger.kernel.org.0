Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46ABC4EC1E6
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344839AbiC3L5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345687AbiC3Ly4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:54:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85625261DD3;
        Wed, 30 Mar 2022 04:51:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29F3FB81C25;
        Wed, 30 Mar 2022 11:51:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46569C340F2;
        Wed, 30 Mar 2022 11:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641076;
        bh=jpH1FFqHwA9Rcvx435BbU8+Ijry2x5lxT/g9E4on9Sg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VoyyspTVbyHZOr92I1O5IUm1KP7Z4vnEkXKnQ5UQGhz2cEDeskyTNiEsRBiEIhJ4V
         u15uXQLyQKZavcw5lpfOHU+EVq1Hjz/b1K4XvQi+tsbr8rK7nUlZGsBMCllTiF2+cW
         kXkIlBNnak1dZ0OT7YZc0Zuo7K9lzOD5p/7qj7CQKEUz+JJy2iQ6h7MBrhp60OfU2I
         NfTD76/IqJas9hXhL4OzjBivEU58QWPGK5r+7nl/r5b02JlEWi00Cld9vy8wP5ZjMQ
         BoPdR//zf7SUGcJ9P5E2JOT5oOoF/fx8FvPwmBckdbQRnmHHLG51NXY/Z3FjGDich7
         b5uh/SRUUNKaA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 47/50] mmc: host: Return an error when ->enable_sdio_irq() ops is missing
Date:   Wed, 30 Mar 2022 07:50:01 -0400
Message-Id: <20220330115005.1671090-47-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115005.1671090-1-sashal@kernel.org>
References: <20220330115005.1671090-1-sashal@kernel.org>
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
index cf140f4ec864..d739e2b631fe 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -588,6 +588,16 @@ struct mmc_host *mmc_alloc_host(int extra, struct device *dev)
 
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
@@ -600,8 +610,9 @@ int mmc_add_host(struct mmc_host *host)
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

