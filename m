Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA511141212
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 21:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729316AbgAQUFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 15:05:41 -0500
Received: from first.geanix.com ([116.203.34.67]:54878 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727519AbgAQUFl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jan 2020 15:05:41 -0500
Received: from localhost (87-49-44-45-mobile.dk.customer.tdc.net [87.49.44.45])
        by first.geanix.com (Postfix) with ESMTPSA id A1778AB85D;
        Fri, 17 Jan 2020 20:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1579291490; bh=1GLtPwg7JdswZinMsh5MjBCQQjQEWaf+P1IDgjM0YLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=F/zPL3CMRnimda2fRV7CLQo6cnt6b/EeyJScsHMKxMi6hiSmzoNjEQzZu4D8Aw81h
         XuCEvmb/mB1TBLrzNW0xKmeXHiMLEul1oGM+sYoXVKm1RS8a7WO6F6GqdlnBv8jGM3
         2uqEEXfmYtAc6DoZXuQT1a1GbQ+3Lzo+2LrggUl16T4T0pGWkGRp4wZOKQk03q1R6s
         kqVHCIMc+l8X1p8W/emJqkd+dMTWgAA9UEiM/hCamv91v3t6SxcaYciAbYzlQyGAHm
         NS4MhpkvCijYCHhkYaJxrIpdVDQQzkUxJDQ1OZhzk+5J0Ls/1Qd14dicBj/ZkI0F6K
         YaJofEoxrUr9A==
From:   Esben Haabendal <esben@geanix.com>
To:     linux-mtd@lists.infradead.org,
        Sascha Hauer <s.hauer@pengutronix.de>, Han Xu <han.xu@nxp.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Boris Brezillon <boris.brezillon@collabora.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>, stable@vger.kernel.org
Subject: [PATCH v2 1/2] mtd: rawnand: gpmi: Fix suspend/resume problem
Date:   Fri, 17 Jan 2020 21:05:36 +0100
Message-Id: <20200117200537.9279-2-esben@geanix.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200117200537.9279-1-esben@geanix.com>
References: <20200117200537.9279-1-esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=4.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=disabled
        version=3.4.3
X-Spam-Checker-Version: SpamAssassin 3.4.3 (2019-12-06) on ea2d15de10a4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On system resume, the gpmi clock must be enabled before accessing gpmi
block.  Without this, resume causes something like

[  661.348790] gpmi_reset_block(5cbb0f7e): module reset timeout
[  661.348889] gpmi-nand 1806000.gpmi-nand: Error setting GPMI : -110
[  661.348928] PM: dpm_run_callback(): platform_pm_resume+0x0/0x44 returns -110
[  661.348961] PM: Device 1806000.gpmi-nand failed to resume: error -110

Fixes: ef347c0cfd61 ("mtd: rawnand: gpmi: Implement exec_op")
Cc: stable@vger.kernel.org
Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
index 334fe3130285..879df8402446 100644
--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -148,6 +148,10 @@ static int gpmi_init(struct gpmi_nand_data *this)
 	struct resources *r = &this->resources;
 	int ret;
 
+	ret = pm_runtime_get_sync(this->dev);
+	if (ret < 0)
+		return ret;
+
 	ret = gpmi_reset_block(r->gpmi_regs, false);
 	if (ret)
 		goto err_out;
@@ -179,8 +183,9 @@ static int gpmi_init(struct gpmi_nand_data *this)
 	 */
 	writel(BM_GPMI_CTRL1_DECOUPLE_CS, r->gpmi_regs + HW_GPMI_CTRL1_SET);
 
-	return 0;
 err_out:
+	pm_runtime_mark_last_busy(this->dev);
+	pm_runtime_put_autosuspend(this->dev);
 	return ret;
 }
 
-- 
2.25.0

