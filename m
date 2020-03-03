Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E721178194
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387941AbgCCSDp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:03:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:45126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387548AbgCCSBG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:01:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34458206D5;
        Tue,  3 Mar 2020 18:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258465;
        bh=56eSzwKVuwzQ78Xa3uPPI19YblmNRXB3c5HYqL1LEpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=udd6n0LZ4M6tKh0/BDXy2mZa3IjOJQN/5GEHqsvURKKvcB+UgQWfSZqwFePXk2O7Y
         AYVwfATxzR+atwKYwZEx/w80tBS6na52bPjOYGnEyAO7b9ftLPqSyo2H3dsYqIA+iJ
         Di738KVKP143fi4yaBV9VQmcoOb0gSu3VRMey6h4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tina Zhang <tina.zhang@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: [PATCH 4.19 58/87] drm/i915/gvt: Separate display reset from ALL_ENGINES reset
Date:   Tue,  3 Mar 2020 18:43:49 +0100
Message-Id: <20200303174355.570310232@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tina Zhang <tina.zhang@intel.com>

commit 3eb55e6f753a379e293395de8d5f3be28351a7f8 upstream.

ALL_ENGINES reset doesn't clobber display with the current gvt-g
supported platforms. Thus ALL_ENGINES reset shouldn't reset the
display engine registers emulated by gvt-g.

This fixes guest warning like

[ 14.622026] [drm] Initialized i915 1.6.0 20200114 for 0000:00:03.0 on minor 0
[ 14.967917] fbcon: i915drmfb (fb0) is primary device
[ 25.100188] [drm:drm_atomic_helper_wait_for_dependencies [drm_kms_helper]] E RROR [CRTC:51:pipe A] flip_done timed out
[ 25.100860] -----------[ cut here ]-----------
[ 25.100861] pll on state mismatch (expected 0, found 1)
[ 25.101024] WARNING: CPU: 1 PID: 30 at drivers/gpu/drm/i915/display/intel_dis play.c:14382 verify_single_dpll_state.isra.115+0x28f/0x320 [i915]
[ 25.101025] Modules linked in: intel_rapl_msr intel_rapl_common kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel i915 aesni_intel cr ypto_simd cryptd glue_helper cec rc_core video drm_kms_helper joydev drm input_l eds i2c_algo_bit serio_raw fb_sys_fops syscopyarea sysfillrect sysimgblt mac_hid qemu_fw_cfg sch_fq_codel parport_pc ppdev lp parport ip_tables x_tables autofs4 e1000 psmouse i2c_piix4 pata_acpi floppy
[ 25.101052] CPU: 1 PID: 30 Comm: kworker/u4:1 Not tainted 5.5.0+ #1
[ 25.101053] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1 .12.1-0-ga5cab58 04/01/2014
[ 25.101055] Workqueue: events_unbound async_run_entry_fn
[ 25.101092] RIP: 0010:verify_single_dpll_state.isra.115+0x28f/0x320 [i915]
[ 25.101093] Code: e0 d9 ff e9 a3 fe ff ff 80 3d e9 c2 11 00 00 44 89 f6 48 c7 c7 c0 9d 88 c0 75 3b e8 eb df d9 ff e9 c7 fe ff ff e8 d1 e0 ae c4 <0f> 0b e9 7a fe ff ff 80 3d c0 c2 11 00 00 8d 71 41 89 c2 48 c7 c7
[ 25.101093] RSP: 0018:ffffb1de80107878 EFLAGS: 00010286
[ 25.101094] RAX: 0000000000000000 RBX: ffffb1de80107884 RCX: 0000000000000007
[ 25.101095] RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffff94fdfdd19740
[ 25.101095] RBP: ffffb1de80107938 R08: 0000000d6bfdc7b4 R09: 000000000000002b
[ 25.101096] R10: ffff94fdf82dc000 R11: 0000000000000225 R12: 00000000000001f8
[ 25.101096] R13: ffff94fdb3ca6a90 R14: ffff94fdb3ca0000 R15: 0000000000000000
[ 25.101097] FS: 0000000000000000(0000) GS:ffff94fdfdd00000(0000) knlGS:00000 00000000000
[ 25.101098] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 25.101098] CR2: 00007fbc3e2be9c8 CR3: 000000003339a003 CR4: 0000000000360ee0
[ 25.101101] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 25.101101] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 25.101102] Call Trace:
[ 25.101139] intel_atomic_commit_tail+0xde4/0x1520 [i915]
[ 25.101141] ? flush_workqueue_prep_pwqs+0xfa/0x130
[ 25.101142] ? flush_workqueue+0x198/0x3c0
[ 25.101174] intel_atomic_commit+0x2ad/0x320 [i915]
[ 25.101209] drm_atomic_commit+0x4a/0x50 [drm]
[ 25.101220] drm_client_modeset_commit_atomic+0x1c4/0x200 [drm]
[ 25.101231] drm_client_modeset_commit_force+0x47/0x170 [drm]
[ 25.101250] drm_fb_helper_restore_fbdev_mode_unlocked+0x4e/0xa0 [drm_kms_hel per]
[ 25.101255] drm_fb_helper_set_par+0x2d/0x60 [drm_kms_helper]
[ 25.101287] intel_fbdev_set_par+0x1a/0x40 [i915]
[ 25.101289] ? con_is_visible+0x2e/0x60
[ 25.101290] fbcon_init+0x378/0x600
[ 25.101292] visual_init+0xd5/0x130
[ 25.101296] do_bind_con_driver+0x217/0x430
[ 25.101297] do_take_over_console+0x7d/0x1b0
[ 25.101298] do_fbcon_takeover+0x5c/0xb0
[ 25.101299] fbcon_fb_registered+0x199/0x1a0
[ 25.101301] register_framebuffer+0x22c/0x330
[ 25.101306] __drm_fb_helper_initial_config_and_unlock+0x31a/0x520 [drm_kms_h elper]
[ 25.101311] drm_fb_helper_initial_config+0x35/0x40 [drm_kms_helper]
[ 25.101341] intel_fbdev_initial_config+0x18/0x30 [i915]
[ 25.101342] async_run_entry_fn+0x3c/0x150
[ 25.101343] process_one_work+0x1fd/0x3f0
[ 25.101344] worker_thread+0x34/0x410
[ 25.101346] kthread+0x121/0x140
[ 25.101346] ? process_one_work+0x3f0/0x3f0
[ 25.101347] ? kthread_park+0x90/0x90
[ 25.101350] ret_from_fork+0x35/0x40
[ 25.101351] --[ end trace b5b47d44cd998ba1 ]--

Fixes: 6294b61ba769 ("drm/i915/gvt: add missing display part reset for vGPU reset")
Signed-off-by: Tina Zhang <tina.zhang@intel.com>
Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20200221023234.28635-1-tina.zhang@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gvt/vgpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gvt/vgpu.c
+++ b/drivers/gpu/drm/i915/gvt/vgpu.c
@@ -556,9 +556,9 @@ void intel_gvt_reset_vgpu_locked(struct
 
 		intel_vgpu_reset_mmio(vgpu, dmlr);
 		populate_pvinfo_page(vgpu);
-		intel_vgpu_reset_display(vgpu);
 
 		if (dmlr) {
+			intel_vgpu_reset_display(vgpu);
 			intel_vgpu_reset_cfg_space(vgpu);
 			/* only reset the failsafe mode when dmlr reset */
 			vgpu->failsafe = false;


