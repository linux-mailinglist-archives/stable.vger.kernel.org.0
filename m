Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A6A5491C7
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350175AbiFMK7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349581AbiFMK5W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:57:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F82725C68;
        Mon, 13 Jun 2022 03:32:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73165B80EA8;
        Mon, 13 Jun 2022 10:32:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A80C34114;
        Mon, 13 Jun 2022 10:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116334;
        bh=3sEpLrvvO/uTRcRbh2J/sUJLoAvJDDtp0BA43wGp+94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4A6SSTuVujUh2WBLNA9bg83E2/v3TY4K3XOD7N9v2srhFGhDr4q/pf1Xn1kqXS+i
         9Ab/gUJIkF6HbiB/I2Bn4sevPaZx8Bez+W6MvEC2/JwdEoJx49PVSnUPBUtAvqTHUT
         egoN2AJRSnQ9Iivl6ouaOhdsT8GyQvEOZZ3WWOrQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kinglong Mee <kinglongmee@gmail.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 172/218] xprtrdma: treat all calls not a bcall when bc_serv is NULL
Date:   Mon, 13 Jun 2022 12:10:30 +0200
Message-Id: <20220613094925.821320025@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
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
index 991d5a96f35b..030bf17a20b6 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -974,6 +974,7 @@ rpcrdma_is_bcall(struct rpcrdma_xprt *r_xprt, struct rpcrdma_rep *rep,
 		 __be32 xid, __be32 proc)
 #if defined(CONFIG_SUNRPC_BACKCHANNEL)
 {
+	struct rpc_xprt *xprt = &r_xprt->rx_xprt;
 	struct xdr_stream *xdr = &rep->rr_stream;
 	__be32 *p;
 
@@ -997,6 +998,10 @@ rpcrdma_is_bcall(struct rpcrdma_xprt *r_xprt, struct rpcrdma_rep *rep,
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



