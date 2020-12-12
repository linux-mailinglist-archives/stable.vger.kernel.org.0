Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415752D879E
	for <lists+stable@lfdr.de>; Sat, 12 Dec 2020 17:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439336AbgLLQJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Dec 2020 11:09:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:56980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbgLLQIv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Dec 2020 11:08:51 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 02/23] drm/tegra: sor: Ensure regulators are disabled on teardown
Date:   Sat, 12 Dec 2020 11:07:43 -0500
Message-Id: <20201212160804.2334982-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201212160804.2334982-1-sashal@kernel.org>
References: <20201212160804.2334982-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 5c1d644c09dbc13b2dc652435786e42b05ac1bb7 ]

The Tegra SOR driver uses the devm infrastructure to request regulators,
but enables them without registering them with the infrastructure.

This results in the following splat if probing fails for any odd resaon
(such as dependencies not being available):

[    8.974187] tegra-sor 15580000.sor: cannot get HDMI supply: -517
[    9.414403] tegra-sor 15580000.sor: failed to probe HDMI: -517
[    9.421240] ------------[ cut here ]------------
[    9.425879] WARNING: CPU: 1 PID: 164 at drivers/regulator/core.c:2089 _regulator_put.part.0+0x16c/0x174
[    9.435259] Modules linked in: tegra_drm(E+) cec(E) ahci_tegra(E) drm_kms_helper(E) drm(E) libahci_platform(E) libahci(E) max77620_regulator(E) xhci_tegra(E+) sdhci_tegra(E) xhci_hcd(E) libata(E) sdhci_pltfm(E) cqhci(E) fixed(E) usbcore(E) scsi_mod(E) sdhci(E) host1x(E)
[    9.459211] CPU: 1 PID: 164 Comm: systemd-udevd Tainted: G S    D W   E     5.9.0-rc7-00298-gf6337624c4fe #1980
[    9.469285] Hardware name: NVIDIA Jetson TX2 Developer Kit (DT)
[    9.475202] pstate: 80000005 (Nzcv daif -PAN -UAO BTYPE=--)
[    9.480784] pc : _regulator_put.part.0+0x16c/0x174
[    9.485581] lr : regulator_put+0x44/0x60
[    9.489501] sp : ffffffc011d837b0
[    9.492814] x29: ffffffc011d837b0 x28: ffffff81dd085900
[    9.498141] x27: ffffff81de1c8ec0 x26: ffffff81de1c8c10
[    9.503464] x25: ffffff81dd085800 x24: ffffffc008f2c6b0
[    9.508790] x23: ffffffc0117373f0 x22: 0000000000000005
[    9.514101] x21: ffffff81dd085900 x20: ffffffc01172b098
[    9.515822] ata1: SATA link down (SStatus 0 SControl 300)
[    9.519426] x19: ffffff81dd085100 x18: 0000000000000030
[    9.530122] x17: 0000000000000000 x16: 0000000000000000
[    9.535453] x15: 0000000000000000 x14: 000000000000038f
[    9.540777] x13: 0000000000000003 x12: 0000000000000040
[    9.546105] x11: ffffff81eb800000 x10: 0000000000000ae0
[    9.551417] x9 : ffffffc0106fea24 x8 : ffffff81de83e6c0
[    9.556728] x7 : 0000000000000018 x6 : 00000000000003c3
[    9.562064] x5 : 0000000000005660 x4 : 0000000000000000
[    9.567392] x3 : ffffffc01172b388 x2 : ffffff81de83db80
[    9.572702] x1 : 0000000000000000 x0 : 0000000000000001
[    9.578034] Call trace:
[    9.580494]  _regulator_put.part.0+0x16c/0x174
[    9.584940]  regulator_put+0x44/0x60
[    9.588522]  devm_regulator_release+0x20/0x2c
[    9.592885]  release_nodes+0x1c8/0x2c0
[    9.596636]  devres_release_all+0x44/0x6c
[    9.600649]  really_probe+0x1ec/0x504
[    9.604316]  driver_probe_device+0x100/0x170
[    9.608589]  device_driver_attach+0xcc/0xd4
[    9.612774]  __driver_attach+0xb0/0x17c
[    9.616614]  bus_for_each_dev+0x7c/0xd4
[    9.620450]  driver_attach+0x30/0x3c
[    9.624027]  bus_add_driver+0x154/0x250
[    9.627867]  driver_register+0x84/0x140
[    9.631719]  __platform_register_drivers+0xa0/0x180
[    9.636660]  host1x_drm_init+0x60/0x1000 [tegra_drm]
[    9.641629]  do_one_initcall+0x54/0x2d0
[    9.645490]  do_init_module+0x68/0x29c
[    9.649244]  load_module+0x2178/0x26c0
[    9.652997]  __do_sys_finit_module+0xb0/0x120
[    9.657356]  __arm64_sys_finit_module+0x2c/0x40
[    9.661902]  el0_svc_common.constprop.0+0x80/0x240
[    9.666701]  do_el0_svc+0x30/0xa0
[    9.670022]  el0_svc+0x18/0x50
[    9.673081]  el0_sync_handler+0x90/0x318
[    9.677006]  el0_sync+0x158/0x180
[    9.680324] ---[ end trace 90f6c89d62d85ff6 ]---

Instead, let's register a callback that will disable the regulators
on teardown. This allows for the removal of the .remove callbacks,
which are not needed anymore.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/sor.c | 59 +++++++++++++++----------------------
 1 file changed, 24 insertions(+), 35 deletions(-)

diff --git a/drivers/gpu/drm/tegra/sor.c b/drivers/gpu/drm/tegra/sor.c
index 5d9a7f008fc6c..f2a114f14a3db 100644
--- a/drivers/gpu/drm/tegra/sor.c
+++ b/drivers/gpu/drm/tegra/sor.c
@@ -397,7 +397,6 @@ struct tegra_sor;
 struct tegra_sor_ops {
 	const char *name;
 	int (*probe)(struct tegra_sor *sor);
-	int (*remove)(struct tegra_sor *sor);
 	void (*audio_enable)(struct tegra_sor *sor);
 	void (*audio_disable)(struct tegra_sor *sor);
 };
@@ -2942,6 +2941,24 @@ static const struct drm_encoder_helper_funcs tegra_sor_dp_helpers = {
 	.atomic_check = tegra_sor_encoder_atomic_check,
 };
 
+static void tegra_sor_disable_regulator(void *data)
+{
+	struct regulator *reg = data;
+
+	regulator_disable(reg);
+}
+
+static int tegra_sor_enable_regulator(struct tegra_sor *sor, struct regulator *reg)
+{
+	int err;
+
+	err = regulator_enable(reg);
+	if (err)
+		return err;
+
+	return devm_add_action_or_reset(sor->dev, tegra_sor_disable_regulator, reg);
+}
+
 static int tegra_sor_hdmi_probe(struct tegra_sor *sor)
 {
 	int err;
@@ -2953,7 +2970,7 @@ static int tegra_sor_hdmi_probe(struct tegra_sor *sor)
 		return PTR_ERR(sor->avdd_io_supply);
 	}
 
-	err = regulator_enable(sor->avdd_io_supply);
+	err = tegra_sor_enable_regulator(sor, sor->avdd_io_supply);
 	if (err < 0) {
 		dev_err(sor->dev, "failed to enable AVDD I/O supply: %d\n",
 			err);
@@ -2967,7 +2984,7 @@ static int tegra_sor_hdmi_probe(struct tegra_sor *sor)
 		return PTR_ERR(sor->vdd_pll_supply);
 	}
 
-	err = regulator_enable(sor->vdd_pll_supply);
+	err = tegra_sor_enable_regulator(sor, sor->vdd_pll_supply);
 	if (err < 0) {
 		dev_err(sor->dev, "failed to enable VDD PLL supply: %d\n",
 			err);
@@ -2981,7 +2998,7 @@ static int tegra_sor_hdmi_probe(struct tegra_sor *sor)
 		return PTR_ERR(sor->hdmi_supply);
 	}
 
-	err = regulator_enable(sor->hdmi_supply);
+	err = tegra_sor_enable_regulator(sor, sor->hdmi_supply);
 	if (err < 0) {
 		dev_err(sor->dev, "failed to enable HDMI supply: %d\n", err);
 		return err;
@@ -2992,19 +3009,9 @@ static int tegra_sor_hdmi_probe(struct tegra_sor *sor)
 	return 0;
 }
 
-static int tegra_sor_hdmi_remove(struct tegra_sor *sor)
-{
-	regulator_disable(sor->hdmi_supply);
-	regulator_disable(sor->vdd_pll_supply);
-	regulator_disable(sor->avdd_io_supply);
-
-	return 0;
-}
-
 static const struct tegra_sor_ops tegra_sor_hdmi_ops = {
 	.name = "HDMI",
 	.probe = tegra_sor_hdmi_probe,
-	.remove = tegra_sor_hdmi_remove,
 	.audio_enable = tegra_sor_hdmi_audio_enable,
 	.audio_disable = tegra_sor_hdmi_audio_disable,
 };
@@ -3017,7 +3024,7 @@ static int tegra_sor_dp_probe(struct tegra_sor *sor)
 	if (IS_ERR(sor->avdd_io_supply))
 		return PTR_ERR(sor->avdd_io_supply);
 
-	err = regulator_enable(sor->avdd_io_supply);
+	err = tegra_sor_enable_regulator(sor, sor->avdd_io_supply);
 	if (err < 0)
 		return err;
 
@@ -3025,25 +3032,16 @@ static int tegra_sor_dp_probe(struct tegra_sor *sor)
 	if (IS_ERR(sor->vdd_pll_supply))
 		return PTR_ERR(sor->vdd_pll_supply);
 
-	err = regulator_enable(sor->vdd_pll_supply);
+	err = tegra_sor_enable_regulator(sor, sor->vdd_pll_supply);
 	if (err < 0)
 		return err;
 
 	return 0;
 }
 
-static int tegra_sor_dp_remove(struct tegra_sor *sor)
-{
-	regulator_disable(sor->vdd_pll_supply);
-	regulator_disable(sor->avdd_io_supply);
-
-	return 0;
-}
-
 static const struct tegra_sor_ops tegra_sor_dp_ops = {
 	.name = "DP",
 	.probe = tegra_sor_dp_probe,
-	.remove = tegra_sor_dp_remove,
 };
 
 static int tegra_sor_init(struct host1x_client *client)
@@ -3768,7 +3766,7 @@ static int tegra_sor_probe(struct platform_device *pdev)
 		if (err < 0) {
 			dev_err(&pdev->dev, "failed to probe %s: %d\n",
 				sor->ops->name, err);
-			goto output;
+			goto remove;
 		}
 	}
 
@@ -3949,9 +3947,6 @@ unregister:
 rpm_disable:
 	pm_runtime_disable(&pdev->dev);
 remove:
-	if (sor->ops && sor->ops->remove)
-		sor->ops->remove(sor);
-output:
 	tegra_output_remove(&sor->output);
 	return err;
 }
@@ -3970,12 +3965,6 @@ static int tegra_sor_remove(struct platform_device *pdev)
 
 	pm_runtime_disable(&pdev->dev);
 
-	if (sor->ops && sor->ops->remove) {
-		err = sor->ops->remove(sor);
-		if (err < 0)
-			dev_err(&pdev->dev, "failed to remove SOR: %d\n", err);
-	}
-
 	tegra_output_remove(&sor->output);
 
 	return 0;
-- 
2.27.0

