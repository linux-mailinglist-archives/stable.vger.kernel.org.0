Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8960681093
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237013AbjA3OE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236993AbjA3OEo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:04:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09AD30F7
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:04:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B508B80C9B
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:04:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B859FC433D2;
        Mon, 30 Jan 2023 14:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087481;
        bh=QezxbJLgVDif6EPAzlMXoFPqAwcZZ3KYR6AnYe4NI+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qfOiEKXr9IFN4adyg0f5SL23U09yeka7SBLVPKKhYyAhmQXPAx+4OK0wcN50N13fn
         P0cBlk0IjIW92nLAQNFZfKzSpCGwNkBmy8PvvGUNw/zOuciLGcs83schITkSNWrr2+
         5ppPKXmhY6++qkoivYDUnCELWV5ISmJIjulL4olk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dylan Yudaken <dylany@meta.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 222/313] io_uring/net: cache provided buffer group value for multishot receives
Date:   Mon, 30 Jan 2023 14:50:57 +0100
Message-Id: <20230130134347.051307365@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit b00c51ef8f72ced0965d021a291b98ff822c5337 upstream.

If we're using ring provided buffers with multishot receive, and we end
up doing an io-wq based issue at some points that also needs to select
a buffer, we'll lose the initially assigned buffer group as
io_ring_buffer_select() correctly clears the buffer group list as the
issue isn't serialized by the ctx uring_lock. This is fine for normal
receives as the request puts the buffer and finishes, but for multishot,
we will re-arm and do further receives. On the next trigger for this
multishot receive, the receive will try and pick from a buffer group
whose value is the same as the buffer ID of the las receive. That is
obviously incorrect, and will result in a premature -ENOUFS error for
the receive even if we had available buffers in the correct group.

Cache the buffer group value at prep time, so we can restore it for
future receives. This only needs doing for the above mentioned case, but
just do it by default to keep it easier to read.

Cc: stable@vger.kernel.org
Fixes: b3fdea6ecb55 ("io_uring: multishot recv")
Fixes: 9bb66906f23e ("io_uring: support multishot in recvmsg")
Cc: Dylan Yudaken <dylany@meta.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -62,6 +62,7 @@ struct io_sr_msg {
 	u16				flags;
 	/* initialised and used only by !msg send variants */
 	u16				addr_len;
+	u16				buf_group;
 	void __user			*addr;
 	/* used only for send zerocopy */
 	struct io_kiocb 		*notif;
@@ -565,6 +566,15 @@ int io_recvmsg_prep(struct io_kiocb *req
 		if (req->opcode == IORING_OP_RECV && sr->len)
 			return -EINVAL;
 		req->flags |= REQ_F_APOLL_MULTISHOT;
+		/*
+		 * Store the buffer group for this multishot receive separately,
+		 * as if we end up doing an io-wq based issue that selects a
+		 * buffer, it has to be committed immediately and that will
+		 * clear ->buf_list. This means we lose the link to the buffer
+		 * list, and the eventual buffer put on completion then cannot
+		 * restore it.
+		 */
+		sr->buf_group = req->buf_index;
 	}
 
 #ifdef CONFIG_COMPAT
@@ -581,6 +591,7 @@ static inline void io_recv_prep_retry(st
 
 	sr->done_io = 0;
 	sr->len = 0; /* get from the provided buffer */
+	req->buf_index = sr->buf_group;
 }
 
 /*


