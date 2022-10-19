Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F227603D0A
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiJSI4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231907AbiJSI4Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:56:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C475E9C2E0;
        Wed, 19 Oct 2022 01:52:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51F6D61840;
        Wed, 19 Oct 2022 08:48:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3C0C433C1;
        Wed, 19 Oct 2022 08:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169291;
        bh=UCOXvJhWORPwHaVSbJcOe6oEVxI7zAC7T2lMUEbvagY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0bC7j9+XpRTM6b58F0QrhaFRqTYVozzReqca64QCH8pPs0GESVC2gxFgTIwBuRlXt
         Mpukn0JLDraf5ZE0OHB0xJm3I3Y1Knx4UwTQMfmZlJOFknIzWmKs0vIqSgIEAa2PJ5
         jXpM9ciIu+Nt6VE7/bhSMNqsnWZMjDE90fAiuQnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 222/862] SUNRPC: Fix svcxdr_init_decodes end-of-buffer calculation
Date:   Wed, 19 Oct 2022 10:25:09 +0200
Message-Id: <20221019083259.849441093@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 90bfc37b5ab91c1a6165e3e5cfc49bf04571b762 ]

Ensure that stream-based argument decoding can't go past the actual
end of the receive buffer. xdr_init_decode's calculation of the
value of xdr->end over-estimates the end of the buffer because the
Linux kernel RPC server code does not remove the size of the RPC
header from rqstp->rq_arg before calling the upper layer's
dispatcher.

The server-side still uses the svc_getnl() macros to decode the
RPC call header. These macros reduce the length of the head iov
but do not update the total length of the message in the buffer
(buf->len).

A proper fix for this would be to replace the use of svc_getnl() and
friends in the RPC header decoder, but that would be a large and
invasive change that would be difficult to backport.

Fixes: 5191955d6fc6 ("SUNRPC: Prepare for xdr_stream-style decoding on the server-side")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/svc.h | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index daecb009c05b..5a830b66f059 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -544,16 +544,27 @@ static inline void svc_reserve_auth(struct svc_rqst *rqstp, int space)
 }
 
 /**
- * svcxdr_init_decode - Prepare an xdr_stream for svc Call decoding
+ * svcxdr_init_decode - Prepare an xdr_stream for Call decoding
  * @rqstp: controlling server RPC transaction context
  *
+ * This function currently assumes the RPC header in rq_arg has
+ * already been decoded. Upon return, xdr->p points to the
+ * location of the upper layer header.
  */
 static inline void svcxdr_init_decode(struct svc_rqst *rqstp)
 {
 	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
-	struct kvec *argv = rqstp->rq_arg.head;
+	struct xdr_buf *buf = &rqstp->rq_arg;
+	struct kvec *argv = buf->head;
 
-	xdr_init_decode(xdr, &rqstp->rq_arg, argv->iov_base, NULL);
+	/*
+	 * svc_getnl() and friends do not keep the xdr_buf's ::len
+	 * field up to date. Refresh that field before initializing
+	 * the argument decoding stream.
+	 */
+	buf->len = buf->head->iov_len + buf->page_len + buf->tail->iov_len;
+
+	xdr_init_decode(xdr, buf, argv->iov_base, NULL);
 	xdr_set_scratch_page(xdr, rqstp->rq_scratch_page);
 }
 
-- 
2.35.1



