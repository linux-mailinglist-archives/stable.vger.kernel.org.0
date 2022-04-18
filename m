Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD2D505078
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238506AbiDRMZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238648AbiDRMZd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:25:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331211BEAE;
        Mon, 18 Apr 2022 05:19:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AB33B80ED7;
        Mon, 18 Apr 2022 12:19:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE22C385A1;
        Mon, 18 Apr 2022 12:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284372;
        bh=g2PbFRUOzkUxKx6MznAE/X04pbbqErwiMTNr3lEww8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iqhcTPISYhdXpZ+zr4lulM3F8crHY6k7vqpAfWX10lzDotEptQqRMNF7i+UhJVZAx
         qzonOnk5etVdDmT432Eupd7ttz5+m694NjEnIqnHPZV3hx0d6gD4mx3bD+srywPG1Q
         WpPkBQXDB4ILpiWfcetIigSLyPeAql3t1e89Ne3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 093/219] io_uring: stop using io_wq_work as an fd placeholder
Date:   Mon, 18 Apr 2022 14:11:02 +0200
Message-Id: <20220418121209.280248121@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 82733d168cbd3fe9dab603f05894316b99008924 ]

There are two reasons why this isn't the best idea:

- It's an odd area to grab a bit of storage space, hence it's an odd area
  to grab storage from.
- It puts the 3rd io_kiocb cacheline into the hot path, where normal hot
  path just needs the first two.

Use 'cflags' for joint fd/cflags storage. We only need fd until we
successfully issue, and we only need cflags once a request is done and is
completed.

Fixes: 6bf9c47a3989 ("io_uring: defer file assignment")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io-wq.h    |  1 -
 fs/io_uring.c | 12 ++++++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/io-wq.h b/fs/io-wq.h
index 04d374e65e54..dbecd27656c7 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -155,7 +155,6 @@ struct io_wq_work_node *wq_stack_extract(struct io_wq_work_node *stack)
 struct io_wq_work {
 	struct io_wq_work_node list;
 	unsigned flags;
-	int fd;
 };
 
 static inline struct io_wq_work *wq_next_work(struct io_wq_work *work)
diff --git a/fs/io_uring.c b/fs/io_uring.c
index d13f142793f2..d05394b0c1e6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -864,7 +864,11 @@ struct io_kiocb {
 
 	u64				user_data;
 	u32				result;
-	u32				cflags;
+	/* fd initially, then cflags for completion */
+	union {
+		u32			cflags;
+		int			fd;
+	};
 
 	struct io_ring_ctx		*ctx;
 	struct task_struct		*task;
@@ -6708,9 +6712,9 @@ static bool io_assign_file(struct io_kiocb *req, unsigned int issue_flags)
 		return true;
 
 	if (req->flags & REQ_F_FIXED_FILE)
-		req->file = io_file_get_fixed(req, req->work.fd, issue_flags);
+		req->file = io_file_get_fixed(req, req->fd, issue_flags);
 	else
-		req->file = io_file_get_normal(req, req->work.fd);
+		req->file = io_file_get_normal(req, req->fd);
 	if (req->file)
 		return true;
 
@@ -7243,7 +7247,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	if (io_op_defs[opcode].needs_file) {
 		struct io_submit_state *state = &ctx->submit_state;
 
-		req->work.fd = READ_ONCE(sqe->fd);
+		req->fd = READ_ONCE(sqe->fd);
 
 		/*
 		 * Plug now if we have more than 2 IO left after this, and the
-- 
2.35.1



