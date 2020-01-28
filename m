Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDE114BA9A
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729793AbgA1OQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:16:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:39612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729550AbgA1OQS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:16:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80AC124694;
        Tue, 28 Jan 2020 14:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220978;
        bh=cCRQP4ZGQutVXdIRbfZqYD0v7C8VIcC0uXbm8c6TcI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gDgdBXLWo9IKcfgV0S/zHAIvV41/MKwI5unK7xHSwPBxvWUoKKsntv3NAodo3a8Qj
         sjdREXjWkMXjB+OQOE2ZEc7QaHMWdxgh6cHeKkEmtnwbYdxN5yo5q3T1q3NEyp66gG
         +KCKsNtUJ9GhugIB8dyGz6q6SuOoUBz4VynzULG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gal Pressman <galpress@amazon.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 040/271] RDMA/qedr: Fix out of bounds index check in query pkey
Date:   Tue, 28 Jan 2020 15:03:09 +0100
Message-Id: <20200128135855.648442525@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
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
index cd0408c2b376f..7603a1641c7d8 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -54,7 +54,7 @@
 
 int qedr_query_pkey(struct ib_device *ibdev, u8 port, u16 index, u16 *pkey)
 {
-	if (index > QEDR_ROCE_PKEY_TABLE_LEN)
+	if (index >= QEDR_ROCE_PKEY_TABLE_LEN)
 		return -EINVAL;
 
 	*pkey = QEDR_ROCE_PKEY_DEFAULT;
-- 
2.20.1



