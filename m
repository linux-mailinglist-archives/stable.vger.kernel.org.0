Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDEE6676F0E
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjAVPRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbjAVPRR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:17:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9288F2202A
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:17:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2777460BC5
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:17:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF95C433D2;
        Sun, 22 Jan 2023 15:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400634;
        bh=/XcWDfGyJ7HEHVSwb5TC44LLxAPz1Dtuz55cm6EQcOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ierbr9Fe+ZlNaq0zjzHFZfE4AQHFmWhRuMnXKhtwz5q+lM1h6+/UUtxZxoY5yG7dB
         jtx9eXyWIr6vlB+SL6glB6rkJIjVPlUCuGK25t7qZPenUBBLpfPK4J9jFZSIYBfqCh
         woOWPJ89sBu8584xppzhZIXZOQAdAnEc2aNjEYsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/117] io_uring: add flag for disabling provided buffer recycling
Date:   Sun, 22 Jan 2023 16:03:43 +0100
Message-Id: <20230122150234.099736283@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 8a3e8ee56417f5e0e66580d93941ed9d6f4c8274 upstream.

If we need to continue doing this IO, then we don't want a potentially
selected buffer recycled. Add a flag for that.

Set this for recv/recvmsg if they do partial IO.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 04441e981624..2350d43aa782 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -740,6 +740,7 @@ enum {
 	REQ_F_CREDS_BIT,
 	REQ_F_REFCOUNT_BIT,
 	REQ_F_ARM_LTIMEOUT_BIT,
+	REQ_F_PARTIAL_IO_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_NOWAIT_READ_BIT,
 	REQ_F_NOWAIT_WRITE_BIT,
@@ -795,6 +796,8 @@ enum {
 	REQ_F_REFCOUNT		= BIT(REQ_F_REFCOUNT_BIT),
 	/* there is a linked timeout that has to be armed */
 	REQ_F_ARM_LTIMEOUT	= BIT(REQ_F_ARM_LTIMEOUT_BIT),
+	/* request has already done partial IO */
+	REQ_F_PARTIAL_IO	= BIT(REQ_F_PARTIAL_IO_BIT),
 };
 
 struct async_poll {
@@ -5123,6 +5126,7 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 			ret = -EINTR;
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->done_io += ret;
+			req->flags |= REQ_F_PARTIAL_IO;
 			return io_setup_async_msg(req, kmsg);
 		}
 		req_set_fail(req);
@@ -5196,6 +5200,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 			sr->len -= ret;
 			sr->buf += ret;
 			sr->done_io += ret;
+			req->flags |= REQ_F_PARTIAL_IO;
 			return -EAGAIN;
 		}
 		req_set_fail(req);
-- 
2.39.0



