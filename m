Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8407B24E903
	for <lists+stable@lfdr.de>; Sat, 22 Aug 2020 19:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbgHVR36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Aug 2020 13:29:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728381AbgHVR34 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Aug 2020 13:29:56 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3B992078D;
        Sat, 22 Aug 2020 17:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598117396;
        bh=60v78CIy00Qia4qK0No+pa1ah8qWL5AlZa39rgo+Sck=;
        h=Date:From:To:Subject:From;
        b=blEGsDZzfan/6CDJOmm1re+k50JUxNKrhU42+HEi5MAIlBw2EJDL7VBN2dvswIUxm
         vxfBwybK4g68W0AUTRDvPwQjm8l4j0Gz8wUG1I+VYVdJcvf0Q0JxZgfYmarb/JZe+/
         8fmPyb3mtPSTJYm5kLHzEpzUa/SJ767GM2xC3DHQ=
Date:   Sat, 22 Aug 2020 10:29:55 -0700
From:   akpm@linux-foundation.org
To:     akash.goel@intel.com, chris@chris-wilson.co.uk, dja@axtens.net,
        hulkci@huawei.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        rientjes@google.com, stable@vger.kernel.org, tglx@linutronix.de,
        viro@zeniv.linux.org.uk, walken@google.com, weiyongjun1@huawei.com
Subject:  [merged]
 kernel-relayc-fix-memleak-on-destroy-relay-channel.patch removed from -mm
 tree
Message-ID: <20200822172955.kJFfKHqDV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kernel/relay.c: fix memleak on destroy relay channel
has been removed from the -mm tree.  Its filename was
     kernel-relayc-fix-memleak-on-destroy-relay-channel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: kernel/relay.c: fix memleak on destroy relay channel

kmemleak report memory leak as follows:

unreferenced object 0x607ee4e5f948 (size 8):
comm "syz-executor.1", pid 2098, jiffies 4295031601 (age 288.468s)
hex dump (first 8 bytes):
00 00 00 00 00 00 00 00 ........
backtrace:
[<00000000ca1de2fa>] relay_open kernel/relay.c:583 [inline]
[<00000000ca1de2fa>] relay_open+0xb6/0x970 kernel/relay.c:563
[<0000000038ae5a4b>] do_blk_trace_setup+0x4a8/0xb20 kernel/trace/blktrace.c:557
[<00000000d5e778e9>] __blk_trace_setup+0xb6/0x150 kernel/trace/blktrace.c:597
[<0000000038fdf803>] blk_trace_ioctl+0x146/0x280 kernel/trace/blktrace.c:738
[<00000000ce25a0ca>] blkdev_ioctl+0xb2/0x6a0 block/ioctl.c:613
[<00000000579e47e0>] block_ioctl+0xe5/0x120 fs/block_dev.c:1871
[<00000000b1588c11>] vfs_ioctl fs/ioctl.c:48 [inline]
[<00000000b1588c11>] __do_sys_ioctl fs/ioctl.c:753 [inline]
[<00000000b1588c11>] __se_sys_ioctl fs/ioctl.c:739 [inline]
[<00000000b1588c11>] __x64_sys_ioctl+0x170/0x1ce fs/ioctl.c:739
[<0000000088fc9942>] do_syscall_64+0x33/0x40 arch/x86/entry/common.c:46
[<000000004f6dd57a>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

'chan->buf' is malloced in relay_open() by alloc_percpu() but not free
while destroy the relay channel. Fix it by adding free_percpu() before
return from relay_destroy_channel().

Link: http://lkml.kernel.org/r/20200817122826.48518-1-weiyongjun1@huawei.com
Fixes: 017c59c042d0 ("relay: Use per CPU constructs for the relay channel buffer pointers")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: David Rientjes <rientjes@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Daniel Axtens <dja@axtens.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Akash Goel <akash.goel@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/relay.c~kernel-relayc-fix-memleak-on-destroy-relay-channel
+++ a/kernel/relay.c
@@ -197,6 +197,7 @@ free_buf:
 static void relay_destroy_channel(struct kref *kref)
 {
 	struct rchan *chan = container_of(kref, struct rchan, kref);
+	free_percpu(chan->buf);
 	kfree(chan);
 }
 
_

Patches currently in -mm which might be from weiyongjun1@huawei.com are


