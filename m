Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEC8D55D056
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233225AbiF0H7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 03:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233250AbiF0H67 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 03:58:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40DEBF9;
        Mon, 27 Jun 2022 00:58:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70DFD60F4F;
        Mon, 27 Jun 2022 07:58:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85709C3411D;
        Mon, 27 Jun 2022 07:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656316736;
        bh=yGdNDgKFWodN9KAeqqkUzNf4L1DRoZorIcIf1HtYqJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JPL/KQ4L/jxvkzw3Z+dll+WAeK7RDlFSCexzwSb2A5Qik4BBI+Gnw9gHQQSKKAy4P
         swf8pXZW/r15oId0+RuYZkawoRnGyoInphTXrpGnlRGDT58zNfG5JnMAa/4tiiwVE5
         +0pi/GBYGfTxmAFiOg4NTC9nX2lBO/5za1Z1RLbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.10.126
Date:   Mon, 27 Jun 2022 09:58:46 +0200
Message-Id: <165631672557197@kroah.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <16563167256229@kroah.com>
References: <16563167256229@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index da5b28931e5c..57434487c2b4 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 125
+SUBLEVEL = 126
 EXTRAVERSION =
 NAME = Dare mighty things
 
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 40ac37beca47..2e12dcbc7b0f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -696,6 +696,8 @@ struct io_kiocb {
 	 */
 	struct list_head		inflight_entry;
 
+	struct list_head		iopoll_entry;
+
 	struct percpu_ref		*fixed_file_refs;
 	struct callback_head		task_work;
 	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
@@ -2350,8 +2352,8 @@ static void io_iopoll_queue(struct list_head *again)
 	struct io_kiocb *req;
 
 	do {
-		req = list_first_entry(again, struct io_kiocb, inflight_entry);
-		list_del(&req->inflight_entry);
+		req = list_first_entry(again, struct io_kiocb, iopoll_entry);
+		list_del(&req->iopoll_entry);
 		__io_complete_rw(req, -EAGAIN, 0, NULL);
 	} while (!list_empty(again));
 }
@@ -2373,14 +2375,14 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	while (!list_empty(done)) {
 		int cflags = 0;
 
-		req = list_first_entry(done, struct io_kiocb, inflight_entry);
+		req = list_first_entry(done, struct io_kiocb, iopoll_entry);
 		if (READ_ONCE(req->result) == -EAGAIN) {
 			req->result = 0;
 			req->iopoll_completed = 0;
-			list_move_tail(&req->inflight_entry, &again);
+			list_move_tail(&req->iopoll_entry, &again);
 			continue;
 		}
-		list_del(&req->inflight_entry);
+		list_del(&req->iopoll_entry);
 
 		if (req->flags & REQ_F_BUFFER_SELECTED)
 			cflags = io_put_rw_kbuf(req);
@@ -2416,7 +2418,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	spin = !ctx->poll_multi_file && *nr_events < min;
 
 	ret = 0;
-	list_for_each_entry_safe(req, tmp, &ctx->iopoll_list, inflight_entry) {
+	list_for_each_entry_safe(req, tmp, &ctx->iopoll_list, iopoll_entry) {
 		struct kiocb *kiocb = &req->rw.kiocb;
 
 		/*
@@ -2425,7 +2427,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		 * and complete those lists first, if we have entries there.
 		 */
 		if (READ_ONCE(req->iopoll_completed)) {
-			list_move_tail(&req->inflight_entry, &done);
+			list_move_tail(&req->iopoll_entry, &done);
 			continue;
 		}
 		if (!list_empty(&done))
@@ -2437,7 +2439,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 
 		/* iopoll may have completed current req */
 		if (READ_ONCE(req->iopoll_completed))
-			list_move_tail(&req->inflight_entry, &done);
+			list_move_tail(&req->iopoll_entry, &done);
 
 		if (ret && spin)
 			spin = false;
@@ -2670,7 +2672,7 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
 		struct io_kiocb *list_req;
 
 		list_req = list_first_entry(&ctx->iopoll_list, struct io_kiocb,
-						inflight_entry);
+						iopoll_entry);
 		if (list_req->file != req->file)
 			ctx->poll_multi_file = true;
 	}
@@ -2680,9 +2682,9 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
 	 * it to the front so we find it first.
 	 */
 	if (READ_ONCE(req->iopoll_completed))
-		list_add(&req->inflight_entry, &ctx->iopoll_list);
+		list_add(&req->iopoll_entry, &ctx->iopoll_list);
 	else
-		list_add_tail(&req->inflight_entry, &ctx->iopoll_list);
+		list_add_tail(&req->iopoll_entry, &ctx->iopoll_list);
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) &&
 	    wq_has_sleeper(&ctx->sq_data->wait))
