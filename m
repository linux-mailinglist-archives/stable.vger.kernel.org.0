Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD6381F9970
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 15:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729930AbgFON7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 09:59:15 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:54227 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728773AbgFON7P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 09:59:15 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 2FE746EA;
        Mon, 15 Jun 2020 09:59:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 09:59:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=7RwG+s
        NPU2SZH/sjZnnvfkRHLoqIee3Ap52gwU1oaYM=; b=JGwzY8NEjwh4KpgmeGdyNE
        tNPHABQf/rmC+hHo+65xfBzyaENsE4l0gCVNWBzJHJjsoTeVfiYxu9824SVSUPph
        gcBGXjYtM09k2qRnZLre2I5tDXZhqmWtnthUNt/BDkvlTEz4cQkValuZIoA65Wdy
        OIhOs4zHJ1IBFttbYx3BGIHxtjuJUEPloHhq4C60nUQ6le3bvEMLF7+qff/bB3Vo
        2ijMp5XK9KnCbpC9aWsKknrTT8yUBAyjG61JaDduSTKJtpvn9R1BSAcgTQIgqnB/
        GRHkX9XrJynIhIoghVg7YQvnnbKDUI9KIXHde4hCuEQXhzD5s9GG4HBC4MEbwzFA
        ==
X-ME-Sender: <xms:sX7nXnKDP1VuU-BXPM0gLYtGcxcgLiGwz0M-GhjhCghosBwaV86oQQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgjeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:sX7nXrJ_Ma1wKh7i3ELR_bwz-ynj4jzoKHuNqCOiEmcqMHe0_Dv3oA>
    <xmx:sX7nXvuiRUIqBiS0vV-LtL8-oedOKT1RqWFLXR1k0NVdcKWFgPPuQQ>
    <xmx:sX7nXgZTW_blsGGiaCWavYm1cNrIu1DP2pG8IkurFxvCn6LRRdSZVw>
    <xmx:sX7nXs02L4RAWNSPy1qLK1XJLG5Ppz9Fycy5e9Q-yrrKSfiMfibbbA5Qj2s>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 30C6130618BF;
        Mon, 15 Jun 2020 09:59:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: fix flush req->refs underflow" failed to apply to 5.6-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 15:59:00 +0200
Message-ID: <159222954019964@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.6-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4518a3cc273cf82efdd36522fb1f13baad173c70 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Tue, 26 May 2020 20:34:02 +0300
Subject: [PATCH] io_uring: fix flush req->refs underflow

In io_uring_cancel_files(), after refcount_sub_and_test() leaves 0
req->refs, it calls io_put_req(), which would also put a ref. Call
io_free_req() instead.

Cc: stable@vger.kernel.org
Fixes: 2ca10259b418 ("io_uring: prune request from overflow list on flush")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0b51f21e5432..37422fcdaa7f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7534,7 +7534,7 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 			 * all we had, then we're done with this request.
 			 */
 			if (refcount_sub_and_test(2, &cancel_req->refs)) {
-				io_put_req(cancel_req);
+				io_free_req(cancel_req);
 				finish_wait(&ctx->inflight_wait, &wait);
 				continue;
 			}

