Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5342F7A57
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732310AbhAOMsQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:48:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:43778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733206AbhAOMhJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:37:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CC5E2371F;
        Fri, 15 Jan 2021 12:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714213;
        bh=kn5Y36LNobJVd+5rvXTXg17CVp0cRtgzyf02HnFrEPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k2+OQ/RO64RuM3Ea4CwoDfSXlosJjc+HJYoD7aePQjVxE5eGDxKr+oZWKDby3l6rf
         yHFiWhy2arNkOAeXWJveOCovflPLYnyqoXP0KYL3zlKhv1h4Vtzopleyd+Zd9ePNwj
         E4Ows3/EjkJamPbv9+Q7irMmGs6JqLlswDOvdB5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 008/103] io_uring: Fix return value from alloc_fixed_file_ref_node
Date:   Fri, 15 Jan 2021 13:27:01 +0100
Message-Id: <20210115122006.449565513@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 3e2224c5867fead6c0b94b84727cc676ac6353a3 ]

alloc_fixed_file_ref_node() currently returns an ERR_PTR on failure.
io_sqe_files_unregister() expects it to return NULL and since it can only
return -ENOMEM, it makes more sense to change alloc_fixed_file_ref_node()
to behave that way.

Fixes: 1ffc54220c44 ("io_uring: fix io_sqe_files_unregister() hangs")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 492492a010a2f..4833b68f1a1cc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7461,12 +7461,12 @@ static struct fixed_file_ref_node *alloc_fixed_file_ref_node(
 
 	ref_node = kzalloc(sizeof(*ref_node), GFP_KERNEL);
 	if (!ref_node)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	if (percpu_ref_init(&ref_node->refs, io_file_data_ref_zero,
 			    0, GFP_KERNEL)) {
 		kfree(ref_node);
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 	}
 	INIT_LIST_HEAD(&ref_node->node);
 	INIT_LIST_HEAD(&ref_node->file_list);
@@ -7560,9 +7560,9 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	}
 
 	ref_node = alloc_fixed_file_ref_node(ctx);
-	if (IS_ERR(ref_node)) {
+	if (!ref_node) {
 		io_sqe_files_unregister(ctx);
-		return PTR_ERR(ref_node);
+		return -ENOMEM;
 	}
 
 	io_sqe_files_set_node(file_data, ref_node);
@@ -7662,8 +7662,8 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		return -EINVAL;
 
 	ref_node = alloc_fixed_file_ref_node(ctx);
-	if (IS_ERR(ref_node))
-		return PTR_ERR(ref_node);
+	if (!ref_node)
+		return -ENOMEM;
 
 	done = 0;
 	fds = u64_to_user_ptr(up->fds);
-- 
2.27.0



