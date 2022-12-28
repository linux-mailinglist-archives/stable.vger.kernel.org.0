Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3473E6584FD
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234953AbiL1RFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:05:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235290AbiL1REB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:04:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48AB62019B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:58:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA1F661558
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:58:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5688C433EF;
        Wed, 28 Dec 2022 16:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246709;
        bh=qHAHYNT33XrSf20Dqv65bJt7aFvNtIL7o1cxACxSeKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QKTMSHGnpTNUAO3mryrXTjBEcd5w+HkqomQN4csDTJ+jOL+QsIwmbTE2CcKFIbeOb
         7alVRehlctdfiqcYdS1Q0RjnRS9A3Q96MLhJPou4TV+4XPyfoxulahX38kgztyiZ6k
         5Q0DfxY4hlwpqvozX+dWNXgoX22xTk8taKCkRN44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stefan Metzmacher <metze@samba.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 1135/1146] io_uring/net: introduce IORING_SEND_ZC_REPORT_USAGE flag
Date:   Wed, 28 Dec 2022 15:44:34 +0100
Message-Id: <20221228144400.972036072@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Metzmacher <metze@samba.org>

commit e307e6698165ca6508ed42c69cb1be76c8eb6a3c upstream.

It might be useful for applications to detect if a zero copy transfer with
SEND[MSG]_ZC was actually possible or not. The application can fallback to
plain SEND[MSG] in order to avoid the overhead of two cqes per request. Or
it can generate a log message that could indicate to an administrator that
no zero copy was possible and could explain degraded performance.

Cc: stable@vger.kernel.org # 6.1
Link: https://lore.kernel.org/io-uring/fb6a7599-8a9b-15e5-9b64-6cd9d01c6ff4@gmail.com/T/#m2b0d9df94ce43b0e69e6c089bdff0ce6babbdfaa
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/8945b01756d902f5d5b0667f20b957ad3f742e5e.1666895626.git.metze@samba.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/io_uring.h |   18 ++++++++++++++++++
 io_uring/net.c                |    6 +++++-
 io_uring/notif.c              |   12 ++++++++++++
 io_uring/notif.h              |    3 +++
 4 files changed, 38 insertions(+), 1 deletion(-)

--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -296,10 +296,28 @@ enum io_uring_op {
  *
  * IORING_RECVSEND_FIXED_BUF	Use registered buffers, the index is stored in
  *				the buf_index field.
+ *
+ * IORING_SEND_ZC_REPORT_USAGE
+ *				If set, SEND[MSG]_ZC should report
+ *				the zerocopy usage in cqe.res
+ *				for the IORING_CQE_F_NOTIF cqe.
+ *				0 is reported if zerocopy was actually possible.
+ *				IORING_NOTIF_USAGE_ZC_COPIED if data was copied
+ *				(at least partially).
  */
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
 #define IORING_RECV_MULTISHOT		(1U << 1)
 #define IORING_RECVSEND_FIXED_BUF	(1U << 2)
+#define IORING_SEND_ZC_REPORT_USAGE	(1U << 3)
+
+/*
+ * cqe.res for IORING_CQE_F_NOTIF if
+ * IORING_SEND_ZC_REPORT_USAGE was requested
+ *
+ * It should be treated as a flag, all other
+ * bits of cqe.res should be treated as reserved!
+ */
+#define IORING_NOTIF_USAGE_ZC_COPIED    (1U << 31)
 
 /*
  * accept flags stored in sqe->ioprio
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -937,7 +937,8 @@ int io_send_zc_prep(struct io_kiocb *req
 
 	zc->flags = READ_ONCE(sqe->ioprio);
 	if (zc->flags & ~(IORING_RECVSEND_POLL_FIRST |
-			  IORING_RECVSEND_FIXED_BUF))
+			  IORING_RECVSEND_FIXED_BUF |
+			  IORING_SEND_ZC_REPORT_USAGE))
 		return -EINVAL;
 	notif = zc->notif = io_alloc_notif(ctx);
 	if (!notif)
@@ -955,6 +956,9 @@ int io_send_zc_prep(struct io_kiocb *req
 		req->imu = READ_ONCE(ctx->user_bufs[idx]);
 		io_req_set_rsrc_node(notif, ctx, 0);
 	}
+	if (zc->flags & IORING_SEND_ZC_REPORT_USAGE) {
+		io_notif_to_data(notif)->zc_report = true;
+	}
 
 	if (req->opcode == IORING_OP_SEND_ZC) {
 		if (READ_ONCE(sqe->__pad3[0]))
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -18,6 +18,10 @@ static void __io_notif_complete_tw(struc
 		__io_unaccount_mem(ctx->user, nd->account_pages);
 		nd->account_pages = 0;
 	}
+
+	if (nd->zc_report && (nd->zc_copied || !nd->zc_used))
+		notif->cqe.res |= IORING_NOTIF_USAGE_ZC_COPIED;
+
 	io_req_task_complete(notif, locked);
 }
 
@@ -28,6 +32,13 @@ static void io_uring_tx_zerocopy_callbac
 	struct io_notif_data *nd = container_of(uarg, struct io_notif_data, uarg);
 	struct io_kiocb *notif = cmd_to_io_kiocb(nd);
 
+	if (nd->zc_report) {
+		if (success && !nd->zc_used && skb)
+			WRITE_ONCE(nd->zc_used, true);
+		else if (!success && !nd->zc_copied)
+			WRITE_ONCE(nd->zc_copied, true);
+	}
+
 	if (refcount_dec_and_test(&uarg->refcnt)) {
 		notif->io_task_work.func = __io_notif_complete_tw;
 		io_req_task_work_add(notif);
@@ -55,6 +66,7 @@ struct io_kiocb *io_alloc_notif(struct i
 	nd->account_pages = 0;
 	nd->uarg.flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
 	nd->uarg.callback = io_uring_tx_zerocopy_callback;
+	nd->zc_report = nd->zc_used = nd->zc_copied = false;
 	refcount_set(&nd->uarg.refcnt, 1);
 	return notif;
 }
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -13,6 +13,9 @@ struct io_notif_data {
 	struct file		*file;
 	struct ubuf_info	uarg;
 	unsigned long		account_pages;
+	bool			zc_report;
+	bool			zc_used;
+	bool			zc_copied;
 };
 
 void io_notif_flush(struct io_kiocb *notif);


