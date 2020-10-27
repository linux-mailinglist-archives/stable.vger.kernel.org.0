Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3234229B4D4
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793560AbgJ0PHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:07:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1790230AbgJ0PEG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:04:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB35921D24;
        Tue, 27 Oct 2020 15:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811046;
        bh=NJacS4oBuVWWmLqcOvAH3Yozjh4PxvQaH9pRervH21s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rrUeHM93gnsIQWy+ZwBERVdC9VFypivlmJQL/diBj7SLQpNzviIvW85AYGaFxxdBw
         B9iXixljXto4e0YZ+ki0uw9PhnwEXvotsdz4Yfeeo/KOruxvbfF5a4eQcYqvlo0JKb
         dl+rQGFS9wHfB41NGYaUP8SWNSiI8nPmzfVkkzHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 355/633] RDMA/qedr: Fix doorbell setting
Date:   Tue, 27 Oct 2020 14:51:38 +0100
Message-Id: <20201027135539.340629519@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Kalderon <michal.kalderon@marvell.com>

[ Upstream commit 0b1eddc1964351cd5ce57aff46853ed4ce9ebbff ]

Change the doorbell setting so that the maximum value between the last and
current value is set. This is to avoid doorbells being lost.

Fixes: a7efd7773e31 ("qedr: Add support for PD,PKEY and CQ verbs")
Link: https://lore.kernel.org/r/20200902165741.8355-3-michal.kalderon@marvell.com
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index c6165c6390a71..7de96ac4ce543 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -998,7 +998,7 @@ int qedr_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		/* Generate doorbell address. */
 		cq->db.data.icid = cq->icid;
 		cq->db_addr = dev->db_addr + db_offset;
-		cq->db.data.params = DB_AGG_CMD_SET <<
+		cq->db.data.params = DB_AGG_CMD_MAX <<
 		    RDMA_PWM_VAL32_DATA_AGG_CMD_SHIFT;
 
 		/* point to the very last element, passing it we will toggle */
-- 
2.25.1



