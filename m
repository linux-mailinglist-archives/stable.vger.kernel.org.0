Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFC412C825
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732093AbfL2Rva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:51:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:36720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732084AbfL2Rv1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:51:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25E08206A4;
        Sun, 29 Dec 2019 17:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641885;
        bh=yLC3y6gqfz7npKcTqFQgGGREA5dnKxR6PzarNR9950M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pZsVxtOugMJvgGAaPrcwQdUzfdNH1XhtWolzQI+tvdHd7ye7bqTE9Owpxam4jJB98
         T9Tag+HVyJ5sFcZveo8JpQQam3qMPb2z6CaeZidNvLEGt9pEPx1qP1UMLUUf25F7uB
         T8uzoA7dxqvP+7fv4ZCEtc7AaEUo+FT3oAPcUJ6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 235/434] media: vivid: media_device_cleanup was called too early
Date:   Sun, 29 Dec 2019 18:24:48 +0100
Message-Id: <20191229172717.489442745@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 8ffd573c25e5fac1daeeffc592e2ed6bc6a3d947 ]

Running the contrib/test/test-media script in v4l-utils with the vivid argument
will cause this kernel warning:

[  104.748720] videodev: v4l2_release
[  104.748731] ------------[ cut here ]------------
[  104.748750] DEBUG_LOCKS_WARN_ON(lock->magic != lock)
[  104.748790] WARNING: CPU: 6 PID: 1823 at kernel/locking/mutex.c:938 __mutex_lock+0x919/0xc10
[  104.748800] Modules linked in: rc_cec vivid v4l2_tpg videobuf2_dma_contig cec rc_core v4l2_dv_timings videobuf2_vmalloc videobuf2_memops
videobuf2_v4l2 videobuf2_common videodev mc vmw_balloon vmw_vmci button vmwgfx
[  104.748845] CPU: 6 PID: 1823 Comm: sleep Not tainted 5.4.0-rc1-test-no #150
[  104.748853] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/29/2019
[  104.748867] RIP: 0010:__mutex_lock+0x919/0xc10
[  104.748878] Code: 59 83 e8 9a fc 16 ff 44 8b 05 23 61 38 01 45 85 c0 0f 85 ef f7 ff ff 48 c7 c6 a0 1f 87 82 48 c7 c7 a0 1e 87 82 e8 cd bb
f7 fe <0f> 0b e9 d5 f7 ff ff f6 c3 04 0f 84 3b fd ff ff 49 89 df 41 83 e7
[  104.748886] RSP: 0018:ffff88811a357b80 EFLAGS: 00010286
[  104.748895] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[  104.748902] RDX: 0000000000000003 RSI: 0000000000000004 RDI: ffffed102346af62
[  104.748910] RBP: ffff88811a357cf0 R08: ffffffff81217c91 R09: fffffbfff061c271
[  104.748917] R10: fffffbfff061c270 R11: ffffffff830e1383 R12: ffff8881a46103c0
[  104.748924] R13: 0000000000000000 R14: ffff8881a4614f90 R15: ffff8881a46153d0
[  104.748933] FS:  0000000000000000(0000) GS:ffff8881b6780000(0000) knlGS:0000000000000000
[  104.748940] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  104.748949] CR2: 00007f163fc9ca20 CR3: 0000000003013004 CR4: 00000000001606e0
[  104.749036] Call Trace:
[  104.749051]  ? _raw_spin_unlock+0x1f/0x30
[  104.749067]  ? llist_add_batch+0x33/0x50
[  104.749081]  ? tick_nohz_tick_stopped+0x19/0x30
[  104.749130]  ? v4l2_release.cold+0x6c/0xd6 [videodev]
[  104.749143]  ? mutex_lock_io_nested+0xb80/0xb80
[  104.749153]  ? vprintk_emit+0xf2/0x220
[  104.749191]  ? vivid_req_validate+0x40/0x40 [vivid]
[  104.749201]  ? printk+0xad/0xde
[  104.749211]  ? kmsg_dump_rewind_nolock+0x54/0x54
[  104.749226]  ? locks_remove_file+0x78/0x2b0
[  104.749248]  ? __fsnotify_update_child_dentry_flags.part.0+0x170/0x170
[  104.749281]  ? vivid_req_validate+0x40/0x40 [vivid]
[  104.749321]  ? v4l2_release.cold+0x6c/0xd6 [videodev]
[  104.749361]  v4l2_release.cold+0x6c/0xd6 [videodev]
[  104.749378]  __fput+0x15a/0x390
[  104.749393]  task_work_run+0xb2/0xe0
[  104.749407]  do_exit+0x4d0/0x1200
[  104.749422]  ? do_user_addr_fault+0x367/0x610
[  104.749431]  ? release_task+0x990/0x990
[  104.749449]  ? rwsem_spin_on_owner+0x170/0x170
[  104.749463]  ? vmacache_find+0xb2/0x100
[  104.749476]  do_group_exit+0x85/0x130
[  104.749487]  __x64_sys_exit_group+0x23/0x30
[  104.749500]  do_syscall_64+0x5e/0x1c0
[  104.749511]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  104.749520] RIP: 0033:0x7f163fc5c9d6
[  104.749536] Code: Bad RIP value.
[  104.749543] RSP: 002b:00007ffe6f3bec58 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
[  104.749553] RAX: ffffffffffffffda RBX: 00007f163fd4d760 RCX: 00007f163fc5c9d6
[  104.749560] RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
[  104.749567] RBP: 0000000000000000 R08: 00000000000000e7 R09: ffffffffffffff80
[  104.749574] R10: 00007ffe6f3beb24 R11: 0000000000000246 R12: 00007f163fd4d760
[  104.749581] R13: 0000000000000002 R14: 00007f163fd56428 R15: 0000000000000000
[  104.749597] ---[ end trace 66f20f73fc0daf79 ]---

This is caused by media_device_cleanup() which destroys
v4l2_dev->mdev->req_queue_mutex. But v4l2_release() tries to lock
that mutex after media_device_cleanup() is called.

By moving media_device_cleanup() to the v4l2_device's release function it is
guaranteed that the mutex is valid whenever v4l2_release is called.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vivid/vivid-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index 53315c8dd2bb..f6a5cdbd74e7 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -616,6 +616,9 @@ static void vivid_dev_release(struct v4l2_device *v4l2_dev)
 
 	vivid_free_controls(dev);
 	v4l2_device_unregister(&dev->v4l2_dev);
+#ifdef CONFIG_MEDIA_CONTROLLER
+	media_device_cleanup(&dev->mdev);
+#endif
 	vfree(dev->scaled_line);
 	vfree(dev->blended_line);
 	vfree(dev->edid);
@@ -1580,7 +1583,6 @@ static int vivid_remove(struct platform_device *pdev)
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 		media_device_unregister(&dev->mdev);
-		media_device_cleanup(&dev->mdev);
 #endif
 
 		if (dev->has_vid_cap) {
-- 
2.20.1



