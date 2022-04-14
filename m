Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDAF501440
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245206AbiDNOIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347708AbiDNN7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:59:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6686CA76F3;
        Thu, 14 Apr 2022 06:51:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C542B82990;
        Thu, 14 Apr 2022 13:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE4EC385A5;
        Thu, 14 Apr 2022 13:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649944307;
        bh=ji+Vu9oKkZG2EzVq7HbQ8ZOLSkcDfIfAAp7sojUI33I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m/Z1LAZ4CzO/6J5G7aywLLmL0QbDRxK3ZorwEn+YS9lv+NgdHJZFFarRaSybaL3C6
         iB2k9dfv2ngqpD3c4rz/Xg4NDxHOq5KFKj75R/IgwUJieZRRrgx2URbrdIOfBYSq4Q
         9E0uk2JE9JKdl3+PXUziQSjtXpm2qmuzuUyavOIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bing-Jhong Billy Jheng <billy@starlabs.sg>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.4 467/475] io_uring: fix fs->users overflow
Date:   Thu, 14 Apr 2022 15:14:12 +0200
Message-Id: <20220414110908.124909230@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
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

There is a bunch of cases where we can grab req->fs but not put it, this
can be used to cause a controllable overflow with further implications.
Release req->fs in the request free path and make sure we zero the field
to be sure we don't do it twice.

Fixes: cac68d12c531 ("io_uring: grab ->fs as part of async offload")
Reported-by: Bing-Jhong Billy Jheng <billy@starlabs.sg>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -438,6 +438,22 @@ static struct io_ring_ctx *io_ring_ctx_a
 	return ctx;
 }
 
+static void io_req_put_fs(struct io_kiocb *req)
+{
+	struct fs_struct *fs = req->fs;
+
+	if (!fs)
+		return;
+
+	spin_lock(&req->fs->lock);
+	if (--fs->users)
+		fs = NULL;
+	spin_unlock(&req->fs->lock);
+	if (fs)
+		free_fs_struct(fs);
+	req->fs = NULL;
+}
+
 static inline bool __io_sequence_defer(struct io_ring_ctx *ctx,
 				       struct io_kiocb *req)
 {
@@ -695,6 +711,7 @@ static void io_free_req_many(struct io_r
 
 static void __io_free_req(struct io_kiocb *req)
 {
+	io_req_put_fs(req);
 	if (req->file && !(req->flags & REQ_F_FIXED_FILE))
 		fput(req->file);
 	percpu_ref_put(&req->ctx->refs);
@@ -1701,16 +1718,7 @@ static int io_send_recvmsg(struct io_kio
 			ret = -EINTR;
 	}
 
-	if (req->fs) {
-		struct fs_struct *fs = req->fs;
-
-		spin_lock(&req->fs->lock);
-		if (--fs->users)
-			fs = NULL;
-		spin_unlock(&req->fs->lock);
-		if (fs)
-			free_fs_struct(fs);
-	}
+	io_req_put_fs(req);
 	io_cqring_add_event(req->ctx, sqe->user_data, ret);
 	io_put_req(req);
 	return 0;


