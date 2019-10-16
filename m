Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B93CD9658
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 18:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732792AbfJPQFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 12:05:46 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34039 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727714AbfJPQFq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 12:05:46 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 0C3E2216A6;
        Wed, 16 Oct 2019 12:05:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 16 Oct 2019 12:05:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=y4BmKm
        ibAfoDsxVov49pH1tmgnfbswKUxmVE4XD+1fs=; b=lQ6uXbaZEJ8BH3GiQOfz/M
        qLJ1XVqFogNfI433R3RwTACa2dMi3goSBoazj9WJDUx6f2oBm/URPg4okaOeTPbU
        NIMVy3vsLHYLt9PDEp126esrGuxKQuaU06fykyXy1uQHqi+2f+/4Xt1XjluwvOWP
        fvK9hBV0G6G24e4y6KEDQDDNpu1Ty3f672/oAc/qEe3BwAKX0WZ3rJpMjCHhJMqJ
        VoFXxgGfzPl6b33n2+th77y+5lxRfdsW2htsDauFhA36CoI7e2rybehzSOCVKtT1
        UkCZRI8d/x36M2UoYIqSGSjNBRXV/qr15DVkI8VyrzZpGxk+nxPA3VxkFITV83ag
        ==
X-ME-Sender: <xms:2D-nXfWh6B31rjuqPZezXr2ixmBTfkZDFEZcSmfxmWh4YpB_Ytx6_g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjeehgdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepudejvddruddtgedrvdegkedrgeegnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:2D-nXb0IkCJCa6EUgjqHthNjFniylPOv32iUhf2V59MDB0g_gYogoA>
    <xmx:2D-nXWZzFNWcPCvrfWAQoTAvFLo3WjBtddq6By2x5iQULFirqtuNpw>
    <xmx:2D-nXerPaf4d-kRoMDX0sH07Xs6kUodLV9lrYdtMVWcobLaDYEpxtA>
    <xmx:2T-nXQrEswntUl6b3LqzTIHqjtHQGwcRfGOeCarVC5ICJa_yBWvTCw>
Received: from localhost (li1825-44.members.linode.com [172.104.248.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9419D80065;
        Wed, 16 Oct 2019 12:05:43 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: only flush workqueues on fileset removal" failed to apply to 5.3-stable tree
To:     axboe@kernel.dk, stefanha@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 16 Oct 2019 09:04:43 -0700
Message-ID: <1571241883130167@kroah.com>
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

From 8a99734081775c012a4a6c442fdef0379fe52bdf Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Wed, 9 Oct 2019 14:40:13 -0600
Subject: [PATCH] io_uring: only flush workqueues on fileset removal

We should not remove the workqueue, we just need to ensure that the
workqueues are synced. The workqueues are torn down on ctx removal.

Cc: stable@vger.kernel.org
Fixes: 6b06314c47e1 ("io_uring: add file set registration")
Reported-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ceb3497bdd2a..2c44648217bd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2866,8 +2866,12 @@ static void io_finish_async(struct io_ring_ctx *ctx)
 static void io_destruct_skb(struct sk_buff *skb)
 {
 	struct io_ring_ctx *ctx = skb->sk->sk_user_data;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ctx->sqo_wq); i++)
+		if (ctx->sqo_wq[i])
+			flush_workqueue(ctx->sqo_wq[i]);
 
-	io_finish_async(ctx);
 	unix_destruct_scm(skb);
 }
 

