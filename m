Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 360704F2A0D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236355AbiDEI1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239522AbiDEIUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7197DEBC;
        Tue,  5 Apr 2022 01:15:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F568609D0;
        Tue,  5 Apr 2022 08:15:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB51C385A1;
        Tue,  5 Apr 2022 08:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146510;
        bh=fUELxiGKn9yMltYwLmzgS4G3Cg5zoeW2IXsri3WLId0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NTPgMvElEh8QvSAY8P5hUQGVY3cThh7dv6JTsvlMTXMe/t+fo/KnFa5Tx468Ty+HI
         Iy6DDFyjAqwttM+XZIT0XegY/zMWr1bvGBSwPJgtQe5QP6H/GKQ15Y9c5Lf7VigXuz
         fVoShSOGQdj4H9+TpmC0XHp+1iiu43GDXT85j4TI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0789/1126] SUNRPC/call_alloc: async tasks mustnt block waiting for memory
Date:   Tue,  5 Apr 2022 09:25:36 +0200
Message-Id: <20220405070430.732283454@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index e2c835482791..d5b6e897f5a5 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -1023,8 +1023,10 @@ int rpc_malloc(struct rpc_task *task)
 	struct rpc_buffer *buf;
 	gfp_t gfp = GFP_NOFS;
 
+	if (RPC_IS_ASYNC(task))
+		gfp = GFP_NOWAIT | __GFP_NOWARN;
 	if (RPC_IS_SWAPPER(task))
-		gfp = __GFP_MEMALLOC | GFP_NOWAIT | __GFP_NOWARN;
+		gfp |= __GFP_MEMALLOC;
 
 	size += sizeof(struct rpc_buffer);
 	if (size <= RPC_BUFFER_MAXSIZE)
diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 42e375dbdadb..5714bf880e95 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -570,8 +570,10 @@ xprt_rdma_allocate(struct rpc_task *task)
 	gfp_t flags;
 
 	flags = RPCRDMA_DEF_GFP;
+	if (RPC_IS_ASYNC(task))
+		flags = GFP_NOWAIT | __GFP_NOWARN;
 	if (RPC_IS_SWAPPER(task))
-		flags = __GFP_MEMALLOC | GFP_NOWAIT | __GFP_NOWARN;
+		flags |= __GFP_MEMALLOC;
 
 	if (!rpcrdma_check_regbuf(r_xprt, req->rl_sendbuf, rqst->rq_callsize,
 				  flags))
-- 
2.34.1



