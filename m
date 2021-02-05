Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B300E310F0D
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 18:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbhBEQEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 11:04:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:54904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233540AbhBEQC0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 11:02:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC1EC650CD;
        Fri,  5 Feb 2021 14:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612534742;
        bh=IsqTu5U4jAeaoIgHjiiLYMtjGgreQQGXa+ZI9MgTDPQ=;
        h=From:To:Cc:Subject:Date:From;
        b=WN1xbVFDXQBWBmHuFJJvxgzEHk6Pi9fuqm+bMdljHoy/24H1PjdnWkKOKe77q+APf
         VDUynbay+Pmo3z/x9Q9ZDFbEBGPw7zc7QRyuavce7aYxKwY30dGWXLa5h6QO9SeCuJ
         TqgWWq6NWz0sKzfs3klc4Y5hoJoPvnZFgn5E+Q4in2GKIFCM31huRv2denjq46qRNX
         aKJsW2MD+Hin2+yhLF1VZ2/cLRY+ZvAA+e821c1Gz9QCNt3LmiLCJHvK+5SPrcDMEu
         eTrSvp4Is7i/xpWdN2IP0V3vtcNPuhtgZD3D6kcKnXLUmgA841oPmsrL4qKr7N/8rE
         w/TgIGAjF6A8w==
From:   Peter Chen <peter.chen@kernel.org>
To:     mahongwei@zeku.com
Cc:     wangqinyuan@zeku.com, chengwei@zeku.com,
        Hongwei Ma <mahongwei_123@126.com>, stable@vger.kernel.org,
        Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 1/1] mmc: core: sdio_bus: call sdio_free_func_cis only for standard SDIO card
Date:   Fri,  5 Feb 2021 22:18:45 +0800
Message-Id: <20210205141845.21701-1-peter.chen@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hongwei Ma <mahongwei_123@126.com>

tuple is only allcated for standard SDIO card, especially it causes memory
corruption issue when the non-standard SDIO card has removed since the card
device's reference counter does not increase for it at sdio_init_func, but
all SDIO card device reference counter has decreased at sdio_release_func.

Cc: <stable@vger.kernel.org> #v5.4+
Signed-off-by: Peter Chen <peter.chen@kernel.org>
---
 drivers/mmc/core/sdio_bus.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index 3d709029e07c..50279f805a53 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -292,7 +292,8 @@ static void sdio_release_func(struct device *dev)
 {
 	struct sdio_func *func = dev_to_sdio_func(dev);
 
-	sdio_free_func_cis(func);
+	if (!(card->quirks & MMC_QUIRK_NONSTD_SDIO))
+		sdio_free_func_cis(func);
 
 	kfree(func->info);
 	kfree(func->tmpbuf);
-- 
2.17.1

