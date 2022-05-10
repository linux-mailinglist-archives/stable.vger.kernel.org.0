Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDB9B5219B8
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243712AbiEJNux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244632AbiEJNqy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:46:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E05C166087;
        Tue, 10 May 2022 06:31:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 29FBBCE1EF3;
        Tue, 10 May 2022 13:31:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409DCC385C2;
        Tue, 10 May 2022 13:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189501;
        bh=YFToRyVXhmzLDZgl3f3DToTAGiJM3j38EqlIn1xAvSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=13Rhj9KBnjlp2IeVAffI+HT6l9CksGl/7+8sphCJq3IXuDfWzuGLW46xwmsuAJE0J
         PG4B7JeVZbLwahpO6t2yxFHnwDSDDF/mfRU5VsqZv3yPpNgekGGY0dQ2IJqikbIcYc
         4jrEiRT12aJhePtdbdVHmn7Fmmr/yXoy3udTmwQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Kuogee Hsieh <quic_khsieh@quicinc.com>,
        Rob Clark <robdclark@chromium.org>
Subject: [PATCH 5.15 070/135] drm/msm/dp: remove fail safe mode related code
Date:   Tue, 10 May 2022 15:07:32 +0200
Message-Id: <20220510130742.420309289@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuogee Hsieh <quic_khsieh@quicinc.com>

commit 3f65b1e2f424f44585bd701024a3bfd0b1e0ade2 upstream.

Current DP driver implementation has adding safe mode done at
dp_hpd_plug_handle() which is expected to be executed under event
thread context.

However there is possible circular locking happen (see blow stack trace)
after edp driver call dp_hpd_plug_handle() from dp_bridge_enable() which
is executed under drm_thread context.

After review all possibilities methods and as discussed on
https://patchwork.freedesktop.org/patch/483155/, supporting EDID
compliance tests in the driver is quite hacky. As seen with other
vendor drivers, supporting these will be much easier with IGT. Hence
removing all the related fail safe code for it so that no possibility
of circular lock will happen.
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

======================================================
 WARNING: possible circular locking dependency detected
 5.15.35-lockdep #6 Tainted: G        W
 ------------------------------------------------------
 frecon/429 is trying to acquire lock:
 ffffff808dc3c4e8 (&dev->mode_config.mutex){+.+.}-{3:3}, at:
dp_panel_add_fail_safe_mode+0x4c/0xa0

 but task is already holding lock:
 ffffff808dc441e0 (&kms->commit_lock[i]){+.+.}-{3:3}, at: lock_crtcs+0xb4/0x124

 which lock already depends on the new lock.

 the existing dependency chain (in reverse order) is:

 -> #3 (&kms->commit_lock[i]){+.+.}-{3:3}:
        __mutex_lock_common+0x174/0x1a64
        mutex_lock_nested+0x98/0xac
        lock_crtcs+0xb4/0x124
        msm_atomic_commit_tail+0x330/0x748
        commit_tail+0x19c/0x278
        drm_atomic_helper_commit+0x1dc/0x1f0
        drm_atomic_commit+0xc0/0xd8
        drm_atomic_helper_set_config+0xb4/0x134
        drm_mode_setcrtc+0x688/0x1248
        drm_ioctl_kernel+0x1e4/0x338
        drm_ioctl+0x3a4/0x684
        __arm64_sys_ioctl+0x118/0x154
        invoke_syscall+0x78/0x224
        el0_svc_common+0x178/0x200
        do_el0_svc+0x94/0x13c
        el0_svc+0x5c/0xec
        el0t_64_sync_handler+0x78/0x108
        el0t_64_sync+0x1a4/0x1a8

 -> #2 (crtc_ww_class_mutex){+.+.}-{3:3}:
        __mutex_lock_common+0x174/0x1a64
        ww_mutex_lock+0xb8/0x278
        modeset_lock+0x304/0x4ac
        drm_modeset_lock+0x4c/0x7c
        drmm_mode_config_init+0x4a8/0xc50
        msm_drm_init+0x274/0xac0
        msm_drm_bind+0x20/0x2c
        try_to_bring_up_master+0x3dc/0x470
        __component_add+0x18c/0x3c0
        component_add+0x1c/0x28
        dp_display_probe+0x954/0xa98
        platform_probe+0x124/0x15c
        really_probe+0x1b0/0x5f8
        __driver_probe_device+0x174/0x20c
        driver_probe_device+0x70/0x134
        __device_attach_driver+0x130/0x1d0
        bus_for_each_drv+0xfc/0x14c
        __device_attach+0x1bc/0x2bc
        device_initial_probe+0x1c/0x28
        bus_probe_device+0x94/0x178
        deferred_probe_work_func+0x1a4/0x1f0
        process_one_work+0x5d4/0x9dc
        worker_thread+0x898/0xccc
        kthread+0x2d4/0x3d4
        ret_from_fork+0x10/0x20

 -> #1 (crtc_ww_class_acquire){+.+.}-{0:0}:
        ww_acquire_init+0x1c4/0x2c8
        drm_modeset_acquire_init+0x44/0xc8
        drm_helper_probe_single_connector_modes+0xb0/0x12dc
        drm_mode_getconnector+0x5dc/0xfe8
        drm_ioctl_kernel+0x1e4/0x338
        drm_ioctl+0x3a4/0x684
        __arm64_sys_ioctl+0x118/0x154
        invoke_syscall+0x78/0x224
        el0_svc_common+0x178/0x200
        do_el0_svc+0x94/0x13c
        el0_svc+0x5c/0xec
        el0t_64_sync_handler+0x78/0x108
        el0t_64_sync+0x1a4/0x1a8

 -> #0 (&dev->mode_config.mutex){+.+.}-{3:3}:
        __lock_acquire+0x2650/0x672c
        lock_acquire+0x1b4/0x4ac
        __mutex_lock_common+0x174/0x1a64
        mutex_lock_nested+0x98/0xac
        dp_panel_add_fail_safe_mode+0x4c/0xa0
        dp_hpd_plug_handle+0x1f0/0x280
        dp_bridge_enable+0x94/0x2b8
        drm_atomic_bridge_chain_enable+0x11c/0x168
        drm_atomic_helper_commit_modeset_enables+0x500/0x740
        msm_atomic_commit_tail+0x3e4/0x748
        commit_tail+0x19c/0x278
        drm_atomic_helper_commit+0x1dc/0x1f0
        drm_atomic_commit+0xc0/0xd8
        drm_atomic_helper_set_config+0xb4/0x134
        drm_mode_setcrtc+0x688/0x1248
        drm_ioctl_kernel+0x1e4/0x338
        drm_ioctl+0x3a4/0x684
        __arm64_sys_ioctl+0x118/0x154
        invoke_syscall+0x78/0x224
        el0_svc_common+0x178/0x200
        do_el0_svc+0x94/0x13c
        el0_svc+0x5c/0xec
        el0t_64_sync_handler+0x78/0x108
        el0t_64_sync+0x1a4/0x1a8

Changes in v2:
-- re text commit title
-- remove all fail safe mode

Changes in v3:
-- remove dp_panel_add_fail_safe_mode() from dp_panel.h
-- add Fixes

Changes in v5:
--  to=dianders@chromium.org

Changes in v6:
--  fix Fixes commit ID

Fixes: 8b2c181e3dcf ("drm/msm/dp: add fail safe mode outside of event_mutex context")
Reported-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Link: https://lore.kernel.org/r/1651007534-31842-1-git-send-email-quic_khsieh@quicinc.com
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c |    6 ------
 drivers/gpu/drm/msm/dp/dp_panel.c   |   11 -----------
 drivers/gpu/drm/msm/dp/dp_panel.h   |    1 -
 3 files changed, 18 deletions(-)

--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -551,12 +551,6 @@ static int dp_hpd_plug_handle(struct dp_
 
 	mutex_unlock(&dp->event_mutex);
 
-	/*
-	 * add fail safe mode outside event_mutex scope
-	 * to avoid potiential circular lock with drm thread
-	 */
-	dp_panel_add_fail_safe_mode(dp->dp_display.connector);
-
 	/* uevent will complete connection part */
 	return 0;
 };
--- a/drivers/gpu/drm/msm/dp/dp_panel.c
+++ b/drivers/gpu/drm/msm/dp/dp_panel.c
@@ -151,15 +151,6 @@ static int dp_panel_update_modes(struct
 	return rc;
 }
 
-void dp_panel_add_fail_safe_mode(struct drm_connector *connector)
-{
-	/* fail safe edid */
-	mutex_lock(&connector->dev->mode_config.mutex);
-	if (drm_add_modes_noedid(connector, 640, 480))
-		drm_set_preferred_mode(connector, 640, 480);
-	mutex_unlock(&connector->dev->mode_config.mutex);
-}
-
 int dp_panel_read_sink_caps(struct dp_panel *dp_panel,
 	struct drm_connector *connector)
 {
@@ -215,8 +206,6 @@ int dp_panel_read_sink_caps(struct dp_pa
 			rc = -ETIMEDOUT;
 			goto end;
 		}
-
-		dp_panel_add_fail_safe_mode(connector);
 	}
 
 	if (panel->aux_cfg_update_done) {
--- a/drivers/gpu/drm/msm/dp/dp_panel.h
+++ b/drivers/gpu/drm/msm/dp/dp_panel.h
@@ -59,7 +59,6 @@ int dp_panel_init_panel_info(struct dp_p
 int dp_panel_deinit(struct dp_panel *dp_panel);
 int dp_panel_timing_cfg(struct dp_panel *dp_panel);
 void dp_panel_dump_regs(struct dp_panel *dp_panel);
-void dp_panel_add_fail_safe_mode(struct drm_connector *connector);
 int dp_panel_read_sink_caps(struct dp_panel *dp_panel,
 		struct drm_connector *connector);
 u32 dp_panel_get_mode_bpp(struct dp_panel *dp_panel, u32 mode_max_bpp,


