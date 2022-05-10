Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E09521AB6
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243922AbiEJOD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245278AbiEJN5Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:57:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701F32D4B56;
        Tue, 10 May 2022 06:39:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09148615E9;
        Tue, 10 May 2022 13:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22EBC385A6;
        Tue, 10 May 2022 13:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189945;
        bh=H80LzjsCwwDuMoTh8aPlJp2dEdjqVJunQqjAV47P7vE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ayohSOjUylXRgcTXmXLE1jrt+OORp/WrBZQpMXCYup2wirN0NzbCJAnIGXedMeF1d
         WmsMVxKPrmgi2v4uyaUkOGY6e1K7QRxfqFHZznuzXl3yLdPA89p1cOYpTjIpYhbPJ4
         Ma/6jBbS46EzY+Zz/ElaSnBaC3GzIDVJlXprRW8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.17 078/140] SUNRPC release the transport of a relocated task with an assigned transport
Date:   Tue, 10 May 2022 15:07:48 +0200
Message-Id: <20220510130743.844609243@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <kolga@netapp.com>

commit e13433b4416fa31a24e621cbbbb39227a3d651dd upstream.

A relocated task must release its previous transport.

Fixes: 82ee41b85cef1 ("SUNRPC don't resend a task on an offlined transport")
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/clnt.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1065,10 +1065,13 @@ rpc_task_get_next_xprt(struct rpc_clnt *
 static
 void rpc_task_set_transport(struct rpc_task *task, struct rpc_clnt *clnt)
 {
-	if (task->tk_xprt &&
-			!(test_bit(XPRT_OFFLINE, &task->tk_xprt->state) &&
-                        (task->tk_flags & RPC_TASK_MOVEABLE)))
-		return;
+	if (task->tk_xprt) {
+		if (!(test_bit(XPRT_OFFLINE, &task->tk_xprt->state) &&
+		      (task->tk_flags & RPC_TASK_MOVEABLE)))
+			return;
+		xprt_release(task);
+		xprt_put(task->tk_xprt);
+	}
 	if (task->tk_flags & RPC_TASK_NO_ROUND_ROBIN)
 		task->tk_xprt = rpc_task_get_first_xprt(clnt);
 	else


