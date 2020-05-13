Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E976E1D0DCF
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387572AbgEMJ4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:56:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:59480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388343AbgEMJ4B (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:56:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7772205ED;
        Wed, 13 May 2020 09:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363761;
        bh=BK2IuMds37I6KVyFy/t0DPC7b/EYKzwfvjKXqUM5nl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EPVvuc8no/cosr4eY6XkQ3QOXPa2i+m4lhkmZVNBUfMxcnabwMss2ShKADLqqVzQD
         yoaYuAEUCcFgtYQni3MENzuZiGGygQswlJtG6dhhd340IbGIZdMDguOwrcfrmwX6ww
         hYOVXzedPI+c92VSdxmE0Xq3gAX7GOXKs6f2Be88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Kellermann <mk@cm4all.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.6 116/118] io_uring: dont use fd for openat/openat2/statx
Date:   Wed, 13 May 2020 11:45:35 +0200
Message-Id: <20200513094428.036106422@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Kellermann <mk@cm4all.com>

Based on commit 63ff822358b276137059520cf16e587e8073e80f upstream.

If an operation's flag `needs_file` is set, the function
io_req_set_file() calls io_file_get() to obtain a `struct file*`.

This fails for `O_PATH` file descriptors, because io_file_get() calls
fget(), which rejects `O_PATH` file descriptors.  To support `O_PATH`,
fdget_raw() must be used (like path_init() in `fs/namei.c` does).
This rejection causes io_req_set_file() to throw `-EBADF`.  This
breaks the operations `openat`, `openat2` and `statx`, where `O_PATH`
file descriptors are commonly used.

This could be solved by adding support for `O_PATH` file descriptors
with another `io_op_def` flag, but since those three operations don't
need the `struct file*` but operate directly on the numeric file
descriptors, the best solution here is to simply remove `needs_file`
(and the accompanying flag `fd_non_reg`).

Cc: stable@vger.kernel.org
Signed-off-by: Max Kellermann <mk@cm4all.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -696,8 +696,6 @@ static const struct io_op_def io_op_defs
 		.needs_file		= 1,
 	},
 	[IORING_OP_OPENAT] = {
-		.needs_file		= 1,
-		.fd_non_neg		= 1,
 		.file_table		= 1,
 		.needs_fs		= 1,
 	},
@@ -711,8 +709,6 @@ static const struct io_op_def io_op_defs
 	},
 	[IORING_OP_STATX] = {
 		.needs_mm		= 1,
-		.needs_file		= 1,
-		.fd_non_neg		= 1,
 		.needs_fs		= 1,
 		.file_table		= 1,
 	},
@@ -743,8 +739,6 @@ static const struct io_op_def io_op_defs
 		.unbound_nonreg_file	= 1,
 	},
 	[IORING_OP_OPENAT2] = {
-		.needs_file		= 1,
-		.fd_non_neg		= 1,
 		.file_table		= 1,
 		.needs_fs		= 1,
 	},


