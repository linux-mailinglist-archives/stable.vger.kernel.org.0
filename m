Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BABC59DC2B
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358681AbiHWLwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358493AbiHWLtx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:49:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E005B77EA2;
        Tue, 23 Aug 2022 02:31:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAEB4612D8;
        Tue, 23 Aug 2022 09:31:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF458C433D6;
        Tue, 23 Aug 2022 09:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247068;
        bh=Ar0Ri1pXQ2u5TEvE1oM8+Sx9bnNlWLzCZzLjllN8NEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ONd5t7ZUKTJs5Sl+X74bQFOz1ddyOq5uPTWgOeSAj5SrNV7JusKIaXoS8WKAqhM0C
         Ec8jHq71hgmJKfKsZj0UJVSEzM6ARUmtbYKhrZKRjAb4/g0rGIt/Q8MHZWJxtSMjkE
         BQ/j2i7ApZNdT+dvyGtcZLOqOLNMBmzZHRb94cPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.4 309/389] SUNRPC: Reinitialise the backchannel request buffers before reuse
Date:   Tue, 23 Aug 2022 10:26:27 +0200
Message-Id: <20220823080128.484628977@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 6622e3a73112fc336c1c2c582428fb5ef18e456a upstream.

When we're reusing the backchannel requests instead of freeing them,
then we should reinitialise any values of the send/receive xdr_bufs so
that they reflect the available space.

Fixes: 0d2a970d0ae5 ("SUNRPC: Fix a backchannel race")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/backchannel_rqst.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/net/sunrpc/backchannel_rqst.c
+++ b/net/sunrpc/backchannel_rqst.c
@@ -64,6 +64,17 @@ static void xprt_free_allocation(struct
 	kfree(req);
 }
 
+static void xprt_bc_reinit_xdr_buf(struct xdr_buf *buf)
+{
+	buf->head[0].iov_len = PAGE_SIZE;
+	buf->tail[0].iov_len = 0;
+	buf->pages = NULL;
+	buf->page_len = 0;
+	buf->flags = 0;
+	buf->len = 0;
+	buf->buflen = PAGE_SIZE;
+}
+
 static int xprt_alloc_xdr_buf(struct xdr_buf *buf, gfp_t gfp_flags)
 {
 	struct page *page;
@@ -292,6 +303,9 @@ void xprt_free_bc_rqst(struct rpc_rqst *
 	 */
 	spin_lock_bh(&xprt->bc_pa_lock);
 	if (xprt_need_to_requeue(xprt)) {
+		xprt_bc_reinit_xdr_buf(&req->rq_snd_buf);
+		xprt_bc_reinit_xdr_buf(&req->rq_rcv_buf);
+		req->rq_rcv_buf.len = PAGE_SIZE;
 		list_add_tail(&req->rq_bc_pa_list, &xprt->bc_pa_list);
 		xprt->bc_alloc_count++;
 		atomic_inc(&xprt->bc_slot_count);


