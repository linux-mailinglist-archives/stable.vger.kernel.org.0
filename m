Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF14BD4E41
	for <lists+stable@lfdr.de>; Sat, 12 Oct 2019 10:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728919AbfJLISI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Oct 2019 04:18:08 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34193 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728903AbfJLISI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Oct 2019 04:18:08 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 54FD821B74;
        Sat, 12 Oct 2019 04:18:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sat, 12 Oct 2019 04:18:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=R+bj+H
        S/eCPrREUuyUZIdEp9e+hHY5Xt0/3O0z84Wfs=; b=WYxsahyUEJPjcB6hD2R8p3
        ihn/3eGZoDfvT+52HqrKj0xY1UiLw7T0JzlfvZjSpDmWv1xLkv3NujtWEu4JqivP
        6WmJW9oi8A0MawM+EhSqHv9LzSgA5N40Tj+3MGywPGdG3cqlQL/kQD5fkOJDXzvz
        RozKt57FZRXexb5ucgQ/x5afpOd0DWolhGe44ja3b3OgyfQzpxWHCBWkPBJX4vF6
        RrhFEU3+E9TBkGOg+3z8z6lbnnmY5wwcQlNk7+SaEa9yrZy/MdIlTyOL5o/Uc8Nf
        o9B9HI7JkkrWRYAi6mbsl2ANW03yH7FZXiA2tEA7Bp0C5XGBqJEEFNS/SqA+vPYw
        ==
X-ME-Sender: <xms:PoyhXQeuzrQL0ewJfyBwwmw5Ze2VM8VnElMvPaHHQ4b-FxjIaTEP5A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrieejgddtvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeeivddrudduledrudeiie
    drleenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:PoyhXSXkXzdCBq579_2e4o31W4kpmaMvkoN4IwuoKgUihM5fJX0XpA>
    <xmx:PoyhXZdrvJC0tyLor6yYD_5875NYQgcadJJ_aLuGz4YS8z0dtfonEQ>
    <xmx:PoyhXeM5Rm2WZ4QreTFRKcEV-R-LSYDW8C-J866lkMiMWlvcfrOSXQ>
    <xmx:P4yhXSSZDy69WG4Kwat1pDm29j-QStqHBUtLJvyoK-heIAz5FJAwhA>
Received: from localhost (unknown [62.119.166.9])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0FB32D6005A;
        Sat, 12 Oct 2019 04:18:05 -0400 (EDT)
Subject: FAILED: patch "[PATCH] writeback: fix use-after-free in finish_writeback_work()" failed to apply to 5.3-stable tree
To:     tj@kernel.org, akpm@linux-foundation.org, axboe@kernel.dk,
        clm@fb.com, jack@suse.cz, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 12 Oct 2019 10:17:58 +0200
Message-ID: <157086827811218@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.3-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8e00c4e9dd852f7a9bf12234fad65a2f2f93788f Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Sun, 6 Oct 2019 17:58:09 -0700
Subject: [PATCH] writeback: fix use-after-free in finish_writeback_work()

finish_writeback_work() reads @done->waitq after decrementing
@done->cnt.  However, once @done->cnt reaches zero, @done may be freed
(from stack) at any moment and @done->waitq can contain something
unrelated by the time finish_writeback_work() tries to read it.  This
led to the following crash.

  "BUG: kernel NULL pointer dereference, address: 0000000000000002"
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  PGD 0 P4D 0
  Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
  CPU: 40 PID: 555153 Comm: kworker/u98:50 Kdump: loaded Not tainted
  ...
  Workqueue: writeback wb_workfn (flush-btrfs-1)
  RIP: 0010:_raw_spin_lock_irqsave+0x10/0x30
  Code: 48 89 d8 5b c3 e8 50 db 6b ff eb f4 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 53 9c 5b fa 31 c0 ba 01 00 00 00 <f0> 0f b1 17 75 05 48 89 d8 5b c3 89 c6 e8 fe ca 6b ff eb f2 66 90
  RSP: 0018:ffffc90049b27d98 EFLAGS: 00010046
  RAX: 0000000000000000 RBX: 0000000000000246 RCX: 0000000000000000
  RDX: 0000000000000001 RSI: 0000000000000003 RDI: 0000000000000002
  RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
  R10: ffff889fff407600 R11: ffff88ba9395d740 R12: 000000000000e300
  R13: 0000000000000003 R14: 0000000000000000 R15: 0000000000000000
  FS:  0000000000000000(0000) GS:ffff88bfdfa00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000002 CR3: 0000000002409005 CR4: 00000000001606e0
  Call Trace:
   __wake_up_common_lock+0x63/0xc0
   wb_workfn+0xd2/0x3e0
   process_one_work+0x1f5/0x3f0
   worker_thread+0x2d/0x3d0
   kthread+0x111/0x130
   ret_from_fork+0x1f/0x30

Fix it by reading and caching @done->waitq before decrementing
@done->cnt.

Link: http://lkml.kernel.org/r/20190924010631.GH2233839@devbig004.ftw2.facebook.com
Fixes: 5b9cce4c7eb069 ("writeback: Generalize and expose wb_completion")
Signed-off-by: Tejun Heo <tj@kernel.org>
Debugged-by: Chris Mason <clm@fb.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>	[5.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 8aaa7eec7b74..e88421d9a48d 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -164,8 +164,13 @@ static void finish_writeback_work(struct bdi_writeback *wb,
 
 	if (work->auto_free)
 		kfree(work);
-	if (done && atomic_dec_and_test(&done->cnt))
-		wake_up_all(done->waitq);
+	if (done) {
+		wait_queue_head_t *waitq = done->waitq;
+
+		/* @done can't be accessed after the following dec */
+		if (atomic_dec_and_test(&done->cnt))
+			wake_up_all(waitq);
+	}
 }
 
 static void wb_queue_work(struct bdi_writeback *wb,

