Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 995AC12C86C
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732691AbfL2Ryb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:54:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:42418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732701AbfL2Rya (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:54:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6453E21744;
        Sun, 29 Dec 2019 17:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642069;
        bh=Q432QctRkoU5hLRYShE/8499UXQRF6N38JWH7IIpFkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aj++kNP10t1dbxxUEqLqpx/R7jbgbgrsKY7hqyq+pwm5VG4sUtNbIZwu5q8U4bFdG
         ZhM1Zle6VGxAk29LC8aoP3vKxr+rusMZmUVYvcaxUMby1crnwzsIAqa3fqAs3KIvz2
         WqA01dWXjhYMLErmrEdz07/LBB9oVJyk5H3CjEIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 286/434] media: vim2m: media_device_cleanup was called too early
Date:   Sun, 29 Dec 2019 18:25:39 +0100
Message-Id: <20191229172720.946084488@linuxfoundation.org>
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

[ Upstream commit 9f22e88a4bba270d3427684cee84dfbf67489e86 ]

Running the contrib/test/test-media script in v4l-utils with the vim2m argument
will cause this kernel warning:

[  554.430157] ------------[ cut here ]------------
[  554.433034] DEBUG_LOCKS_WARN_ON(lock->magic != lock)
[  554.433064] WARNING: CPU: 0 PID: 616 at kernel/locking/mutex.c:938 __mutex_lock+0xd7a/0x1380
[  554.439736] Modules linked in: vim2m v4l2_mem2mem vivid rc_cec videobuf2_dma_contig v4l2_dv_timings cec videobuf2_vmalloc videobuf2_memops v4l2_tpg videobuf2_v4l2 videobuf2_common videodev mc rc_core [last unloaded: vivid]
[  554.445794] CPU: 0 PID: 616 Comm: sleep Not tainted 5.4.0-rc1-virtme #1
[  554.448481] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-0-ga698c8995f-prebuilt.qemu.org 04/01/2014
[  554.453088] RIP: 0010:__mutex_lock+0xd7a/0x1380
[  554.454955] Code: d2 0f 85 de 05 00 00 44 8b 05 82 d9 f7 00 45 85 c0 0f 85 bf f3 ff ff 48 c7 c6 e0 30 a6 b7 48 c7 c7 e0 2e a6 b7 e8 5c 76 36 fe <0f> 0b e9 a5 f3 ff ff 65 48 8b 1c 25 80 ef 01 00 be 08 00 00 00 48
[  554.462836] RSP: 0018:ffff88803a4cfad0 EFLAGS: 00010282
[  554.465129] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffffb5a3d24f
[  554.468143] RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffffffffb85273f4
[  554.471000] RBP: ffff88803a4cfc50 R08: fffffbfff701e681 R09: fffffbfff701e681
[  554.473990] R10: fffffbfff701e680 R11: ffffffffb80f3403 R12: 0000000000000000
[  554.476831] R13: dffffc0000000000 R14: ffffffffb9714f00 R15: ffff888053103fc8
[  554.479622] FS:  00007fac6358a540(0000) GS:ffff88805d000000(0000) knlGS:0000000000000000
[  554.482673] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  554.484949] CR2: 00007fac6343faf0 CR3: 0000000036c22000 CR4: 00000000003406f0
[  554.487811] Call Trace:
[  554.488860]  ? v4l2_release+0x1b8/0x390 [videodev]
[  554.490818]  ? do_exit+0x946/0x2980
[  554.492269]  ? mutex_lock_io_nested+0x1250/0x1250
[  554.494128]  ? __lock_acquire+0xe90/0x3c30
[  554.495774]  ? fsnotify_first_mark+0x120/0x120
[  554.497487]  ? vim2m_device_release+0x50/0x50 [vim2m]
[  554.499469]  ? v4l2_release+0x1b8/0x390 [videodev]
[  554.501493]  v4l2_release+0x1b8/0x390 [videodev]
[  554.503430]  __fput+0x256/0x790
[  554.504711]  task_work_run+0x109/0x190
[  554.506145]  do_exit+0x95e/0x2980
[  554.507421]  ? vfs_lock_file+0x21/0xf0
[  554.509013]  ? find_held_lock+0x33/0x1c0
[  554.510382]  ? __close_fd+0xee/0x190
[  554.511862]  ? release_task.part.21+0x1310/0x1310
[  554.513701]  ? lock_downgrade+0x6d0/0x6d0
[  554.515299]  do_group_exit+0xeb/0x2d0
[  554.516862]  __x64_sys_exit_group+0x35/0x40
[  554.518610]  do_syscall_64+0x90/0x450
[  554.520142]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  554.522289] RIP: 0033:0x7fac6348ecf6
[  554.523876] Code: Bad RIP value.
[  554.525294] RSP: 002b:00007ffe6373dc58 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
[  554.528555] RAX: ffffffffffffffda RBX: 00007fac6357f760 RCX: 00007fac6348ecf6
[  554.531537] RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
[  554.534709] RBP: 0000000000000000 R08: 00000000000000e7 R09: ffffffffffffff80
[  554.536752] R10: 00007ffe6373db24 R11: 0000000000000246 R12: 00007fac6357f760
[  554.538643] R13: 0000000000000002 R14: 00007fac63588428 R15: 0000000000000000
[  554.540634] irq event stamp: 21731
[  554.541618] hardirqs last  enabled at (21731): [<ffffffffb75b3cd4>] _raw_spin_unlock_irq+0x24/0x30
[  554.544145] hardirqs last disabled at (21730): [<ffffffffb75b3ada>] _raw_spin_lock_irq+0xa/0x40
[  554.547027] softirqs last  enabled at (20148): [<ffffffffb780064d>] __do_softirq+0x64d/0x906
[  554.550385] softirqs last disabled at (19857): [<ffffffffb5926bd5>] irq_exit+0x175/0x1a0
[  554.553668] ---[ end trace a389c80c2ca84244 ]---

This is caused by media_device_cleanup() which destroys
v4l2_dev->mdev->req_queue_mutex. But v4l2_release() tries to lock
that mutex after media_device_cleanup() is called.

By moving media_device_cleanup() to the video_device's release function it is
guaranteed that the mutex is valid whenever v4l2_release is called.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vim2m.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index e17792f837f8..8d6b09623d88 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -1275,6 +1275,9 @@ static void vim2m_device_release(struct video_device *vdev)
 
 	v4l2_device_unregister(&dev->v4l2_dev);
 	v4l2_m2m_release(dev->m2m_dev);
+#ifdef CONFIG_MEDIA_CONTROLLER
+	media_device_cleanup(&dev->mdev);
+#endif
 	kfree(dev);
 }
 
@@ -1399,7 +1402,6 @@ static int vim2m_remove(struct platform_device *pdev)
 #ifdef CONFIG_MEDIA_CONTROLLER
 	media_device_unregister(&dev->mdev);
 	v4l2_m2m_unregister_media_controller(dev->m2m_dev);
-	media_device_cleanup(&dev->mdev);
 #endif
 	video_unregister_device(&dev->vfd);
 
-- 
2.20.1



