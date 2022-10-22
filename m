Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C91186089A3
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234073AbiJVIiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234181AbiJVIgW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:36:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2535DCABD5;
        Sat, 22 Oct 2022 01:05:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68E8160ADF;
        Sat, 22 Oct 2022 08:05:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 419BAC433D6;
        Sat, 22 Oct 2022 08:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425905;
        bh=yQMzmi3/xHCBOzJ1cZr79veCLv7Gm5AMH6ZpJQs9X10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hk3EUBVmDwp9qlV3fsqaz2I8MWSVary71Kk9/LvpMwMalvOAD0XwLSefxhSbXitwK
         no9FpAN2KAEJQYma5B6ceD3sD/vcJxrevXT3Ka8HDWhWNTTcQ/zMhxYWKI2mAN+4Pp
         S2mORJGe5eq1v+6akF7ZXSlAbqX+/a4CjZJKdT7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 624/717] drm/meson: remove drm bridges at aggregate driver unbind time
Date:   Sat, 22 Oct 2022 09:28:23 +0200
Message-Id: <20221022072526.050296514@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrián Larumbe <adrian.larumbe@collabora.com>

[ Upstream commit 09847723c12fc2753749cec3939a02ee92dac468 ]

drm bridges added by meson_encoder_hdmi_init and meson_encoder_cvbs_init
were not manually removed at module unload time, which caused dangling
references to freed memory to remain linked in the global bridge_list.

When loading the driver modules back in, the same functions would again
call drm_bridge_add, and when traversing the global bridge_list, would
end up peeking into freed memory.

Once again KASAN revealed the problem:

[  +0.000095] =============================================================
[  +0.000008] BUG: KASAN: use-after-free in __list_add_valid+0x9c/0x120
[  +0.000018] Read of size 8 at addr ffff00003da291f0 by task modprobe/2483

[  +0.000018] CPU: 3 PID: 2483 Comm: modprobe Tainted: G         C O      5.19.0-rc6-lrmbkasan+ #1
[  +0.000011] Hardware name: Hardkernel ODROID-N2Plus (DT)
[  +0.000008] Call trace:
[  +0.000006]  dump_backtrace+0x1ec/0x280
[  +0.000012]  show_stack+0x24/0x80
[  +0.000008]  dump_stack_lvl+0x98/0xd4
[  +0.000011]  print_address_description.constprop.0+0x80/0x520
[  +0.000011]  print_report+0x128/0x260
[  +0.000008]  kasan_report+0xb8/0xfc
[  +0.000008]  __asan_report_load8_noabort+0x3c/0x50
[  +0.000009]  __list_add_valid+0x9c/0x120
[  +0.000009]  drm_bridge_add+0x6c/0x104 [drm]
[  +0.000165]  dw_hdmi_probe+0x1900/0x2360 [dw_hdmi]
[  +0.000022]  meson_dw_hdmi_bind+0x520/0x814 [meson_dw_hdmi]
[  +0.000014]  component_bind+0x174/0x520
[  +0.000012]  component_bind_all+0x1a8/0x38c
[  +0.000010]  meson_drv_bind_master+0x5e8/0xb74 [meson_drm]
[  +0.000032]  meson_drv_bind+0x20/0x2c [meson_drm]
[  +0.000027]  try_to_bring_up_aggregate_device+0x19c/0x390
[  +0.000010]  component_master_add_with_match+0x1c8/0x284
[  +0.000009]  meson_drv_probe+0x274/0x280 [meson_drm]
[  +0.000026]  platform_probe+0xd0/0x220
[  +0.000009]  really_probe+0x3ac/0xa80
[  +0.000009]  __driver_probe_device+0x1f8/0x400
[  +0.000009]  driver_probe_device+0x68/0x1b0
[  +0.000009]  __driver_attach+0x20c/0x480
[  +0.000008]  bus_for_each_dev+0x114/0x1b0
[  +0.000009]  driver_attach+0x48/0x64
[  +0.000008]  bus_add_driver+0x390/0x564
[  +0.000009]  driver_register+0x1a8/0x3e4
[  +0.000009]  __platform_driver_register+0x6c/0x94
[  +0.000008]  meson_drm_platform_driver_init+0x3c/0x1000 [meson_drm]
[  +0.000027]  do_one_initcall+0xc4/0x2b0
[  +0.000011]  do_init_module+0x154/0x570
[  +0.000011]  load_module+0x1a78/0x1ea4
[  +0.000008]  __do_sys_init_module+0x184/0x1cc
[  +0.000009]  __arm64_sys_init_module+0x78/0xb0
[  +0.000009]  invoke_syscall+0x74/0x260
[  +0.000009]  el0_svc_common.constprop.0+0xcc/0x260
[  +0.000008]  do_el0_svc+0x50/0x70
[  +0.000007]  el0_svc+0x68/0x1a0
[  +0.000012]  el0t_64_sync_handler+0x11c/0x150
[  +0.000008]  el0t_64_sync+0x18c/0x190

[  +0.000016] Allocated by task 879:
[  +0.000008]  kasan_save_stack+0x2c/0x5c
[  +0.000011]  __kasan_kmalloc+0x90/0xd0
[  +0.000007]  __kmalloc+0x278/0x4a0
[  +0.000011]  mpi_resize+0x13c/0x1d0
[  +0.000011]  mpi_powm+0xd24/0x1570
[  +0.000009]  rsa_enc+0x1a4/0x30c
[  +0.000009]  pkcs1pad_verify+0x3f0/0x580
[  +0.000009]  public_key_verify_signature+0x7a8/0xba4
[  +0.000010]  public_key_verify_signature_2+0x40/0x60
[  +0.000008]  verify_signature+0xb4/0x114
[  +0.000008]  pkcs7_validate_trust_one.constprop.0+0x3b8/0x574
[  +0.000009]  pkcs7_validate_trust+0xb8/0x15c
[  +0.000008]  verify_pkcs7_message_sig+0xec/0x1b0
[  +0.000012]  verify_pkcs7_signature+0x78/0xac
[  +0.000007]  mod_verify_sig+0x110/0x190
[  +0.000009]  module_sig_check+0x114/0x1e0
[  +0.000009]  load_module+0xa0/0x1ea4
[  +0.000008]  __do_sys_init_module+0x184/0x1cc
[  +0.000008]  __arm64_sys_init_module+0x78/0xb0
[  +0.000008]  invoke_syscall+0x74/0x260
[  +0.000009]  el0_svc_common.constprop.0+0x1a8/0x260
[  +0.000008]  do_el0_svc+0x50/0x70
[  +0.000007]  el0_svc+0x68/0x1a0
[  +0.000009]  el0t_64_sync_handler+0x11c/0x150
[  +0.000009]  el0t_64_sync+0x18c/0x190

[  +0.000013] Freed by task 2422:
[  +0.000008]  kasan_save_stack+0x2c/0x5c
[  +0.000009]  kasan_set_track+0x2c/0x40
[  +0.000007]  kasan_set_free_info+0x28/0x50
[  +0.000009]  ____kasan_slab_free+0x128/0x1d4
[  +0.000008]  __kasan_slab_free+0x18/0x24
[  +0.000007]  slab_free_freelist_hook+0x108/0x230
[  +0.000010]  kfree+0x110/0x35c
[  +0.000008]  release_nodes+0xf0/0x16c
[  +0.000009]  devres_release_group+0x180/0x270
[  +0.000008]  take_down_aggregate_device+0xcc/0x160
[  +0.000010]  component_del+0x18c/0x360
[  +0.000009]  meson_dw_hdmi_remove+0x28/0x40 [meson_dw_hdmi]
[  +0.000013]  platform_remove+0x64/0xb0
[  +0.000008]  device_remove+0xb8/0x154
[  +0.000009]  device_release_driver_internal+0x398/0x5b0
[  +0.000009]  driver_detach+0xac/0x1b0
[  +0.000009]  bus_remove_driver+0x158/0x29c
[  +0.000008]  driver_unregister+0x70/0xb0
[  +0.000009]  platform_driver_unregister+0x20/0x2c
[  +0.000007]  meson_dw_hdmi_platform_driver_exit+0x1c/0x30 [meson_dw_hdmi]
[  +0.000012]  __do_sys_delete_module+0x288/0x400
[  +0.000009]  __arm64_sys_delete_module+0x5c/0x80
[  +0.000009]  invoke_syscall+0x74/0x260
[  +0.000008]  el0_svc_common.constprop.0+0xcc/0x260
[  +0.000008]  do_el0_svc+0x50/0x70
[  +0.000007]  el0_svc+0x68/0x1a0
[  +0.000008]  el0t_64_sync_handler+0x11c/0x150
[  +0.000009]  el0t_64_sync+0x18c/0x190

[  +0.000013] The buggy address belongs to the object at ffff00003da29000
               which belongs to the cache kmalloc-1k of size 1024
[  +0.000008] The buggy address is located 496 bytes inside of
               1024-byte region [ffff00003da29000, ffff00003da29400)

[  +0.000015] The buggy address belongs to the physical page:
[  +0.000009] page:fffffc0000f68a00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x3da28
[  +0.000012] head:fffffc0000f68a00 order:3 compound_mapcount:0 compound_pincount:0
[  +0.000009] flags: 0xffff00000010200(slab|head|node=0|zone=0|lastcpupid=0xffff)
[  +0.000019] raw: 0ffff00000010200 fffffc0000eb5c08 fffffc0000d96608 ffff000000002a80
[  +0.000008] raw: 0000000000000000 00000000000a000a 00000001ffffffff 0000000000000000
[  +0.000008] page dumped because: kasan: bad access detected

[  +0.000011] Memory state around the buggy address:
[  +0.000009]  ffff00003da29080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  +0.000007]  ffff00003da29100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  +0.000007] >ffff00003da29180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  +0.000007]                                                              ^
[  +0.000008]  ffff00003da29200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  +0.000006]  ffff00003da29280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  +0.000007] ==================================================================

Fix by keeping track of which encoders were initialised in the meson_drm
structure and manually removing their bridges at aggregate driver's unbind
time.

Signed-off-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220920222842.1053234-1-adrian.larumbe@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_drv.c          |  4 ++++
 drivers/gpu/drm/meson/meson_drv.h          |  7 +++++++
 drivers/gpu/drm/meson/meson_encoder_cvbs.c | 13 +++++++++++++
 drivers/gpu/drm/meson/meson_encoder_cvbs.h |  1 +
 drivers/gpu/drm/meson/meson_encoder_hdmi.c | 13 +++++++++++++
 drivers/gpu/drm/meson/meson_encoder_hdmi.h |  1 +
 6 files changed, 39 insertions(+)

diff --git a/drivers/gpu/drm/meson/meson_drv.c b/drivers/gpu/drm/meson/meson_drv.c
index 8444d90165fb..86b90d0f5780 100644
--- a/drivers/gpu/drm/meson/meson_drv.c
+++ b/drivers/gpu/drm/meson/meson_drv.c
@@ -390,6 +390,10 @@ static void meson_drv_unbind(struct device *dev)
 	drm_atomic_helper_shutdown(drm);
 	free_irq(priv->vsync_irq, drm);
 	drm_dev_put(drm);
+
+	meson_encoder_hdmi_remove(priv);
+	meson_encoder_cvbs_remove(priv);
+
 	component_unbind_all(dev, drm);
 
 	if (priv->afbcd.ops)
diff --git a/drivers/gpu/drm/meson/meson_drv.h b/drivers/gpu/drm/meson/meson_drv.h
index 177dac3ca3be..c62ee358456f 100644
--- a/drivers/gpu/drm/meson/meson_drv.h
+++ b/drivers/gpu/drm/meson/meson_drv.h
@@ -25,6 +25,12 @@ enum vpu_compatible {
 	VPU_COMPATIBLE_G12A = 3,
 };
 
+enum {
+	MESON_ENC_CVBS = 0,
+	MESON_ENC_HDMI,
+	MESON_ENC_LAST,
+};
+
 struct meson_drm_match_data {
 	enum vpu_compatible compat;
 	struct meson_afbcd_ops *afbcd_ops;
@@ -51,6 +57,7 @@ struct meson_drm {
 	struct drm_crtc *crtc;
 	struct drm_plane *primary_plane;
 	struct drm_plane *overlay_plane;
+	void *encoders[MESON_ENC_LAST];
 
 	const struct meson_drm_soc_limits *limits;
 
diff --git a/drivers/gpu/drm/meson/meson_encoder_cvbs.c b/drivers/gpu/drm/meson/meson_encoder_cvbs.c
index 8110a6e39320..5675bc2a92cf 100644
--- a/drivers/gpu/drm/meson/meson_encoder_cvbs.c
+++ b/drivers/gpu/drm/meson/meson_encoder_cvbs.c
@@ -281,5 +281,18 @@ int meson_encoder_cvbs_init(struct meson_drm *priv)
 	}
 	drm_connector_attach_encoder(connector, &meson_encoder_cvbs->encoder);
 
+	priv->encoders[MESON_ENC_CVBS] = meson_encoder_cvbs;
+
 	return 0;
 }
+
+void meson_encoder_cvbs_remove(struct meson_drm *priv)
+{
+	struct meson_encoder_cvbs *meson_encoder_cvbs;
+
+	if (priv->encoders[MESON_ENC_CVBS]) {
+		meson_encoder_cvbs = priv->encoders[MESON_ENC_CVBS];
+		drm_bridge_remove(&meson_encoder_cvbs->bridge);
+		drm_bridge_remove(meson_encoder_cvbs->next_bridge);
+	}
+}
diff --git a/drivers/gpu/drm/meson/meson_encoder_cvbs.h b/drivers/gpu/drm/meson/meson_encoder_cvbs.h
index 61d9d183ce7f..09710fec3c66 100644
--- a/drivers/gpu/drm/meson/meson_encoder_cvbs.h
+++ b/drivers/gpu/drm/meson/meson_encoder_cvbs.h
@@ -25,5 +25,6 @@ struct meson_cvbs_mode {
 extern struct meson_cvbs_mode meson_cvbs_modes[MESON_CVBS_MODES_COUNT];
 
 int meson_encoder_cvbs_init(struct meson_drm *priv);
+void meson_encoder_cvbs_remove(struct meson_drm *priv);
 
 #endif /* __MESON_VENC_CVBS_H */
diff --git a/drivers/gpu/drm/meson/meson_encoder_hdmi.c b/drivers/gpu/drm/meson/meson_encoder_hdmi.c
index a7692584487c..af6025037ecc 100644
--- a/drivers/gpu/drm/meson/meson_encoder_hdmi.c
+++ b/drivers/gpu/drm/meson/meson_encoder_hdmi.c
@@ -446,6 +446,8 @@ int meson_encoder_hdmi_init(struct meson_drm *priv)
 		meson_encoder_hdmi->cec_notifier = notifier;
 	}
 
+	priv->encoders[MESON_ENC_HDMI] = meson_encoder_hdmi;
+
 	dev_dbg(priv->dev, "HDMI encoder initialized\n");
 
 	return 0;
@@ -454,3 +456,14 @@ int meson_encoder_hdmi_init(struct meson_drm *priv)
 	of_node_put(remote);
 	return ret;
 }
+
+void meson_encoder_hdmi_remove(struct meson_drm *priv)
+{
+	struct meson_encoder_hdmi *meson_encoder_hdmi;
+
+	if (priv->encoders[MESON_ENC_HDMI]) {
+		meson_encoder_hdmi = priv->encoders[MESON_ENC_HDMI];
+		drm_bridge_remove(&meson_encoder_hdmi->bridge);
+		drm_bridge_remove(meson_encoder_hdmi->next_bridge);
+	}
+}
diff --git a/drivers/gpu/drm/meson/meson_encoder_hdmi.h b/drivers/gpu/drm/meson/meson_encoder_hdmi.h
index ed19494f0956..a6cd38eb5f71 100644
--- a/drivers/gpu/drm/meson/meson_encoder_hdmi.h
+++ b/drivers/gpu/drm/meson/meson_encoder_hdmi.h
@@ -8,5 +8,6 @@
 #define __MESON_ENCODER_HDMI_H
 
 int meson_encoder_hdmi_init(struct meson_drm *priv);
+void meson_encoder_hdmi_remove(struct meson_drm *priv);
 
 #endif /* __MESON_ENCODER_HDMI_H */
-- 
2.35.1



