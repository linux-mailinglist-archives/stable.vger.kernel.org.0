Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9A0A657B50
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbiL1PUN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:20:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233291AbiL1PUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:20:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85A313FB3
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:20:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48A9761544
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CDC9C433D2;
        Wed, 28 Dec 2022 15:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240809;
        bh=CP7a1J3UzcHjL/T2hHMHh/H4J7EkKLK09p9FIS0JKqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gFAFEDTVvQ4AehPS9euCSUysQ1zjBVld3u7jSGoXYe1Nsil/4E193xRgztMILJOT2
         BoYC0v96cTEDa9NKAQeqVW/4MOihAq4ij2143z8PM9MH9PI+SnrKkjCuxVVj9VkVjT
         p1HDr4cW7Xdsd+iBRMz+ZxDVMHbM4v7ADb5DNW8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 400/731] RDMA/rxe: Fix NULL-ptr-deref in rxe_qp_do_cleanup() when socket create failed
Date:   Wed, 28 Dec 2022 15:38:27 +0100
Message-Id: <20221228144308.160899631@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit f67376d801499f4fa0838c18c1efcad8840e550d ]

There is a null-ptr-deref when mount.cifs over rdma:

  BUG: KASAN: null-ptr-deref in rxe_qp_do_cleanup+0x2f3/0x360 [rdma_rxe]
  Read of size 8 at addr 0000000000000018 by task mount.cifs/3046

  CPU: 2 PID: 3046 Comm: mount.cifs Not tainted 6.1.0-rc5+ #62
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1.fc3
  Call Trace:
   <TASK>
   dump_stack_lvl+0x34/0x44
   kasan_report+0xad/0x130
   rxe_qp_do_cleanup+0x2f3/0x360 [rdma_rxe]
   execute_in_process_context+0x25/0x90
   __rxe_cleanup+0x101/0x1d0 [rdma_rxe]
   rxe_create_qp+0x16a/0x180 [rdma_rxe]
   create_qp.part.0+0x27d/0x340
   ib_create_qp_kernel+0x73/0x160
   rdma_create_qp+0x100/0x230
   _smbd_get_connection+0x752/0x20f0
   smbd_get_connection+0x21/0x40
   cifs_get_tcp_session+0x8ef/0xda0
   mount_get_conns+0x60/0x750
   cifs_mount+0x103/0xd00
   cifs_smb3_do_mount+0x1dd/0xcb0
   smb3_get_tree+0x1d5/0x300
   vfs_get_tree+0x41/0xf0
   path_mount+0x9b3/0xdd0
   __x64_sys_mount+0x190/0x1d0
   do_syscall_64+0x35/0x80
   entry_SYSCALL_64_after_hwframe+0x46/0xb0

The root cause of the issue is the socket create failed in
rxe_qp_init_req().

So move the reset rxe_qp_do_cleanup() after the NULL ptr check.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/r/20221122151437.1057671-1-zhangxiaoxu5@huawei.com
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_qp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 57ebf4871608..d7a968356a9b 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -830,12 +830,12 @@ static void rxe_qp_do_cleanup(struct work_struct *work)
 		qp->resp.mr = NULL;
 	}
 
-	if (qp_type(qp) == IB_QPT_RC)
-		sk_dst_reset(qp->sk->sk);
-
 	free_rd_atomic_resources(qp);
 
 	if (qp->sk) {
+		if (qp_type(qp) == IB_QPT_RC)
+			sk_dst_reset(qp->sk->sk);
+
 		kernel_sock_shutdown(qp->sk, SHUT_RDWR);
 		sock_release(qp->sk);
 	}
-- 
2.35.1



