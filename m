Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3136505940
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 16:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245728AbiDROO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 10:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245681AbiDROMW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 10:12:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294AC38196;
        Mon, 18 Apr 2022 06:11:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B863E60EFC;
        Mon, 18 Apr 2022 13:11:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD37EC385A7;
        Mon, 18 Apr 2022 13:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287504;
        bh=o3Y4MUM+DNhjUjNVPBgOfK2l3qJrVw3f+XAyqWVhVyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xe7zgu+iF9L6XClbPNW2piycnCtfOeDJYnUy38Ddg8tdaHddW0merwUaKYiZSPqgi
         q9fkM7G4OWAopisTXPE7e6HIpnCP8C7V35QJXgx4WkSebEIZ6xJAcCdqWaEhnmIIN8
         mZ9JDxB4yN0ZU87FBMFe8kAQ0dfNkD/fRAR+hylg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 183/218] SUNRPC/call_alloc: async tasks mustnt block waiting for memory
Date:   Mon, 18 Apr 2022 14:14:09 +0200
Message-Id: <20220418121206.237161544@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 00d95fefdc6f..ccb9fa5812d8 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -883,8 +883,10 @@ int rpc_malloc(struct rpc_task *task)
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
index 3ea3bb64b6d5..f308f286e9aa 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -577,8 +577,10 @@ xprt_rdma_allocate(struct rpc_task *task)
 		return -ENOMEM;
 
 	flags = RPCRDMA_DEF_GFP;
+	if (RPC_IS_ASYNC(task))
+		flags = GFP_NOWAIT | __GFP_NOWARN;
 	if (RPC_IS_SWAPPER(task))
-		flags = __GFP_MEMALLOC | GFP_NOWAIT | __GFP_NOWARN;
+		flags |= __GFP_MEMALLOC;
 
 	if (!rpcrdma_get_rdmabuf(r_xprt, req, flags))
 		goto out_fail;
-- 
2.35.1



