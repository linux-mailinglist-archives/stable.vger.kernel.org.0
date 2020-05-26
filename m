Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1C41AA2E5
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505694AbgDONAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 09:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2505698AbgDONA3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 09:00:29 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58813C061A0F
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 06:00:29 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id m15so10601221wrb.0
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 06:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=s3Dxz6p1foOuGnxsSwWBIgg5lmhpYMN/jCU503kDd5o=;
        b=IfOMSEpx4pQsR3HEfyZOboHR9m64ZHfElfCnje4KRTt3afIq0tZW6YVXq1Lj/rAPCx
         /yAkOGcVUVYzFtctxYp/ddj9EgFchjAribmeuWeYkqF43fOc0RoenxXfybf5Er4fg4YK
         43aM6iQ6z8OQxQKLvfnl8X/ogD+sLNZRx7RekltR9FE6Rin5f0L14W6kN5yCbnYdLTCK
         b0NRJaWP7OuAkvC/oWTYOS8h+Xt2mgG/Nsv1A6OgiHkdC0E90GrluqLUWxwbLCiTOfDi
         Xj9Mne8DAX6Lwj6BgOVuBnmbwKg/Ty2bps4dywBBVGgt30HdKNMBOs/2TpLkFNYjcJeo
         gBJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=s3Dxz6p1foOuGnxsSwWBIgg5lmhpYMN/jCU503kDd5o=;
        b=psOwndWL6XwrD2eUl3qZfMZ1Y7vD2U7tDWsK0fkk8m+Jy6+xDQwyOhCEI0AGOT+2/E
         dHHIUKPECqamzz5u+eRFXOfoImo55gr9w05XRpH0SjW5hd1NN1fZzhkqfqzvtGJHJcj6
         64zpYzhc9loWzen/y6BjTyB9r3rpjvEwG3bGHv7e9rrLOd7uN/UOxhKBQfJqPsMUOIEP
         AGUwSS+FZyLf+UIkuqFTHerBUhOCbtEssEKtUvq/uGIhC5lw7JOYq/FFxhmjZIWgP235
         668ECobxeXYNjlJqrpWPISdIqyfbfxHJB4wWmsj6nQBkpTrQZwj97UrnESqCyI3w7ltR
         YttQ==
X-Gm-Message-State: AGi0PuYnIbLlsWvvYNQ5S0d7wENhuElpkVF6hCh690NrFj8f+Xfcy7op
        w3Ma+fK2WEQ6beRd/3HV5bs1n0xsL3bNoQ==
X-Google-Smtp-Source: APiQypIp0009AH1kf1YuFTFoNXOREBYaJxauBtwP18dY6kJ/6AEXAzSa7n4cFwaAW91uUPTqLtnhcBJFy6SR7g==
X-Received: by 2002:a5d:6a92:: with SMTP id s18mr27270946wru.50.1586955627848;
 Wed, 15 Apr 2020 06:00:27 -0700 (PDT)
Date:   Wed, 15 Apr 2020 14:00:15 +0100
In-Reply-To: <CAGvU0Hn2U88Dy2MEP-ZTNvfrWaKF4XL9EtR+4iF5BZ6_GW3Tvg@mail.gmail.com>
Message-Id: <20200415130017.244979-3-gprocida@google.com>
Mime-Version: 1.0
References: <CAGvU0Hn2U88Dy2MEP-ZTNvfrWaKF4XL9EtR+4iF5BZ6_GW3Tvg@mail.gmail.com>
X-Mailer: git-send-email 2.26.0.110.g2183baf09c-goog
Subject: [PATCH v2 2/4] blk-mq: Allow timeouts to run while queue is freezing
From:   Giuliano Procida <gprocida@google.com>
To:     greg@kroah.com
Cc:     Giuliano Procida <gprocida@google.com>, stable@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        Keith Busch <keith.busch@intel.com>,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 block/blk-mq.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 11a23bf73fd9..d13e70d40df9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -628,7 +628,20 @@ static void blk_mq_rq_timer(unsigned long priv)
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
-- 
2.26.0.110.g2183baf09c-goog

