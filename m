Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 798DA5AAFB8
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237240AbiIBMmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237181AbiIBMmT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:42:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BC175B7A6;
        Fri,  2 Sep 2022 05:31:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5E89B82AC9;
        Fri,  2 Sep 2022 12:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1A0C433D6;
        Fri,  2 Sep 2022 12:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121876;
        bh=h+GfMyh6NtoOf91jqcS/nVhsx8iBfFEUNzTg3tAQC00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZuNvaBMuPDLVcczKosOV3UWnADCHDbJLL93ECxYvyC2DZKYuyU83KZPt+SIAQgqA1
         HGcC9AkRm+kMt5FVqaxun3/a1wuVWHSRopgYrEugGkdyn9Fwr41LaV1KY2rRwDglGi
         87CVo/GSbgEaSl3rxr2YgqYPVuLbNUJsGxZy2T7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 16/73] io_uring: inline io_poll_complete
Date:   Fri,  2 Sep 2022 14:18:40 +0200
Message-Id: <20220902121404.992001264@linuxfoundation.org>
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

[ upstream commmit eb6e6f0690c846f7de46181bab3954c12c96e11e ]

Inline io_poll_complete(), it's simple and doesn't have any particular
purpose.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/933d7ee3e4450749a2d892235462c8f18d030293.1633373302.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[pavel: backport]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5447,16 +5447,6 @@ static bool __io_poll_complete(struct io
 	return !(flags & IORING_CQE_F_MORE);
 }
 
-static inline bool io_poll_complete(struct io_kiocb *req, __poll_t mask)
-	__must_hold(&req->ctx->completion_lock)
-{
-	bool done;
-
-	done = __io_poll_complete(req, mask);
-	io_commit_cqring(req->ctx);
-	return done;
-}
-
 static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -5910,7 +5900,8 @@ static int io_poll_add(struct io_kiocb *
 
 	if (mask) { /* no async, we'd stolen it */
 		ipt.error = 0;
-		done = io_poll_complete(req, mask);
+		done = __io_poll_complete(req, mask);
+		io_commit_cqring(req->ctx);
 	}
 	spin_unlock(&ctx->completion_lock);
 


