Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A34955F8DF2
	for <lists+stable@lfdr.de>; Sun,  9 Oct 2022 22:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiJIUvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 16:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiJIUvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 16:51:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EF71A38E;
        Sun,  9 Oct 2022 13:51:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 994AF60C85;
        Sun,  9 Oct 2022 20:51:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22813C433C1;
        Sun,  9 Oct 2022 20:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665348698;
        bh=/sSVDk38i6IX0EUR76GfCtC4FXi07BSGvo1EG+db8yY=;
        h=From:To:Cc:Subject:Date:From;
        b=VXRPv3fbB+GLqxKnFXs8uGkTsxWYcorn+APxB1sd/p1vfx+0E0F8KQ0q93tCRIuNi
         hsnvo5RGdZZf/gG/YL/GkOea25i/TB6IfYp+tFBrDc3ZXuUZhtP7qliK4I+RGcSVHc
         eaSWgZm315UFMEYWLbCGXpKNG5wP/mJiHdNJ87oHruSDwqxI3kaexd89uz+J64k+95
         XGrGSOzNTLZbaOkRtDxxTDeu4mp3v1rcZVvbt4Iv0qsJwL7MTaAFLZ0UMr0w02GW6M
         t9VU9gR/Egw+DuRw98CyJIMBGlTGn2/Km2X9vzmLy2pJWajw3RE93D5Is3c3Q021aj
         V/HHtIiqfynhA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, ccaulfie@redhat.com,
        cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 6.0 01/18] fs: dlm: fix race in lowcomms
Date:   Sun,  9 Oct 2022 16:51:18 -0400
Message-Id: <20221009205136.1201774-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 30ea3257e8766027c4d8d609dcbd256ff9a76073 ]

This patch fixes a race between queue_work() in
_dlm_lowcomms_commit_msg() and srcu_read_unlock(). The queue_work() can
take the final reference of a dlm_msg and so msg->idx can contain
garbage which is signaled by the following warning:

[  676.237050] ------------[ cut here ]------------
[  676.237052] WARNING: CPU: 0 PID: 1060 at include/linux/srcu.h:189 dlm_lowcomms_commit_msg+0x41/0x50
[  676.238945] Modules linked in: dlm_locktorture torture rpcsec_gss_krb5 intel_rapl_msr intel_rapl_common iTCO_wdt iTCO_vendor_support qxl kvm_intel drm_ttm_helper vmw_vsock_virtio_transport kvm vmw_vsock_virtio_transport_common ttm irqbypass crc32_pclmul joydev crc32c_intel serio_raw drm_kms_helper vsock virtio_scsi virtio_console virtio_balloon snd_pcm drm syscopyarea sysfillrect sysimgblt snd_timer fb_sys_fops i2c_i801 lpc_ich snd i2c_smbus soundcore pcspkr
[  676.244227] CPU: 0 PID: 1060 Comm: lock_torture_wr Not tainted 5.19.0-rc3+ #1546
[  676.245216] Hardware name: Red Hat KVM/RHEL-AV, BIOS 1.16.0-2.module+el8.7.0+15506+033991b0 04/01/2014
[  676.246460] RIP: 0010:dlm_lowcomms_commit_msg+0x41/0x50
[  676.247132] Code: fe ff ff ff 75 24 48 c7 c6 bd 0f 49 bb 48 c7 c7 38 7c 01 bd e8 00 e7 ca ff 89 de 48 c7 c7 60 78 01 bd e8 42 3d cd ff 5b 5d c3 <0f> 0b eb d8 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48
[  676.249253] RSP: 0018:ffffa401c18ffc68 EFLAGS: 00010282
[  676.249855] RAX: 0000000000000001 RBX: 00000000ffff8b76 RCX: 0000000000000006
[  676.250713] RDX: 0000000000000000 RSI: ffffffffbccf3a10 RDI: ffffffffbcc7b62e
[  676.251610] RBP: ffffa401c18ffc70 R08: 0000000000000001 R09: 0000000000000001
[  676.252481] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000005
[  676.253421] R13: ffff8b76786ec370 R14: ffff8b76786ec370 R15: ffff8b76786ec480
[  676.254257] FS:  0000000000000000(0000) GS:ffff8b7777800000(0000) knlGS:0000000000000000
[  676.255239] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  676.255897] CR2: 00005590205d88b8 CR3: 000000017656c003 CR4: 0000000000770ee0
[  676.256734] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  676.257567] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  676.258397] PKRU: 55555554
[  676.258729] Call Trace:
[  676.259063]  <TASK>
[  676.259354]  dlm_midcomms_commit_mhandle+0xcc/0x110
[  676.259964]  queue_bast+0x8b/0xb0
[  676.260423]  grant_pending_locks+0x166/0x1b0
[  676.261007]  _unlock_lock+0x75/0x90
[  676.261469]  unlock_lock.isra.57+0x62/0xa0
[  676.262009]  dlm_unlock+0x21e/0x330
[  676.262457]  ? lock_torture_stats+0x80/0x80 [dlm_locktorture]
[  676.263183]  torture_unlock+0x5a/0x90 [dlm_locktorture]
[  676.263815]  ? preempt_count_sub+0xba/0x100
[  676.264361]  ? complete+0x1d/0x60
[  676.264777]  lock_torture_writer+0xb8/0x150 [dlm_locktorture]
[  676.265555]  kthread+0x10a/0x130
[  676.266007]  ? kthread_complete_and_exit+0x20/0x20
[  676.266616]  ret_from_fork+0x22/0x30
[  676.267097]  </TASK>
[  676.267381] irq event stamp: 9579855
[  676.267824] hardirqs last  enabled at (9579863): [<ffffffffbb14e6f8>] __up_console_sem+0x58/0x60
[  676.268896] hardirqs last disabled at (9579872): [<ffffffffbb14e6dd>] __up_console_sem+0x3d/0x60
[  676.270008] softirqs last  enabled at (9579798): [<ffffffffbc200349>] __do_softirq+0x349/0x4c7
[  676.271438] softirqs last disabled at (9579897): [<ffffffffbb0d54c0>] irq_exit_rcu+0xb0/0xf0
[  676.272796] ---[ end trace 0000000000000000 ]---

I reproduced this warning with dlm_locktorture test which is currently
not upstream. However this patch fix the issue by make a additional
refcount between dlm_lowcomms_new_msg() and dlm_lowcomms_commit_msg().
In case of the race the kref_put() in dlm_lowcomms_commit_msg() will be
the final put.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lowcomms.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index a4e84e8d94c8..59f64c596233 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1336,6 +1336,8 @@ struct dlm_msg *dlm_lowcomms_new_msg(int nodeid, int len, gfp_t allocation,
 		return NULL;
 	}
 
+	/* for dlm_lowcomms_commit_msg() */
+	kref_get(&msg->ref);
 	/* we assume if successful commit must called */
 	msg->idx = idx;
 	return msg;
@@ -1375,6 +1377,8 @@ void dlm_lowcomms_commit_msg(struct dlm_msg *msg)
 {
 	_dlm_lowcomms_commit_msg(msg);
 	srcu_read_unlock(&connections_srcu, msg->idx);
+	/* because dlm_lowcomms_new_msg() */
+	kref_put(&msg->ref, dlm_msg_release);
 }
 #endif
 
-- 
2.35.1

