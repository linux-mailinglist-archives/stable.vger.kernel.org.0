Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15995203E55
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 19:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730046AbgFVRtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 13:49:16 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:49495 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729886AbgFVRtQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 13:49:16 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id BB323300;
        Mon, 22 Jun 2020 13:49:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 22 Jun 2020 13:49:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=o6Ico9
        F2rhW2izwHdO9695b/wdtofhNBnZuWka4DnZ8=; b=dSa+gTObDIlTl7wMfDAy66
        38QvcwnDcpa7aE34ESpA8HIHOAMIu0cboplHtkL0l5cJx5rWXQbngnztIeRN4Hb+
        0msDKIXztL6AM3TNro8Rpl5gGbkycyxiHry++8NX47U24/Z9oeJLuO3SzJPAdDnX
        4XXXl6H75iRYA3opkjYGmINAAliO5SLA/miGy0QHeXvm3+A3GTtaIYGy0fPnFwWK
        6F05jtCWaeKkdpIElQGDkgaUhe3fYojNp+Xp/B7v7nscjBVwCXksk4+aJFQCXo7D
        nD3Qa0KHhdDVUTXWuaSejaM/Jw2lu1WBsiZT3N0GChkYrQH6nEp28++7IvFmNd7A
        ==
X-ME-Sender: <xms:G-_wXqiCTWkxb6APHuMoj8pZ2u9DSgKfuUnY-VDOOkQNgzzSgc2bOA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekvddguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhs
    thgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:G-_wXrCtOeRlPc_3AtMu5oAr0KUr0PqYKqMjZaL1jvHapcYaSWzU8g>
    <xmx:G-_wXiFsO7RWYcSWGij1tQ8ezjRNnh4s11YAuWgXxv9K6a0g33QUoA>
    <xmx:G-_wXjQcwrGqPlYkwCTVyDwplSObB4f2N8BQiifGqN_MD5TBZSOf5Q>
    <xmx:G-_wXm-avH03WvaesDVRC0OT4h9q87DSvDbvq1DEJakObM1gVGa23kCg_tk>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 054E33280065;
        Mon, 22 Jun 2020 13:49:14 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: reap poll completions while waiting for refs to" failed to apply to 5.7-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Jun 2020 19:49:10 +0200
Message-ID: <1592848150115103@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.7-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 56952e91acc93ed624fe9da840900defb75f1323 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Wed, 17 Jun 2020 15:00:04 -0600
Subject: [PATCH] io_uring: reap poll completions while waiting for refs to
 drop on exit

If we're doing polled IO and end up having requests being submitted
async, then completions can come in while we're waiting for refs to
drop. We need to reap these manually, as nobody else will be looking
for them.

Break the wait into 1/20th of a second time waits, and check for done
poll completions if we time out. Otherwise we can have done poll
completions sitting in ctx->poll_list, which needs us to reap them but
we're just waiting for them.

Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 98c83fbf4f88..2038d52c5450 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7363,7 +7363,17 @@ static void io_ring_exit_work(struct work_struct *work)
 	if (ctx->rings)
 		io_cqring_overflow_flush(ctx, true);
 
-	wait_for_completion(&ctx->ref_comp);
+	/*
+	 * If we're doing polled IO and end up having requests being
+	 * submitted async (out-of-line), then completions can come in while
+	 * we're waiting for refs to drop. We need to reap these manually,
+	 * as nobody else will be looking for them.
+	 */
+	while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20)) {
+		io_iopoll_reap_events(ctx);
+		if (ctx->rings)
+			io_cqring_overflow_flush(ctx, true);
+	}
 	io_ring_ctx_free(ctx);
 }
 

