Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5784A40DF0E
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234814AbhIPQG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:06:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240632AbhIPQGF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:06:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F79361246;
        Thu, 16 Sep 2021 16:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808284;
        bh=j8CxYzr7s71NGwomFaDqLXZwsfJSNRfc09qozhTjnj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aWhUoeh6Htf8+EcXSmwgXWZl1WcYmqNJ8SXJ8YEEvplGEBvZ5n20IaX+0yjs9CiPY
         bkTdIJtYmRxzghUDqZ83sYI3WLAWhu7bXcVNOuQBIjngrE5M1W1Q1ZU2hM4CQh/YSw
         So6MnVfvTcHmXq1UoFLEZaSTEJ7yowxfAfCbztu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 003/306] io_uring: place fixed tables under memcg limits
Date:   Thu, 16 Sep 2021 17:55:48 +0200
Message-Id: <20210916155754.022754998@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 0bea96f59ba40e63c0ae93ad6a02417b95f22f4d upstream.

Fixed tables may be large enough, place all of them together with
allocated tags under memcg limits.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/b3ac9f5da9821bb59837b5fe25e8ef4be982218c.1629451684.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7383,7 +7383,7 @@ static int io_sqe_alloc_file_tables(stru
 
 		this_files = min(nr_files, IORING_MAX_FILES_TABLE);
 		table->files = kcalloc(this_files, sizeof(struct file *),
-					GFP_KERNEL);
+					GFP_KERNEL_ACCOUNT);
 		if (!table->files)
 			break;
 		nr_files -= this_files;
@@ -7582,7 +7582,7 @@ static int io_sqe_files_register(struct
 	if (nr_args > rlimit(RLIMIT_NOFILE))
 		return -EMFILE;
 
-	file_data = kzalloc(sizeof(*ctx->file_data), GFP_KERNEL);
+	file_data = kzalloc(sizeof(*ctx->file_data), GFP_KERNEL_ACCOUNT);
 	if (!file_data)
 		return -ENOMEM;
 	file_data->ctx = ctx;
@@ -7592,7 +7592,7 @@ static int io_sqe_files_register(struct
 
 	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_FILES_TABLE);
 	file_data->table = kcalloc(nr_tables, sizeof(*file_data->table),
-				   GFP_KERNEL);
+				   GFP_KERNEL_ACCOUNT);
 	if (!file_data->table)
 		goto out_free;
 


