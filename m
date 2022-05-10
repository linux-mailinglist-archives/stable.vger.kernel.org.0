Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D560552196E
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241530AbiEJNs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243493AbiEJNpi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:45:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB7953E00;
        Tue, 10 May 2022 06:31:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AF50FCE1E67;
        Tue, 10 May 2022 13:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1AD9C385A6;
        Tue, 10 May 2022 13:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189449;
        bh=H80LzjsCwwDuMoTh8aPlJp2dEdjqVJunQqjAV47P7vE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LRkMMc+wdA/W2MWEkG5pbb3oUOT4QwisVbUVSSNmzb2ZAb2x9V/DOgmbAA2bWDJXD
         lEufoEC+Zor5MphOVwTnQ6sWop1VeCmn3ouo8Y0TY9oRRo2QDXi4tWy1c994IZWWVf
         wb2hzlof7LTcJwtEITlQbC2kNScVBSiHD/byUg20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.15 055/135] SUNRPC release the transport of a relocated task with an assigned transport
Date:   Tue, 10 May 2022 15:07:17 +0200
Message-Id: <20220510130741.984760719@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
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


