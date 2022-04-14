Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 127C95015D0
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245379AbiDNNnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344085AbiDNNaU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:30:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4959626CB;
        Thu, 14 Apr 2022 06:27:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B539B82941;
        Thu, 14 Apr 2022 13:27:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DDDC385A1;
        Thu, 14 Apr 2022 13:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942872;
        bh=gNs2ksaw6yENkOk8CTLKk8Qj5drHLfx47ybYTf8cIro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pVBO5LYfwoB7crlhnETeXJKZdtbj0RMhcmRjP7ove/ynp4KwloKwz7GfTmZ2NC9DM
         9WSMx6apXQprbKtPaZzalyGdOAp2xfjaL013C0pLXuuifCjiCokQ9ZM4uExfcMGN7r
         ZLumK/Efl7lL6dkzq886RXz3EC6eScnWP/jn+e+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 293/338] SUNRPC/call_alloc: async tasks mustnt block waiting for memory
Date:   Thu, 14 Apr 2022 15:13:16 +0200
Message-Id: <20220414110847.227926095@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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

From: NeilBrown <neilb@suse.de>

[ Upstream commit c487216bec83b0c5a8803e5c61433d33ad7b104d ]

When memory is short, new worker threads cannot be created and we depend
on the minimum one rpciod thread to be able to handle everything.
So it must not block waiting for memory.

mempools are particularly a problem as memory can only be released back
to the mempool by an async rpc task running.  If all available
workqueue threads are waiting on the mempool, no thread is available to
return anything.

rpc_malloc() can block, and this might cause deadlocks.
So check RPC_IS_ASYNC(), rather than RPC_IS_SWAPPER() to determine if
blocking is acceptable.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/sched.c              | 4 +++-
 net/sunrpc/xprtrdma/transport.c | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index e339f8da1b0a..e36ae4d4b540 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -893,8 +893,10 @@ int rpc_malloc(struct rpc_task *task)
 	struct rpc_buffer *buf;
 	gfp_t gfp = GFP_NOIO | __GFP_NOWARN;
 
+	if (RPC_IS_ASYNC(task))
+		gfp = GFP_NOWAIT | __GFP_NOWARN;
 	if (RPC_IS_SWAPPER(task))
-		gfp = __GFP_MEMALLOC | GFP_NOWAIT | __GFP_NOWARN;
+		gfp |= __GFP_MEMALLOC;
 
 	size += sizeof(struct rpc_buffer);
 	if (size <= RPC_BUFFER_MAXSIZE)
diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index fdd14908eacb..e87a79be7ef0 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -665,8 +665,10 @@ xprt_rdma_allocate(struct rpc_task *task)
 	gfp_t flags;
 
 	flags = RPCRDMA_DEF_GFP;
+	if (RPC_IS_ASYNC(task))
+		flags = GFP_NOWAIT | __GFP_NOWARN;
 	if (RPC_IS_SWAPPER(task))
-		flags = __GFP_MEMALLOC | GFP_NOWAIT | __GFP_NOWARN;
+		flags |= __GFP_MEMALLOC;
 
 	if (!rpcrdma_get_sendbuf(r_xprt, req, rqst->rq_callsize, flags))
 		goto out_fail;
-- 
2.35.1



