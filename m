Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0F21FB8C1
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732581AbgFPPyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:54:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732963AbgFPPyQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:54:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95C2821527;
        Tue, 16 Jun 2020 15:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322856;
        bh=v0CSC7d6WhJ2bIpIBAu+WGTgul81sAmDxaMiaZ1+04c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vmju6KLnDmEJx10WHyJar9QMwzw2YwD068apcYi/zy79yDf9CN6MkavvWskHAhsyY
         m4uIKoDIlr+J2Jeox5Ku0mwdmQWS6819Y+vcJpmzQhAtSeeYuIJOCT3pS+8hZOx0wl
         5rkvrZPCKN/vXVeZauEr1iZm91C+3Q44M4otsGn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.6 101/161] io_uring: fix mismatched finish_wait() calls in io_uring_cancel_files()
Date:   Tue, 16 Jun 2020 17:34:51 +0200
Message-Id: <20200616153111.172048635@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>

commit d8f1b9716cfd1a1f74c0fedad40c5f65a25aa208 upstream.

The prepare_to_wait() and finish_wait() calls in io_uring_cancel_files()
are mismatched. Currently I don't see any issues related this bug, just
find it by learning codes.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6488,11 +6488,9 @@ static int io_uring_release(struct inode
 static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				  struct files_struct *files)
 {
-	struct io_kiocb *req;
-	DEFINE_WAIT(wait);
-
 	while (!list_empty_careful(&ctx->inflight_list)) {
-		struct io_kiocb *cancel_req = NULL;
+		struct io_kiocb *cancel_req = NULL, *req;
+		DEFINE_WAIT(wait);
 
 		spin_lock_irq(&ctx->inflight_lock);
 		list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
@@ -6532,6 +6530,7 @@ static void io_uring_cancel_files(struct
 			 */
 			if (refcount_sub_and_test(2, &cancel_req->refs)) {
 				io_put_req(cancel_req);
+				finish_wait(&ctx->inflight_wait, &wait);
 				continue;
 			}
 		}
@@ -6539,8 +6538,8 @@ static void io_uring_cancel_files(struct
 		io_wq_cancel_work(ctx->io_wq, &cancel_req->work);
 		io_put_req(cancel_req);
 		schedule();
+		finish_wait(&ctx->inflight_wait, &wait);
 	}
-	finish_wait(&ctx->inflight_wait, &wait);
 }
 
 static int io_uring_flush(struct file *file, void *data)


