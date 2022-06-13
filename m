Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA74E549866
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355124AbiFMLhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354373AbiFMLey (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:34:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F4EF43AF4;
        Mon, 13 Jun 2022 03:47:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92D75B80D41;
        Mon, 13 Jun 2022 10:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE52CC34114;
        Mon, 13 Jun 2022 10:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117276;
        bh=Sclf7lVmV+mqd2eS8IKNwFXIS2EI9KeHGxjc4ArTIkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sl2fzHM0C7ny+rXB6CZW8FknQqayQs93SMlaHDd+FZqPOBqn3ys+BFwplcMoFytIS
         tgjnACLjSpLzX6zLF+aIuUgR+WAI2W2uKkNTRSdwu9bjREcyES6KrpKA75qDKlpreu
         5pRAf6B+foQWVPXx3uvszGlCSinqH1p0br4ecEtE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kinglong Mee <kinglongmee@gmail.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 347/411] xprtrdma: treat all calls not a bcall when bc_serv is NULL
Date:   Mon, 13 Jun 2022 12:10:20 +0200
Message-Id: <20220613094939.113317188@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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
index c091417bd799..60aaed9457e4 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -1042,6 +1042,7 @@ static bool
 rpcrdma_is_bcall(struct rpcrdma_xprt *r_xprt, struct rpcrdma_rep *rep)
 #if defined(CONFIG_SUNRPC_BACKCHANNEL)
 {
+	struct rpc_xprt *xprt = &r_xprt->rx_xprt;
 	struct xdr_stream *xdr = &rep->rr_stream;
 	__be32 *p;
 
@@ -1065,6 +1066,10 @@ rpcrdma_is_bcall(struct rpcrdma_xprt *r_xprt, struct rpcrdma_rep *rep)
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



