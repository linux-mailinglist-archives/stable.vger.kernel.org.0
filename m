Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE76C115D56
	for <lists+stable@lfdr.de>; Sat,  7 Dec 2019 16:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbfLGPfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Dec 2019 10:35:07 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:37489 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726409AbfLGPfH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Dec 2019 10:35:07 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 691BC22779;
        Sat,  7 Dec 2019 10:35:06 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sat, 07 Dec 2019 10:35:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=XaSj5Y
        RxslARMBs4+h03pKuMT/t1Cfa+kJLylnu+XN4=; b=ovyyajRFlevc8sS5Mu4RZr
        Cow48CAAUobbTGZ/7IDNKBkQo5PsT8d0XwlEHJrf9szEq2Adm/l3venALbKMFQtk
        YlBSraswoIe1nDGJzCQDjYmHKXMfrocLYCSSvNkVXRKE29lroHh0lfzSSUVazsvs
        Qt/lJxp4CKTvpvjnhbJOpXvntCfWB0+A/6/wwY3h6vSlktRc6R8j7D1fG3qG5/vU
        66CmLvGBSobCxE0O8aTsNoT/Nj4Gc6dh9bb8Yk8f4va5JvwXca7FJdOfmvHacuf8
        cpe9nTGXtFo1tjClaLS6NR2U3pkJpfAmSPaeugtw1cBmPiANt8R4hXkjFPiKQsKQ
        ==
X-ME-Sender: <xms:qsbrXZ1kEkiKI74JuRENseKT2Dju3NasJ8wsphGyEeeEMc4Y1CqCqg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudekhedgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:qsbrXUXaGr66B8fqHZwaQNUga3gqbYm2AHV5at4Wnr4bTZ_RYieh_w>
    <xmx:qsbrXU7az-Buf7ASfuGgqXh4lJuIpgsCeDifk_A4nK8PYy8E5NeuxQ>
    <xmx:qsbrXbIQiWno8H4Opj2Jh-CgTHnFxVPRr37PseXxWIoxexR4yPmfow>
    <xmx:qsbrXZI-ZA_oyclSfRCtmtnCT7VfmGo_lTUo1199r05hSUP28uHgRw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B57BC80060;
        Sat,  7 Dec 2019 10:35:05 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: Fix mm_fault with READ/WRITE_FIXED" failed to apply to 5.4-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 07 Dec 2019 16:35:03 +0100
Message-ID: <157573290350121@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 95a1b3ff9a3e4ea2f26c4e802067d58831f415db Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Sun, 27 Oct 2019 23:15:41 +0300
Subject: [PATCH] io_uring: Fix mm_fault with READ/WRITE_FIXED

Commit fb5ccc98782f ("io_uring: Fix broken links with offloading")
introduced a potential performance regression with unconditionally
taking mm even for READ/WRITE_FIXED operations.

Return the logic handling it back. mm-faulted requests will go through
the generic submission path, so honoring links and drains, but will
fail further on req->has_user check.

Fixes: fb5ccc98782f ("io_uring: Fix broken links with offloading")
Cc: stable@vger.kernel.org # v5.4
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 545efd89a1f9..f9eff8f62ddb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2726,13 +2726,14 @@ static bool io_get_sqring(struct io_ring_ctx *ctx, struct sqe_submit *s)
 }
 
 static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
-			  bool has_user, bool mm_fault)
+			  struct mm_struct **mm)
 {
 	struct io_submit_state state, *statep = NULL;
 	struct io_kiocb *link = NULL;
 	struct io_kiocb *shadow_req = NULL;
 	bool prev_was_link = false;
 	int i, submitted = 0;
+	bool mm_fault = false;
 
 	if (nr > IO_PLUG_THRESHOLD) {
 		io_submit_state_start(&state, ctx, nr);
@@ -2745,6 +2746,14 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		if (!io_get_sqring(ctx, &s))
 			break;
 
+		if (io_sqe_needs_user(s.sqe) && !*mm) {
+			mm_fault = mm_fault || !mmget_not_zero(ctx->sqo_mm);
+			if (!mm_fault) {
+				use_mm(ctx->sqo_mm);
+				*mm = ctx->sqo_mm;
+			}
+		}
+
 		/*
 		 * If previous wasn't linked and we have a linked command,
 		 * that's the end of the chain. Submit the previous link.
@@ -2768,17 +2777,12 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		}
 
 out:
-		if (unlikely(mm_fault)) {
-			io_cqring_add_event(ctx, s.sqe->user_data,
-						-EFAULT);
-		} else {
-			s.has_user = has_user;
-			s.in_async = true;
-			s.needs_fixed_file = true;
-			trace_io_uring_submit_sqe(ctx, true, true);
-			io_submit_sqe(ctx, &s, statep, &link);
-			submitted++;
-		}
+		s.has_user = *mm != NULL;
+		s.in_async = true;
+		s.needs_fixed_file = true;
+		trace_io_uring_submit_sqe(ctx, true, true);
+		io_submit_sqe(ctx, &s, statep, &link);
+		submitted++;
 	}
 
 	if (link)
@@ -2805,7 +2809,6 @@ static int io_sq_thread(void *data)
 
 	timeout = inflight = 0;
 	while (!kthread_should_park()) {
-		bool mm_fault = false;
 		unsigned int to_submit;
 
 		if (inflight) {
@@ -2890,18 +2893,8 @@ static int io_sq_thread(void *data)
 			ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
 		}
 
-		/* Unless all new commands are FIXED regions, grab mm */
-		if (!cur_mm) {
-			mm_fault = !mmget_not_zero(ctx->sqo_mm);
-			if (!mm_fault) {
-				use_mm(ctx->sqo_mm);
-				cur_mm = ctx->sqo_mm;
-			}
-		}
-
 		to_submit = min(to_submit, ctx->sq_entries);
-		inflight += io_submit_sqes(ctx, to_submit, cur_mm != NULL,
-					   mm_fault);
+		inflight += io_submit_sqes(ctx, to_submit, &cur_mm);
 
 		/* Commit SQ ring head once we've consumed all SQEs */
 		io_commit_sqring(ctx);

