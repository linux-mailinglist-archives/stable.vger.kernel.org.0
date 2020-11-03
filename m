Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93312A5846
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729518AbgKCVuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:50:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:41674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731435AbgKCUtH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:49:07 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D8D522404;
        Tue,  3 Nov 2020 20:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436546;
        bh=HxP24GZ8BhdPLAtEVsQZBRTDboxnusE+HL1PwTy/hrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j4G5quIuXqEBZVaBHej586lnVa5eITOr5s/6CpndV/qsgQj3VdStjgX7dokmY6Ufv
         cxst9+BgiJ4HNPmISIKujuBpXidxhJGXVl8mwfnSCZJqqHcGAGV2gat4wFXco2+xxS
         4amYA1N8GIyeh4CuIYBMfjkHJ3aEXE1IJeXMN/Hw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.9 296/391] io_uring: use type appropriate io_kiocb handler for double poll
Date:   Tue,  3 Nov 2020 21:35:47 +0100
Message-Id: <20201103203407.049715487@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit c8b5e2600a2cfa1cdfbecf151afd67aee227381d upstream.

io_poll_double_wake() is called for both request types - both pure poll
requests, and internal polls. This means that we should be using the
right handler based on the request type. Use the one that the original
caller already assigned for the waitqueue handling, that will always
match the correct type.

Cc: stable@vger.kernel.org # v5.8+
Reported-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4786,8 +4786,10 @@ static int io_poll_double_wake(struct wa
 		/* make sure double remove sees this as being gone */
 		wait->private = NULL;
 		spin_unlock(&poll->head->lock);
-		if (!done)
-			__io_async_wake(req, poll, mask, io_poll_task_func);
+		if (!done) {
+			/* use wait func handler, so it matches the rq type */
+			poll->wait.func(&poll->wait, mode, sync, key);
+		}
 	}
 	refcount_dec(&req->refs);
 	return 1;


