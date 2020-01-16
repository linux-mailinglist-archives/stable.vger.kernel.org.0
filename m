Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2FEB13E2C8
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387537AbgAPQ5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:57:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:45170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729830AbgAPQ5n (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:57:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E279924681;
        Thu, 16 Jan 2020 16:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193863;
        bh=2ogJrxCusEH0gfrYCALjRRYW/QPd+P+eeSdTKKA4tJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kar/78e3rgfKFO+/ijS9U6WK6rGFprI+D+Q0TuJAJi4LqvcYz52n3ngjrpHWtCf6x
         GFuhtOEFn6ehSL/7aPq8Lw20KOLxkr50i90fYJKbTlDtAoj+1gARUPCHmHmqcnZnv+
         +ev36IhS96kaqNZUUnBq203zgd8gfOMxaHAkzx+M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gal Pressman <galpress@amazon.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 110/671] RDMA/qedr: Fix out of bounds index check in query pkey
Date:   Thu, 16 Jan 2020 11:45:41 -0500
Message-Id: <20200116165502.8838-110-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
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
index 9167a1c40bcf..8fd8b97348bf 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -67,7 +67,7 @@ static inline int qedr_ib_copy_to_udata(struct ib_udata *udata, void *src,
 
 int qedr_query_pkey(struct ib_device *ibdev, u8 port, u16 index, u16 *pkey)
 {
-	if (index > QEDR_ROCE_PKEY_TABLE_LEN)
+	if (index >= QEDR_ROCE_PKEY_TABLE_LEN)
 		return -EINVAL;
 
 	*pkey = QEDR_ROCE_PKEY_DEFAULT;
-- 
2.20.1

