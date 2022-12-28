Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD1D657F90
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234342AbiL1QG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:06:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234358AbiL1QGL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:06:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02365178AF
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:06:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86C736156B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:06:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98FCEC433EF;
        Wed, 28 Dec 2022 16:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243563;
        bh=jA5Lh04MvNxyrxnmTEl1cwIoiZqzyvMPI9M/23RBUKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rAAquMYO7ltKzRp8w0yQiYzYw9A/8LXdlBLXJLr1ra8PISsSKLnw48YzkcBRU9Kag
         PI1DAA4uQ8mYShicrL8hG/2ZiZ9l0urQrcrVfTHjhxHzBSq0zo4EZQF7L35UJ49DEl
         DYJa226CpNwhgH2xOhb91c6A8z1fp5Q71KowYGVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gabriel Somlo <gsomlo@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0504/1146] mmc: litex_mmc: ensure `host->irq == 0` if polling
Date:   Wed, 28 Dec 2022 15:34:03 +0100
Message-Id: <20221228144343.866273542@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gabriel Somlo <gsomlo@gmail.com>

[ Upstream commit 5c1a2b77cd1b59112cf22b3e338f7e416797ad32 ]

Ensure the flag is explicitly set to 0 if we determine that polling is
needed during driver probe, to cover all possible cases.

Fixes: 92e099104729 ("mmc: Add driver for LiteX's LiteSDCard interface")
Signed-off-by: Gabriel Somlo <gsomlo@gmail.com>
Link: https://lore.kernel.org/r/20221107155516.2535912-1-gsomlo@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/litex_mmc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/litex_mmc.c b/drivers/mmc/host/litex_mmc.c
index 6ba0d63b8c07..39c6707fdfdb 100644
--- a/drivers/mmc/host/litex_mmc.c
+++ b/drivers/mmc/host/litex_mmc.c
@@ -502,6 +502,7 @@ static int litex_mmc_irq_init(struct platform_device *pdev,
 
 use_polling:
 	host->mmc->caps |= MMC_CAP_NEEDS_POLL;
+	host->irq = 0;
 	return 0;
 }
 
-- 
2.35.1



