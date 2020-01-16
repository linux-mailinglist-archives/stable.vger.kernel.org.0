Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82B0213FFCA
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390939AbgAPXWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:22:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:50740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390934AbgAPXWr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:22:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 135DF20684;
        Thu, 16 Jan 2020 23:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216966;
        bh=3oRBICP9LGTX4WZJ2m1pX3TqhBaRwmsSoXD/shiVEPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j6FeXBPjb/rlBS7Q7QTHHYyJo6O3zXyA+LfHjm/8T7GlDo8RA7KQyM2BOoWUNYFDW
         kjSdtUdLuil7HA0LtucVe03y6mYOafLki55zOQoKbZ3vaHUacIANtDFrz53NELRqI/
         K4/yl7piqKwd3wVxrlkRq4MdG6keSCMr2bc6FGe8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.4 093/203] xprtrdma: Fix create_qp crash on device unload
Date:   Fri, 17 Jan 2020 00:16:50 +0100
Message-Id: <20200116231753.806565095@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

commit b32b9ed493f938e191f790a0991d20b18b38c35b upstream.

On device re-insertion, the RDMA device driver crashes trying to set
up a new QP:

Nov 27 16:32:06 manet kernel: BUG: kernel NULL pointer dereference, address: 00000000000001c0
Nov 27 16:32:06 manet kernel: #PF: supervisor write access in kernel mode
Nov 27 16:32:06 manet kernel: #PF: error_code(0x0002) - not-present page
Nov 27 16:32:06 manet kernel: PGD 0 P4D 0
Nov 27 16:32:06 manet kernel: Oops: 0002 [#1] SMP
Nov 27 16:32:06 manet kernel: CPU: 1 PID: 345 Comm: kworker/u28:0 Tainted: G        W         5.4.0 #852
Nov 27 16:32:06 manet kernel: Hardware name: Supermicro SYS-6028R-T/X10DRi, BIOS 1.1a 10/16/2015
Nov 27 16:32:06 manet kernel: Workqueue: xprtiod xprt_rdma_connect_worker [rpcrdma]
Nov 27 16:32:06 manet kernel: RIP: 0010:atomic_try_cmpxchg+0x2/0x12
Nov 27 16:32:06 manet kernel: Code: ff ff 48 8b 04 24 5a c3 c6 07 00 0f 1f 40 00 c3 31 c0 48 81 ff 08 09 68 81 72 0c 31 c0 48 81 ff 83 0c 68 81 0f 92 c0 c3 8b 06 <f0> 0f b1 17 0f 94 c2 84 d2 75 02 89 06 88 d0 c3 53 ba 01 00 00 00
Nov 27 16:32:06 manet kernel: RSP: 0018:ffffc900035abbf0 EFLAGS: 00010046
Nov 27 16:32:06 manet kernel: RAX: 0000000000000000 RBX: 00000000000001c0 RCX: 0000000000000000
Nov 27 16:32:06 manet kernel: RDX: 0000000000000001 RSI: ffffc900035abbfc RDI: 00000000000001c0
Nov 27 16:32:06 manet kernel: RBP: ffffc900035abde0 R08: 000000000000000e R09: ffffffffffffc000
Nov 27 16:32:06 manet kernel: R10: 0000000000000000 R11: 000000000002e800 R12: ffff88886169d9f8
Nov 27 16:32:06 manet kernel: R13: ffff88886169d9f4 R14: 0000000000000246 R15: 0000000000000000
Nov 27 16:32:06 manet kernel: FS:  0000000000000000(0000) GS:ffff88846fa40000(0000) knlGS:0000000000000000
Nov 27 16:32:06 manet kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 27 16:32:06 manet kernel: CR2: 00000000000001c0 CR3: 0000000002009006 CR4: 00000000001606e0
Nov 27 16:32:06 manet kernel: Call Trace:
Nov 27 16:32:06 manet kernel: do_raw_spin_lock+0x2f/0x5a
Nov 27 16:32:06 manet kernel: create_qp_common.isra.47+0x856/0xadf [mlx4_ib]
Nov 27 16:32:06 manet kernel: ? slab_post_alloc_hook.isra.60+0xa/0x1a
Nov 27 16:32:06 manet kernel: ? __kmalloc+0x125/0x139
Nov 27 16:32:06 manet kernel: mlx4_ib_create_qp+0x57f/0x972 [mlx4_ib]

The fix is to copy the qp_init_attr struct that was just created by
rpcrdma_ep_create() instead of using the one from the previous
connection instance.

Fixes: 98ef77d1aaa7 ("xprtrdma: Send Queue size grows after a reconnect")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/xprtrdma/verbs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -607,6 +607,7 @@ static int rpcrdma_ep_recreate_xprt(stru
 				    struct ib_qp_init_attr *qp_init_attr)
 {
 	struct rpcrdma_ia *ia = &r_xprt->rx_ia;
+	struct rpcrdma_ep *ep = &r_xprt->rx_ep;
 	int rc, err;
 
 	trace_xprtrdma_reinsert(r_xprt);
@@ -621,6 +622,7 @@ static int rpcrdma_ep_recreate_xprt(stru
 		pr_err("rpcrdma: rpcrdma_ep_create returned %d\n", err);
 		goto out2;
 	}
+	memcpy(qp_init_attr, &ep->rep_attr, sizeof(*qp_init_attr));
 
 	rc = -ENETUNREACH;
 	err = rdma_create_qp(ia->ri_id, ia->ri_pd, qp_init_attr);


