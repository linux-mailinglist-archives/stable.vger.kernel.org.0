Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFC763D55A
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 13:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiK3MRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 07:17:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233414AbiK3MRo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 07:17:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170C8FF7
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 04:17:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97E1661B9C
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 12:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD4BC433C1;
        Wed, 30 Nov 2022 12:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669810660;
        bh=iZfrNo3DvPJBDY9yfy3aFQcJp3O3yBDvnrcCNq1kxCM=;
        h=Subject:To:Cc:From:Date:From;
        b=se6rBfbPEXiFV+yptZL7rQTf7cmmcRNJqwa0yxzcN6Hsr8fW1doHGpOBgYFvC+77Y
         mXHQsddMzI98soVHPEibdh0Fph8hLZ7RQypCShMvg/5OVBz1HbTuIDVzK3VCvuTS/U
         nI6J1Q3Z8kCyeVChuSJWCBc0O6Yu6pMhHqrHBmYI=
Subject: FAILED: patch "[PATCH] io_uring: make poll refs more robust" failed to apply to 5.15-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk, linma@zju.edu.cn
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 30 Nov 2022 13:17:37 +0100
Message-ID: <166981065733150@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

a26a35e9019f ("io_uring: make poll refs more robust")
539bcb57da2f ("io_uring: fix tw losing poll events")
0638cd7be212 ("io_uring: clean poll ->private flagging")
329061d3e2f9 ("io_uring: move poll handling into its own file")
cfd22e6b3319 ("io_uring: add opcode name to io_op_defs")
c9f06aa7de15 ("io_uring: move io_uring_task (tctx) helpers into its own file")
a4ad4f748ea9 ("io_uring: move fdinfo helpers to its own file")
e5550a1447bf ("io_uring: use io_is_uring_fops() consistently")
17437f311490 ("io_uring: move SQPOLL related handling into its own file")
59915143e89f ("io_uring: move timeout opcodes and handling into its own file")
e418bbc97bff ("io_uring: move our reference counting into a header")
36404b09aa60 ("io_uring: move msg_ring into its own file")
f9ead18c1058 ("io_uring: split network related opcodes into its own file")
e0da14def1ee ("io_uring: move statx handling to its own file")
a9c210cebe13 ("io_uring: move epoll handler to its own file")
4cf90495281b ("io_uring: add a dummy -EOPNOTSUPP prep handler")
99f15d8d6136 ("io_uring: move uring_cmd handling to its own file")
cd40cae29ef8 ("io_uring: split out open/close operations")
453b329be5ea ("io_uring: separate out file table handling code")
f4c163dd7d4b ("io_uring: split out fadvise/madvise operations")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a26a35e9019fd70bf3cf647dcfdae87abc7bacea Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Sun, 20 Nov 2022 16:57:42 +0000
Subject: [PATCH] io_uring: make poll refs more robust

poll_refs carry two functions, the first is ownership over the request.
The second is notifying the io_poll_check_events() that there was an
event but wake up couldn't grab the ownership, so io_poll_check_events()
should retry.

We want to make poll_refs more robust against overflows. Instead of
always incrementing it, which covers two purposes with one atomic, check
if poll_refs is elevated enough and if so set a retry flag without
attempts to grab ownership. The gap between the bias check and following
atomics may seem racy, but we don't need it to be strict. Moreover there
might only be maximum 4 parallel updates: by the first and the second
poll entries, __io_arm_poll_handler() and cancellation. From those four,
only poll wake ups may be executed multiple times, but they're protected
by a spin.

Cc: stable@vger.kernel.org
Reported-by: Lin Ma <linma@zju.edu.cn>
Fixes: aa43477b04025 ("io_uring: poll rework")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/c762bc31f8683b3270f3587691348a7119ef9c9d.1668963050.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 1b78b527075d..b444b7d87697 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -40,7 +40,14 @@ struct io_poll_table {
 };
 
 #define IO_POLL_CANCEL_FLAG	BIT(31)
-#define IO_POLL_REF_MASK	GENMASK(30, 0)
+#define IO_POLL_RETRY_FLAG	BIT(30)
+#define IO_POLL_REF_MASK	GENMASK(29, 0)
+
+/*
+ * We usually have 1-2 refs taken, 128 is more than enough and we want to
+ * maximise the margin between this amount and the moment when it overflows.
+ */
+#define IO_POLL_REF_BIAS	128
 
 #define IO_WQE_F_DOUBLE		1
 
@@ -58,6 +65,21 @@ static inline bool wqe_is_double(struct wait_queue_entry *wqe)
 	return priv & IO_WQE_F_DOUBLE;
 }
 
+static bool io_poll_get_ownership_slowpath(struct io_kiocb *req)
+{
+	int v;
+
+	/*
+	 * poll_refs are already elevated and we don't have much hope for
+	 * grabbing the ownership. Instead of incrementing set a retry flag
+	 * to notify the loop that there might have been some change.
+	 */
+	v = atomic_fetch_or(IO_POLL_RETRY_FLAG, &req->poll_refs);
+	if (v & IO_POLL_REF_MASK)
+		return false;
+	return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
+}
+
 /*
  * If refs part of ->poll_refs (see IO_POLL_REF_MASK) is 0, it's free. We can
  * bump it and acquire ownership. It's disallowed to modify requests while not
@@ -66,6 +88,8 @@ static inline bool wqe_is_double(struct wait_queue_entry *wqe)
  */
 static inline bool io_poll_get_ownership(struct io_kiocb *req)
 {
+	if (unlikely(atomic_read(&req->poll_refs) >= IO_POLL_REF_BIAS))
+		return io_poll_get_ownership_slowpath(req);
 	return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
 }
 
@@ -235,6 +259,16 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 		 */
 		if ((v & IO_POLL_REF_MASK) != 1)
 			req->cqe.res = 0;
+		if (v & IO_POLL_RETRY_FLAG) {
+			req->cqe.res = 0;
+			/*
+			 * We won't find new events that came in between
+			 * vfs_poll and the ref put unless we clear the flag
+			 * in advance.
+			 */
+			atomic_andnot(IO_POLL_RETRY_FLAG, &req->poll_refs);
+			v &= ~IO_POLL_RETRY_FLAG;
+		}
 
 		/* the mask was stashed in __io_poll_execute */
 		if (!req->cqe.res) {

