Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56B38119557
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbfLJVUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:20:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:35676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728905AbfLJVML (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:12:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 795FC2077B;
        Tue, 10 Dec 2019 21:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012330;
        bh=+MijAwq9//b4pfhu9HbmyZUqzqIrNqHBr0xiftDtzsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j01MI163AJ1CN+V7S6YGdLcXc+kI+DneedptNydmvNbyLmUllQgyq2MCIuxFx0ZUN
         7SMWSnwk8b8uTKjp/rAczvXx1cCkGKHPHXhhf7weMuaBfw0SSJaaGB/64BL6RvuXOD
         julQI4T9RgHStvzxS0s7jgqNqy7QF0avvkmd5GH4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 262/350] media: vicodec: media_device_cleanup was called too early
Date:   Tue, 10 Dec 2019 16:06:07 -0500
Message-Id: <20191210210735.9077-223-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 693c5f144aeb9636ae161a3c61a838c50b2ae41c ]

Running the contrib/test/test-media script in v4l-utils with the vicodec argument
will cause this kernel warning:

[  372.298824] ------------[ cut here ]------------
[  372.298848] DEBUG_LOCKS_WARN_ON(lock->magic != lock)
[  372.298896] WARNING: CPU: 11 PID: 2220 at kernel/locking/mutex.c:938 __mutex_lock+0x919/0xc10
[  372.298907] Modules linked in: vicodec v4l2_mem2mem vivid rc_cec v4l2_tpg videobuf2_dma_contig cec rc_core v4l2_dv_timings videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_common videodev mc vmw_balloon vmw_vmci button vmwgfx [last unloaded: vimc]
[  372.298961] CPU: 11 PID: 2220 Comm: sleep Not tainted 5.4.0-rc1-test-no #150
[  372.298970] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/29/2019
[  372.298983] RIP: 0010:__mutex_lock+0x919/0xc10
[  372.298995] Code: 59 83 e8 9a fc 16 ff 44 8b 05 23 61 38 01 45 85 c0 0f 85 ef f7 ff ff 48 c7 c6 a0 1f 87 82 48 c7 c7 a0 1e 87 82 e8 cd bb f7 fe <0f> 0b e9 d5 f7 ff ff f6 c3 04 0f 84 3b fd ff ff 49 89 df 41 83 e7
[  372.299004] RSP: 0018:ffff8881b400fb80 EFLAGS: 00010286
[  372.299014] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[  372.299022] RDX: 0000000000000003 RSI: 0000000000000004 RDI: ffffed1036801f62
[  372.299030] RBP: ffff8881b400fcf0 R08: ffffffff81217c91 R09: fffffbfff061c271
[  372.299038] R10: fffffbfff061c270 R11: ffffffff830e1383 R12: ffff88814761dc80
[  372.299046] R13: 0000000000000000 R14: ffff88814761cbf0 R15: ffff88814761d030
[  372.299055] FS:  0000000000000000(0000) GS:ffff8881b68c0000(0000) knlGS:0000000000000000
[  372.299063] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  372.299071] CR2: 00007f606d78aa20 CR3: 0000000003013002 CR4: 00000000001606e0
[  372.299153] Call Trace:
[  372.299176]  ? __kasan_slab_free+0x12f/0x180
[  372.299187]  ? kmem_cache_free+0x9b/0x250
[  372.299200]  ? do_exit+0xcdf/0x1200
[  372.299210]  ? do_group_exit+0x85/0x130
[  372.299220]  ? __x64_sys_exit_group+0x23/0x30
[  372.299231]  ? do_syscall_64+0x5e/0x1c0
[  372.299241]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  372.299295]  ? v4l2_release+0xed/0x190 [videodev]
[  372.299309]  ? mutex_lock_io_nested+0xb80/0xb80
[  372.299323]  ? find_held_lock+0x85/0xa0
[  372.299335]  ? fsnotify+0x5b0/0x600
[  372.299351]  ? locks_remove_file+0x78/0x2b0
[  372.299363]  ? __fsnotify_update_child_dentry_flags.part.0+0x170/0x170
[  372.299383]  ? vidioc_querycap+0x50/0x50 [vicodec]
[  372.299426]  ? v4l2_release+0xed/0x190 [videodev]
[  372.299467]  v4l2_release+0xed/0x190 [videodev]
[  372.299484]  __fput+0x15a/0x390
[  372.299499]  task_work_run+0xb2/0xe0
[  372.299512]  do_exit+0x4d0/0x1200
[  372.299528]  ? do_user_addr_fault+0x367/0x610
[  372.299538]  ? release_task+0x990/0x990
[  372.299552]  ? rwsem_spin_on_owner+0x170/0x170
[  372.299567]  ? vmacache_find+0xb2/0x100
[  372.299580]  do_group_exit+0x85/0x130
[  372.299592]  __x64_sys_exit_group+0x23/0x30
[  372.299602]  do_syscall_64+0x5e/0x1c0
[  372.299614]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  372.299624] RIP: 0033:0x7f606d74a9d6
[  372.299640] Code: Bad RIP value.
[  372.299648] RSP: 002b:00007fff65364468 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
[  372.299658] RAX: ffffffffffffffda RBX: 00007f606d83b760 RCX: 00007f606d74a9d6
[  372.299666] RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
[  372.299673] RBP: 0000000000000000 R08: 00000000000000e7 R09: ffffffffffffff80
[  372.299681] R10: 00007fff65364334 R11: 0000000000000246 R12: 00007f606d83b760
[  372.299689] R13: 0000000000000002 R14: 00007f606d844428 R15: 0000000000000000
[  372.299704] ---[ end trace add7d62ca4bc65e3 ]---

This is caused by media_device_cleanup() which destroys
v4l2_dev->mdev->req_queue_mutex. But v4l2_release() tries to lock
that mutex after media_device_cleanup() is called.

By moving media_device_cleanup() to the v4l2_device's release function it is
guaranteed that the mutex is valid whenever v4l2_release is called.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vicodec/vicodec-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 0ee143ae0f6b7..82350097503e6 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -2139,6 +2139,9 @@ static void vicodec_v4l2_dev_release(struct v4l2_device *v4l2_dev)
 	v4l2_m2m_release(dev->stateful_enc.m2m_dev);
 	v4l2_m2m_release(dev->stateful_dec.m2m_dev);
 	v4l2_m2m_release(dev->stateless_dec.m2m_dev);
+#ifdef CONFIG_MEDIA_CONTROLLER
+	media_device_cleanup(&dev->mdev);
+#endif
 	kfree(dev);
 }
 
@@ -2250,7 +2253,6 @@ static int vicodec_remove(struct platform_device *pdev)
 	v4l2_m2m_unregister_media_controller(dev->stateful_enc.m2m_dev);
 	v4l2_m2m_unregister_media_controller(dev->stateful_dec.m2m_dev);
 	v4l2_m2m_unregister_media_controller(dev->stateless_dec.m2m_dev);
-	media_device_cleanup(&dev->mdev);
 #endif
 
 	video_unregister_device(&dev->stateful_enc.vfd);
-- 
2.20.1

