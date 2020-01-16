Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38AD013E62A
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391488AbgAPRSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:18:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:46136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391482AbgAPRSa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:18:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D63B246C2;
        Thu, 16 Jan 2020 17:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195110;
        bh=2/v5QHfw3l8zGdaCEudsJ1pkGUVVaiN2NA4Ytun8qr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oCce6H37jyJUPVqypYB1M+UWJTORold8e2jmfw8+bgUN3md4hIitJ+hLzMI/oWQjh
         hBpgHyPvhylJJ17i+l4xaACunn/U480nqDszn5eEb65KGJyRA+b0x8GC6itN1bMN+M
         1Rs6vYpfOMKkbXkOySogO6A0Ce0SqTbTFH1lPoFU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gal Pressman <galpress@amazon.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 052/371] RDMA/qedr: Fix out of bounds index check in query pkey
Date:   Thu, 16 Jan 2020 12:12:00 -0500
Message-Id: <20200116171719.16965-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116171719.16965-1-sashal@kernel.org>
References: <20200116171719.16965-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gal Pressman <galpress@amazon.com>

[ Upstream commit dbe30dae487e1a232158c24b432d45281c2805b7 ]

The pkey table size is QEDR_ROCE_PKEY_TABLE_LEN, index should be tested
for >= QEDR_ROCE_PKEY_TABLE_LEN instead of > QEDR_ROCE_PKEY_TABLE_LEN.

Fixes: a7efd7773e31 ("qedr: Add support for PD,PKEY and CQ verbs")
Signed-off-by: Gal Pressman <galpress@amazon.com>
Acked-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 656e7c1a4449..8bfe9073da78 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -63,7 +63,7 @@ static inline int qedr_ib_copy_to_udata(struct ib_udata *udata, void *src,
 
 int qedr_query_pkey(struct ib_device *ibdev, u8 port, u16 index, u16 *pkey)
 {
-	if (index > QEDR_ROCE_PKEY_TABLE_LEN)
+	if (index >= QEDR_ROCE_PKEY_TABLE_LEN)
 		return -EINVAL;
 
 	*pkey = QEDR_ROCE_PKEY_DEFAULT;
-- 
2.20.1

