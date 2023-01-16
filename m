Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5AC866CB5D
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbjAPROe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:14:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234409AbjAPRNN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:13:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D1D4B760
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:53:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4CDAB8105D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:53:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F2DC433EF;
        Mon, 16 Jan 2023 16:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888032;
        bh=WRAhQKFBzAfGcvTK0bLhIHPnr4oVYydtmHwao50DIFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mfb/YIIPq5Cv315vWM59Datr8W7j7tUMUy+w0TWsuin3lcVgougxFUeX9AuPwUwiz
         ykJTJwRVYTWxtAaN829VflDorfIdnKwXev41sayQcfbqF/gR3+jXyUiMhwI3+Tf4WT
         6xChxNVNUA/YwprQM2PVJZgV6Cbp9+q3JEFAJwqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 4.19 375/521] SUNRPC: Dont leak netobj memory when gss_read_proxy_verf() fails
Date:   Mon, 16 Jan 2023 16:50:37 +0100
Message-Id: <20230116154903.876636661@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

commit da522b5fe1a5f8b7c20a0023e87b52a150e53bf5 upstream.

Fixes: 030d794bf498 ("SUNRPC: Use gssproxy upcall for server RPCGSS authentication.")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: <stable@vger.kernel.org>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1088,18 +1088,23 @@ static int gss_read_proxy_verf(struct sv
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


