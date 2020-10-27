Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC0E29B25D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750060AbgJ0Ojp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:39:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761437AbgJ0Ojo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:39:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6B9E222E9;
        Tue, 27 Oct 2020 14:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809583;
        bh=VyKMO4b7HunskFaXyAIOitqClm9OmAIOnWQWz6nRZRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SzOD+OlYqCBnhwZiMNtak16/+pvmP9ivb/E5OJt4CY3TUmpCzZQGigH9H8KH1uA5J
         OYAUPHr8nFb2eIL+sGjMbihnMxbFbq+mwJVF0gwdNAGYYtcMl1ji8jtABdBehziijn
         W2E6yIKqnI5r9JcyN2YdmnLKe78zJguKmpPpyYHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 218/408] RDMA/qedr: Fix qp structure memory leak
Date:   Tue, 27 Oct 2020 14:52:36 +0100
Message-Id: <20201027135505.200045182@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Kalderon <michal.kalderon@marvell.com>

[ Upstream commit 098e345a1a8faaad6e4e54d138773466cecc45d4 ]

The qedr_qp structure wasn't freed when the protocol was RoCE.  kmemleak
output when running basic RoCE scenario.

unreferenced object 0xffff927ad7e22c00 (size 1024):
  comm "ib_send_bw", pid 7082, jiffies 4384133693 (age 274.698s)
  hex dump (first 32 bytes):
    00 b0 cd a2 79 92 ff ff 00 3f a1 a2 79 92 ff ff  ....y....?..y...
    00 ee 5c dd 80 92 ff ff 00 f6 5c dd 80 92 ff ff  ..\.......\.....
  backtrace:
    [<00000000b2ba0f35>] qedr_create_qp+0xb3/0x6c0 [qedr]
    [<00000000e85a43dd>] ib_uverbs_handler_UVERBS_METHOD_QP_CREATE+0x555/0xad0 [ib_uverbs]
    [<00000000fee4d029>] ib_uverbs_cmd_verbs+0xa5a/0xb80 [ib_uverbs]
    [<000000005d622660>] ib_uverbs_ioctl+0xa4/0x110 [ib_uverbs]
    [<00000000eb4cdc71>] ksys_ioctl+0x87/0xc0
    [<00000000abe6b23a>] __x64_sys_ioctl+0x16/0x20
    [<0000000046e7cef4>] do_syscall_64+0x4d/0x90
    [<00000000c6948f76>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 1212767e23bb ("qedr: Add wrapping generic structure for qpidr and adjust idr routines.")
Link: https://lore.kernel.org/r/20200902165741.8355-2-michal.kalderon@marvell.com
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 16a994fd7d0a7..682329789d00d 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -2518,6 +2518,8 @@ int qedr_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 
 	if (rdma_protocol_iwarp(&dev->ibdev, 1))
 		qedr_iw_qp_rem_ref(&qp->ibqp);
+	else
+		kfree(qp);
 
 	return 0;
 }
-- 
2.25.1



