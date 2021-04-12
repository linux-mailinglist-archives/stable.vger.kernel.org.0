Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C01A35C088
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240114AbhDLJOT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:14:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240819AbhDLJLD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:11:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49501613BA;
        Mon, 12 Apr 2021 09:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218401;
        bh=mwPeOwYa6+TILM7b2Kj3bYsh7NxEiquG11SAkuDKt/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ahyPFh0l+qnHtgLR9WvNbv6elYzOoiy27kykWPZH8ZB7KXLcDzAx6M040IAJAVASj
         MAapmS6jusY8gAZFxJcX3Nxe+BBlFsEFcIGiMvW6YGRnGnZuFwzZPaOmYT81asFJ9v
         TUSfu0QdfqFRwy+eJICNkmk6c3vvX7tR0TVxVSO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 184/210] RDMA/qedr: Fix kernel panic when trying to access recv_cq
Date:   Mon, 12 Apr 2021 10:41:29 +0200
Message-Id: <20210412084022.133879626@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Heib <kamalheib1@gmail.com>

[ Upstream commit e1ad897b9c738d5550be6762bf3a6ef1672259a4 ]

As INI QP does not require a recv_cq, avoid the following null pointer
dereference by checking if the qp_type is not INI before trying to extract
the recv_cq.

BUG: kernel NULL pointer dereference, address: 00000000000000e0
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: 0000 [#1] SMP PTI
 CPU: 0 PID: 54250 Comm: mpitests-IMB-MP Not tainted 5.12.0-rc5 #1
 Hardware name: Dell Inc. PowerEdge R320/0KM5PX, BIOS 2.7.0 08/19/2019
 RIP: 0010:qedr_create_qp+0x378/0x820 [qedr]
 Code: 02 00 00 50 e8 29 d4 a9 d1 48 83 c4 18 e9 65 fe ff ff 48 8b 53 10 48 8b 43 18 44 8b 82 e0 00 00 00 45 85 c0 0f 84 10 74 00 00 <8b> b8 e0 00 00 00 85 ff 0f 85 50 fd ff ff e9 fd 73 00 00 48 8d bd
 RSP: 0018:ffff9c8f056f7a70 EFLAGS: 00010202
 RAX: 0000000000000000 RBX: ffff9c8f056f7b58 RCX: 0000000000000009
 RDX: ffff8c41a9744c00 RSI: ffff9c8f056f7b58 RDI: ffff8c41c0dfa280
 RBP: ffff8c41c0dfa280 R08: 0000000000000002 R09: 0000000000000001
 R10: 0000000000000000 R11: ffff8c41e06fc608 R12: ffff8c4194052000
 R13: 0000000000000000 R14: ffff8c4191546070 R15: ffff8c41c0dfa280
 FS:  00007f78b2787b80(0000) GS:ffff8c43a3200000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00000000000000e0 CR3: 00000001011d6002 CR4: 00000000001706f0
 Call Trace:
  ib_uverbs_handler_UVERBS_METHOD_QP_CREATE+0x4e4/0xb90 [ib_uverbs]
  ? ib_uverbs_cq_event_handler+0x30/0x30 [ib_uverbs]
  ib_uverbs_run_method+0x6f6/0x7a0 [ib_uverbs]
  ? ib_uverbs_handler_UVERBS_METHOD_QP_DESTROY+0x70/0x70 [ib_uverbs]
  ? __cond_resched+0x15/0x30
  ? __kmalloc+0x5a/0x440
  ib_uverbs_cmd_verbs+0x195/0x360 [ib_uverbs]
  ? xa_load+0x6e/0x90
  ? cred_has_capability+0x7c/0x130
  ? avc_has_extended_perms+0x17f/0x440
  ? vma_link+0xae/0xb0
  ? vma_set_page_prot+0x2a/0x60
  ? mmap_region+0x298/0x6c0
  ? do_mmap+0x373/0x520
  ? selinux_file_ioctl+0x17f/0x220
  ib_uverbs_ioctl+0xa7/0x110 [ib_uverbs]
  __x64_sys_ioctl+0x84/0xc0
  do_syscall_64+0x33/0x40
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7f78b120262b

Fixes: 06e8d1df46ed ("RDMA/qedr: Add support for user mode XRC-SRQ's")
Link: https://lore.kernel.org/r/20210404125501.154789-1-kamalheib1@gmail.com
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 0eb6a7a618e0..9ea542270ed4 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -1244,7 +1244,8 @@ static int qedr_check_qp_attrs(struct ib_pd *ibpd, struct qedr_dev *dev,
 	 * TGT QP isn't associated with RQ/SQ
 	 */
 	if ((attrs->qp_type != IB_QPT_GSI) && (dev->gsi_qp_created) &&
-	    (attrs->qp_type != IB_QPT_XRC_TGT)) {
+	    (attrs->qp_type != IB_QPT_XRC_TGT) &&
+	    (attrs->qp_type != IB_QPT_XRC_INI)) {
 		struct qedr_cq *send_cq = get_qedr_cq(attrs->send_cq);
 		struct qedr_cq *recv_cq = get_qedr_cq(attrs->recv_cq);
 
-- 
2.30.2



