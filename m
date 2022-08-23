Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3626159DA46
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352177AbiHWKHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352759AbiHWKGP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:06:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DCCB1C4;
        Tue, 23 Aug 2022 01:52:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2E95B81C28;
        Tue, 23 Aug 2022 08:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06CBAC433C1;
        Tue, 23 Aug 2022 08:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244768;
        bh=OQlvZM+K22KXk20z/y80Vu43gP5UH4g2hFg4EP4s7Wc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XVGVL3PilQvNhE0Tef1DKIM5ZEtOvW7dZm/fnQRYC58h+A4WDvNDIxA8gvXP7ZpA+
         FG1MN/d9g3n+lwi719CH4gNz3d1ZRpiElhAY/2rh5Pyq2bavA2rziokC291BfbJ6pU
         yrG6NFs2gMmH8/NqOH2DJM8zQZO09sljfON8+o5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.14 187/229] SUNRPC: Reinitialise the backchannel request buffers before reuse
Date:   Tue, 23 Aug 2022 10:25:48 +0200
Message-Id: <20220823080100.290060127@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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
@@ -69,6 +69,17 @@ static void xprt_free_allocation(struct
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
@@ -291,6 +302,9 @@ void xprt_free_bc_rqst(struct rpc_rqst *
 	 */
 	spin_lock_bh(&xprt->bc_pa_lock);
 	if (xprt_need_to_requeue(xprt)) {
+		xprt_bc_reinit_xdr_buf(&req->rq_snd_buf);
+		xprt_bc_reinit_xdr_buf(&req->rq_rcv_buf);
+		req->rq_rcv_buf.len = PAGE_SIZE;
 		list_add_tail(&req->rq_bc_pa_list, &xprt->bc_pa_list);
 		xprt->bc_alloc_count++;
 		req = NULL;


