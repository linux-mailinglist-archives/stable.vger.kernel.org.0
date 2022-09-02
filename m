Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B28E5AB21F
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 15:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238102AbiIBNwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 09:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238108AbiIBNvd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 09:51:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B6110F96F;
        Fri,  2 Sep 2022 06:26:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28C5AB82A96;
        Fri,  2 Sep 2022 12:31:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C981C433D6;
        Fri,  2 Sep 2022 12:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121867;
        bh=oBwYNBQG2bD4bY5vsoYIcoQiEwSXUi5hobMsxKpEJ7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fDVl8yEiKy3nK84/M1iqe9kN/DrSSCuK/bLJ3p8rBUfoHVm4YdJoUAiuGmls+yqvE
         R7hL3F5lQ7icQ72bkBoywGVXXyiaO7qCo2X0oo6gluSp4R9TrMbR0grcvS0UQMDQHh
         7PaK2gPEL6Z1offDxePHTQIpvPW1LUnYb5HWigFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 13/73] io_uring: refactor poll update
Date:   Fri,  2 Sep 2022 14:18:37 +0200
Message-Id: <20220902121404.867208559@linuxfoundation.org>
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

[ upstream commmit 2bbb146d96f4b45e17d6aeede300796bc1a96d68 ]

Clean up io_poll_update() and unify cancellation paths for remove and
update.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/5937138b6265a1285220e2fab1b28132c1d73ce3.1639605189.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[pavel: backport]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   62 ++++++++++++++++++++++++----------------------------------
 1 file changed, 26 insertions(+), 36 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5931,61 +5931,51 @@ static int io_poll_update(struct io_kioc
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *preq;
 	bool completing;
-	int ret;
+	int ret2, ret = 0;
 
 	spin_lock(&ctx->completion_lock);
 	preq = io_poll_find(ctx, req->poll_update.old_user_data, true);
 	if (!preq) {
 		ret = -ENOENT;
-		goto err;
-	}
-
-	if (!req->poll_update.update_events && !req->poll_update.update_user_data) {
-		completing = true;
-		ret = io_poll_remove_one(preq) ? 0 : -EALREADY;
-		goto err;
+fail:
+		spin_unlock(&ctx->completion_lock);
+		goto out;
 	}
-
+	io_poll_remove_double(preq);
 	/*
 	 * Don't allow racy completion with singleshot, as we cannot safely
 	 * update those. For multishot, if we're racing with completion, just
 	 * let completion re-add it.
 	 */
-	io_poll_remove_double(preq);
 	completing = !__io_poll_remove_one(preq, &preq->poll, false);
 	if (completing && (preq->poll.events & EPOLLONESHOT)) {
 		ret = -EALREADY;
-		goto err;
-	}
-	/* we now have a detached poll request. reissue. */
-	ret = 0;
-err:
-	if (ret < 0) {
-		spin_unlock(&ctx->completion_lock);
-		req_set_fail(req);
-		io_req_complete(req, ret);
-		return 0;
-	}
-	/* only mask one event flags, keep behavior flags */
-	if (req->poll_update.update_events) {
-		preq->poll.events &= ~0xffff;
-		preq->poll.events |= req->poll_update.events & 0xffff;
-		preq->poll.events |= IO_POLL_UNMASK;
+		goto fail;
 	}
-	if (req->poll_update.update_user_data)
-		preq->user_data = req->poll_update.new_user_data;
 	spin_unlock(&ctx->completion_lock);
 
+	if (req->poll_update.update_events || req->poll_update.update_user_data) {
+		/* only mask one event flags, keep behavior flags */
+		if (req->poll_update.update_events) {
+			preq->poll.events &= ~0xffff;
+			preq->poll.events |= req->poll_update.events & 0xffff;
+			preq->poll.events |= IO_POLL_UNMASK;
+		}
+		if (req->poll_update.update_user_data)
+			preq->user_data = req->poll_update.new_user_data;
+
+		ret2 = io_poll_add(preq, issue_flags);
+		/* successfully updated, don't complete poll request */
+		if (!ret2)
+			goto out;
+	}
+	req_set_fail(preq);
+	io_req_complete(preq, -ECANCELED);
+out:
+	if (ret < 0)
+		req_set_fail(req);
 	/* complete update request, we're done with it */
 	io_req_complete(req, ret);
-
-	if (!completing) {
-		ret = io_poll_add(preq, issue_flags);
-		if (ret < 0) {
-			req_set_fail(preq);
-			io_req_complete(preq, ret);
-		}
-	}
 	return 0;
 }
 


