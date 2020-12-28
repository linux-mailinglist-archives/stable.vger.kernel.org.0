Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD692E419A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438587AbgL1OIG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:08:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:42568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438578AbgL1OIF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:08:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5B48205CB;
        Mon, 28 Dec 2020 14:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164444;
        bh=BUfFs33LsMjfiBuxXUdAQnnhTNdwc6/HlNtL19etTPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X9345fiTZS5Glrc6c9zu7On4o2fzb7jRuHn3mdjOR5bqjFYnvwSynVoiSnPtqdYWu
         A6dXM62USvxCLWhJJ5SkfMzmh8oRME7AhmevytGj5eKi/KZLJD54kkFZ8kMhUC2Udg
         dzDzW7m2YpdOc4zMOvw6PMbNlP2M8qNQb643qYkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 142/717] drm/meson: Unbind all connectors on module removal
Date:   Mon, 28 Dec 2020 13:42:20 +0100
Message-Id: <20201228125027.762130837@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit e78ad18ba3658fbc8c63629e034b68d8e51acbf1 ]

Removing the meson DRM module results in the following splats:

[   42.689228] WARNING: CPU: 0 PID: 572 at drivers/gpu/drm/drm_irq.c:192 drm_irq_uninstall+0x130/0x160 [drm]
[...]
[   42.812820] Hardware name:  , BIOS 2021.01-rc2-00012-gde865f7ee1 11/16/2020
[   42.819723] pstate: 80400089 (Nzcv daIf +PAN -UAO -TCO BTYPE=--)
[   42.825737] pc : drm_irq_uninstall+0x130/0x160 [drm]
[   42.830647] lr : drm_irq_uninstall+0xc4/0x160 [drm]
[...]
[   42.917614] Call trace:
[   42.920086]  drm_irq_uninstall+0x130/0x160 [drm]
[   42.924612]  meson_drv_unbind+0x68/0xa4 [meson_drm]
[   42.929436]  component_del+0xc0/0x180
[   42.933058]  meson_dw_hdmi_remove+0x28/0x40 [meson_dw_hdmi]
[   42.938576]  platform_drv_remove+0x38/0x60
[   42.942628]  __device_release_driver+0x190/0x23c
[   42.947198]  driver_detach+0xcc/0x160
[   42.950822]  bus_remove_driver+0x68/0xe0
[   42.954702]  driver_unregister+0x3c/0x6c
[   42.958583]  platform_driver_unregister+0x20/0x2c
[   42.963243]  meson_dw_hdmi_platform_driver_exit+0x18/0x4a8 [meson_dw_hdmi]
[   42.970057]  __arm64_sys_delete_module+0x1bc/0x294
[   42.974801]  el0_svc_common.constprop.0+0x80/0x240
[   42.979542]  do_el0_svc+0x30/0xa0
[   42.982821]  el0_svc+0x18/0x50
[   42.985839]  el0_sync_handler+0x198/0x404
[   42.989806]  el0_sync+0x158/0x180

immediatelly followed by

[   43.002296] WARNING: CPU: 0 PID: 572 at drivers/gpu/drm/drm_mode_config.c:504 drm_mode_config_cleanup+0x2a8/0x304 [drm]
[...]
[   43.128150] Hardware name:  , BIOS 2021.01-rc2-00012-gde865f7ee1 11/16/2020
[   43.135052] pstate: 80400009 (Nzcv daif +PAN -UAO -TCO BTYPE=--)
[   43.141062] pc : drm_mode_config_cleanup+0x2a8/0x304 [drm]
[   43.146492] lr : drm_mode_config_cleanup+0xac/0x304 [drm]
[...]
[   43.233979] Call trace:
[   43.236451]  drm_mode_config_cleanup+0x2a8/0x304 [drm]
[   43.241538]  drm_mode_config_init_release+0x1c/0x2c [drm]
[   43.246886]  drm_managed_release+0xa8/0x120 [drm]
[   43.251543]  drm_dev_put+0x94/0xc0 [drm]
[   43.255380]  meson_drv_unbind+0x78/0xa4 [meson_drm]
[   43.260204]  component_del+0xc0/0x180
[   43.263829]  meson_dw_hdmi_remove+0x28/0x40 [meson_dw_hdmi]
[   43.269344]  platform_drv_remove+0x38/0x60
[   43.273398]  __device_release_driver+0x190/0x23c
[   43.277967]  driver_detach+0xcc/0x160
[   43.281590]  bus_remove_driver+0x68/0xe0
[   43.285471]  driver_unregister+0x3c/0x6c
[   43.289352]  platform_driver_unregister+0x20/0x2c
[   43.294011]  meson_dw_hdmi_platform_driver_exit+0x18/0x4a8 [meson_dw_hdmi]
[   43.300826]  __arm64_sys_delete_module+0x1bc/0x294
[   43.305570]  el0_svc_common.constprop.0+0x80/0x240
[   43.310312]  do_el0_svc+0x30/0xa0
[   43.313590]  el0_svc+0x18/0x50
[   43.316608]  el0_sync_handler+0x198/0x404
[   43.320574]  el0_sync+0x158/0x180
[   43.323852] ---[ end trace d796a3072dab01da ]---
[   43.328561] [drm:drm_mode_config_cleanup [drm]] *ERROR* connector HDMI-A-1 leaked!

both triggered by the fact that the HDMI subsystem is still active,
and the DRM removal doesn't result in the connectors being torn down.

Call drm_atomic_helper_shutdown() and component_unbind_all() to safely
tear the module down.

Fixes: 2d8f92897ad8 ("drm/meson: Uninstall IRQ handler")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201116200744.495826-3-maz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/meson/meson_drv.c b/drivers/gpu/drm/meson/meson_drv.c
index 324fa489f1c46..3d1de9cbb1c8d 100644
--- a/drivers/gpu/drm/meson/meson_drv.c
+++ b/drivers/gpu/drm/meson/meson_drv.c
@@ -390,8 +390,10 @@ static void meson_drv_unbind(struct device *dev)
 	}
 
 	drm_dev_unregister(drm);
-	drm_irq_uninstall(drm);
 	drm_kms_helper_poll_fini(drm);
+	drm_atomic_helper_shutdown(drm);
+	component_unbind_all(dev, drm);
+	drm_irq_uninstall(drm);
 	drm_dev_put(drm);
 
 	if (priv->afbcd.ops) {
-- 
2.27.0



