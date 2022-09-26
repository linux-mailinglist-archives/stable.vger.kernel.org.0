Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355F55EA535
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238774AbiIZL7L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239015AbiIZL5V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:57:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D327A522;
        Mon, 26 Sep 2022 03:51:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36D2DB80930;
        Mon, 26 Sep 2022 10:51:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2838C433C1;
        Mon, 26 Sep 2022 10:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189483;
        bh=GBcGwIueOLO58Yp/xzMrac4ghKpdtAPg/t5F7+WWSzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ph2ehd3wVcFRhi3E1qTFe026WObPnl7oEFdvNV0B26D03pM55uhoN8cqmUve0swrg
         dDNHY23uJdmgPZDTv0upHXxOzQn/8qZ0xtT30zyuf9ov9yvT2nusxerI8rmz06AWwM
         6Wu8zEv1iFYXUlSBs/7MomfQIwrgT9pr3d5NYOqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 173/207] drm/gma500: Fix WARN_ON(lock->magic != lock) error
Date:   Mon, 26 Sep 2022 12:12:42 +0200
Message-Id: <20220926100814.410572629@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit b6f25c3b94f2aadbf5cbef954db4073614943d74 ]

psb_gem_unpin() calls dma_resv_lock() but the underlying ww_mutex
gets destroyed by drm_gem_object_release() move the
drm_gem_object_release() call in psb_gem_free_object() to after
the unpin to fix the below warning:

[   79.693962] ------------[ cut here ]------------
[   79.693992] DEBUG_LOCKS_WARN_ON(lock->magic != lock)
[   79.694015] WARNING: CPU: 0 PID: 240 at kernel/locking/mutex.c:582 __ww_mutex_lock.constprop.0+0x569/0xfb0
[   79.694052] Modules linked in: rfcomm snd_seq_dummy snd_hrtimer qrtr bnep ath9k ath9k_common ath9k_hw snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio snd_hda_codec_hdmi snd_hda_intel ath3k snd_intel_dspcfg mac80211 snd_intel_sdw_acpi btusb snd_hda_codec btrtl btbcm btintel btmtk bluetooth at24 snd_hda_core snd_hwdep uvcvideo snd_seq libarc4 videobuf2_vmalloc ath videobuf2_memops videobuf2_v4l2 videobuf2_common snd_seq_device videodev acer_wmi intel_powerclamp coretemp mc snd_pcm joydev sparse_keymap ecdh_generic pcspkr wmi_bmof cfg80211 i2c_i801 i2c_smbus snd_timer snd r8169 rfkill lpc_ich soundcore acpi_cpufreq zram rtsx_pci_sdmmc mmc_core serio_raw rtsx_pci gma500_gfx(E) video wmi ip6_tables ip_tables i2c_dev fuse
[   79.694436] CPU: 0 PID: 240 Comm: plymouthd Tainted: G        W   E      6.0.0-rc3+ #490
[   79.694457] Hardware name: Packard Bell dot s/SJE01_CT, BIOS V1.10 07/23/2013
[   79.694469] RIP: 0010:__ww_mutex_lock.constprop.0+0x569/0xfb0
[   79.694496] Code: ff 85 c0 0f 84 15 fb ff ff 8b 05 ca 3c 11 01 85 c0 0f 85 07 fb ff ff 48 c7 c6 30 cb 84 aa 48 c7 c7 a3 e1 82 aa e8 ac 29 f8 ff <0f> 0b e9 ed fa ff ff e8 5b 83 8a ff 85 c0 74 10 44 8b 0d 98 3c 11
[   79.694513] RSP: 0018:ffffad1dc048bbe0 EFLAGS: 00010282
[   79.694623] RAX: 0000000000000028 RBX: 0000000000000000 RCX: 0000000000000000
[   79.694636] RDX: 0000000000000001 RSI: ffffffffaa8b0ffc RDI: 00000000ffffffff
[   79.694650] RBP: ffffad1dc048bc80 R08: 0000000000000000 R09: ffffad1dc048ba90
[   79.694662] R10: 0000000000000003 R11: ffffffffaad62fe8 R12: ffff9ff302103138
[   79.694675] R13: ffff9ff306ec8000 R14: ffff9ff307779078 R15: ffff9ff3014c0270
[   79.694690] FS:  00007ff1cccf1740(0000) GS:ffff9ff3bc200000(0000) knlGS:0000000000000000
[   79.694705] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   79.694719] CR2: 0000559ecbcb4420 CR3: 0000000013210000 CR4: 00000000000006f0
[   79.694734] Call Trace:
[   79.694749]  <TASK>
[   79.694761]  ? __schedule+0x47f/0x1670
[   79.694796]  ? psb_gem_unpin+0x27/0x1a0 [gma500_gfx]
[   79.694830]  ? lock_is_held_type+0xe3/0x140
[   79.694864]  ? ww_mutex_lock+0x38/0xa0
[   79.694885]  ? __cond_resched+0x1c/0x30
[   79.694902]  ww_mutex_lock+0x38/0xa0
[   79.694925]  psb_gem_unpin+0x27/0x1a0 [gma500_gfx]
[   79.694964]  psb_gem_unpin+0x199/0x1a0 [gma500_gfx]
[   79.694996]  drm_gem_object_release_handle+0x50/0x60
[   79.695020]  ? drm_gem_object_handle_put_unlocked+0xf0/0xf0
[   79.695042]  idr_for_each+0x4b/0xb0
[   79.695066]  ? _raw_spin_unlock_irqrestore+0x30/0x60
[   79.695095]  drm_gem_release+0x1c/0x30
[   79.695118]  drm_file_free.part.0+0x1ea/0x260
[   79.695150]  drm_release+0x6a/0x120
[   79.695175]  __fput+0x9f/0x260
[   79.695203]  task_work_run+0x59/0xa0
[   79.695227]  do_exit+0x387/0xbe0
[   79.695250]  ? seqcount_lockdep_reader_access.constprop.0+0x82/0x90
[   79.695275]  ? lockdep_hardirqs_on+0x7d/0x100
[   79.695304]  do_group_exit+0x33/0xb0
[   79.695331]  __x64_sys_exit_group+0x14/0x20
[   79.695353]  do_syscall_64+0x58/0x80
[   79.695376]  ? up_read+0x17/0x20
[   79.695401]  ? lock_is_held_type+0xe3/0x140
[   79.695429]  ? asm_exc_page_fault+0x22/0x30
[   79.695450]  ? lockdep_hardirqs_on+0x7d/0x100
[   79.695473]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   79.695493] RIP: 0033:0x7ff1ccefe3f1
[   79.695516] Code: Unable to access opcode bytes at RIP 0x7ff1ccefe3c7.
[   79.695607] RSP: 002b:00007ffed4413378 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
[   79.695629] RAX: ffffffffffffffda RBX: 00007ff1cd0159e0 RCX: 00007ff1ccefe3f1
[   79.695644] RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
[   79.695656] RBP: 0000000000000000 R08: ffffffffffffff80 R09: 00007ff1cd020b20
[   79.695671] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ff1cd0159e0
[   79.695684] R13: 0000000000000000 R14: 00007ff1cd01aee8 R15: 00007ff1cd01af00
[   79.695733]  </TASK>
[   79.695746] irq event stamp: 725979
[   79.695757] hardirqs last  enabled at (725979): [<ffffffffa9132d54>] finish_task_switch.isra.0+0xe4/0x3f0
[   79.695780] hardirqs last disabled at (725978): [<ffffffffa9eb4113>] __schedule+0xdd3/0x1670
[   79.695803] softirqs last  enabled at (725974): [<ffffffffa90fbc9d>] __irq_exit_rcu+0xed/0x160
[   79.695825] softirqs last disabled at (725969): [<ffffffffa90fbc9d>] __irq_exit_rcu+0xed/0x160
[   79.695845] ---[ end trace 0000000000000000 ]---

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220906203852.527663-3-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/gma500/gem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/gma500/gem.c b/drivers/gpu/drm/gma500/gem.c
index dffe37490206..4b7627a72637 100644
--- a/drivers/gpu/drm/gma500/gem.c
+++ b/drivers/gpu/drm/gma500/gem.c
@@ -112,12 +112,12 @@ static void psb_gem_free_object(struct drm_gem_object *obj)
 {
 	struct psb_gem_object *pobj = to_psb_gem_object(obj);
 
-	drm_gem_object_release(obj);
-
 	/* Undo the mmap pin if we are destroying the object */
 	if (pobj->mmapping)
 		psb_gem_unpin(pobj);
 
+	drm_gem_object_release(obj);
+
 	WARN_ON(pobj->in_gart && !pobj->stolen);
 
 	release_resource(&pobj->resource);
-- 
2.35.1



