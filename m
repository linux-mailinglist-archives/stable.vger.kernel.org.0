Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 521384FD055
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350274AbiDLGpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350683AbiDLGm6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:42:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E829617E36;
        Mon, 11 Apr 2022 23:36:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68446B81B49;
        Tue, 12 Apr 2022 06:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE089C385A6;
        Tue, 12 Apr 2022 06:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745396;
        bh=ybLqq2JlpuKJF04INgQ7dIq+Q8rNuZfr5+6uW8wlq4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ihxuRtlzzty2LMA5XAgKbgWzzVhsw+MvTlgM6X+z4nGXbz73JaCLzAr+23p2ilRRp
         GdrUnVwYAZiCLwsshsEhPEMrLwt8FT7pBIZWrWto7o9lqa0PR4NrVi2GymF0GaGF+Z
         HaiiG3GletRZDbSnOrnOXxd4iUT4vfuPGwMOR02g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 083/171] SUNRPC/xprt: async tasks mustnt block waiting for memory
Date:   Tue, 12 Apr 2022 08:29:34 +0200
Message-Id: <20220412062930.289655419@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
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

[ Upstream commit a721035477fb5fb8abc738fbe410b07c12af3dc5 ]

When memory is short, new worker threads cannot be created and we depend
on the minimum one rpciod thread to be able to handle everything.  So it
must not block waiting for memory.

xprt_dynamic_alloc_slot can block indefinitely.  This can tie up all
workqueue threads and NFS can deadlock.  So when called from a
workqueue, set __GFP_NORETRY.

The rdma alloc_slot already does not block.  However it sets the error
to -EAGAIN suggesting this will trigger a sleep.  It does not.  As we
can see in call_reserveresult(), only -ENOMEM causes a sleep.  -EAGAIN
causes immediate retry.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprt.c               | 5 ++++-
 net/sunrpc/xprtrdma/transport.c | 2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 46304e647c49..441a8604c060 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1635,12 +1635,15 @@ static bool xprt_throttle_congested(struct rpc_xprt *xprt, struct rpc_task *task
 static struct rpc_rqst *xprt_dynamic_alloc_slot(struct rpc_xprt *xprt)
 {
 	struct rpc_rqst *req = ERR_PTR(-EAGAIN);
+	gfp_t gfp_mask = GFP_KERNEL;
 
 	if (xprt->num_reqs >= xprt->max_reqs)
 		goto out;
 	++xprt->num_reqs;
 	spin_unlock(&xprt->reserve_lock);
-	req = kzalloc(sizeof(struct rpc_rqst), GFP_NOFS);
+	if (current->flags & PF_WQ_WORKER)
+		gfp_mask |= __GFP_NORETRY | __GFP_NOWARN;
+	req = kzalloc(sizeof(*req), gfp_mask);
 	spin_lock(&xprt->reserve_lock);
 	if (req != NULL)
 		goto out;
diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index fb7a0ab27899..9cf10cfb85c6 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -519,7 +519,7 @@ xprt_rdma_alloc_slot(struct rpc_xprt *xprt, struct rpc_task *task)
 	return;
 
 out_sleep:
-	task->tk_status = -EAGAIN;
+	task->tk_status = -ENOMEM;
 	xprt_add_backlog(xprt, task);
 }
 
-- 
2.35.1



