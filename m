Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC2F378822
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238998AbhEJLUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:20:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233466AbhEJLJG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:09:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 092AA6101E;
        Mon, 10 May 2021 11:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644670;
        bh=l08rdAgrnyLJwCTB1cnW7Rg5s7W/MjHI81IDf9pEUwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NvRDODn6tzKYimMEx7LqnurlCWha9OXPGCaXLThmsUSlmR6JLmWp6bLofs9W1O5fE
         0OTY7TpdAmeV2a8uF5caxeF5UZ++rbP2j1nbqaq/7MHSadL5Xgd5I/IXjju05Juf1F
         +xcC+GbfPUAwehDESjxnmdFLESWVJGatkIq9Bon8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 176/384] media: venus: core, venc, vdec: Fix probe dependency error
Date:   Mon, 10 May 2021 12:19:25 +0200
Message-Id: <20210510102020.691118079@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit 08b1cf474b7f72750adebe0f0a35f8e9a3eb75f6 ]

Commit aaaa93eda64b ("media] media: venus: venc: add video encoder files")
is the last in a series of three commits to add core.c vdec.c and venc.c
adding core, encoder and decoder.

The encoder and decoder check for core drvdata as set and return -EPROBE_DEFER
if it has not been set, however both the encoder and decoder rely on
core.v4l2_dev as valid.

core.v4l2_dev will not be valid until v4l2_device_register() has completed
in core.c's probe().

Normally this is never seen however, Dmitry reported the following
backtrace when compiling drivers and firmware directly into a kernel image.

[    5.259968] Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
[    5.269850] sd 0:0:0:3: [sdd] Optimal transfer size 524288 bytes
[    5.275505] Workqueue: events deferred_probe_work_func
[    5.275513] pstate: 60400005 (nZCv daif +PAN -UAO -TCO BTYPE=--)
[    5.441211] usb 2-1: new SuperSpeedPlus Gen 2 USB device number 2 using xhci-hcd
[    5.442486] pc : refcount_warn_saturate+0x140/0x148
[    5.493756] hub 2-1:1.0: USB hub found
[    5.496266] lr : refcount_warn_saturate+0x140/0x148
[    5.500982] hub 2-1:1.0: 4 ports detected
[    5.503440] sp : ffff80001067b730
[    5.503442] x29: ffff80001067b730
[    5.592660] usb 1-1: new high-speed USB device number 2 using xhci-hcd
[    5.598478] x28: ffff6c6bc1c379b8
[    5.598480] x27: ffffa5c673852960 x26: ffffa5c673852000
[    5.598484] x25: ffff6c6bc1c37800 x24: 0000000000000001
[    5.810652] x23: 0000000000000000 x22: ffffa5c673bc7118
[    5.813777] hub 1-1:1.0: USB hub found
[    5.816108] x21: ffffa5c674440000 x20: 0000000000000001
[    5.820846] hub 1-1:1.0: 4 ports detected
[    5.825415] x19: ffffa5c6744f4000 x18: ffffffffffffffff
[    5.825418] x17: 0000000000000000 x16: 0000000000000000
[    5.825421] x15: 00000a4810c193ba x14: 0000000000000000
[    5.825424] x13: 00000000000002b8 x12: 000000000000f20a
[    5.825427] x11: 000000000000f20a x10: 0000000000000038
[    5.845447] usb 2-1.1: new SuperSpeed Gen 1 USB device number 3 using xhci-hcd
[    5.845904]
[    5.845905] x9 : 0000000000000000 x8 : ffff6c6d36fae780
[    5.871208] x7 : ffff6c6d36faf240 x6 : 0000000000000000
[    5.876664] x5 : 0000000000000004 x4 : 0000000000000085
[    5.882121] x3 : 0000000000000119 x2 : ffffa5c6741ef478
[    5.887578] x1 : 3acbb3926faf5f00 x0 : 0000000000000000
[    5.893036] Call trace:
[    5.895551]  refcount_warn_saturate+0x140/0x148
[    5.900202]  __video_register_device+0x64c/0xd10
[    5.904944]  venc_probe+0xc4/0x148
[    5.908444]  platform_probe+0x68/0xe0
[    5.912210]  really_probe+0x118/0x3e0
[    5.915977]  driver_probe_device+0x5c/0xc0
[    5.920187]  __device_attach_driver+0x98/0xb8
[    5.924661]  bus_for_each_drv+0x68/0xd0
[    5.928604]  __device_attach+0xec/0x148
[    5.932547]  device_initial_probe+0x14/0x20
[    5.936845]  bus_probe_device+0x9c/0xa8
[    5.940788]  device_add+0x3e8/0x7c8
[    5.944376]  of_device_add+0x4c/0x60
[    5.948056]  of_platform_device_create_pdata+0xbc/0x140
[    5.953425]  of_platform_bus_create+0x17c/0x3c0
[    5.958078]  of_platform_populate+0x80/0x110
[    5.962463]  venus_probe+0x2ec/0x4d8
[    5.966143]  platform_probe+0x68/0xe0
[    5.969907]  really_probe+0x118/0x3e0
[    5.973674]  driver_probe_device+0x5c/0xc0
[    5.977882]  __device_attach_driver+0x98/0xb8
[    5.982356]  bus_for_each_drv+0x68/0xd0
[    5.986298]  __device_attach+0xec/0x148
[    5.990242]  device_initial_probe+0x14/0x20
[    5.994539]  bus_probe_device+0x9c/0xa8
[    5.998481]  deferred_probe_work_func+0x74/0xb0
[    6.003132]  process_one_work+0x1e8/0x360
[    6.007254]  worker_thread+0x208/0x478
[    6.011106]  kthread+0x150/0x158
[    6.014431]  ret_from_fork+0x10/0x30
[    6.018111] ---[ end trace f074246b1ecdb466 ]---

This patch fixes by

- Only setting drvdata after v4l2_device_register() completes
- Moving v4l2_device_register() so that suspend/reume in core::probe()
  stays as-is
- Changes pm_ops->core_function() to take struct venus_core not struct
  device
- Minimal rework of v4l2_device_*register in probe/remove

Reported-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/core.c      | 30 +++++++++++--------
 .../media/platform/qcom/venus/pm_helpers.c    | 30 ++++++++-----------
 .../media/platform/qcom/venus/pm_helpers.h    |  7 +++--
 3 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index f9896c121fd8..d2842f496b47 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -218,7 +218,6 @@ static int venus_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	core->dev = dev;
-	platform_set_drvdata(pdev, core);
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	core->base = devm_ioremap_resource(dev, r);
@@ -248,7 +247,7 @@ static int venus_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	if (core->pm_ops->core_get) {
-		ret = core->pm_ops->core_get(dev);
+		ret = core->pm_ops->core_get(core);
 		if (ret)
 			return ret;
 	}
@@ -273,6 +272,12 @@ static int venus_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_core_put;
 
+	ret = v4l2_device_register(dev, &core->v4l2_dev);
+	if (ret)
+		goto err_core_deinit;
+
+	platform_set_drvdata(pdev, core);
+
 	pm_runtime_enable(dev);
 
 	ret = pm_runtime_get_sync(dev);
@@ -307,10 +312,6 @@ static int venus_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_venus_shutdown;
 
-	ret = v4l2_device_register(dev, &core->v4l2_dev);
-	if (ret)
-		goto err_core_deinit;
-
 	ret = pm_runtime_put_sync(dev);
 	if (ret) {
 		pm_runtime_get_noresume(dev);
@@ -323,8 +324,6 @@ static int venus_probe(struct platform_device *pdev)
 
 err_dev_unregister:
 	v4l2_device_unregister(&core->v4l2_dev);
-err_core_deinit:
-	hfi_core_deinit(core, false);
 err_venus_shutdown:
 	venus_shutdown(core);
 err_runtime_disable:
@@ -332,9 +331,11 @@ err_runtime_disable:
 	pm_runtime_set_suspended(dev);
 	pm_runtime_disable(dev);
 	hfi_destroy(core);
+err_core_deinit:
+	hfi_core_deinit(core, false);
 err_core_put:
 	if (core->pm_ops->core_put)
-		core->pm_ops->core_put(dev);
+		core->pm_ops->core_put(core);
 	return ret;
 }
 
@@ -360,7 +361,9 @@ static int venus_remove(struct platform_device *pdev)
 	pm_runtime_disable(dev);
 
 	if (pm_ops->core_put)
-		pm_ops->core_put(dev);
+		pm_ops->core_put(core);
+
+	v4l2_device_unregister(&core->v4l2_dev);
 
 	hfi_destroy(core);
 
@@ -368,6 +371,7 @@ static int venus_remove(struct platform_device *pdev)
 	icc_put(core->cpucfg_path);
 
 	v4l2_device_unregister(&core->v4l2_dev);
+
 	mutex_destroy(&core->pm_lock);
 	mutex_destroy(&core->lock);
 	venus_dbgfs_deinit(core);
@@ -396,7 +400,7 @@ static __maybe_unused int venus_runtime_suspend(struct device *dev)
 		return ret;
 
 	if (pm_ops->core_power) {
-		ret = pm_ops->core_power(dev, POWER_OFF);
+		ret = pm_ops->core_power(core, POWER_OFF);
 		if (ret)
 			return ret;
 	}
@@ -414,7 +418,7 @@ static __maybe_unused int venus_runtime_suspend(struct device *dev)
 err_video_path:
 	icc_set_bw(core->cpucfg_path, kbps_to_icc(1000), 0);
 err_cpucfg_path:
-	pm_ops->core_power(dev, POWER_ON);
+	pm_ops->core_power(core, POWER_ON);
 
 	return ret;
 }
@@ -434,7 +438,7 @@ static __maybe_unused int venus_runtime_resume(struct device *dev)
 		return ret;
 
 	if (pm_ops->core_power) {
-		ret = pm_ops->core_power(dev, POWER_ON);
+		ret = pm_ops->core_power(core, POWER_ON);
 		if (ret)
 			return ret;
 	}
diff --git a/drivers/media/platform/qcom/venus/pm_helpers.c b/drivers/media/platform/qcom/venus/pm_helpers.c
index 43c4e3d9e281..e349d01422c5 100644
--- a/drivers/media/platform/qcom/venus/pm_helpers.c
+++ b/drivers/media/platform/qcom/venus/pm_helpers.c
@@ -277,16 +277,13 @@ set_freq:
 	return 0;
 }
 
-static int core_get_v1(struct device *dev)
+static int core_get_v1(struct venus_core *core)
 {
-	struct venus_core *core = dev_get_drvdata(dev);
-
 	return core_clks_get(core);
 }
 
-static int core_power_v1(struct device *dev, int on)
+static int core_power_v1(struct venus_core *core, int on)
 {
-	struct venus_core *core = dev_get_drvdata(dev);
 	int ret = 0;
 
 	if (on == POWER_ON)
@@ -753,12 +750,12 @@ static int venc_power_v4(struct device *dev, int on)
 	return ret;
 }
 
-static int vcodec_domains_get(struct device *dev)
+static int vcodec_domains_get(struct venus_core *core)
 {
 	int ret;
 	struct opp_table *opp_table;
 	struct device **opp_virt_dev;
-	struct venus_core *core = dev_get_drvdata(dev);
+	struct device *dev = core->dev;
 	const struct venus_resources *res = core->res;
 	struct device *pd;
 	unsigned int i;
@@ -809,9 +806,8 @@ opp_attach_err:
 	return ret;
 }
 
-static void vcodec_domains_put(struct device *dev)
+static void vcodec_domains_put(struct venus_core *core)
 {
-	struct venus_core *core = dev_get_drvdata(dev);
 	const struct venus_resources *res = core->res;
 	unsigned int i;
 
@@ -834,9 +830,9 @@ skip_pmdomains:
 	dev_pm_opp_detach_genpd(core->opp_table);
 }
 
-static int core_get_v4(struct device *dev)
+static int core_get_v4(struct venus_core *core)
 {
-	struct venus_core *core = dev_get_drvdata(dev);
+	struct device *dev = core->dev;
 	const struct venus_resources *res = core->res;
 	int ret;
 
@@ -875,7 +871,7 @@ static int core_get_v4(struct device *dev)
 		}
 	}
 
-	ret = vcodec_domains_get(dev);
+	ret = vcodec_domains_get(core);
 	if (ret) {
 		if (core->has_opp_table)
 			dev_pm_opp_of_remove_table(dev);
@@ -886,14 +882,14 @@ static int core_get_v4(struct device *dev)
 	return 0;
 }
 
-static void core_put_v4(struct device *dev)
+static void core_put_v4(struct venus_core *core)
 {
-	struct venus_core *core = dev_get_drvdata(dev);
+	struct device *dev = core->dev;
 
 	if (legacy_binding)
 		return;
 
-	vcodec_domains_put(dev);
+	vcodec_domains_put(core);
 
 	if (core->has_opp_table)
 		dev_pm_opp_of_remove_table(dev);
@@ -901,9 +897,9 @@ static void core_put_v4(struct device *dev)
 
 }
 
-static int core_power_v4(struct device *dev, int on)
+static int core_power_v4(struct venus_core *core, int on)
 {
-	struct venus_core *core = dev_get_drvdata(dev);
+	struct device *dev = core->dev;
 	struct device *pmctrl = core->pmdomains[0];
 	int ret = 0;
 
diff --git a/drivers/media/platform/qcom/venus/pm_helpers.h b/drivers/media/platform/qcom/venus/pm_helpers.h
index aa2f6afa2354..a492c50c5543 100644
--- a/drivers/media/platform/qcom/venus/pm_helpers.h
+++ b/drivers/media/platform/qcom/venus/pm_helpers.h
@@ -4,14 +4,15 @@
 #define __VENUS_PM_HELPERS_H__
 
 struct device;
+struct venus_core;
 
 #define POWER_ON	1
 #define POWER_OFF	0
 
 struct venus_pm_ops {
-	int (*core_get)(struct device *dev);
-	void (*core_put)(struct device *dev);
-	int (*core_power)(struct device *dev, int on);
+	int (*core_get)(struct venus_core *core);
+	void (*core_put)(struct venus_core *core);
+	int (*core_power)(struct venus_core *core, int on);
 
 	int (*vdec_get)(struct device *dev);
 	void (*vdec_put)(struct device *dev);
-- 
2.30.2



