Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 135C1603BBB
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbiJSIjC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbiJSIii (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:38:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B1780BD4;
        Wed, 19 Oct 2022 01:38:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 70DCCCE20DB;
        Wed, 19 Oct 2022 08:37:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 673F3C433D6;
        Wed, 19 Oct 2022 08:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168666;
        bh=B3ERKmsNnN430Zj+rZLDONZtKrHxu1wQ+S1atC0iTRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lJuUpEjyzlaNFsGhcJ4pVFs4omO5dj9VlSF3b30po7RwNV9feOYaqoGUbbFPsNIuO
         w0BnOgqO1afFo8o3F4FjGHalv/JUfDc6/8yuruN7DAdlw28Isd/uHKcVkcW/hUDBha
         wdX7xmTyBe19AJnEk9vEP3Qf7KaOev5tHFN8wVpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Metzmacher <metze@samba.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 015/862] io_uring/net: fix fast_iov assignment in io_setup_async_msg()
Date:   Wed, 19 Oct 2022 10:21:42 +0200
Message-Id: <20221019083250.679094053@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
 io_uring/net.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -165,8 +165,10 @@ static int io_setup_async_msg(struct io_
 	memcpy(async_msg, kmsg, sizeof(*kmsg));
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


