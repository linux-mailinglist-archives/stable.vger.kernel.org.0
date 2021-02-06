Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D35311C42
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 09:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbhBFIoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Feb 2021 03:44:12 -0500
Received: from www.linuxtv.org ([130.149.80.248]:44896 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229715AbhBFIoA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 6 Feb 2021 03:44:00 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1l8JBT-00Ec3F-QG; Sat, 06 Feb 2021 08:43:15 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Sat, 06 Feb 2021 08:31:03 +0000
Subject: [git:media_tree/master] media: marvell-ccic: power up the device on mclk enable
To:     linuxtv-commits@linuxtv.org
Cc:     Lubomir Rintel <lkundrak@v3.sk>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1l8JBT-00Ec3F-QG@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: marvell-ccic: power up the device on mclk enable
Author:  Lubomir Rintel <lkundrak@v3.sk>
Date:    Wed Jan 27 19:01:43 2021 +0100

Writing to REG_CLKCTRL with the power off causes a hang. Enable the
device first.

Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/platform/marvell-ccic/mcam-core.c | 2 ++
 1 file changed, 2 insertions(+)

---

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 153277e4fe80..141bf5d97a04 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -931,6 +931,7 @@ static int mclk_enable(struct clk_hw *hw)
 		mclk_div = 2;
 	}
 
+	pm_runtime_get_sync(cam->dev);
 	clk_enable(cam->clk[0]);
 	mcam_reg_write(cam, REG_CLKCTRL, (mclk_src << 29) | mclk_div);
 	mcam_ctlr_power_up(cam);
@@ -944,6 +945,7 @@ static void mclk_disable(struct clk_hw *hw)
 
 	mcam_ctlr_power_down(cam);
 	clk_disable(cam->clk[0]);
+	pm_runtime_put(cam->dev);
 }
 
 static unsigned long mclk_recalc_rate(struct clk_hw *hw,
