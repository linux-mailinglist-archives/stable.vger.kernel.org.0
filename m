Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CAF27CB68
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732400AbgI2M1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:27:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728725AbgI2LdY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:33:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 830A823B46;
        Tue, 29 Sep 2020 11:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378770;
        bh=ti6HRQ/IcV2A2YJFoLnGunt84o8zR3wRKUG8qEzCUk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pv4w4ooPoMpz4E4A4aRulsZY3FoRKiq8FRrJiKAMn475h27tffk9n5M+JZAYNughb
         0bqe3DOJ48iPDRq0h8TML6oDrWO412nd4A4KmiC8Z+CZT2Yt3rXqXlfttslXURxGgZ
         S70oqcowgKZDyuzgc/mvdW2gSfVG9gpqvt/q0oik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 132/245] svcrdma: Fix leak of transport addresses
Date:   Tue, 29 Sep 2020 12:59:43 +0200
Message-Id: <20200929105953.412944357@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 1a33d8a284b1e85e03b8c7b1ea8fb985fccd1d71 ]

Kernel memory leak detected:

unreferenced object 0xffff888849cdf480 (size 8):
  comm "kworker/u8:3", pid 2086, jiffies 4297898756 (age 4269.856s)
  hex dump (first 8 bytes):
    30 00 cd 49 88 88 ff ff                          0..I....
  backtrace:
    [<00000000acfc370b>] __kmalloc_track_caller+0x137/0x183
    [<00000000a2724354>] kstrdup+0x2b/0x43
    [<0000000082964f84>] xprt_rdma_format_addresses+0x114/0x17d [rpcrdma]
    [<00000000dfa6ed00>] xprt_setup_rdma_bc+0xc0/0x10c [rpcrdma]
    [<0000000073051a83>] xprt_create_transport+0x3f/0x1a0 [sunrpc]
    [<0000000053531a8e>] rpc_create+0x118/0x1cd [sunrpc]
    [<000000003a51b5f8>] setup_callback_client+0x1a5/0x27d [nfsd]
    [<000000001bd410af>] nfsd4_process_cb_update.isra.7+0x16c/0x1ac [nfsd]
    [<000000007f4bbd56>] nfsd4_run_cb_work+0x4c/0xbd [nfsd]
    [<0000000055c5586b>] process_one_work+0x1b2/0x2fe
    [<00000000b1e3e8ef>] worker_thread+0x1a6/0x25a
    [<000000005205fb78>] kthread+0xf6/0xfb
    [<000000006d2dc057>] ret_from_fork+0x3a/0x50

Introduce a call to xprt_rdma_free_addresses() similar to the way
that the TCP backchannel releases a transport's peer address
strings.

Fixes: 5d252f90a800 ("svcrdma: Add class for RDMA backwards direction transport")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_backchannel.c b/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
index b9827665ff355..d183d4aee822c 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
@@ -256,6 +256,7 @@ xprt_rdma_bc_put(struct rpc_xprt *xprt)
 {
 	dprintk("svcrdma: %s: xprt %p\n", __func__, xprt);
 
+	xprt_rdma_free_addresses(xprt);
 	xprt_free(xprt);
 	module_put(THIS_MODULE);
 }
-- 
2.25.1



