Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10DA667753
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239591AbjALOmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237624AbjALOlY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:41:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14E7EA9
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:31:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76F3862036
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86463C433EF;
        Thu, 12 Jan 2023 14:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533863;
        bh=HLYGwh8W1owOthZL04DgE1B08evCzcBUvnLS5UMVSaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0JPyWpOkQVsdZV1YBKgzTQT7UyjWZdSD45TJO2EDY68g2qPp6TtTpP3chGSui8EGq
         rQY2LNfFNQTE1OjH8mJx/d8CTSMs4JLZqWI1oJGtmhReg7r3Cek3hzzuqN6Pjx51Dh
         QDxZ2qL2gEOgv0vsjxivWlG8VH6u4fAl/RoAJbmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.10 599/783] SUNRPC: Dont leak netobj memory when gss_read_proxy_verf() fails
Date:   Thu, 12 Jan 2023 14:55:15 +0100
Message-Id: <20230112135552.043539944@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
@@ -1156,18 +1156,23 @@ static int gss_read_proxy_verf(struct sv
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


