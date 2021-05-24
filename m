Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3450138EF6C
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235005AbhEXP51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:57:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234557AbhEXP4b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:56:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6585461457;
        Mon, 24 May 2021 15:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870974;
        bh=vf1coNbYQp2Fl7VwcfI2tqUoLExfsfhtsgdG0UjBLkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k/4xLZx89IWGoMxzMjwZIAwXbeMi5q7s8vYOmvsAxamOZrypYpoYWikbCUpcSpm7W
         efv1W+ChRIvcINTgMaLhSDPqQqh6AuYk5ohchDy9sxxItlYTUrpUEy/1JFv1DBvwvH
         MvL6eMhpzWXnoW/o6RqGJx55kF42Uuqzq4IsOvA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 016/127] RDMA/core: Dont access cm_id after its destruction
Date:   Mon, 24 May 2021 17:25:33 +0200
Message-Id: <20210524152335.406314882@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 889d916b6f8a48b8c9489fffcad3b78eedd01a51 ]

restrack should only be attached to a cm_id while the ID has a valid
device pointer. It is set up when the device is first loaded, but not
cleared when the device is removed. There is also two copies of the device
pointer, one private and one in the public API, and these were left out of
sync.

Make everything go to NULL together and manipulate restrack right around
the device assignments.

Found by syzcaller:
BUG: KASAN: wild-memory-access in __list_del include/linux/list.h:112 [inline]
BUG: KASAN: wild-memory-access in __list_del_entry include/linux/list.h:135 [inline]
BUG: KASAN: wild-memory-access in list_del include/linux/list.h:146 [inline]
BUG: KASAN: wild-memory-access in cma_cancel_listens drivers/infiniband/core/cma.c:1767 [inline]
BUG: KASAN: wild-memory-access in cma_cancel_operation drivers/infiniband/core/cma.c:1795 [inline]
BUG: KASAN: wild-memory-access in cma_cancel_operation+0x1f4/0x4b0 drivers/infiniband/core/cma.c:1783
Write of size 8 at addr dead000000000108 by task syz-executor716/334

CPU: 0 PID: 334 Comm: syz-executor716 Not tainted 5.11.0+ #271
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0xbe/0xf9 lib/dump_stack.c:120
 __kasan_report mm/kasan/report.c:400 [inline]
 kasan_report.cold+0x5f/0xd5 mm/kasan/report.c:413
 __list_del include/linux/list.h:112 [inline]
 __list_del_entry include/linux/list.h:135 [inline]
 list_del include/linux/list.h:146 [inline]
 cma_cancel_listens drivers/infiniband/core/cma.c:1767 [inline]
 cma_cancel_operation drivers/infiniband/core/cma.c:1795 [inline]
 cma_cancel_operation+0x1f4/0x4b0 drivers/infiniband/core/cma.c:1783
 _destroy_id+0x29/0x460 drivers/infiniband/core/cma.c:1862
 ucma_close_id+0x36/0x50 drivers/infiniband/core/ucma.c:185
 ucma_destroy_private_ctx+0x58d/0x5b0 drivers/infiniband/core/ucma.c:576
 ucma_close+0x91/0xd0 drivers/infiniband/core/ucma.c:1797
 __fput+0x169/0x540 fs/file_table.c:280
 task_work_run+0xb7/0x100 kernel/task_work.c:140
 exit_task_work include/linux/task_work.h:30 [inline]
 do_exit+0x7da/0x17f0 kernel/exit.c:825
 do_group_exit+0x9e/0x190 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x2d/0x30 kernel/exit.c:931
 do_syscall_64+0x2d/0x40 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 255d0c14b375 ("RDMA/cma: rdma_bind_addr() leaks a cma_dev reference count")
Link: https://lore.kernel.org/r/3352ee288fe34f2b44220457a29bfc0548686363.1620711734.git.leonro@nvidia.com
Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 6ac07911a17b..5b9022a8c9ec 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -482,6 +482,7 @@ static void cma_release_dev(struct rdma_id_private *id_priv)
 	list_del(&id_priv->list);
 	cma_dev_put(id_priv->cma_dev);
 	id_priv->cma_dev = NULL;
+	id_priv->id.device = NULL;
 	if (id_priv->id.route.addr.dev_addr.sgid_attr) {
 		rdma_put_gid_attr(id_priv->id.route.addr.dev_addr.sgid_attr);
 		id_priv->id.route.addr.dev_addr.sgid_attr = NULL;
@@ -1864,6 +1865,7 @@ static void _destroy_id(struct rdma_id_private *id_priv,
 				iw_destroy_cm_id(id_priv->cm_id.iw);
 		}
 		cma_leave_mc_groups(id_priv);
+		rdma_restrack_del(&id_priv->res);
 		cma_release_dev(id_priv);
 	}
 
@@ -1877,7 +1879,6 @@ static void _destroy_id(struct rdma_id_private *id_priv,
 	kfree(id_priv->id.route.path_rec);
 
 	put_net(id_priv->id.route.addr.dev_addr.net);
-	rdma_restrack_del(&id_priv->res);
 	kfree(id_priv);
 }
 
@@ -3740,7 +3741,7 @@ int rdma_listen(struct rdma_cm_id *id, int backlog)
 	}
 
 	id_priv->backlog = backlog;
-	if (id->device) {
+	if (id_priv->cma_dev) {
 		if (rdma_cap_ib_cm(id->device, 1)) {
 			ret = cma_ib_listen(id_priv);
 			if (ret)
-- 
2.30.2



