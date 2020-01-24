Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE535147BE3
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732386AbgAXJrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:47:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:46872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730667AbgAXJrK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:47:10 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06275206D5;
        Fri, 24 Jan 2020 09:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859230;
        bh=K2XlFAo+7Nr8H9m2C1bQsibYstaZuOfaDgmwvGixCPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nFeb7Ul6u3F8YIEyD3aWGb0MTm/5riYqa7X3uwV7P8T7GnSHJemwOweLNvdGHYlS/
         Ud8TRyG/nVibSOoePWc5sxP42AuoHvSM+gEP7UWAi9Xb62MdKe4vIZIbsrM7uxt/u+
         KQwQdpTJxH6ujkxR/YK5rTbu0wfYfMfBfVYidV1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gal Pressman <galpress@amazon.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 059/343] RDMA/qedr: Fix out of bounds index check in query pkey
Date:   Fri, 24 Jan 2020 10:27:57 +0100
Message-Id: <20200124092927.609911010@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 656e7c1a4449f..8bfe9073da78c 100644
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



