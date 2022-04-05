Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61DC34F381B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376318AbiDELVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349379AbiDEJtq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:46 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7371140D4;
        Tue,  5 Apr 2022 02:44:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4264BCE1C99;
        Tue,  5 Apr 2022 09:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D432C385A1;
        Tue,  5 Apr 2022 09:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151881;
        bh=JrpgfPZriwtLYhO8teFG0FTJO+BmkrH9SYNl8YqsT4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oiaYJcmgfMF+ziJ18lzDbIb0SCRTUA6yODhj4D+UZ4+tbFH+CmRDOvpPSio0cGIoT
         YknfK6o2NsAWQVwH2gIX60vs7tTOA1RKt6vyUElcaKxKr3SRIdClwSNz7ahMkMpXEc
         xP9kw6DORP+6St19KyzasbGvmKsIKd2PZttfx7Eg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 538/913] Revert "RDMA/core: Fix ib_qp_usecnt_dec() called when error"
Date:   Tue,  5 Apr 2022 09:26:40 +0200
Message-Id: <20220405070355.975998475@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 7922d3de4d270a9aedb71212fc0d5ae697ced516 ]

This reverts commit 7c4a539ec38f4ce400a0f3fcb5ff6c940fcd67bb. which causes
to the following error in mlx4.

  Destroy of kernel CQ shouldn't fail
  WARNING: CPU: 4 PID: 18064 at include/rdma/ib_verbs.h:3936 mlx4_ib_dealloc_xrcd+0x12e/0x1b0 [mlx4_ib]
  Modules linked in: bonding ib_ipoib ip_gre ipip tunnel4 geneve rdma_ucm nf_tables ib_umad mlx4_en mlx4_ib ib_uverbs mlx4_core ip6_gre gre ip6_tunnel tunnel6 iptable_raw openvswitch nsh rpcrdma ib_iser libiscsi scsi_transport_iscsi rdma_cm iw_cm ib_cm ib_core xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype iptable_nat nf_nat br_netfilter overlay fuse [last unloaded: mlx4_core]
  CPU: 4 PID: 18064 Comm: ibv_xsrq_pingpo Not tainted 5.17.0-rc7_master_62c6ecb #1
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
  RIP: 0010:mlx4_ib_dealloc_xrcd+0x12e/0x1b0 [mlx4_ib]
  Code: 1e 93 08 00 40 80 fd 01 0f 87 fa f1 04 00 83 e5 01 0f 85 2b ff ff ff 48 c7 c7 20 4f b6 a0 c6 05 fd 92 08 00 01 e8 47 c9 82 e2 <0f> 0b e9 11 ff ff ff 0f b6 2d eb 92 08 00 40 80 fd 01 0f 87 b1 f1
  RSP: 0018:ffff8881a4957750 EFLAGS: 00010286
  RAX: 0000000000000000 RBX: ffff8881ac4b6800 RCX: 0000000000000000
  RDX: 0000000000000027 RSI: 0000000000000004 RDI: ffffed103492aedc
  RBP: 0000000000000000 R08: 0000000000000001 R09: ffff8884d2e378eb
  R10: ffffed109a5c6f1d R11: 0000000000000001 R12: ffff888132620000
  R13: ffff8881a4957a90 R14: ffff8881aa2d4000 R15: ffff8881a4957ad0
  FS:  00007f0401747740(0000) GS:ffff8884d2e00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 000055f8ae036118 CR3: 000000012fe94005 CR4: 0000000000370ea0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   <TASK>
   ib_dealloc_xrcd_user+0xce/0x120 [ib_core]
   ib_uverbs_dealloc_xrcd+0xad/0x210 [ib_uverbs]
   uverbs_free_xrcd+0xe8/0x190 [ib_uverbs]
   destroy_hw_idr_uobject+0x7a/0x130 [ib_uverbs]
   uverbs_destroy_uobject+0x164/0x730 [ib_uverbs]
   uobj_destroy+0x72/0xf0 [ib_uverbs]
   ib_uverbs_cmd_verbs+0x19fb/0x3110 [ib_uverbs]
   ib_uverbs_ioctl+0x169/0x260 [ib_uverbs]
   __x64_sys_ioctl+0x856/0x1550
   do_syscall_64+0x3d/0x90
   entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: 7c4a539ec38f ("RDMA/core: Fix ib_qp_usecnt_dec() called when error")
Link: https://lore.kernel.org/r/74c11029adaf449b3b9228a77cc82f39e9e892c8.1646851220.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_cmd.c          | 1 +
 drivers/infiniband/core/uverbs_std_types_qp.c | 1 +
 drivers/infiniband/core/verbs.c               | 3 ++-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 5a99e31df5f5..d1345d76d9b1 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1438,6 +1438,7 @@ static int create_qp(struct uverbs_attr_bundle *attrs,
 		ret = PTR_ERR(qp);
 		goto err_put;
 	}
+	ib_qp_usecnt_inc(qp);
 
 	obj->uevent.uobject.object = qp;
 	obj->uevent.event_file = READ_ONCE(attrs->ufile->default_async_file);
diff --git a/drivers/infiniband/core/uverbs_std_types_qp.c b/drivers/infiniband/core/uverbs_std_types_qp.c
index 75353e09c6fe..dd1075466f61 100644
--- a/drivers/infiniband/core/uverbs_std_types_qp.c
+++ b/drivers/infiniband/core/uverbs_std_types_qp.c
@@ -254,6 +254,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE)(
 		ret = PTR_ERR(qp);
 		goto err_put;
 	}
+	ib_qp_usecnt_inc(qp);
 
 	if (attr.qp_type == IB_QPT_XRC_TGT) {
 		obj->uxrcd = container_of(xrcd_uobj, struct ib_uxrcd_object,
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index b78cd65d20a6..59e20936b800 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1253,7 +1253,6 @@ static struct ib_qp *create_qp(struct ib_device *dev, struct ib_pd *pd,
 	if (ret)
 		goto err_security;
 
-	ib_qp_usecnt_inc(qp);
 	rdma_restrack_add(&qp->res);
 	return qp;
 
@@ -1354,6 +1353,8 @@ struct ib_qp *ib_create_qp_kernel(struct ib_pd *pd,
 	if (IS_ERR(qp))
 		return qp;
 
+	ib_qp_usecnt_inc(qp);
+
 	if (qp_init_attr->cap.max_rdma_ctxs) {
 		ret = rdma_rw_init_mrs(qp, qp_init_attr);
 		if (ret)
-- 
2.34.1



