Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E594B4F3252
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242307AbiDEIhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238535AbiDEITK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:19:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D779E0F3;
        Tue,  5 Apr 2022 01:09:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C309B81BB1;
        Tue,  5 Apr 2022 08:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB69C385A1;
        Tue,  5 Apr 2022 08:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146143;
        bh=u4tXa0GGjmzZfPuyaGK+qz2ziwENaCYDi8oAWOxIsZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WNsp50xCEG1Rm8fthmi38X3XGlWs31ZUP9WIEk5suib9AgqUH0Lp+8+nmu546eMKn
         3mRnRqpY4X46oUTstVFDNUVu2Z2SwLybO3TaYxC2PiMa2aS6wV2DyC+34WMSODY0zL
         6Gd/vKLjcp/Y4P9n+A++KP67/I36QtBEcSZm5824=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0658/1126] Revert "RDMA/core: Fix ib_qp_usecnt_dec() called when error"
Date:   Tue,  5 Apr 2022 09:23:25 +0200
Message-Id: <20220405070426.943352888@linuxfoundation.org>
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
index 4437f834c0a7..6b6393176b3c 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1437,6 +1437,7 @@ static int create_qp(struct uverbs_attr_bundle *attrs,
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
index 961055eb330d..e821dc94a43e 100644
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



