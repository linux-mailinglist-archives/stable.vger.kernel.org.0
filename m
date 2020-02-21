Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D68ED167372
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732837AbgBUIMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:12:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:48164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732835AbgBUIMY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:12:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0690720722;
        Fri, 21 Feb 2020 08:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272743;
        bh=/kSJUdQ1ahCq/N2iGkEHHNNjI4ZS98H5v/xzEyM8kXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UdlHq2C0nsp9d/KygMhcnlHHdgxwBfJZkT8cGSsp1mO/X4Bj37d2HujtZ2sLVgGNK
         IDm8r9I2l7Tx/kJvKGcRRh1QnKl4HUGIFakK26Ox9hxgdgDz7exaEnOtXyA1Ph8yNS
         H+4QubjZ5WTeE/bn+qxWrMQvIIJrhPYoNztrTElE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 257/344] regulator: vctrl-regulator: Avoid deadlock getting and setting the voltage
Date:   Fri, 21 Feb 2020 08:40:56 +0100
Message-Id: <20200221072412.921814070@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enric Balletbo i Serra <enric.balletbo@collabora.com>

[ Upstream commit e9153311491da9d9863ead9888a1613531cb4a1b ]

`cat /sys/kernel/debug/regulator/regulator_summary` ends on a deadlock
when you have a voltage controlled regulator (vctrl).

The problem is that the vctrl_get_voltage() and vctrl_set_voltage() calls the
regulator_get_voltage() and regulator_set_voltage() and that will try to lock
again the dependent regulators (the regulator supplying the control voltage).

Fix the issue by exporting the unlocked version of the regulator_get_voltage()
and regulator_set_voltage() API so drivers that need it, like the voltage
controlled regulator driver can use it.

Fixes: f8702f9e4aa7 ("regulator: core: Use ww_mutex for regulators locking")
Reported-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Link: https://lore.kernel.org/r/20200116094543.2847321-1-enric.balletbo@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c            |  2 ++
 drivers/regulator/vctrl-regulator.c | 38 +++++++++++++++++------------
 2 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 1dba0bdf37623..c6fa0f4451aeb 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3462,6 +3462,7 @@ int regulator_set_voltage_rdev(struct regulator_dev *rdev, int min_uV,
 out:
 	return ret;
 }
+EXPORT_SYMBOL(regulator_set_voltage_rdev);
 
 static int regulator_limit_voltage_step(struct regulator_dev *rdev,
 					int *current_uV, int *min_uV)
@@ -4026,6 +4027,7 @@ int regulator_get_voltage_rdev(struct regulator_dev *rdev)
 		return ret;
 	return ret - rdev->constraints->uV_offset;
 }
+EXPORT_SYMBOL(regulator_get_voltage_rdev);
 
 /**
  * regulator_get_voltage - get regulator output voltage
diff --git a/drivers/regulator/vctrl-regulator.c b/drivers/regulator/vctrl-regulator.c
index 9a9ee81881098..cbadb1c996790 100644
--- a/drivers/regulator/vctrl-regulator.c
+++ b/drivers/regulator/vctrl-regulator.c
@@ -11,10 +11,13 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/regulator/coupler.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/of_regulator.h>
 #include <linux/sort.h>
 
+#include "internal.h"
+
 struct vctrl_voltage_range {
 	int min_uV;
 	int max_uV;
@@ -79,7 +82,7 @@ static int vctrl_calc_output_voltage(struct vctrl_data *vctrl, int ctrl_uV)
 static int vctrl_get_voltage(struct regulator_dev *rdev)
 {
 	struct vctrl_data *vctrl = rdev_get_drvdata(rdev);
-	int ctrl_uV = regulator_get_voltage(vctrl->ctrl_reg);
+	int ctrl_uV = regulator_get_voltage_rdev(vctrl->ctrl_reg->rdev);
 
 	return vctrl_calc_output_voltage(vctrl, ctrl_uV);
 }
@@ -90,16 +93,16 @@ static int vctrl_set_voltage(struct regulator_dev *rdev,
 {
 	struct vctrl_data *vctrl = rdev_get_drvdata(rdev);
 	struct regulator *ctrl_reg = vctrl->ctrl_reg;
-	int orig_ctrl_uV = regulator_get_voltage(ctrl_reg);
+	int orig_ctrl_uV = regulator_get_voltage_rdev(ctrl_reg->rdev);
 	int uV = vctrl_calc_output_voltage(vctrl, orig_ctrl_uV);
 	int ret;
 
 	if (req_min_uV >= uV || !vctrl->ovp_threshold)
 		/* voltage rising or no OVP */
-		return regulator_set_voltage(
-			ctrl_reg,
+		return regulator_set_voltage_rdev(ctrl_reg->rdev,
 			vctrl_calc_ctrl_voltage(vctrl, req_min_uV),
-			vctrl_calc_ctrl_voltage(vctrl, req_max_uV));
+			vctrl_calc_ctrl_voltage(vctrl, req_max_uV),
+			PM_SUSPEND_ON);
 
 	while (uV > req_min_uV) {
 		int max_drop_uV = (uV * vctrl->ovp_threshold) / 100;
@@ -114,9 +117,10 @@ static int vctrl_set_voltage(struct regulator_dev *rdev,
 		next_uV = max_t(int, req_min_uV, uV - max_drop_uV);
 		next_ctrl_uV = vctrl_calc_ctrl_voltage(vctrl, next_uV);
 
-		ret = regulator_set_voltage(ctrl_reg,
+		ret = regulator_set_voltage_rdev(ctrl_reg->rdev,
+					    next_ctrl_uV,
 					    next_ctrl_uV,
-					    next_ctrl_uV);
+					    PM_SUSPEND_ON);
 		if (ret)
 			goto err;
 
@@ -130,7 +134,8 @@ static int vctrl_set_voltage(struct regulator_dev *rdev,
 
 err:
 	/* Try to go back to original voltage */
-	regulator_set_voltage(ctrl_reg, orig_ctrl_uV, orig_ctrl_uV);
+	regulator_set_voltage_rdev(ctrl_reg->rdev, orig_ctrl_uV, orig_ctrl_uV,
+				   PM_SUSPEND_ON);
 
 	return ret;
 }
@@ -155,9 +160,10 @@ static int vctrl_set_voltage_sel(struct regulator_dev *rdev,
 
 	if (selector >= vctrl->sel || !vctrl->ovp_threshold) {
 		/* voltage rising or no OVP */
-		ret = regulator_set_voltage(ctrl_reg,
+		ret = regulator_set_voltage_rdev(ctrl_reg->rdev,
+					    vctrl->vtable[selector].ctrl,
 					    vctrl->vtable[selector].ctrl,
-					    vctrl->vtable[selector].ctrl);
+					    PM_SUSPEND_ON);
 		if (!ret)
 			vctrl->sel = selector;
 
@@ -173,9 +179,10 @@ static int vctrl_set_voltage_sel(struct regulator_dev *rdev,
 		else
 			next_sel = vctrl->vtable[vctrl->sel].ovp_min_sel;
 
-		ret = regulator_set_voltage(ctrl_reg,
+		ret = regulator_set_voltage_rdev(ctrl_reg->rdev,
 					    vctrl->vtable[next_sel].ctrl,
-					    vctrl->vtable[next_sel].ctrl);
+					    vctrl->vtable[next_sel].ctrl,
+					    PM_SUSPEND_ON);
 		if (ret) {
 			dev_err(&rdev->dev,
 				"failed to set control voltage to %duV\n",
@@ -195,9 +202,10 @@ static int vctrl_set_voltage_sel(struct regulator_dev *rdev,
 err:
 	if (vctrl->sel != orig_sel) {
 		/* Try to go back to original voltage */
-		if (!regulator_set_voltage(ctrl_reg,
+		if (!regulator_set_voltage_rdev(ctrl_reg->rdev,
+					   vctrl->vtable[orig_sel].ctrl,
 					   vctrl->vtable[orig_sel].ctrl,
-					   vctrl->vtable[orig_sel].ctrl))
+					   PM_SUSPEND_ON))
 			vctrl->sel = orig_sel;
 		else
 			dev_warn(&rdev->dev,
@@ -482,7 +490,7 @@ static int vctrl_probe(struct platform_device *pdev)
 		if (ret)
 			return ret;
 
-		ctrl_uV = regulator_get_voltage(vctrl->ctrl_reg);
+		ctrl_uV = regulator_get_voltage_rdev(vctrl->ctrl_reg->rdev);
 		if (ctrl_uV < 0) {
 			dev_err(&pdev->dev, "failed to get control voltage\n");
 			return ctrl_uV;
-- 
2.20.1



