Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2385C0215
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbiIUPrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbiIUPr1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:47:27 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08D098CA3;
        Wed, 21 Sep 2022 08:47:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0D5F9CE1DEC;
        Wed, 21 Sep 2022 15:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D42A8C433D6;
        Wed, 21 Sep 2022 15:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775227;
        bh=eDDVGGUZV6WZWx5bcgZ+MyeNahQyU8/MG6bbtAH7YN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CGlCOkPtQpW/hPa3IDC7mVSDPo7DiHvuoOrQSouvxO3x5jo9/CpwBSMHfh0X9hNX7
         1aR4EZOUS4NMVTqokKr4wo6/W42jwXS/Kyw9sOSy1DIbFqKetCBW08e8XoVCXapNQK
         agJXNRLRRM3jOUnhsU8ceiJgPgUrjt4nwkrXfYFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Coddington <bcodding@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 06/38] SUNRPC: Fix call completion races with call_decode()
Date:   Wed, 21 Sep 2022 17:45:50 +0200
Message-Id: <20220921153646.503251236@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.298361220@linuxfoundation.org>
References: <20220921153646.298361220@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 17814819ac9829a437e06fbb5c7056a1f4f893da ]

We need to make sure that the req->rq_private_buf is completely up to
date before we make req->rq_reply_bytes_recvd visible to the
call_decode() routine in order to avoid triggering the WARN_ON().

Reported-by: Benjamin Coddington <bcodding@redhat.com>
Fixes: 72691a269f0b ("SUNRPC: Don't reuse bvec on retransmission of the request")
Tested-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 53b024cea3b3..5ecafffe7ce5 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1179,11 +1179,8 @@ xprt_request_dequeue_receive_locked(struct rpc_task *task)
 {
 	struct rpc_rqst *req = task->tk_rqstp;
 
-	if (test_and_clear_bit(RPC_TASK_NEED_RECV, &task->tk_runstate)) {
+	if (test_and_clear_bit(RPC_TASK_NEED_RECV, &task->tk_runstate))
 		xprt_request_rb_remove(req->rq_xprt, req);
-		xdr_free_bvec(&req->rq_rcv_buf);
-		req->rq_private_buf.bvec = NULL;
-	}
 }
 
 /**
@@ -1221,6 +1218,8 @@ void xprt_complete_rqst(struct rpc_task *task, int copied)
 
 	xprt->stat.recvs++;
 
+	xdr_free_bvec(&req->rq_rcv_buf);
+	req->rq_private_buf.bvec = NULL;
 	req->rq_private_buf.len = copied;
 	/* Ensure all writes are done before we update */
 	/* req->rq_reply_bytes_recvd */
@@ -1453,6 +1452,7 @@ xprt_request_dequeue_xprt(struct rpc_task *task)
 		xprt_request_dequeue_transmit_locked(task);
 		xprt_request_dequeue_receive_locked(task);
 		spin_unlock(&xprt->queue_lock);
+		xdr_free_bvec(&req->rq_rcv_buf);
 	}
 }
 
-- 
2.35.1



