Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B387A1C9A22
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 20:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbgEGS5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 14:57:47 -0400
Received: from nibbler.cm4all.net ([82.165.145.151]:58142 "EHLO
        nibbler.cm4all.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728371AbgEGS5r (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 14:57:47 -0400
Received: from localhost (localhost [127.0.0.1])
        by nibbler.cm4all.net (Postfix) with ESMTP id 2D054C023F
        for <stable@vger.kernel.org>; Thu,  7 May 2020 20:57:42 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at nibbler.cm4all.net
Received: from nibbler.cm4all.net ([127.0.0.1])
        by localhost (nibbler.cm4all.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id wLP7bDcBTtuK for <stable@vger.kernel.org>;
        Thu,  7 May 2020 20:57:42 +0200 (CEST)
Received: from zero.intern.cm-ag (zero.intern.cm-ag [172.30.16.10])
        by nibbler.cm4all.net (Postfix) with SMTP id 0B01FC0215
        for <stable@vger.kernel.org>; Thu,  7 May 2020 20:57:42 +0200 (CEST)
Received: (qmail 2040 invoked from network); 7 May 2020 22:13:59 +0200
Received: from unknown (HELO rabbit.intern.cm-ag) (172.30.3.1)
  by zero.intern.cm-ag with SMTP; 7 May 2020 22:13:59 +0200
Received: by rabbit.intern.cm-ag (Postfix, from userid 1023)
        id D022A461450; Thu,  7 May 2020 20:57:41 +0200 (CEST)
From:   Max Kellermann <mk@cm4all.com>
To:     axboe@kernel.dk, linux-fsdevel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Max Kellermann <mk@cm4all.com>,
        stable@vger.kernel.org
Subject: [PATCH] fs/io_uring: fix O_PATH fds in openat, openat2, statx
Date:   Thu,  7 May 2020 20:57:25 +0200
Message-Id: <20200507185725.15840-1-mk@cm4all.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If an operation's flag `needs_file` is set, the function
io_req_set_file() calls io_file_get() to obtain a `struct file*`.

This fails for `O_PATH` file descriptors, because those have no
`struct file*`, causing io_req_set_file() to throw `-EBADF`.  This
breaks the operations `openat`, `openat2` and `statx`, where `O_PATH`
file descriptors are commonly used.

The solution is to simply remove `needs_file` (and the accompanying
flag `fd_non_reg`).  This flag was never needed because those
operations use numeric file descriptor and don't use the `struct
file*` obtained by io_req_set_file().

Signed-off-by: Max Kellermann <mk@cm4all.com>
Cc: stable@vger.kernel.org
---
 fs/io_uring.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a46de2cfc28e..d24f8e33323c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -693,8 +693,6 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 	},
 	[IORING_OP_OPENAT] = {
-		.needs_file		= 1,
-		.fd_non_neg		= 1,
 		.file_table		= 1,
 		.needs_fs		= 1,
 	},
@@ -708,8 +706,6 @@ static const struct io_op_def io_op_defs[] = {
 	},
 	[IORING_OP_STATX] = {
 		.needs_mm		= 1,
-		.needs_file		= 1,
-		.fd_non_neg		= 1,
 		.needs_fs		= 1,
 	},
 	[IORING_OP_READ] = {
@@ -739,8 +735,6 @@ static const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 	},
 	[IORING_OP_OPENAT2] = {
-		.needs_file		= 1,
-		.fd_non_neg		= 1,
 		.file_table		= 1,
 		.needs_fs		= 1,
 	},
-- 
2.20.1

