Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A0D24C94E
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 02:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgHUAmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 20:42:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727031AbgHUAmQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 20:42:16 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AD44208E4;
        Fri, 21 Aug 2020 00:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597970535;
        bh=VaUhYJWR/1JwUL0k35caQCtTO9zYWbbKFBoWO/AsmfI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=eAnPby51eTm033wX5FRWNYvWwPQg5+QdgpvjQ/p8R9wZ1G2d9pUUC/X0pqhdibkVC
         n1voVaJoNc3kv3ipZXaERkmTlVDiFWA6zqWcN2w9X6+f1ILjZfeWIbQLnnAID287z7
         jOMs+xpZue+NsXiL+t7ZWdfj3vSSMeC3oLXqykc8=
Date:   Thu, 20 Aug 2020 17:42:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akash.goel@intel.com, akpm@linux-foundation.org,
        chris@chris-wilson.co.uk, dja@axtens.net, hulkci@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        rientjes@google.com, stable@vger.kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        walken@google.com, weiyongjun1@huawei.com
Subject:  [patch 07/11] kernel/relay.c: fix memleak on destroy
 relay channel
Message-ID: <20200821004214.qRMMcztwG%akpm@linux-foundation.org>
In-Reply-To: <20200820174132.67fd4a7a9359048f807a533b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
