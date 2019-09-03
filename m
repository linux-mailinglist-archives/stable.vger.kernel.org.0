Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6174A6F61
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730817AbfICQch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:32:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731419AbfICQcP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:32:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CAE8238C5;
        Tue,  3 Sep 2019 16:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528333;
        bh=lHLzGeJ80lC6PwD/xjvFZt99d22R34+rzxc8vyTl0Tc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KA14D7GFs/ZVkizXQACJE+72ZYx6XT8BB9e4iKX98iUK1tGKsAluNTFIlIGXhSnGR
         jBtEls0rYOIzj0DRuljJsHQaekWzHX3qqToREv7aqiq8dlpLW2+Qj5gHUq5OR+zf/o
         2e3MQqN7gXkLIwzyyhmNKbBuqu6St30ejVMNQWDQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lyude Paul <lyude@redhat.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 163/167] drm/atomic_helper: Allow DPMS On<->Off changes for unregistered connectors
Date:   Tue,  3 Sep 2019 12:25:15 -0400
Message-Id: <20190903162519.7136-163-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

[ Upstream commit 34ca26a98ad67edd6e4870fe2d4aa047d41a51dd ]

It appears when testing my previous fix for some of the legacy
modesetting issues with MST, I misattributed some kernel splats that
started appearing on my machine after a rebase as being from upstream.
But it appears they actually came from my patch series:

[    2.980512] [drm:drm_atomic_helper_check_modeset [drm_kms_helper]] Updating routing for [CONNECTOR:65:eDP-1]
[    2.980516] [drm:drm_atomic_helper_check_modeset [drm_kms_helper]] [CONNECTOR:65:eDP-1] is not registered
[    2.980516] ------------[ cut here ]------------
[    2.980519] Could not determine valid watermarks for inherited state
[    2.980553] WARNING: CPU: 3 PID: 551 at drivers/gpu/drm/i915/intel_display.c:14983 intel_modeset_init+0x14d7/0x19f0 [i915]
[    2.980556] Modules linked in: i915(O+) i2c_algo_bit drm_kms_helper(O) syscopyarea sysfillrect sysimgblt fb_sys_fops drm(O) intel_rapl x86_pkg_temp_thermal iTCO_wdt wmi_bmof coretemp crc32_pclmul psmouse i2c_i801 mei_me mei i2c_core lpc_ich mfd_core tpm_tis tpm_tis_core wmi tpm thinkpad_acpi pcc_cpufreq video ehci_pci crc32c_intel serio_raw ehci_hcd xhci_pci xhci_hcd
[    2.980577] CPU: 3 PID: 551 Comm: systemd-udevd Tainted: G           O      4.19.0-rc7Lyude-Test+ #1
[    2.980579] Hardware name: LENOVO 20BWS1KY00/20BWS1KY00, BIOS JBET63WW (1.27 ) 11/10/2016
[    2.980605] RIP: 0010:intel_modeset_init+0x14d7/0x19f0 [i915]
[    2.980607] Code: 89 df e8 ec 27 02 00 e9 24 f2 ff ff be 03 00 00 00 48 89 df e8 da 27 02 00 e9 26 f2 ff ff 48 c7 c7 c8 d1 34 a0 e8 23 cf dc e0 <0f> 0b e9 7c fd ff ff f6 c4 04 0f 85 37 f7 ff ff 48 8b 83 60 08 00
[    2.980611] RSP: 0018:ffffc90000287988 EFLAGS: 00010282
[    2.980614] RAX: 0000000000000000 RBX: ffff88031b488000 RCX: 0000000000000006
[    2.980617] RDX: 0000000000000007 RSI: 0000000000000086 RDI: ffff880321ad54d0
[    2.980620] RBP: ffffc90000287a10 R08: 000000000000040a R09: 0000000000000065
[    2.980623] R10: ffff88030ebb8f00 R11: ffffffff81416590 R12: ffff88031b488000
[    2.980626] R13: ffff88031b4883a0 R14: ffffc900002879a8 R15: ffff880319099800
[    2.980630] FS:  00007f475620d180(0000) GS:ffff880321ac0000(0000) knlGS:0000000000000000
[    2.980633] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.980636] CR2: 00007f9ef28018a0 CR3: 000000031b72c001 CR4: 00000000003606e0
[    2.980639] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    2.980642] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    2.980645] Call Trace:
[    2.980675]  i915_driver_load+0xb0e/0xdc0 [i915]
[    2.980681]  ? kernfs_add_one+0xe7/0x130
[    2.980709]  i915_pci_probe+0x46/0x60 [i915]
[    2.980715]  pci_device_probe+0xd4/0x150
[    2.980719]  really_probe+0x243/0x3b0
[    2.980722]  driver_probe_device+0xba/0x100
[    2.980726]  __driver_attach+0xe4/0x110
[    2.980729]  ? driver_probe_device+0x100/0x100
[    2.980733]  bus_for_each_dev+0x74/0xb0
[    2.980736]  driver_attach+0x1e/0x20
[    2.980739]  bus_add_driver+0x159/0x230
[    2.980743]  ? 0xffffffffa0393000
[    2.980746]  driver_register+0x70/0xc0
[    2.980749]  ? 0xffffffffa0393000
[    2.980753]  __pci_register_driver+0x57/0x60
[    2.980780]  i915_init+0x55/0x58 [i915]
[    2.980785]  do_one_initcall+0x4a/0x1c4
[    2.980789]  ? do_init_module+0x27/0x210
[    2.980793]  ? kmem_cache_alloc_trace+0x131/0x190
[    2.980797]  do_init_module+0x60/0x210
[    2.980800]  load_module+0x2063/0x22e0
[    2.980804]  ? vfs_read+0x116/0x140
[    2.980807]  ? vfs_read+0x116/0x140
[    2.980811]  __do_sys_finit_module+0xbd/0x120
[    2.980814]  ? __do_sys_finit_module+0xbd/0x120
[    2.980818]  __x64_sys_finit_module+0x1a/0x20
[    2.980821]  do_syscall_64+0x5a/0x110
[    2.980824]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[    2.980826] RIP: 0033:0x7f4754e32879
[    2.980828] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d f7 45 2c 00 f7 d8 64 89 01 48
[    2.980831] RSP: 002b:00007fff43fd97d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[    2.980834] RAX: ffffffffffffffda RBX: 0000559a44ca64f0 RCX: 00007f4754e32879
[    2.980836] RDX: 0000000000000000 RSI: 00007f475599f4cd RDI: 0000000000000018
[    2.980838] RBP: 00007f475599f4cd R08: 0000000000000000 R09: 0000000000000000
[    2.980839] R10: 0000000000000018 R11: 0000000000000246 R12: 0000000000000000
[    2.980841] R13: 0000559a44c92fd0 R14: 0000000000020000 R15: 0000000000000000
[    2.980881] WARNING: CPU: 3 PID: 551 at drivers/gpu/drm/i915/intel_display.c:14983 intel_modeset_init+0x14d7/0x19f0 [i915]
[    2.980884] ---[ end trace 5eb47a76277d4731 ]---

The cause of this appears to be due to the fact that if there's
pre-existing display state that was set by the BIOS when i915 loads, it
will attempt to perform a modeset before the driver is registered with
userspace. Since this happens before the driver's registered with
userspace, it's connectors are also unregistered and thus-states which
would turn on DPMS on a connector end up getting rejected since the
connector isn't registered.

These bugs managed to get past Intel's CI partially due to the fact it
never ran a full test on my patches for some reason, but also because
all of the tests unload the GPU once before running. Since this bug is
only really triggered when the drivers tries to perform a modeset before
it's been fully registered with userspace when coming from whatever
display configuration the firmware left us with, it likely would never
have been picked up by CI in the first place.

After some discussion with vsyrjala, we decided the best course of
action would be to just move the unregistered connector checks out of
update_connector_routing() and into drm_atomic_set_crtc_for_connector().
The reason for this being that legacy modesetting isn't going to be
expecting failures anywhere (at least this is the case with X), so
ideally we want to ensure that any DPMS changes will still work even on
unregistered connectors. Instead, we now only reject new modesets which
would change the current CRTC assigned to an unregistered connector
unless no new CRTC is being assigned to replace the connector's previous
one.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Reported-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Fixes: 4d80273976bf ("drm/atomic_helper: Disallow new modesets on unregistered connectors")
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20181009204424.21462-1-lyude@redhat.com
(cherry picked from commit b5d29843d8ef86d4cde4742e095b81b7fd41e688)
Fixes: e96550956fbc ("drm/atomic_helper: Disallow new modesets on unregistered connectors")
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_atomic.c        | 21 +++++++++++++++++++++
 drivers/gpu/drm/drm_atomic_helper.c | 21 +--------------------
 2 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
index 281cf9cbb44c4..1a4b44923aeca 100644
--- a/drivers/gpu/drm/drm_atomic.c
+++ b/drivers/gpu/drm/drm_atomic.c
@@ -1702,6 +1702,27 @@ drm_atomic_set_crtc_for_connector(struct drm_connector_state *conn_state,
 	struct drm_connector *connector = conn_state->connector;
 	struct drm_crtc_state *crtc_state;
 
+	/*
+	 * For compatibility with legacy users, we want to make sure that
+	 * we allow DPMS On<->Off modesets on unregistered connectors, since
+	 * legacy modesetting users will not be expecting these to fail. We do
+	 * not however, want to allow legacy users to assign a connector
+	 * that's been unregistered from sysfs to another CRTC, since doing
+	 * this with a now non-existent connector could potentially leave us
+	 * in an invalid state.
+	 *
+	 * Since the connector can be unregistered at any point during an
+	 * atomic check or commit, this is racy. But that's OK: all we care
+	 * about is ensuring that userspace can't use this connector for new
+	 * configurations after it's been notified that the connector is no
+	 * longer present.
+	 */
+	if (!READ_ONCE(connector->registered) && crtc) {
+		DRM_DEBUG_ATOMIC("[CONNECTOR:%d:%s] is not registered\n",
+				 connector->base.id, connector->name);
+		return -EINVAL;
+	}
+
 	if (conn_state->crtc == crtc)
 		return 0;
 
diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index 71c70a031a043..c22062cc99923 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -307,26 +307,6 @@ update_connector_routing(struct drm_atomic_state *state,
 		return 0;
 	}
 
-	crtc_state = drm_atomic_get_new_crtc_state(state,
-						   new_connector_state->crtc);
-	/*
-	 * For compatibility with legacy users, we want to make sure that
-	 * we allow DPMS On->Off modesets on unregistered connectors. Modesets
-	 * which would result in anything else must be considered invalid, to
-	 * avoid turning on new displays on dead connectors.
-	 *
-	 * Since the connector can be unregistered at any point during an
-	 * atomic check or commit, this is racy. But that's OK: all we care
-	 * about is ensuring that userspace can't do anything but shut off the
-	 * display on a connector that was destroyed after its been notified,
-	 * not before.
-	 */
-	if (!READ_ONCE(connector->registered) && crtc_state->active) {
-		DRM_DEBUG_ATOMIC("[CONNECTOR:%d:%s] is not registered\n",
-				 connector->base.id, connector->name);
-		return -EINVAL;
-	}
-
 	funcs = connector->helper_private;
 
 	if (funcs->atomic_best_encoder)
@@ -371,6 +351,7 @@ update_connector_routing(struct drm_atomic_state *state,
 
 	set_best_encoder(state, new_connector_state, new_encoder);
 
+	crtc_state = drm_atomic_get_new_crtc_state(state, new_connector_state->crtc);
 	crtc_state->connectors_changed = true;
 
 	DRM_DEBUG_ATOMIC("[CONNECTOR:%d:%s] using [ENCODER:%d:%s] on [CRTC:%d:%s]\n",
-- 
2.20.1

