Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1B90676F4D
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbjAVPT5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:19:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbjAVPT4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:19:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5775A21954
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:19:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E514260BC5
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:19:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B0EC433D2;
        Sun, 22 Jan 2023 15:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400794;
        bh=kD5wUm+p6pOHPBaTAfalvMlsgflcNCz+LnsDb/x06iI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rdzYM7qfwRxe7bZNyrMyJk8tqA27JXPSsnXdyHND/gOXbLGpE71cxpX0TpoRpAFYl
         WiaDyUxUyqTEtQXbLuYPr/da9LtzWhL8ekFrZ7j3ugDm9QbWdSJDKqbezm1T7s2Ned
         74TZtCMvx+wy3hzU+SRX2UHddtGMbXbu7nvfWfG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stefan Metzmacher <metze@samba.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 112/117] io_uring/net: fix fast_iov assignment in io_setup_async_msg()
Date:   Sun, 22 Jan 2023 16:05:02 +0100
Message-Id: <20230122150237.473035818@linuxfoundation.org>
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

From: Stefan Metzmacher <metze@samba.org>

commit 3e4cb6ebbb2bad201c1186bc0b7e8cf41dd7f7e6 upstream.

I hit a very bad problem during my tests of SENDMSG_ZC.
BUG(); in first_iovec_segment() triggered very easily.
The problem was io_setup_async_msg() in the partial retry case,
which seems to happen more often with _ZC.

iov_iter_iovec_advance() may change i->iov in order to have i->iov_offset
being only relative to the first element.

Which means kmsg->msg.msg_iter.iov is no longer the
same as kmsg->fast_iov.

But this would rewind the copy to be the start of
async_msg->fast_iov, which means the internal
state of sync_msg->msg.msg_iter is inconsitent.

I tested with 5 vectors with length like this 4, 0, 64, 20, 8388608
and got a short writes with:
- ret=2675244 min_ret=8388692 => remaining 5713448 sr->done_io=2675244
- ret=-EAGAIN => io_uring_poll_arm
- ret=4911225 min_ret=5713448 => remaining 802223  sr->done_io=7586469
- ret=-EAGAIN => io_uring_poll_arm
- ret=802223  min_ret=802223  => res=8388692

While this was easily triggered with SENDMSG_ZC (queued for 6.1),
it was a potential problem starting with 7ba89d2af17aa879dda30f5d5d3f152e587fc551
in 5.18 for IORING_OP_RECVMSG.
And also with 4c3c09439c08b03d9503df0ca4c7619c5842892e in 5.19
for IORING_OP_SENDMSG.

However 257e84a5377fbbc336ff563833a8712619acce56 introduced the critical
code into io_setup_async_msg() in 5.11.

Fixes: 7ba89d2af17aa ("io_uring: ensure recv and recvmsg handle MSG_WAITALL correctly")
Fixes: 257e84a5377fb ("io_uring: refactor sendmsg/recvmsg iov managing")
Cc: stable@vger.kernel.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/b2e7be246e2fb173520862b0c7098e55767567a2.1664436949.git.metze@samba.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4827,8 +4827,10 @@ static int io_setup_async_msg(struct io_
 	if (async_msg->msg.msg_name)
 		async_msg->msg.msg_name = &async_msg->addr;
 	/* if were using fast_iov, set it to the new one */
-	if (!async_msg->free_iov)
-		async_msg->msg.msg_iter.iov = async_msg->fast_iov;
+	if (!kmsg->free_iov) {
+		size_t fast_idx = kmsg->msg.msg_iter.iov - kmsg->fast_iov;
+		async_msg->msg.msg_iter.iov = &async_msg->fast_iov[fast_idx];
+	}
 
 	return -EAGAIN;
 }


