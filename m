Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93378266435
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 18:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgIKQcw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 12:32:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:53402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726411AbgIKPTF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 11:19:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3E3E2245D;
        Fri, 11 Sep 2020 12:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829188;
        bh=RV6uXMAPMOa5KZMYxcVcnmRvi9ObHug+YNzLU1eB/PI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MwFL+i/DY7mteBn340vV9gwEiOG79RAhPLVs6XC/c/rrZDfHQcMrFQm6QaHrXmJIT
         doD7bPd1l2/RM9L5HERvAqlWLGWZGKNx+bwcL45laOUDnTtB2yVLOvoScv4yGo4vDj
         f1K3Rh0HsgvIJ+vk8394DOLvGQ0e0vHub7OtCzO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 02/16] io_uring: fix linked deferred ->files cancellation
Date:   Fri, 11 Sep 2020 14:47:19 +0200
Message-Id: <20200911122459.714236078@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122459.585735377@linuxfoundation.org>
References: <20200911122459.585735377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit c127a2a1b7baa5eb40a7e2de4b7f0c51ccbbb2ef ]

While looking for ->files in ->defer_list, consider that requests there
may actually be links.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5f627194d0920..d05023ca74bdc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7601,6 +7601,28 @@ static bool io_match_link(struct io_kiocb *preq, struct io_kiocb *req)
 	return false;
 }
 
+static inline bool io_match_files(struct io_kiocb *req,
+				       struct files_struct *files)
+{
+	return (req->flags & REQ_F_WORK_INITIALIZED) && req->work.files == files;
+}
+
+static bool io_match_link_files(struct io_kiocb *req,
+				struct files_struct *files)
+{
+	struct io_kiocb *link;
+
+	if (io_match_files(req, files))
+		return true;
+	if (req->flags & REQ_F_LINK_HEAD) {
+		list_for_each_entry(link, &req->link_list, link_list) {
+			if (io_match_files(link, files))
+				return true;
+		}
+	}
+	return false;
+}
+
 /*
  * We're looking to cancel 'req' because it's holding on to our files, but
  * 'req' could be a link to another request. See if it is, and cancel that
@@ -7683,8 +7705,7 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
 
 	spin_lock_irq(&ctx->completion_lock);
 	list_for_each_entry_reverse(req, &ctx->defer_list, list) {
-		if ((req->flags & REQ_F_WORK_INITIALIZED)
-			&& req->work.files == files) {
+		if (io_match_link_files(req, files)) {
 			list_cut_position(&list, &ctx->defer_list, &req->list);
 			break;
 		}
-- 
2.25.1



