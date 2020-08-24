Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCE024F413
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgHXIcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:32:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726646AbgHXIcT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:32:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 722302075B;
        Mon, 24 Aug 2020 08:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598257938;
        bh=MdqGIJpCx/+wgQQjrkGUNZbwGiGXF25VfSr3JxxELIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pu128YIQMKPa8/7gkvSj0TqEzARdTsZgf7uZLjvNtOuzteA69ZRt/AUS7hND6pxs+
         AA6yvAgtdmuaDBuFJipir6bs65XqDATRCQSgcgUyz4GENahfYpJNyXycvO0/K4COQ1
         r/p59h64vXvFEEn1jgud1LkxBO04FoduZzm/9DmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Michael Ellerman <mpe@ellerman.id.au>,
        David Rientjes <rientjes@google.com>,
        Michel Lespinasse <walken@google.com>,
        Daniel Axtens <dja@axtens.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Akash Goel <akash.goel@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.8 015/148] kernel/relay.c: fix memleak on destroy relay channel
Date:   Mon, 24 Aug 2020 10:28:33 +0200
Message-Id: <20200824082414.696953831@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

commit 71e843295c680898959b22dc877ae3839cc22470 upstream.

kmemleak report memory leak as follows:

  unreferenced object 0x607ee4e5f948 (size 8):
  comm "syz-executor.1", pid 2098, jiffies 4295031601 (age 288.468s)
  hex dump (first 8 bytes):
  00 00 00 00 00 00 00 00 ........
  backtrace:
     relay_open kernel/relay.c:583 [inline]
     relay_open+0xb6/0x970 kernel/relay.c:563
     do_blk_trace_setup+0x4a8/0xb20 kernel/trace/blktrace.c:557
     __blk_trace_setup+0xb6/0x150 kernel/trace/blktrace.c:597
     blk_trace_ioctl+0x146/0x280 kernel/trace/blktrace.c:738
     blkdev_ioctl+0xb2/0x6a0 block/ioctl.c:613
     block_ioctl+0xe5/0x120 fs/block_dev.c:1871
     vfs_ioctl fs/ioctl.c:48 [inline]
     __do_sys_ioctl fs/ioctl.c:753 [inline]
     __se_sys_ioctl fs/ioctl.c:739 [inline]
     __x64_sys_ioctl+0x170/0x1ce fs/ioctl.c:739
     do_syscall_64+0x33/0x40 arch/x86/entry/common.c:46
     entry_SYSCALL_64_after_hwframe+0x44/0xa9

'chan->buf' is malloced in relay_open() by alloc_percpu() but not free
while destroy the relay channel.  Fix it by adding free_percpu() before
return from relay_destroy_channel().

Fixes: 017c59c042d0 ("relay: Use per CPU constructs for the relay channel buffer pointers")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: David Rientjes <rientjes@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Daniel Axtens <dja@axtens.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Akash Goel <akash.goel@intel.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200817122826.48518-1-weiyongjun1@huawei.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/relay.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -197,6 +197,7 @@ free_buf:
 static void relay_destroy_channel(struct kref *kref)
 {
 	struct rchan *chan = container_of(kref, struct rchan, kref);
+	free_percpu(chan->buf);
 	kfree(chan);
 }
 


