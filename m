Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 555FB26EB7C
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbgIRCFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:05:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727552AbgIRCFb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:05:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4468D238A0;
        Fri, 18 Sep 2020 02:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394729;
        bh=Ft50cF0MuhbQrKK3V7Zti76wllVU65zW4BxljG/MI9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gvLatr+v4bB2NL+gUcQHW9hrQzThnOigpjyktc6KxddR29mAuRIQKfWQAcHIBwH1f
         Cz54MSuEc0wEtKgaiOYLxWjZtmcBDpeuWXquCoFsYl342J+2v9uobsTLmN+nk9gBdA
         OhtlDHAJK3QY6GWQu89uMjTzd0NvEFNFotI2lW2M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergey Gorenko <sergeygo@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 211/330] IB/iser: Always check sig MR before putting it to the free pool
Date:   Thu, 17 Sep 2020 21:59:11 -0400
Message-Id: <20200918020110.2063155-211-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Gorenko <sergeygo@mellanox.com>

[ Upstream commit 26e28deb813eed908cf31a6052870b6493ec0e86 ]

libiscsi calls the check_protection transport handler only if SCSI-Respose
is received. So, the handler is never called if iSCSI task is completed
for some other reason like a timeout or error handling. And this behavior
looks correct. But the iSER does not handle this case properly because it
puts a non-checked signature MR to the free pool. Then the error occurs at
reusing the MR because it is not allowed to invalidate a signature MR
without checking.

This commit adds an extra check to iser_unreg_mem_fastreg(), which is a
part of the task cleanup flow. Now the signature MR is checked there if it
is needed.

Link: https://lore.kernel.org/r/20200325151210.1548-1-sergeygo@mellanox.com
Signed-off-by: Sergey Gorenko <sergeygo@mellanox.com>
Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/iser/iser_memory.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 2cc89a9b9e9bb..ea8e611397a3b 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -292,12 +292,27 @@ void iser_unreg_mem_fastreg(struct iscsi_iser_task *iser_task,
 {
 	struct iser_device *device = iser_task->iser_conn->ib_conn.device;
 	struct iser_mem_reg *reg = &iser_task->rdma_reg[cmd_dir];
+	struct iser_fr_desc *desc;
+	struct ib_mr_status mr_status;
 
-	if (!reg->mem_h)
+	desc = reg->mem_h;
+	if (!desc)
 		return;
 
-	device->reg_ops->reg_desc_put(&iser_task->iser_conn->ib_conn,
-				     reg->mem_h);
+	/*
+	 * The signature MR cannot be invalidated and reused without checking.
+	 * libiscsi calls the check_protection transport handler only if
+	 * SCSI-Response is received. And the signature MR is not checked if
+	 * the task is completed for some other reason like a timeout or error
+	 * handling. That's why we must check the signature MR here before
+	 * putting it to the free pool.
+	 */
+	if (unlikely(desc->sig_protected)) {
+		desc->sig_protected = false;
+		ib_check_mr_status(desc->rsc.sig_mr, IB_MR_CHECK_SIG_STATUS,
+				   &mr_status);
+	}
+	device->reg_ops->reg_desc_put(&iser_task->iser_conn->ib_conn, desc);
 	reg->mem_h = NULL;
 }
 
-- 
2.25.1

