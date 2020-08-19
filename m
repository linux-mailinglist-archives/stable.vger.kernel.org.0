Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E84A2492F1
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 04:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgHSCjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 22:39:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727063AbgHSCjb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 22:39:31 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAA3820639;
        Wed, 19 Aug 2020 02:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597804769;
        bh=1sg34DpK34YvRAIG7NKdmk3vjoU73v2/s/kT2x+SrnY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=h9B/pun1Fu4fTJUzg4OrzT7CtJURLr9CZcZBkVe7imTqLUOgaK6Rg8QNg4d9Sv5hf
         qZc99DTW/CoSvp4/0ntukhecJNcuDVhDbv8z+5/C2RP9gFYLORNPnSu560scHvJxNz
         QpKjMCRthODvf3KawAolORLaFvC0dLKIp9PjD14I=
Date:   Tue, 18 Aug 2020 19:39:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akash.goel@intel.com, chris@chris-wilson.co.uk, dja@axtens.net,
        hulkci@huawei.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        rientjes@google.com, stable@vger.kernel.org, tglx@linutronix.de,
        viro@zeniv.linux.org.uk, walken@google.com, weiyongjun1@huawei.com
Subject:  +
 kernel-relayc-fix-memleak-on-destroy-relay-channel.patch added to -mm tree
Message-ID: <20200819023928.UDjVfIY4b%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kernel/relay.c: fix memleak on destroy relay channel
has been added to the -mm tree.  Its filename is
     kernel-relayc-fix-memleak-on-destroy-relay-channel.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-relayc-fix-memleak-on-destroy-relay-channel.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-relayc-fix-memleak-on-destroy-relay-channel.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kernel-relayc-fix-memleak-on-destroy-relay-channel.patch

