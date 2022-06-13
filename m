Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81F10548A84
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353626AbiFMMQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358705AbiFMMOS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:14:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345DF5468B;
        Mon, 13 Jun 2022 04:01:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE07961435;
        Mon, 13 Jun 2022 11:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF87FC34114;
        Mon, 13 Jun 2022 11:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118115;
        bh=JNL82SmDWxYNCtU/gNOc7WAO0pSHqkbMptkPcQIA5c8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tsQIOkW/QWV6vwyhlkC9OCPqTAz328qH39V3wY1ZL7TQLFMBceSalfgoJ/5Jh374g
         YMH6YoNh+7VUg6mGMxy0KuFpwg//7sLlfVH+/Uau2xBAa7+3a66TkFzxMHKtIsa8QA
         bfdr2zlGBmfipXq10zgfUJZfSlRdS8+sp1UQ+I3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kinglong Mee <kinglongmee@gmail.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 235/287] xprtrdma: treat all calls not a bcall when bc_serv is NULL
Date:   Mon, 13 Jun 2022 12:10:59 +0200
Message-Id: <20220613094931.142922411@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kinglong Mee <kinglongmee@gmail.com>

[ Upstream commit 11270e7ca268e8d61b5d9e5c3a54bd1550642c9c ]

When a rdma server returns a fault format reply, nfs v3 client may
treats it as a bcall when bc service is not exist.

The debug message at rpcrdma_bc_receive_call are,

[56579.837169] RPC:       rpcrdma_bc_receive_call: callback XID
00000001, length=20
[56579.837174] RPC:       rpcrdma_bc_receive_call: 00 00 00 01 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 04

After that, rpcrdma_bc_receive_call will meets NULL pointer as,

[  226.057890] BUG: unable to handle kernel NULL pointer dereference at
00000000000000c8
...
[  226.058704] RIP: 0010:_raw_spin_lock+0xc/0x20
...
[  226.059732] Call Trace:
[  226.059878]  rpcrdma_bc_receive_call+0x138/0x327 [rpcrdma]
[  226.060011]  __ib_process_cq+0x89/0x170 [ib_core]
[  226.060092]  ib_cq_poll_work+0x26/0x80 [ib_core]
[  226.060257]  process_one_work+0x1a7/0x360
[  226.060367]  ? create_worker+0x1a0/0x1a0
[  226.060440]  worker_thread+0x30/0x390
[  226.060500]  ? create_worker+0x1a0/0x1a0
[  226.060574]  kthread+0x116/0x130
[  226.060661]  ? kthread_flush_work_fn+0x10/0x10
[  226.060724]  ret_from_fork+0x35/0x40
...

Signed-off-by: Kinglong Mee <kinglongmee@gmail.com>
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index f2eaf264726b..3d65a2bccfc7 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -980,6 +980,7 @@ static bool
 rpcrdma_is_bcall(struct rpcrdma_xprt *r_xprt, struct rpcrdma_rep *rep)
 #if defined(CONFIG_SUNRPC_BACKCHANNEL)
 {
+	struct rpc_xprt *xprt = &r_xprt->rx_xprt;
 	struct xdr_stream *xdr = &rep->rr_stream;
 	__be32 *p;
 
@@ -1003,6 +1004,10 @@ rpcrdma_is_bcall(struct rpcrdma_xprt *r_xprt, struct rpcrdma_rep *rep)
 	if (*p != cpu_to_be32(RPC_CALL))
 		return false;
 
+	/* No bc service. */
+	if (xprt->bc_serv == NULL)
+		return false;
+
 	/* Now that we are sure this is a backchannel call,
 	 * advance to the RPC header.
 	 */
-- 
2.35.1



