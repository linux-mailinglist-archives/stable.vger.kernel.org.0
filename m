Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30923C3AB0
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 18:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbfJAQjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 12:39:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbfJAQjZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 12:39:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58B532168B;
        Tue,  1 Oct 2019 16:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569947964;
        bh=sdWjKc7950Ix1oAlzn3Bdm8pbL63ww+3W/0cLP/FqRI=;
        h=From:To:Cc:Subject:Date:From;
        b=lcMSEn1iwSYiXpzEX/NXKetKJPHm1YTvbJ/HdTCfJnJ5kJbveV4SsHzjVEZQppWg7
         yvMf48oSC1BomSPh+Ksi4NTScQRl8Fz/99VlSMP94QeWtiQ8LqfnIKWnpPLj6YPvfb
         R254JFg47OUEZzBEYC5fS/9UwYb4HPSvQ1Ihu1rQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 01/71] drivers: thermal: qcom: tsens: Fix memory leak from qfprom read
Date:   Tue,  1 Oct 2019 12:38:11 -0400
Message-Id: <20191001163922.14735-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 6b8249abb093551ef173d13a25ed0044d5dd33e0 ]

memory returned as part of nvmem_read via qfprom_read should be
freed by the consumer once done.
Existing code is not doing it so fix it.

Below memory leak detected by kmemleak
   [<ffffff80088b7658>] kmemleak_alloc+0x50/0x84
    [<ffffff80081df120>] __kmalloc+0xe8/0x168
    [<ffffff80086db350>] nvmem_cell_read+0x30/0x80
    [<ffffff8008632790>] qfprom_read+0x4c/0x7c
    [<ffffff80086335a4>] calibrate_v1+0x34/0x204
    [<ffffff8008632518>] tsens_probe+0x164/0x258
    [<ffffff80084e0a1c>] platform_drv_probe+0x80/0xa0
    [<ffffff80084de4f4>] really_probe+0x208/0x248
    [<ffffff80084de2c4>] driver_probe_device+0x98/0xc0
    [<ffffff80084dec54>] __device_attach_driver+0x9c/0xac
    [<ffffff80084dca74>] bus_for_each_drv+0x60/0x8c
    [<ffffff80084de634>] __device_attach+0x8c/0x100
    [<ffffff80084de6c8>] device_initial_probe+0x20/0x28
    [<ffffff80084dcbb8>] bus_probe_device+0x34/0x7c
    [<ffffff80084deb08>] deferred_probe_work_func+0x6c/0x98
    [<ffffff80080c3da8>] process_one_work+0x160/0x2f8

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Acked-by: Amit Kucheria <amit.kucheria@linaro.org>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/qcom/tsens-8960.c |  2 ++
 drivers/thermal/qcom/tsens-v0_1.c | 12 ++++++++++--
 drivers/thermal/qcom/tsens-v1.c   |  1 +
 drivers/thermal/qcom/tsens.h      |  1 +
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/qcom/tsens-8960.c b/drivers/thermal/qcom/tsens-8960.c
index 8d9b721dadb65..e46a4e3f25c42 100644
--- a/drivers/thermal/qcom/tsens-8960.c
+++ b/drivers/thermal/qcom/tsens-8960.c
@@ -229,6 +229,8 @@ static int calibrate_8960(struct tsens_priv *priv)
 	for (i = 0; i < num_read; i++, s++)
 		s->offset = data[i];
 
+	kfree(data);
+
 	return 0;
 }
 
diff --git a/drivers/thermal/qcom/tsens-v0_1.c b/drivers/thermal/qcom/tsens-v0_1.c
index 6f26fadf4c279..055647bcee67d 100644
--- a/drivers/thermal/qcom/tsens-v0_1.c
+++ b/drivers/thermal/qcom/tsens-v0_1.c
@@ -145,8 +145,10 @@ static int calibrate_8916(struct tsens_priv *priv)
 		return PTR_ERR(qfprom_cdata);
 
 	qfprom_csel = (u32 *)qfprom_read(priv->dev, "calib_sel");
-	if (IS_ERR(qfprom_csel))
+	if (IS_ERR(qfprom_csel)) {
+		kfree(qfprom_cdata);
 		return PTR_ERR(qfprom_csel);
+	}
 
 	mode = (qfprom_csel[0] & MSM8916_CAL_SEL_MASK) >> MSM8916_CAL_SEL_SHIFT;
 	dev_dbg(priv->dev, "calibration mode is %d\n", mode);
@@ -181,6 +183,8 @@ static int calibrate_8916(struct tsens_priv *priv)
 	}
 
 	compute_intercept_slope(priv, p1, p2, mode);
+	kfree(qfprom_cdata);
+	kfree(qfprom_csel);
 
 	return 0;
 }
@@ -198,8 +202,10 @@ static int calibrate_8974(struct tsens_priv *priv)
 		return PTR_ERR(calib);
 
 	bkp = (u32 *)qfprom_read(priv->dev, "calib_backup");
-	if (IS_ERR(bkp))
+	if (IS_ERR(bkp)) {
+		kfree(calib);
 		return PTR_ERR(bkp);
+	}
 
 	calib_redun_sel =  bkp[1] & BKP_REDUN_SEL;
 	calib_redun_sel >>= BKP_REDUN_SHIFT;
@@ -313,6 +319,8 @@ static int calibrate_8974(struct tsens_priv *priv)
 	}
 
 	compute_intercept_slope(priv, p1, p2, mode);
+	kfree(calib);
+	kfree(bkp);
 
 	return 0;
 }
diff --git a/drivers/thermal/qcom/tsens-v1.c b/drivers/thermal/qcom/tsens-v1.c
index 10b595d4f6199..870f502f2cb6c 100644
--- a/drivers/thermal/qcom/tsens-v1.c
+++ b/drivers/thermal/qcom/tsens-v1.c
@@ -138,6 +138,7 @@ static int calibrate_v1(struct tsens_priv *priv)
 	}
 
 	compute_intercept_slope(priv, p1, p2, mode);
+	kfree(qfprom_cdata);
 
 	return 0;
 }
diff --git a/drivers/thermal/qcom/tsens.h b/drivers/thermal/qcom/tsens.h
index 2fd94997245bf..b89083b61c383 100644
--- a/drivers/thermal/qcom/tsens.h
+++ b/drivers/thermal/qcom/tsens.h
@@ -17,6 +17,7 @@
 
 #include <linux/thermal.h>
 #include <linux/regmap.h>
+#include <linux/slab.h>
 
 struct tsens_priv;
 
-- 
2.20.1

