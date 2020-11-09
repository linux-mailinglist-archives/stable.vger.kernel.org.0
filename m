Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787412ABAD0
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733286AbgKINWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:22:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:50192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388181AbgKINWN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:22:13 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F56520897;
        Mon,  9 Nov 2020 13:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604928132;
        bh=rh+yamCrNpKlbritzWA0kXGJsv6zk9B6xt0Immc13EM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mdaPxTvD33YNMhVZqjMqhTJW8GVGowB+/0xpNJSc1M8SX5TfKZm5LlmNJOfh1HK7A
         N/oggY+duRT7wH3tflKBoKEVkwXZRR8ihzZXt1CaiQHbHV5vL4RM3F0Z+TMk4gEzZ8
         p92avC/sWwZ28SROrHRtS7qJ6nMkhdgx8l1Dqq/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, William Tseng <william.tseng@intel.com>,
        Cooper Chiou <cooper.chiou@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Anshuman Gupta <anshuman.gupta@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.9 131/133] drm/i915: Fix encoder lookup during PSR atomic check
Date:   Mon,  9 Nov 2020 13:56:33 +0100
Message-Id: <20201109125036.991998007@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

commit d9a57c853975742c8281f703b9e536d8aa016ec2 upstream.

The atomic check hooks must look up the encoder to be used with a
connector from the connector's atomic state, and not assume that it's
the connector's current attached encoder. The latter one can change
under the atomic check func, or can be unset yet as in the case of MST
connectors.

This fixes
[    7.940719] Oops: 0000 [#1] SMP NOPTI
[    7.944407] CPU: 2 PID: 143 Comm: kworker/2:2 Not tainted 5.6.0-1023-oem #23-Ubuntu
[    7.952102] Hardware name: Dell Inc. Latitude 7320/, BIOS 88.87.11 09/07/2020
[    7.959278] Workqueue: events output_poll_execute [drm_kms_helper]
[    7.965511] RIP: 0010:intel_psr_atomic_check+0x37/0xa0 [i915]
[    7.971327] Code: 80 2d 06 00 00 20 74 42 80 b8 34 71 00 00 00 74 39 48 8b 72 08 48 85 f6 74 30 80 b8 f8 71 00 00 00 74 27 4c 8b 87 80 04 00 00 <41> 8b 78 78 83 ff 08 77 19 31 c9 83 ff 05 77 19 48 81 c1 20 01 00
[    7.977541] input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input5
[    7.990154] RSP: 0018:ffffb864c073fac8 EFLAGS: 00010202
[    7.990155] RAX: ffff8c5d55ce0000 RBX: ffff8c5d54519000 RCX: 0000000000000000
[    7.990155] RDX: ffff8c5d55cb30c0 RSI: ffff8c5d89a0c800 RDI: ffff8c5d55fcf800
[    7.990156] RBP: ffffb864c073fac8 R08: 0000000000000000 R09: ffff8c5d55d9f3a0
[    7.990156] R10: ffff8c5d55cb30c0 R11: 0000000000000009 R12: ffff8c5d55fcf800
[    7.990156] R13: ffff8c5d55cb30c0 R14: ffff8c5d56989cc0 R15: ffff8c5d56989cc0
[    7.990158] FS:  0000000000000000(0000) GS:ffff8c5d8e480000(0000) knlGS:0000000000000000
[    8.047193] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    8.052970] CR2: 0000000000000078 CR3: 0000000856500005 CR4: 0000000000760ee0
[    8.060137] PKRU: 55555554
[    8.062867] Call Trace:
[    8.065361]  intel_digital_connector_atomic_check+0x53/0x130 [i915]
[    8.071703]  intel_dp_mst_atomic_check+0x5b/0x200 [i915]
[    8.077074]  drm_atomic_helper_check_modeset+0x1db/0x790 [drm_kms_helper]
[    8.083942]  intel_atomic_check+0x92/0xc50 [i915]
[    8.088705]  ? drm_plane_check_pixel_format+0x4f/0xb0 [drm]
[    8.094345]  ? drm_atomic_plane_check+0x7a/0x3a0 [drm]
[    8.099548]  drm_atomic_check_only+0x2b1/0x450 [drm]
[    8.104573]  drm_atomic_commit+0x18/0x50 [drm]
[    8.109070]  drm_client_modeset_commit_atomic+0x1c9/0x200 [drm]
[    8.115056]  drm_client_modeset_commit_force+0x55/0x160 [drm]
[    8.120866]  drm_fb_helper_restore_fbdev_mode_unlocked+0x54/0xb0 [drm_kms_helper]
[    8.128415]  drm_fb_helper_set_par+0x34/0x50 [drm_kms_helper]
[    8.134225]  drm_fb_helper_hotplug_event.part.0+0xb4/0xe0 [drm_kms_helper]
[    8.141150]  drm_fb_helper_hotplug_event+0x1c/0x30 [drm_kms_helper]
[    8.147481]  intel_fbdev_output_poll_changed+0x6f/0xa0 [i915]
[    8.153287]  drm_kms_helper_hotplug_event+0x2c/0x40 [drm_kms_helper]
[    8.159709]  output_poll_execute+0x1aa/0x1c0 [drm_kms_helper]
[    8.165506]  process_one_work+0x1e8/0x3b0
[    8.169561]  worker_thread+0x4d/0x400
[    8.173249]  kthread+0x104/0x140
[    8.176515]  ? process_one_work+0x3b0/0x3b0
[    8.180726]  ? kthread_park+0x90/0x90
[    8.184416]  ret_from_fork+0x1f/0x40

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2361
Reported-by: William Tseng <william.tseng@intel.com>
Reported-by: Cooper Chiou <cooper.chiou@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Anshuman Gupta <anshuman.gupta@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201027160928.3665377-1-imre.deak@intel.com
(cherry picked from commit 00e5deb5c4f5fe367311465e720e65cfa1178792)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/display/intel_psr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -1672,7 +1672,7 @@ void intel_psr_atomic_check(struct drm_c
 		return;
 
 	intel_connector = to_intel_connector(connector);
-	dig_port = enc_to_dig_port(intel_attached_encoder(intel_connector));
+	dig_port = enc_to_dig_port(to_intel_encoder(new_state->best_encoder));
 	if (dev_priv->psr.dp != &dig_port->dp)
 		return;
 


