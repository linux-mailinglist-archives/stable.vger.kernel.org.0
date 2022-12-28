Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 972E3658491
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235127AbiL1Q62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235373AbiL1Q5p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:57:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196DA1D31B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:54:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C70A5B8171E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B42C433EF;
        Wed, 28 Dec 2022 16:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246441;
        bh=slyJE37SDOyRA6H47M3Y5FSvn7P7FZsg5FEcxjsOgR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uawths0RU+jNdc6l55QIPClMXw+2AcDeGKVBuQg7glFZGi+8Cvz4wYvxKdqLpzfv3
         IB/H07PxPlsgyNcWGLDO8Zul1wAqOTFKEslmyYzsuil6aAnhgX1TYJUbFR67waPTxI
         FHhAoWFVp9X/oTBhcQjuHI7mVmuBsU9A6p6OOMqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 1063/1073] io_uring: remove iopoll spinlock
Date:   Wed, 28 Dec 2022 15:44:11 +0100
Message-Id: <20221228144357.108737456@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 2dac1a159216b39ced8d78dba590c5d2f4249586 upstream.

This reverts commit 2ccc92f4effcfa1c51c4fcf1e34d769099d3cad4

io_req_complete_post() should now behave well even in case of IOPOLL, we
can remove completion_lock locking.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/7e171c8b530656b14a671c59100ca260e46e7f2a.1669203009.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rw.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1063,7 +1063,6 @@ int io_do_iopoll(struct io_ring_ctx *ctx
 	else if (!pos)
 		return 0;
 
-	spin_lock(&ctx->completion_lock);
 	prev = start;
 	wq_list_for_each_resume(pos, prev) {
 		struct io_kiocb *req = container_of(pos, struct io_kiocb, comp_list);
@@ -1078,11 +1077,11 @@ int io_do_iopoll(struct io_ring_ctx *ctx
 		req->cqe.flags = io_put_kbuf(req, 0);
 		__io_fill_cqe_req(req->ctx, req);
 	}
-	io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
+
 	if (unlikely(!nr_events))
 		return 0;
 
+	io_commit_cqring(ctx);
 	io_cqring_ev_posted_iopoll(ctx);
 	pos = start ? start->next : ctx->iopoll_list.first;
 	wq_list_cut(&ctx->iopoll_list, prev, start);


