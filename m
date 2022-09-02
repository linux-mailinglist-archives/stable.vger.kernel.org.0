Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC8D05AAFB2
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237338AbiIBMms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237190AbiIBMmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:42:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5284E8699;
        Fri,  2 Sep 2022 05:31:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AD4DB82AA5;
        Fri,  2 Sep 2022 12:31:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4636C433D6;
        Fri,  2 Sep 2022 12:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121873;
        bh=xB2tD8kJvb9U7sUO+SOThbWwhK+u9scHeLrOqkYhLnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sbYgTTdLmSJR1SFzznHiLtv+RXV5lVdQ9rQcqNLOBIUxSd9mZk3kUj7T/nyjh+wZb
         7k5G9tQxT6Bj1op2pzO+2XFc6EMDti9/OPqXpu3aNaS6BIwli9GEn4F33/HdmV6z/P
         BRIUEEoWMcY8kThbZzYdTMwJ2LNbwW3n3N7vdgfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 15/73] io_uring: kill poll linking optimisation
Date:   Fri,  2 Sep 2022 14:18:39 +0200
Message-Id: <20220902121404.944851730@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ upstream commmit ab1dab960b8352cee082db0f8a54dc92a948bfd7 ]

With IORING_FEAT_FAST_POLL in place, io_put_req_find_next() for poll
requests doesn't make much sense, and in any case re-adding it
shouldn't be a problem considering batching in tctx_task_work(). We can
remove it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/15699682bf81610ec901d4e79d6da64baa9f70be.1639605189.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[pavel: backport]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5460,7 +5460,6 @@ static inline bool io_poll_complete(stru
 static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_kiocb *nxt;
 
 	if (io_poll_rewait(req, &req->poll)) {
 		spin_unlock(&ctx->completion_lock);
@@ -5484,11 +5483,8 @@ static void io_poll_task_func(struct io_
 		spin_unlock(&ctx->completion_lock);
 		io_cqring_ev_posted(ctx);
 
-		if (done) {
-			nxt = io_put_req_find_next(req);
-			if (nxt)
-				io_req_task_submit(nxt, locked);
-		}
+		if (done)
+			io_put_req(req);
 	}
 }
 


