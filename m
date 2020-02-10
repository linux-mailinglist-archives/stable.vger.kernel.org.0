Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5C45157716
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbgBJM5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:57:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:43710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729996AbgBJMl2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:28 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0718620838;
        Mon, 10 Feb 2020 12:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338488;
        bh=Lrjhd+75/BuBho5+CpWHxQM7vVs0K8Al2b2GFCPrP5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dO+W0iAZ8eNoJOHPvx8Dx5xFtvlNYhqy7+3nTnUUTi/U6vjyaGvNY5mS3DKiXTBp7
         kMp38dgZMoOHt/OERxMIDsQMs5pF2nWmZku8NTzqOSUpk8sR69KeRVyxaDPs1X+SOx
         PqiFxY2+YDRp5XmWCaHZV84Qwp6GqzChbJHZKiNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikita Lipski <Mikita.Lipski@amd.com>,
        Lyude Paul <lyude@redhat.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.5 270/367] drm/amd/dm/mst: Ignore payload update failures
Date:   Mon, 10 Feb 2020 04:33:03 -0800
Message-Id: <20200210122449.246971803@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

commit 58fe03d6dec908a1bec07eea7e94907af5c07eec upstream.

Disabling a display on MST can potentially happen after the entire MST
topology has been removed, which means that we can't communicate with
the topology at all in this scenario. Likewise, this also means that we
can't properly update payloads on the topology and as such, it's a good
idea to ignore payload update failures when disabling displays.
Currently, amdgpu makes the mistake of halting the payload update
process when any payload update failures occur, resulting in leaving
DC's local copies of the payload tables out of date.

This ends up causing problems with hotplugging MST topologies, and
causes modesets on the second hotplug to fail like so:

[drm] Failed to updateMST allocation table forpipe idx:1
------------[ cut here ]------------
WARNING: CPU: 5 PID: 1511 at
drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_link.c:2677
update_mst_stream_alloc_table+0x11e/0x130 [amdgpu]
Modules linked in: cdc_ether usbnet fuse xt_conntrack nf_conntrack
nf_defrag_ipv6 libcrc32c nf_defrag_ipv4 ipt_REJECT nf_reject_ipv4
nft_counter nft_compat nf_tables nfnetlink tun bridge stp llc sunrpc
vfat fat wmi_bmof uvcvideo snd_hda_codec_realtek snd_hda_codec_generic
snd_hda_codec_hdmi videobuf2_vmalloc snd_hda_intel videobuf2_memops
videobuf2_v4l2 snd_intel_dspcfg videobuf2_common crct10dif_pclmul
snd_hda_codec videodev crc32_pclmul snd_hwdep snd_hda_core
ghash_clmulni_intel snd_seq mc joydev pcspkr snd_seq_device snd_pcm
sp5100_tco k10temp i2c_piix4 snd_timer thinkpad_acpi ledtrig_audio snd
wmi soundcore video i2c_scmi acpi_cpufreq ip_tables amdgpu(O)
rtsx_pci_sdmmc amd_iommu_v2 gpu_sched mmc_core i2c_algo_bit ttm
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops cec drm
crc32c_intel serio_raw hid_multitouch r8152 mii nvme r8169 nvme_core
rtsx_pci pinctrl_amd
CPU: 5 PID: 1511 Comm: gnome-shell Tainted: G           O      5.5.0-rc7Lyude-Test+ #4
Hardware name: LENOVO FA495SIT26/FA495SIT26, BIOS R12ET22W(0.22 ) 01/31/2019
RIP: 0010:update_mst_stream_alloc_table+0x11e/0x130 [amdgpu]
Code: 28 00 00 00 75 2b 48 8d 65 e0 5b 41 5c 41 5d 41 5e 5d c3 0f b6 06
49 89 1c 24 41 88 44 24 08 0f b6 46 01 41 88 44 24 09 eb 93 <0f> 0b e9
2f ff ff ff e8 a6 82 a3 c2 66 0f 1f 44 00 00 0f 1f 44 00
RSP: 0018:ffffac428127f5b0 EFLAGS: 00010202
RAX: 0000000000000002 RBX: ffff8d1e166eee80 RCX: 0000000000000000
RDX: ffffac428127f668 RSI: ffff8d1e166eee80 RDI: ffffac428127f610
RBP: ffffac428127f640 R08: ffffffffc03d94a8 R09: 0000000000000000
R10: ffff8d1e24b02000 R11: ffffac428127f5b0 R12: ffff8d1e1b83d000
R13: ffff8d1e1bea0b08 R14: 0000000000000002 R15: 0000000000000002
FS:  00007fab23ffcd80(0000) GS:ffff8d1e28b40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f151f1711e8 CR3: 00000005997c0000 CR4: 00000000003406e0
Call Trace:
 ? mutex_lock+0xe/0x30
 dc_link_allocate_mst_payload+0x9a/0x210 [amdgpu]
 ? dm_read_reg_func+0x39/0xb0 [amdgpu]
 ? core_link_enable_stream+0x656/0x730 [amdgpu]
 core_link_enable_stream+0x656/0x730 [amdgpu]
 dce110_apply_ctx_to_hw+0x58e/0x5d0 [amdgpu]
 ? dcn10_verify_allow_pstate_change_high+0x1d/0x280 [amdgpu]
 ? dcn10_wait_for_mpcc_disconnect+0x3c/0x130 [amdgpu]
 dc_commit_state+0x292/0x770 [amdgpu]
 ? add_timer+0x101/0x1f0
 ? ttm_bo_put+0x1a1/0x2f0 [ttm]
 amdgpu_dm_atomic_commit_tail+0xb59/0x1ff0 [amdgpu]
 ? amdgpu_move_blit.constprop.0+0xb8/0x1f0 [amdgpu]
 ? amdgpu_bo_move+0x16d/0x2b0 [amdgpu]
 ? ttm_bo_handle_move_mem+0x118/0x570 [ttm]
 ? ttm_bo_validate+0x134/0x150 [ttm]
 ? dm_plane_helper_prepare_fb+0x1b9/0x2a0 [amdgpu]
 ? _cond_resched+0x15/0x30
 ? wait_for_completion_timeout+0x38/0x160
 ? _cond_resched+0x15/0x30
 ? wait_for_completion_interruptible+0x33/0x190
 commit_tail+0x94/0x130 [drm_kms_helper]
 drm_atomic_helper_commit+0x113/0x140 [drm_kms_helper]
 drm_atomic_helper_set_config+0x70/0xb0 [drm_kms_helper]
 drm_mode_setcrtc+0x194/0x6a0 [drm]
 ? _cond_resched+0x15/0x30
 ? mutex_lock+0xe/0x30
 ? drm_mode_getcrtc+0x180/0x180 [drm]
 drm_ioctl_kernel+0xaa/0xf0 [drm]
 drm_ioctl+0x208/0x390 [drm]
 ? drm_mode_getcrtc+0x180/0x180 [drm]
 amdgpu_drm_ioctl+0x49/0x80 [amdgpu]
 do_vfs_ioctl+0x458/0x6d0
 ksys_ioctl+0x5e/0x90
 __x64_sys_ioctl+0x16/0x20
 do_syscall_64+0x55/0x1b0
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fab2121f87b
Code: 0f 1e fa 48 8b 05 0d 96 2c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff
ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d dd 95 2c 00 f7 d8 64 89 01 48
RSP: 002b:00007ffd045f9068 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffd045f90a0 RCX: 00007fab2121f87b
RDX: 00007ffd045f90a0 RSI: 00000000c06864a2 RDI: 000000000000000b
RBP: 00007ffd045f90a0 R08: 0000000000000000 R09: 000055dbd2985d10
R10: 000055dbd2196280 R11: 0000000000000246 R12: 00000000c06864a2
R13: 000000000000000b R14: 0000000000000000 R15: 000055dbd2196280
---[ end trace 6ea888c24d2059cd ]---

Note as well, I have only been able to reproduce this on setups with 2
MST displays.

Changes since v1:
* Don't return false when part 1 or part 2 of updating the payloads
  fails, we don't want to abort at any step of the process even if
  things fail

Reviewed-by: Mikita Lipski <Mikita.Lipski@amd.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Acked-by: Harry Wentland <harry.wentland@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -246,7 +246,8 @@ bool dm_helpers_dp_mst_write_payload_all
 		drm_dp_mst_reset_vcpi_slots(mst_mgr, mst_port);
 	}
 
-	ret = drm_dp_update_payload_part1(mst_mgr);
+	/* It's OK for this to fail */
+	drm_dp_update_payload_part1(mst_mgr);
 
 	/* mst_mgr->->payloads are VC payload notify MST branch using DPCD or
 	 * AUX message. The sequence is slot 1-63 allocated sequence for each
@@ -255,9 +256,6 @@ bool dm_helpers_dp_mst_write_payload_all
 
 	get_payload_table(aconnector, proposed_table);
 
-	if (ret)
-		return false;
-
 	return true;
 }
 
@@ -315,7 +313,6 @@ bool dm_helpers_dp_mst_send_payload_allo
 	struct amdgpu_dm_connector *aconnector;
 	struct drm_dp_mst_topology_mgr *mst_mgr;
 	struct drm_dp_mst_port *mst_port;
-	int ret;
 
 	aconnector = (struct amdgpu_dm_connector *)stream->dm_stream_context;
 
@@ -329,10 +326,8 @@ bool dm_helpers_dp_mst_send_payload_allo
 	if (!mst_mgr->mst_state)
 		return false;
 
-	ret = drm_dp_update_payload_part2(mst_mgr);
-
-	if (ret)
-		return false;
+	/* It's OK for this to fail */
+	drm_dp_update_payload_part2(mst_mgr);
 
 	if (!enable)
 		drm_dp_mst_deallocate_vcpi(mst_mgr, mst_port);


