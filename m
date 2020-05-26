Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 365711AC84D
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389075AbgDPNwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:52:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408836AbgDPNwF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:52:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D806020732;
        Thu, 16 Apr 2020 13:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045124;
        bh=vP3JJAffYxZCvXlEdLKGTWxwoN2n85VkPRZo0AD7VwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YbxGs3x4oMeSRecDt3MfT+p9lgU9c4vqvcF/w9kwqRNzwYZfiUi2VpoqgWORGnlru
         rtjsaa715LVz0N7C7HUxiMW4X6fy+dQSDgz9+XuQX0/gD2wc5k7xd7h/O0CJDf9BRt
         uzBXArEw0fq9cDWVqnymaVIBSDPKQVv7k2JJrhhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Sean Paul <sean@poorly.run>, Wayne Lin <Wayne.Lin@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 226/232] Revert "drm/dp_mst: Remove VCPI while disabling topology mgr"
Date:   Thu, 16 Apr 2020 15:25:20 +0200
Message-Id: <20200416131343.776061824@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a86675968e2300fb567994459da3dbc4cd1b322a ]

This reverts commit 64e62bdf04ab8529f45ed0a85122c703035dec3a.

This commit ends up causing some lockdep splats due to trying to grab the
payload lock while holding the mgr's lock:

[   54.010099]
[   54.011765] ======================================================
[   54.018670] WARNING: possible circular locking dependency detected
[   54.025577] 5.5.0-rc6-02274-g77381c23ee63 #47 Not tainted
[   54.031610] ------------------------------------------------------
[   54.038516] kworker/1:6/1040 is trying to acquire lock:
[   54.044354] ffff888272af3228 (&mgr->payload_lock){+.+.}, at:
drm_dp_mst_topology_mgr_set_mst+0x218/0x2e4
[   54.054957]
[   54.054957] but task is already holding lock:
[   54.061473] ffff888272af3060 (&mgr->lock){+.+.}, at:
drm_dp_mst_topology_mgr_set_mst+0x3c/0x2e4
[   54.071193]
[   54.071193] which lock already depends on the new lock.
[   54.071193]
[   54.080334]
[   54.080334] the existing dependency chain (in reverse order) is:
[   54.088697]
[   54.088697] -> #1 (&mgr->lock){+.+.}:
[   54.094440]        __mutex_lock+0xc3/0x498
[   54.099015]        drm_dp_mst_topology_get_port_validated+0x25/0x80
[   54.106018]        drm_dp_update_payload_part1+0xa2/0x2e2
[   54.112051]        intel_mst_pre_enable_dp+0x144/0x18f
[   54.117791]        intel_encoders_pre_enable+0x63/0x70
[   54.123532]        hsw_crtc_enable+0xa1/0x722
[   54.128396]        intel_update_crtc+0x50/0x194
[   54.133455]        skl_commit_modeset_enables+0x40c/0x540
[   54.139485]        intel_atomic_commit_tail+0x5f7/0x130d
[   54.145418]        intel_atomic_commit+0x2c8/0x2d8
[   54.150770]        drm_atomic_helper_set_config+0x5a/0x70
[   54.156801]        drm_mode_setcrtc+0x2ab/0x833
[   54.161862]        drm_ioctl+0x2e5/0x424
[   54.166242]        vfs_ioctl+0x21/0x2f
[   54.170426]        do_vfs_ioctl+0x5fb/0x61e
[   54.175096]        ksys_ioctl+0x55/0x75
[   54.179377]        __x64_sys_ioctl+0x1a/0x1e
[   54.184146]        do_syscall_64+0x5c/0x6d
[   54.188721]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   54.194946]
[   54.194946] -> #0 (&mgr->payload_lock){+.+.}:
[   54.201463]
[   54.201463] other info that might help us debug this:
[   54.201463]
[   54.210410]  Possible unsafe locking scenario:
[   54.210410]
[   54.217025]        CPU0                    CPU1
[   54.222082]        ----                    ----
[   54.227138]   lock(&mgr->lock);
[   54.230643]                                lock(&mgr->payload_lock);
[   54.237742]                                lock(&mgr->lock);
[   54.244062]   lock(&mgr->payload_lock);
[   54.248346]
[   54.248346]  *** DEADLOCK ***
[   54.248346]
[   54.254959] 7 locks held by kworker/1:6/1040:
[   54.259822]  #0: ffff888275c4f528 ((wq_completion)events){+.+.},
at: worker_thread+0x455/0x6e2
[   54.269451]  #1: ffffc9000119beb0
((work_completion)(&(&dev_priv->hotplug.hotplug_work)->work)){+.+.},
at: worker_thread+0x455/0x6e2
[   54.282768]  #2: ffff888272a403f0 (&dev->mode_config.mutex){+.+.},
at: i915_hotplug_work_func+0x4b/0x2be
[   54.293368]  #3: ffffffff824fc6c0 (drm_connector_list_iter){.+.+},
at: i915_hotplug_work_func+0x17e/0x2be
[   54.304061]  #4: ffffc9000119bc58 (crtc_ww_class_acquire){+.+.},
at: drm_helper_probe_detect_ctx+0x40/0xfd
[   54.314855]  #5: ffff888272a40470 (crtc_ww_class_mutex){+.+.}, at:
drm_modeset_lock+0x74/0xe2
[   54.324385]  #6: ffff888272af3060 (&mgr->lock){+.+.}, at:
drm_dp_mst_topology_mgr_set_mst+0x3c/0x2e4
[   54.334597]
[   54.334597] stack backtrace:
[   54.339464] CPU: 1 PID: 1040 Comm: kworker/1:6 Not tainted
5.5.0-rc6-02274-g77381c23ee63 #47
[   54.348893] Hardware name: Google Fizz/Fizz, BIOS
Google_Fizz.10139.39.0 01/04/2018
[   54.357451] Workqueue: events i915_hotplug_work_func
[   54.362995] Call Trace:
[   54.365724]  dump_stack+0x71/0x9c
[   54.369427]  check_noncircular+0x91/0xbc
[   54.373809]  ? __lock_acquire+0xc9e/0xf66
[   54.378286]  ? __lock_acquire+0xc9e/0xf66
[   54.382763]  ? lock_acquire+0x175/0x1ac
[   54.387048]  ? drm_dp_mst_topology_mgr_set_mst+0x218/0x2e4
[   54.393177]  ? __mutex_lock+0xc3/0x498
[   54.397362]  ? drm_dp_mst_topology_mgr_set_mst+0x218/0x2e4
[   54.403492]  ? drm_dp_mst_topology_mgr_set_mst+0x218/0x2e4
[   54.409620]  ? drm_dp_dpcd_access+0xd9/0x101
[   54.414390]  ? drm_dp_mst_topology_mgr_set_mst+0x218/0x2e4
[   54.420517]  ? drm_dp_mst_topology_mgr_set_mst+0x218/0x2e4
[   54.426645]  ? intel_digital_port_connected+0x34d/0x35c
[   54.432482]  ? intel_dp_detect+0x227/0x44e
[   54.437056]  ? ww_mutex_lock+0x49/0x9a
[   54.441242]  ? drm_helper_probe_detect_ctx+0x75/0xfd
[   54.446789]  ? intel_encoder_hotplug+0x4b/0x97
[   54.451752]  ? intel_ddi_hotplug+0x61/0x2e0
[   54.456423]  ? mark_held_locks+0x53/0x68
[   54.460803]  ? _raw_spin_unlock_irqrestore+0x3a/0x51
[   54.466347]  ? lockdep_hardirqs_on+0x187/0x1a4
[   54.471310]  ? drm_connector_list_iter_next+0x89/0x9a
[   54.476953]  ? i915_hotplug_work_func+0x206/0x2be
[   54.482208]  ? worker_thread+0x4d5/0x6e2
[   54.486587]  ? worker_thread+0x455/0x6e2
[   54.490966]  ? queue_work_on+0x64/0x64
[   54.495151]  ? kthread+0x1e9/0x1f1
[   54.498946]  ? queue_work_on+0x64/0x64
[   54.503130]  ? kthread_unpark+0x5e/0x5e
[   54.507413]  ? ret_from_fork+0x3a/0x50

The proper fix for this is probably cleanup the VCPI allocations when we're
enabling the topology, or on the first payload allocation. For now though,
let's just revert.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: 64e62bdf04ab ("drm/dp_mst: Remove VCPI while disabling topology mgr")
Cc: Sean Paul <sean@poorly.run>
Cc: Wayne Lin <Wayne.Lin@amd.com>
Reviewed-by: Sean Paul <sean@poorly.run>
Link: https://patchwork.freedesktop.org/patch/msgid/20200117205149.97262-1-lyude@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index c5e9e2305fffc..a48a4c21b1b38 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -2694,7 +2694,6 @@ static bool drm_dp_get_vc_payload_bw(int dp_link_bw,
 int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_mst_topology_mgr *mgr, bool mst_state)
 {
 	int ret = 0;
-	int i = 0;
 	struct drm_dp_mst_branch *mstb = NULL;
 
 	mutex_lock(&mgr->lock);
@@ -2755,21 +2754,10 @@ int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_mst_topology_mgr *mgr, bool ms
 		/* this can fail if the device is gone */
 		drm_dp_dpcd_writeb(mgr->aux, DP_MSTM_CTRL, 0);
 		ret = 0;
-		mutex_lock(&mgr->payload_lock);
 		memset(mgr->payloads, 0, mgr->max_payloads * sizeof(struct drm_dp_payload));
 		mgr->payload_mask = 0;
 		set_bit(0, &mgr->payload_mask);
-		for (i = 0; i < mgr->max_payloads; i++) {
-			struct drm_dp_vcpi *vcpi = mgr->proposed_vcpis[i];
-
-			if (vcpi) {
-				vcpi->vcpi = 0;
-				vcpi->num_slots = 0;
-			}
-			mgr->proposed_vcpis[i] = NULL;
-		}
 		mgr->vcpi_mask = 0;
-		mutex_unlock(&mgr->payload_lock);
 	}
 
 out_unlock:
-- 
2.20.1



