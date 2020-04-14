Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7911A7A94
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 14:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440032AbgDNMUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 08:20:40 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:47029 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730014AbgDNMUc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 08:20:32 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 14EA584E;
        Tue, 14 Apr 2020 08:20:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 14 Apr 2020 08:20:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Mk6+5e
        RKjeksBQTKVNNKO2G6fAVH9NDI6692lVUhi78=; b=YVrdL68Yt5RbCjIshtUPHo
        WShBCD7dfyaUxGtKSgt/aJaOAmtiWh2aBVvlBC6JUuZXkfjlLADPOiZHCv4VPSFP
        xBaTmztGmNnAPZsJOdQa5MASRe3zVo8sysJT+33UCOGvMKFUl7m7NOJhwESWct1N
        uSh6VEX2zLXIUcCQ68nuffJa4c3ULXOEmkbq6H+qDzqd60bunnNL1Fap+4+0vHdf
        UH0bWb4cprIZtUUrslHApco4Zt6HM/3sBtdGaInBuSoCjmSU2ohIuUuhyrPjGHVy
        5wV1BfqWRmSI+omUEkZK6DAlUQ198xRyM+a2By3OVTKtudhdbYJi7uGgfWubttfg
        ==
X-ME-Sender: <xms:j6qVXlWF7souScmM30NBbnnxxjGJU5eLcmFrO5cNY1wlo2MHavDhhw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfedugdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:j6qVXsq5EBQlidWIhQCZ2Xn9oKqrj7UfAEwKUukLU7jTjl7SRDtLFg>
    <xmx:j6qVXpG4DA7nzLri5xVF7HHSBSa1HhBsckySUvttKUQwuvb5ecWktg>
    <xmx:j6qVXuuP9xbfmXzrd8N41pU9k-XahqUSWmuwh4Pe8jP2dldIsdXQxw>
    <xmx:j6qVXsfUK1vWk71q9QUI8JNWSByW2S5pfqWSwGtgPpTMXG2QcvvgbA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1DAC8306005B;
        Tue, 14 Apr 2020 08:20:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: honor original task RLIMIT_FSIZE" failed to apply to 5.6-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 14 Apr 2020 14:20:29 +0200
Message-ID: <1586866829230106@kroah.com>
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

From 4ed734b0d0913e566a9d871e15d24eb240f269f7 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Fri, 20 Mar 2020 11:23:41 -0600
Subject: [PATCH] io_uring: honor original task RLIMIT_FSIZE

With the previous fixes for number of files open checking, I added some
debug code to see if we had other spots where we're checking rlimit()
against the async io-wq workers. The only one I found was file size
checking, which we should also honor.

During write and fallocate prep, store the max file size and override
that for the current ask if we're in io-wq worker context.

Cc: stable@vger.kernel.org # 5.1+
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index dfe40bf80adc..05260ed485ad 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -604,7 +604,10 @@ struct io_kiocb {
 	struct list_head	list;
 	unsigned int		flags;
 	refcount_t		refs;
-	struct task_struct	*task;
+	union {
+		struct task_struct	*task;
+		unsigned long		fsize;
+	};
 	u64			user_data;
 	u32			result;
 	u32			sequence;
@@ -2593,6 +2596,8 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (unlikely(!(req->file->f_mode & FMODE_WRITE)))
 		return -EBADF;
 
+	req->fsize = rlimit(RLIMIT_FSIZE);
+
 	/* either don't need iovec imported or already have it */
 	if (!req->io || req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
@@ -2662,10 +2667,17 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 		}
 		kiocb->ki_flags |= IOCB_WRITE;
 
+		if (!force_nonblock)
+			current->signal->rlim[RLIMIT_FSIZE].rlim_cur = req->fsize;
+
 		if (req->file->f_op->write_iter)
 			ret2 = call_write_iter(req->file, kiocb, &iter);
 		else
 			ret2 = loop_rw_iter(WRITE, req->file, kiocb, &iter);
+
+		if (!force_nonblock)
+			current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
+
 		/*
 		 * Raw bdev writes will -EOPNOTSUPP for IOCB_NOWAIT. Just
 		 * retry them without IOCB_NOWAIT.
@@ -2848,8 +2860,10 @@ static void __io_fallocate(struct io_kiocb *req)
 {
 	int ret;
 
+	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = req->fsize;
 	ret = vfs_fallocate(req->file, req->sync.mode, req->sync.off,
 				req->sync.len);
+	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
@@ -2875,6 +2889,7 @@ static int io_fallocate_prep(struct io_kiocb *req,
 	req->sync.off = READ_ONCE(sqe->off);
 	req->sync.len = READ_ONCE(sqe->addr);
 	req->sync.mode = READ_ONCE(sqe->len);
+	req->fsize = rlimit(RLIMIT_FSIZE);
 	return 0;
 }
 

