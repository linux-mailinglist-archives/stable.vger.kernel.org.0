Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C801D86EA
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729132AbgERRkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:40:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729121AbgERRkl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:40:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0910120829;
        Mon, 18 May 2020 17:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823640;
        bh=k6R50BJnSJAsdfMITjdQB0gK2h+S7nINXG3Eh7ugscQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GXpADY6vy9s4UQi6L/KhuyR2wbWI6ct01c0fpk3+Eh7JGO7/6QRjfNypyOfqDyWIZ
         WZyc5uR3VuN+y5FZ16nUv4HKLiW3PFU6aTbIiUm/qyf0Sggs6P8ysAvvEVTN2dSAwR
         BMAGpBk3fTf53729ytaRhNNoTWb++RzJST5gJgEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        Keith Busch <keith.busch@intel.com>,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.4 64/86] blk-mq: Allow timeouts to run while queue is freezing
Date:   Mon, 18 May 2020 19:36:35 +0200
Message-Id: <20200518173503.327209969@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.254571947@linuxfoundation.org>
References: <20200518173450.254571947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>

commit 71f79fb3179e69b0c1448a2101a866d871c66e7f upstream.

In case a submitted request gets stuck for some reason, the block layer
can prevent the request starvation by starting the scheduled timeout work.
If this stuck request occurs at the same time another thread has started
a queue freeze, the blk_mq_timeout_work will not be able to acquire the
queue reference and will return silently, thus not issuing the timeout.
But since the request is already holding a q_usage_counter reference and
is unable to complete, it will never release its reference, preventing
the queue from completing the freeze started by first thread.  This puts
the request_queue in a hung state, forever waiting for the freeze
completion.

This was observed while running IO to a NVMe device at the same time we
toggled the CPU hotplug code. Eventually, once a request got stuck
requiring a timeout during a queue freeze, we saw the CPU Hotplug
notification code get stuck inside blk_mq_freeze_queue_wait, as shown in
the trace below.

[c000000deaf13690] [c000000deaf13738] 0xc000000deaf13738 (unreliable)
[c000000deaf13860] [c000000000015ce8] __switch_to+0x1f8/0x350
[c000000deaf138b0] [c000000000ade0e4] __schedule+0x314/0x990
[c000000deaf13940] [c000000000ade7a8] schedule+0x48/0xc0
[c000000deaf13970] [c0000000005492a4] blk_mq_freeze_queue_wait+0x74/0x110
[c000000deaf139e0] [c00000000054b6a8] blk_mq_queue_reinit_notify+0x1a8/0x2e0
[c000000deaf13a40] [c0000000000e7878] notifier_call_chain+0x98/0x100
[c000000deaf13a90] [c0000000000b8e08] cpu_notify_nofail+0x48/0xa0
[c000000deaf13ac0] [c0000000000b92f0] _cpu_down+0x2a0/0x400
[c000000deaf13b90] [c0000000000b94a8] cpu_down+0x58/0xa0
[c000000deaf13bc0] [c0000000006d5dcc] cpu_subsys_offline+0x2c/0x50
[c000000deaf13bf0] [c0000000006cd244] device_offline+0x104/0x140
[c000000deaf13c30] [c0000000006cd40c] online_store+0x6c/0xc0
[c000000deaf13c80] [c0000000006c8c78] dev_attr_store+0x68/0xa0
[c000000deaf13cc0] [c0000000003974d0] sysfs_kf_write+0x80/0xb0
[c000000deaf13d00] [c0000000003963e8] kernfs_fop_write+0x188/0x200
[c000000deaf13d50] [c0000000002e0f6c] __vfs_write+0x6c/0xe0
[c000000deaf13d90] [c0000000002e1ca0] vfs_write+0xc0/0x230
[c000000deaf13de0] [c0000000002e2cdc] SyS_write+0x6c/0x110
[c000000deaf13e30] [c000000000009204] system_call+0x38/0xb4

The fix is to allow the timeout work to execute in the window between
dropping the initial refcount reference and the release of the last
reference, which actually marks the freeze completion.  This can be
achieved with percpu_refcount_tryget, which does not require the counter
to be alive.  This way the timeout work can do it's job and terminate a
stuck request even during a freeze, returning its reference and avoiding
the deadlock.

Allowing the timeout to run is just a part of the fix, since for some
devices, we might get stuck again inside the device driver's timeout
handler, should it attempt to allocate a new request in that path -
which is a quite common action for Abort commands, which need to be sent
after a timeout.  In NVMe, for instance, we call blk_mq_alloc_request
from inside the timeout handler, which will fail during a freeze, since
it also tries to acquire a queue reference.

I considered a similar change to blk_mq_alloc_request as a generic
solution for further device driver hangs, but we can't do that, since it
would allow new requests to disturb the freeze process.  I thought about
creating a new function in the block layer to support unfreezable
requests for these occasions, but after working on it for a while, I
feel like this should be handled in a per-driver basis.  I'm now
experimenting with changes to the NVMe timeout path, but I'm open to
suggestions of ways to make this generic.

Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>
Cc: Keith Busch <keith.busch@intel.com>
Cc: linux-nvme@lists.infradead.org
Cc: linux-block@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Giuliano Procida <gprocida@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-mq.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -628,7 +628,20 @@ static void blk_mq_rq_timer(unsigned lon
 	};
 	int i;
 
-	if (blk_queue_enter(q, GFP_NOWAIT))
+	/* A deadlock might occur if a request is stuck requiring a
+	 * timeout at the same time a queue freeze is waiting
+	 * completion, since the timeout code would not be able to
+	 * acquire the queue reference here.
+	 *
+	 * That's why we don't use blk_queue_enter here; instead, we use
+	 * percpu_ref_tryget directly, because we need to be able to
+	 * obtain a reference even in the short window between the queue
+	 * starting to freeze, by dropping the first reference in
+	 * blk_mq_freeze_queue_start, and the moment the last request is
+	 * consumed, marked by the instant q_usage_counter reaches
+	 * zero.
+	 */
+	if (!percpu_ref_tryget(&q->q_usage_counter))
 		return;
 
 	blk_mq_queue_tag_busy_iter(q, blk_mq_check_expired, &data);


