Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B802665B03F
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbjABLEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:04:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbjABLEY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:04:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB96062EA
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:04:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 481FD60F19
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:04:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30302C433EF;
        Mon,  2 Jan 2023 11:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672657462;
        bh=pndrFTHzt1rDnA9WXQwl2yy1AaAWQbLXRNiG0Cysh7c=;
        h=Subject:To:Cc:From:Date:From;
        b=l5VHqpMVg0YeovJeDJsKYATsbOGwupajoL8kVk/6LPAWz9cU/rHMb6eHZNYwNSsQO
         UREQ+pqs63kmZPubXHexsLICNGTCuMHuQkLpBLImB3zuhPSPm5AvmeWoe6nFXUE3xo
         xPXd8lsIckjtVyueRnhjxbrXppfaHET/FhgDt3XA=
Subject: FAILED: patch "[PATCH] SUNRPC: Don't leak netobj memory when gss_read_proxy_verf()" failed to apply to 4.14-stable tree
To:     chuck.lever@oracle.com, jlayton@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 02 Jan 2023 12:04:19 +0100
Message-ID: <167265745954148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

da522b5fe1a5 ("SUNRPC: Don't leak netobj memory when gss_read_proxy_verf() fails")
5866efa8cbfb ("SUNRPC: Fix svcauth_gss_proxy_init()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From da522b5fe1a5f8b7c20a0023e87b52a150e53bf5 Mon Sep 17 00:00:00 2001
From: Chuck Lever <chuck.lever@oracle.com>
Date: Sat, 26 Nov 2022 15:55:18 -0500
Subject: [PATCH] SUNRPC: Don't leak netobj memory when gss_read_proxy_verf()
 fails

Fixes: 030d794bf498 ("SUNRPC: Use gssproxy upcall for server RPCGSS authentication.")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: <stable@vger.kernel.org>
Reviewed-by: Jeff Layton <jlayton@kernel.org>

diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index bcd74dddbe2d..9a5db285d4ae 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1162,18 +1162,23 @@ static int gss_read_proxy_verf(struct svc_rqst *rqstp,
 		return res;
 
 	inlen = svc_getnl(argv);
-	if (inlen > (argv->iov_len + rqstp->rq_arg.page_len))
+	if (inlen > (argv->iov_len + rqstp->rq_arg.page_len)) {
+		kfree(in_handle->data);
 		return SVC_DENIED;
+	}
 
 	pages = DIV_ROUND_UP(inlen, PAGE_SIZE);
 	in_token->pages = kcalloc(pages, sizeof(struct page *), GFP_KERNEL);
-	if (!in_token->pages)
+	if (!in_token->pages) {
+		kfree(in_handle->data);
 		return SVC_DENIED;
+	}
 	in_token->page_base = 0;
 	in_token->page_len = inlen;
 	for (i = 0; i < pages; i++) {
 		in_token->pages[i] = alloc_page(GFP_KERNEL);
 		if (!in_token->pages[i]) {
+			kfree(in_handle->data);
 			gss_free_in_token_pages(in_token);
 			return SVC_DENIED;
 		}

