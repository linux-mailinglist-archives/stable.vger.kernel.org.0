Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8929D24BE16
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgHTNU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:20:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728360AbgHTJeg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:34:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE56322C9F;
        Thu, 20 Aug 2020 09:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916076;
        bh=qvaLxjbELX6OsMf9i4nIX/FIJZiEThNuKSSd5MVM3PY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q5fT5q7gkvS1N2MKv7eVjVJVpNpVlcGJrhsLQnR+n10fACbjvjesmgSL9YmeWRHad
         N/NO7w0+jemEU+TdVBEaLCt9QDJt7ZtSYIchWmkZHcHSGMqbkooqJnelHtATUFlswg
         4fjHmh8FIiJUHF3bO7nDk60hvILiE0wAJWnoNeV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Sean Paul <sean@poorly.run>, Wayne Lin <Wayne.Lin@amd.com>,
        Imre Deak <imre.deak@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>
Subject: [PATCH 5.8 224/232] drm/dp_mst: Fix timeout handling of MST down messages
Date:   Thu, 20 Aug 2020 11:21:15 +0200
Message-Id: <20200820091623.632192222@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

commit 58c1721787be8a6ff28b4e5b6ce395915476871e upstream.

This fixes the following use-after-free problem in case an MST down
message times out, while waiting for the response for it:

[  449.022841] [drm:drm_dp_mst_wait_tx_reply.isra.26] timedout msg send 0000000080ba7fa2 2 0
[  449.022898] ------------[ cut here ]------------
[  449.022903] list_add corruption. prev->next should be next (ffff88847dae32c0), but was 6b6b6b6b6b6b6b6b. (prev=ffff88847db1c140).
[  449.022931] WARNING: CPU: 2 PID: 22 at lib/list_debug.c:28 __list_add_valid+0x4d/0x70
[  449.022935] Modules linked in: asix usbnet mii snd_hda_codec_hdmi mei_hdcp i915 x86_pkg_temp_thermal coretemp crct10dif_pclmul crc32_pclmul ghash_clmulni_intel snd_hda_intel snd_intel_dspcfg snd_hda_codec snd_hwdep e1000e snd_hda_core ptp snd_pcm pps_core mei_me mei intel_lpss_pci prime_numbers
[  449.022966] CPU: 2 PID: 22 Comm: kworker/2:0 Not tainted 5.7.0-rc3-CI-Patchwork_17536+ #1
[  449.022970] Hardware name: Intel Corporation Tiger Lake Client Platform/TigerLake U DDR4 SODIMM RVP, BIOS TGLSFWI1.R00.2457.A16.1912270059 12/27/2019
[  449.022976] Workqueue: events_long drm_dp_mst_link_probe_work
[  449.022982] RIP: 0010:__list_add_valid+0x4d/0x70
[  449.022987] Code: c3 48 89 d1 48 c7 c7 f0 e7 32 82 48 89 c2 e8 3a 49 b7 ff 0f 0b 31 c0 c3 48 89 c1 4c 89 c6 48 c7 c7 40 e8 32 82 e8 23 49 b7 ff <0f> 0b 31 c0 c3 48 89 f2 4c 89 c1 48 89 fe 48 c7 c7 90 e8 32 82 e8
[  449.022991] RSP: 0018:ffffc900001abcb0 EFLAGS: 00010286
[  449.022995] RAX: 0000000000000000 RBX: ffff88847dae2d58 RCX: 0000000000000001
[  449.022999] RDX: 0000000080000001 RSI: ffff88849d914978 RDI: 00000000ffffffff
[  449.023002] RBP: ffff88847dae32c0 R08: ffff88849d914978 R09: 0000000000000000
[  449.023006] R10: ffffc900001abcb8 R11: 0000000000000000 R12: ffff888490d98400
[  449.023009] R13: ffff88847dae3230 R14: ffff88847db1c140 R15: ffff888490d98540
[  449.023013] FS:  0000000000000000(0000) GS:ffff88849ff00000(0000) knlGS:0000000000000000
[  449.023017] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  449.023021] CR2: 00007fb96fafdc63 CR3: 0000000005610004 CR4: 0000000000760ee0
[  449.023025] PKRU: 55555554
[  449.023028] Call Trace:
[  449.023034]  drm_dp_queue_down_tx+0x59/0x110
[  449.023041]  ? rcu_read_lock_sched_held+0x4d/0x80
[  449.023050]  ? kmem_cache_alloc_trace+0x2a6/0x2d0
[  449.023060]  drm_dp_send_link_address+0x74/0x870
[  449.023065]  ? __slab_free+0x3e1/0x5c0
[  449.023071]  ? lockdep_hardirqs_on+0xe0/0x1c0
[  449.023078]  ? lockdep_hardirqs_on+0xe0/0x1c0
[  449.023097]  drm_dp_check_and_send_link_address+0x9a/0xc0
[  449.023106]  drm_dp_mst_link_probe_work+0x9e/0x160
[  449.023117]  process_one_work+0x268/0x600
[  449.023124]  ? __schedule+0x307/0x8d0
[  449.023139]  worker_thread+0x37/0x380
[  449.023149]  ? process_one_work+0x600/0x600
[  449.023153]  kthread+0x140/0x160
[  449.023159]  ? kthread_park+0x80/0x80
[  449.023169]  ret_from_fork+0x24/0x50

Fixes: d308a881a591 ("drm/dp_mst: Kill the second sideband tx slot, save the world")
Cc: Lyude Paul <lyude@redhat.com>
Cc: Sean Paul <sean@poorly.run>
Cc: Wayne Lin <Wayne.Lin@amd.com>
Cc: <stable@vger.kernel.org> # v3.17+
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200513103155.12336-1-imre.deak@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_dp_mst_topology.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -1197,7 +1197,8 @@ static int drm_dp_mst_wait_tx_reply(stru
 
 		/* remove from q */
 		if (txmsg->state == DRM_DP_SIDEBAND_TX_QUEUED ||
-		    txmsg->state == DRM_DP_SIDEBAND_TX_START_SEND)
+		    txmsg->state == DRM_DP_SIDEBAND_TX_START_SEND ||
+		    txmsg->state == DRM_DP_SIDEBAND_TX_SENT)
 			list_del(&txmsg->next);
 	}
 out:


