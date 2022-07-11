Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF3856FB07
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbiGKJZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232255AbiGKJYX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:24:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86B222BF8;
        Mon, 11 Jul 2022 02:14:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 162A761140;
        Mon, 11 Jul 2022 09:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20870C34115;
        Mon, 11 Jul 2022 09:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530856;
        bh=uGlEy0o9eAIMJ4xj6ANHll0AzmvXaid4kNNsamvBGuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m3KQpf0o26h5LxgTWSuOy3Wl/fEsvM7tBGOBCEniyqmrEOf6CPF0HqlFQqBaYaBcA
         6JwjFpCNNQT//SZbgFtwQDOefzZ9zdCiS138ojFKM3o6GoUbvJ6Ax6M7o0KsGOjILN
         SDT0IgzOteA5zWMcOqt85TWRv5JnomILLD35Bw3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dylan Yudaken <dylany@fb.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.18 001/112] io_uring: fix provided buffer import
Date:   Mon, 11 Jul 2022 11:06:01 +0200
Message-Id: <20220711090549.589060946@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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

From: Dylan Yudaken <dylany@fb.com>

commit 09007af2b627f0f195c6c53c4829b285cc3990ec upstream.

io_import_iovec uses the s pointer, but this was changed immediately
after the iovec was re-imported and so it was imported into the wrong
place.

Change the ordering.

Fixes: 2be2eb02e2f5 ("io_uring: ensure reads re-import for selected buffers")
Signed-off-by: Dylan Yudaken <dylany@fb.com>
Link: https://lore.kernel.org/r/20220630132006.2825668-1-dylany@fb.com
[axboe: ensure we don't half-import as well]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3495,6 +3495,13 @@ static ssize_t io_iov_buffer_select(stru
 	return __io_iov_buffer_select(req, iov, issue_flags);
 }
 
+static inline bool io_do_buffer_select(struct io_kiocb *req)
+{
+	if (!(req->flags & REQ_F_BUFFER_SELECT))
+		return false;
+	return !(req->flags & REQ_F_BUFFER_SELECTED);
+}
+
 static struct iovec *__io_import_iovec(int rw, struct io_kiocb *req,
 				       struct io_rw_state *s,
 				       unsigned int issue_flags)
@@ -3854,18 +3861,19 @@ static int io_read(struct io_kiocb *req,
 		if (unlikely(ret < 0))
 			return ret;
 	} else {
+		rw = req->async_data;
+		s = &rw->s;
+
 		/*
 		 * Safe and required to re-import if we're using provided
 		 * buffers, as we dropped the selected one before retry.
 		 */
-		if (req->flags & REQ_F_BUFFER_SELECT) {
+		if (io_do_buffer_select(req)) {
 			ret = io_import_iovec(READ, req, &iovec, s, issue_flags);
 			if (unlikely(ret < 0))
 				return ret;
 		}
 
-		rw = req->async_data;
-		s = &rw->s;
 		/*
 		 * We come here from an earlier attempt, restore our state to
 		 * match in case it doesn't. It's cheap enough that we don't


