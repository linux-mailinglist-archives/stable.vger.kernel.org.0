Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2DF53CF14
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345406AbiFCRwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345775AbiFCRuZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:50:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D005908A;
        Fri,  3 Jun 2022 10:46:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9CE960A54;
        Fri,  3 Jun 2022 17:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A18C385A9;
        Fri,  3 Jun 2022 17:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278377;
        bh=7oYHfS1M/s+Jkhydgv6K62l+sh0VCTWVcZ0tPKS1+5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GUnY8gLc6+hT4+/czs/NubQ+kgjDinwwYcX01aYkKmk0997nEZTaglQslY/ODWS/i
         lrpd+aYQL/IZ/rKG9SIAQCiA7OQ6/K2KPj4UgJQUPgElKbFx8ldu4nDtGNOgSZegw6
         YoRyK0ReVaA/dwSS/UdodUrt5I2llqSpaR5RZz9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.10 13/53] io_uring: dont re-import iovecs from callbacks
Date:   Fri,  3 Jun 2022 19:42:58 +0200
Message-Id: <20220603173819.107725914@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173818.716010877@linuxfoundation.org>
References: <20220603173818.716010877@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Pavel Begunkov <asml.silence@gmail.com>

We can't re-import or modify iterators from iocb callbacks, it's not
safe as it might be reverted and/or reexpanded while unwinding stack.
It's also not safe to resubmit as io-wq thread will race with stack
undwinding for the iterator and other data.

Disallow resubmission from callbacks, it can fail some cases that were
handled before, but the possibility of such a failure was a part of the
API from the beginning and so it should be fine.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   39 ---------------------------------------
 1 file changed, 39 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2579,45 +2579,6 @@ static void io_complete_rw_common(struct
 #ifdef CONFIG_BLOCK
 static bool io_resubmit_prep(struct io_kiocb *req, int error)
 {
-	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
-	ssize_t ret = -ECANCELED;
-	struct iov_iter iter;
-	int rw;
-
-	if (error) {
-		ret = error;
-		goto end_req;
-	}
-
-	switch (req->opcode) {
-	case IORING_OP_READV:
-	case IORING_OP_READ_FIXED:
-	case IORING_OP_READ:
-		rw = READ;
-		break;
-	case IORING_OP_WRITEV:
-	case IORING_OP_WRITE_FIXED:
-	case IORING_OP_WRITE:
-		rw = WRITE;
-		break;
-	default:
-		printk_once(KERN_WARNING "io_uring: bad opcode in resubmit %d\n",
-				req->opcode);
-		goto end_req;
-	}
-
-	if (!req->async_data) {
-		ret = io_import_iovec(rw, req, &iovec, &iter, false);
-		if (ret < 0)
-			goto end_req;
-		ret = io_setup_async_rw(req, iovec, inline_vecs, &iter, false);
-		if (!ret)
-			return true;
-		kfree(iovec);
-	} else {
-		return true;
-	}
-end_req:
 	req_set_fail_links(req);
 	return false;
 }


