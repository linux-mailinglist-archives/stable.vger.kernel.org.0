Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F145B4FD0AF
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234162AbiDLGsk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350875AbiDLGsP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:48:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72DFC25585;
        Mon, 11 Apr 2022 23:39:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF190618DC;
        Tue, 12 Apr 2022 06:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE36C385A1;
        Tue, 12 Apr 2022 06:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745569;
        bh=596DBPnwHs2YqO+iTvAQw1ZottEYdxgsk57woNRTF7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NA2zMNMSys+VeIeeJM/qlQeQqwPuOd3i8yl1qnesX4AaFzgVUiHhP6uJKv71CKTsm
         2vFNoipSFL3ihq4Y1n4ozkDWc4/Wy0ngurS6sYMS3bg0X5krHwWffi5RqG5/2I3YIE
         RKfN5iePaE9wnZjDIMRpmbJjN3q0HzdJTsg2bg3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 141/171] io_uring: fix race between timeout flush and removal
Date:   Tue, 12 Apr 2022 08:30:32 +0200
Message-Id: <20220412062931.969405079@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit e677edbcabee849bfdd43f1602bccbecf736a646 upstream.

io_flush_timeouts() assumes the timeout isn't in progress of triggering
or being removed/canceled, so it unconditionally removes it from the
timeout list and attempts to cancel it.

Leave it on the list and let the normal timeout cancelation take care
of it.

Cc: stable@vger.kernel.org # 5.5+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1556,6 +1556,7 @@ static void __io_queue_deferred(struct i
 
 static void io_flush_timeouts(struct io_ring_ctx *ctx)
 {
+	struct io_kiocb *req, *tmp;
 	u32 seq;
 
 	if (list_empty(&ctx->timeout_list))
@@ -1563,10 +1564,8 @@ static void io_flush_timeouts(struct io_
 
 	seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
 
-	do {
+	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, timeout.list) {
 		u32 events_needed, events_got;
-		struct io_kiocb *req = list_first_entry(&ctx->timeout_list,
-						struct io_kiocb, timeout.list);
 
 		if (io_is_timeout_noseq(req))
 			break;
@@ -1583,9 +1582,8 @@ static void io_flush_timeouts(struct io_
 		if (events_got < events_needed)
 			break;
 
-		list_del_init(&req->timeout.list);
 		io_kill_timeout(req, 0);
-	} while (!list_empty(&ctx->timeout_list));
+	}
 
 	ctx->cq_last_tm_flush = seq;
 }
@@ -5639,6 +5637,7 @@ static int io_timeout_prep(struct io_kio
 	else
 		data->mode = HRTIMER_MODE_REL;
 
+	INIT_LIST_HEAD(&req->timeout.list);
 	hrtimer_init(&data->timer, CLOCK_MONOTONIC, data->mode);
 	return 0;
 }
@@ -6282,12 +6281,12 @@ static enum hrtimer_restart io_link_time
 	if (!list_empty(&req->link_list)) {
 		prev = list_entry(req->link_list.prev, struct io_kiocb,
 				  link_list);
-		if (refcount_inc_not_zero(&prev->refs))
-			list_del_init(&req->link_list);
-		else
+		list_del_init(&req->link_list);
+		if (!refcount_inc_not_zero(&prev->refs))
 			prev = NULL;
 	}
 
+	list_del(&req->timeout.list);
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
 	if (prev) {


