Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFD227C88D
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbgI2MCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:02:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:32884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730418AbgI2Liw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:38:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1B792083B;
        Tue, 29 Sep 2020 11:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379532;
        bh=Ft50cF0MuhbQrKK3V7Zti76wllVU65zW4BxljG/MI9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0TeOME+YDaBLixIkBNIcAnPDEsvA/g1ykfJavGJWIAdnpTEL0QWjU3DtlfSPzScPJ
         TTnFJEZnQzk8PW8XXvuCsP8+Dv2Dvg5sYiO5GcfCsUnOD2M/VMR9xH7BzWMPmXxzs8
         DwM3IUlBWwdJk08YSav25KouPCAipPOx/uzebJ5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Gorenko <sergeygo@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 205/388] IB/iser: Always check sig MR before putting it to the free pool
Date:   Tue, 29 Sep 2020 12:58:56 +0200
Message-Id: <20200929110020.408009865@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



