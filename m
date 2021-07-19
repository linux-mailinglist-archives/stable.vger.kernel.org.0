Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 782693CE3FA
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239017AbhGSPl2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:41:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348518AbhGSPf0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A88061623;
        Mon, 19 Jul 2021 16:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711235;
        bh=IQS6fQ51be3SuZkBUN3CfUH9k9n+uJAVVOalJIXtre4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0/nDnFY/7VucC2oyEKqOgjZx4cq80K/OoW1bcBTlWgNXwQ56jnMpMhLF9C/svBzvH
         tMKVjhAkwDaVW5liWMuO2jORYA2iGNOSUAsvOAmECZ2QRa1BLmhVnSikC0ANGY4UeY
         LHMThbeq4Us/FJYB3gFjS8gbKdGW+tSJYZ51aOjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 244/351] io_uring: shuffle rarely used ctx fields
Date:   Mon, 19 Jul 2021 16:53:10 +0200
Message-Id: <20210719144953.013134777@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit b986af7e2df4f0871367c397ba61a542f37c0ab3 ]

There is a bunch of scattered around ctx fields that are almost never
used, e.g. only on ring exit, plunge them to the end, better locality,
better aesthetically.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/782ff94b00355923eae757d58b1a47821b5b46d4.1621201931.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2bf2aacb4c81..5d685c92b8fd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -369,9 +369,6 @@ struct io_ring_ctx {
 		unsigned		cached_cq_overflow;
 		unsigned long		sq_check_overflow;
 
-		/* hashed buffered write serialization */
-		struct io_wq_hash	*hash_map;
-
 		struct list_head	defer_list;
 		struct list_head	timeout_list;
 		struct list_head	cq_overflow_list;
@@ -388,9 +385,6 @@ struct io_ring_ctx {
 
 	struct io_rings	*rings;
 
-	/* Only used for accounting purposes */
-	struct mm_struct	*mm_account;
-
 	const struct cred	*sq_creds;	/* cred used for __io_sq_thread() */
 	struct io_sq_data	*sq_data;	/* if using sq thread polling */
 
@@ -411,14 +405,6 @@ struct io_ring_ctx {
 	unsigned		nr_user_bufs;
 	struct io_mapped_ubuf	**user_bufs;
 
-	struct user_struct	*user;
-
-	struct completion	ref_comp;
-
-#if defined(CONFIG_UNIX)
-	struct socket		*ring_sock;
-#endif
-
 	struct xarray		io_buffers;
 
 	struct xarray		personalities;
@@ -462,12 +448,24 @@ struct io_ring_ctx {
 
 	struct io_restriction		restrictions;
 
-	/* exit task_work */
-	struct callback_head		*exit_task_work;
-
 	/* Keep this last, we don't need it for the fast path */
-	struct work_struct		exit_work;
-	struct list_head		tctx_list;
+	struct {
+		#if defined(CONFIG_UNIX)
+			struct socket		*ring_sock;
+		#endif
+		/* hashed buffered write serialization */
+		struct io_wq_hash		*hash_map;
+
+		/* Only used for accounting purposes */
+		struct user_struct		*user;
+		struct mm_struct		*mm_account;
+
+		/* ctx exit and cancelation */
+		struct callback_head		*exit_task_work;
+		struct work_struct		exit_work;
+		struct list_head		tctx_list;
+		struct completion		ref_comp;
+	};
 };
 
 struct io_uring_task {
-- 
2.30.2



