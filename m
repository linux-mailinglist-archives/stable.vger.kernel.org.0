Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24BA2498F64
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348035AbiAXTwP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:52:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37190 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356508AbiAXTqd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:46:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAAB6B81142;
        Mon, 24 Jan 2022 19:46:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD543C340E7;
        Mon, 24 Jan 2022 19:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053590;
        bh=/Bn2b5Me1W2LVtHE9oXQZpnca875ifPrsY/ztqa5e34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ysamgb6qDDBpSf6fQ64DGlyUBoTpEBQGjRI4E3lwr8nBixmjotcWI8qes6yO6PJqS
         iLIOUH+FLRcihgmIMrxEVBW5K7CHIkk+ZjqtWaKtScvudo//FEQm6BXX1Miq9iXCxL
         cka3b7Mdkz/gNVLz2IglgFC2fayPlPASdX1j7Ra0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/563] media: venus: core, venc, vdec: Fix probe dependency error
Date:   Mon, 24 Jan 2022 19:37:59 +0100
Message-Id: <20220124184028.363198382@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index 58ddebbb84468..bad553bf9f304 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -222,7 +222,6 @@ static int venus_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	core->dev = dev;
-	platform_set_drvdata(pdev, core);
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	core->base = devm_ioremap_resource(dev, r);
@@ -252,7 +251,7 @@ static int venus_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	if (core->pm_ops->core_get) {
-		ret = core->pm_ops->core_get(dev);
+		ret = core->pm_ops->core_get(core);
 		if (ret)
 			return ret;
 	}
@@ -277,6 +276,12 @@ static int venus_probe(struct platform_device *pdev)
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
@@ -311,10 +316,6 @@ static int venus_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_venus_shutdown;
 
-	ret = v4l2_device_register(dev, &core->v4l2_dev);
-	if (ret)
-		goto err_core_deinit;
-
 	ret = pm_runtime_put_sync(dev);
 	if (ret) {
 		pm_runtime_get_noresume(dev);
@@ -327,8 +328,6 @@ static int venus_probe(struct platform_device *pdev)
 
 err_dev_unregister:
 	v4l2_device_unregister(&core->v4l2_dev);
-err_core_deinit:
-	hfi_core_deinit(core, false);
 err_venus_shutdown:
 	venus_shutdown(core);
 err_runtime_disable:
@@ -336,9 +335,11 @@ err_runtime_disable:
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
 
@@ -364,11 +365,14 @@ static int venus_remove(struct platform_device *pdev)
 	pm_runtime_disable(dev);
 
 	if (pm_ops->core_put)
-		pm_ops->core_put(dev);
+		pm_ops->core_put(core);
+
+	v4l2_device_unregister(&core->v4l2_dev);
 
 	hfi_destroy(core);
 
 	v4l2_device_unregister(&core->v4l2_dev);
+
 	mutex_destroy(&core->pm_lock);
 	mutex_destroy(&core->lock);
 	venus_dbgfs_deinit(core);
@@ -387,7 +391,7 @@ static __maybe_unused int venus_runtime_suspend(struct device *dev)
 		return ret;
 
 	if (pm_ops->core_power) {
-		ret = pm_ops->core_power(dev, POWER_OFF);
+		ret = pm_ops->core_power(core, POWER_OFF);
 		if (ret)
 			return ret;
 	}
@@ -405,7 +409,7 @@ static __maybe_unused int venus_runtime_suspend(struct device *dev)
 err_video_path:
 	icc_set_bw(core->cpucfg_path, kbps_to_icc(1000), 0);
 err_cpucfg_path:
-	pm_ops->core_power(dev, POWER_ON);
+	pm_ops->core_power(core, POWER_ON);
 
 	return ret;
 }
@@ -425,7 +429,7 @@ static __maybe_unused int venus_runtime_resume(struct device *dev)
 		return ret;
 
 	if (pm_ops->core_power) {
-		ret = pm_ops->core_power(dev, POWER_ON);
+		ret = pm_ops->core_power(core, POWER_ON);
 		if (ret)
 			return ret;
 	}
diff --git a/drivers/media/platform/qcom/venus/pm_helpers.c b/drivers/media/platform/qcom/venus/pm_helpers.c
index bce9a370015fb..63095d70f8d82 100644
--- a/drivers/media/platform/qcom/venus/pm_helpers.c
+++ b/drivers/media/platform/qcom/venus/pm_helpers.c
@@ -276,16 +276,13 @@ set_freq:
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
@@ -752,12 +749,12 @@ static int venc_power_v4(struct device *dev, int on)
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
@@ -808,9 +805,8 @@ opp_attach_err:
 	return ret;
 }
 
-static void vcodec_domains_put(struct device *dev)
+static void vcodec_domains_put(struct venus_core *core)
 {
-	struct venus_core *core = dev_get_drvdata(dev);
 	const struct venus_resources *res = core->res;
 	unsigned int i;
 
@@ -833,9 +829,9 @@ skip_pmdomains:
 	dev_pm_opp_detach_genpd(core->opp_table);
 }
 
-static int core_get_v4(struct device *dev)
+static int core_get_v4(struct venus_core *core)
 {
-	struct venus_core *core = dev_get_drvdata(dev);
+	struct device *dev = core->dev;
 	const struct venus_resources *res = core->res;
 	int ret;
 
@@ -874,7 +870,7 @@ static int core_get_v4(struct device *dev)
 		}
 	}
 
-	ret = vcodec_domains_get(dev);
+	ret = vcodec_domains_get(core);
 	if (ret) {
 		if (core->has_opp_table)
 			dev_pm_opp_of_remove_table(dev);
@@ -885,14 +881,14 @@ static int core_get_v4(struct device *dev)
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
index aa2f6afa23544..a492c50c5543c 100644
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
2.34.1



