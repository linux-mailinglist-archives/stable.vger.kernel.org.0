Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFDC1FBA4B
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731505AbgFPPot (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:44:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730574AbgFPPos (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:44:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F89721475;
        Tue, 16 Jun 2020 15:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322287;
        bh=2Em7vKIpKvy+bDt4TkT/4BokSyQ2joH3t0jkwKrZN50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=da2vr+9ejQjZTWvMebsnKeBtv4aYwODm+ZaUEMtuQywC84XkNd5jAHZc4xf7GDJaz
         MCxrxb3v+9IuOS6g7DKaKrOfbD59Upk/1WsTKd0urn9NCpFz3ZD3OgCEBVvAc2YMyq
         3mfKGXt40YowL4dzTnBTMFduKe3QoZ4EVp6Uz4M0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.7 056/163] io_uring: allow O_NONBLOCK async retry
Date:   Tue, 16 Jun 2020 17:33:50 +0200
Message-Id: <20200616153109.528537455@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit c5b856255cbc3b664d686a83fa9397a835e063de upstream.

We can assume that O_NONBLOCK is always honored, even if we don't
have a ->read/write_iter() for the file type. Also unify the read/write
checking for allowing async punt, having the write side factoring in the
REQ_F_NOWAIT flag as well.

Cc: stable@vger.kernel.org
Fixes: 490e89676a52 ("io_uring: only force async punt if poll based retry can't handle it")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2038,6 +2038,10 @@ static bool io_file_supports_async(struc
 	if (S_ISREG(mode) && file->f_op != &io_uring_fops)
 		return true;
 
+	/* any ->read/write should understand O_NONBLOCK */
+	if (file->f_flags & O_NONBLOCK)
+		return true;
+
 	if (!(file->f_mode & FMODE_NOWAIT))
 		return false;
 
@@ -2080,8 +2084,7 @@ static int io_prep_rw(struct io_kiocb *r
 		kiocb->ki_ioprio = get_current_ioprio();
 
 	/* don't allow async punt if RWF_NOWAIT was requested */
-	if ((kiocb->ki_flags & IOCB_NOWAIT) ||
-	    (req->file->f_flags & O_NONBLOCK))
+	if (kiocb->ki_flags & IOCB_NOWAIT)
 		req->flags |= REQ_F_NOWAIT;
 
 	if (force_nonblock)
@@ -2722,7 +2725,8 @@ copy_iov:
 			if (ret)
 				goto out_free;
 			/* any defer here is final, must blocking retry */
-			if (!file_can_poll(req->file))
+			if (!(req->flags & REQ_F_NOWAIT) &&
+			    !file_can_poll(req->file))
 				req->flags |= REQ_F_MUST_PUNT;
 			return -EAGAIN;
 		}


