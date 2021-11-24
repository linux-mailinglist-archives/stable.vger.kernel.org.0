Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6352445C53B
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353000AbhKXNzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:55:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:42266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354925AbhKXNxc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:53:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F4FE619F7;
        Wed, 24 Nov 2021 13:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759131;
        bh=k0iAscd78KxagczyzUd5GbKxl5GjlCQW7pmUdSRog2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AIjQQMDBcuNbMGBE/WmluFxtLn7iCI0RgBDf1kQcP603zNeXx4DP6ciSpckTpJCns
         eQpj4xWm7NeTfhBC9myGTwZDjAF3vglbxOBj2k9WbxUTTHXhna5T7zbVOC7Cup8YJ5
         47v2e2Up8Nz6okNRtDhmLBNfYcfja7aFVUKof9DI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 142/279] RDMA/core: Set send and receive CQ before forwarding to the driver
Date:   Wed, 24 Nov 2021 12:57:09 +0100
Message-Id: <20211124115723.687183796@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 6cd7397d01c4a3e09757840299e4f114f0aa5fa0 ]

Preset both receive and send CQ pointers prior to call to the drivers and
overwrite it later again till the mlx4 is going to be changed do not
overwrite ibqp properties.

This change is needed for mlx5, because in case of QP creation failure, it
will go to the path of QP destroy which relies on proper CQ pointers.

 BUG: KASAN: use-after-free in create_qp.cold+0x164/0x16e [mlx5_ib]
 Write of size 8 at addr ffff8880064c55c0 by task a.out/246

 CPU: 0 PID: 246 Comm: a.out Not tainted 5.15.0+ #291
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
 Call Trace:
  dump_stack_lvl+0x45/0x59
  print_address_description.constprop.0+0x1f/0x140
  kasan_report.cold+0x83/0xdf
  create_qp.cold+0x164/0x16e [mlx5_ib]
  mlx5_ib_create_qp+0x358/0x28a0 [mlx5_ib]
  create_qp.part.0+0x45b/0x6a0 [ib_core]
  ib_create_qp_user+0x97/0x150 [ib_core]
  ib_uverbs_handler_UVERBS_METHOD_QP_CREATE+0x92c/0x1250 [ib_uverbs]
  ib_uverbs_cmd_verbs+0x1c38/0x3150 [ib_uverbs]
  ib_uverbs_ioctl+0x169/0x260 [ib_uverbs]
  __x64_sys_ioctl+0x866/0x14d0
  do_syscall_64+0x3d/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xae

 Allocated by task 246:
  kasan_save_stack+0x1b/0x40
  __kasan_kmalloc+0xa4/0xd0
  create_qp.part.0+0x92/0x6a0 [ib_core]
  ib_create_qp_user+0x97/0x150 [ib_core]
  ib_uverbs_handler_UVERBS_METHOD_QP_CREATE+0x92c/0x1250 [ib_uverbs]
  ib_uverbs_cmd_verbs+0x1c38/0x3150 [ib_uverbs]
  ib_uverbs_ioctl+0x169/0x260 [ib_uverbs]
  __x64_sys_ioctl+0x866/0x14d0
  do_syscall_64+0x3d/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xae

 Freed by task 246:
  kasan_save_stack+0x1b/0x40
  kasan_set_track+0x1c/0x30
  kasan_set_free_info+0x20/0x30
  __kasan_slab_free+0x10c/0x150
  slab_free_freelist_hook+0xb4/0x1b0
  kfree+0xe7/0x2a0
  create_qp.part.0+0x52b/0x6a0 [ib_core]
  ib_create_qp_user+0x97/0x150 [ib_core]
  ib_uverbs_handler_UVERBS_METHOD_QP_CREATE+0x92c/0x1250 [ib_uverbs]
  ib_uverbs_cmd_verbs+0x1c38/0x3150 [ib_uverbs]
  ib_uverbs_ioctl+0x169/0x260 [ib_uverbs]
  __x64_sys_ioctl+0x866/0x14d0
  do_syscall_64+0x3d/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: 514aee660df4 ("RDMA: Globally allocate and release QP memory")
Link: https://lore.kernel.org/r/2dbb2e2cbb1efb188a500e5634be1d71956424ce.1636631035.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/verbs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 89a2b21976d63..20a46d8731455 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1232,6 +1232,9 @@ static struct ib_qp *create_qp(struct ib_device *dev, struct ib_pd *pd,
 	INIT_LIST_HEAD(&qp->rdma_mrs);
 	INIT_LIST_HEAD(&qp->sig_mrs);
 
+	qp->send_cq = attr->send_cq;
+	qp->recv_cq = attr->recv_cq;
+
 	rdma_restrack_new(&qp->res, RDMA_RESTRACK_QP);
 	WARN_ONCE(!udata && !caller, "Missing kernel QP owner");
 	rdma_restrack_set_name(&qp->res, udata ? NULL : caller);
-- 
2.33.0



