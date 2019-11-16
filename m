Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C43CBFF1B3
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730960AbfKPQOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:14:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:54730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728458AbfKPPry (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:47:54 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C2652086A;
        Sat, 16 Nov 2019 15:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919274;
        bh=lk+Xh0MaiD1FoRGNeq29i40Di3Mj0VgeUVYmCBBoJno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ygkS7N6wjRqLBg1qvRb0YJ9C0VtBqo/ewZavPGUdPnleUCANYrJRVQ2/aFrA/F4LJ
         ibpRvoMnZNBPTKcVdKWap1i8d8u86uermwstMP3lYGWqTFc78tm9/eN/9GcZZJcjqG
         Depv/gkmwN4TmOM3KJBDJTWDkYd+8zb6SYofi3YA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Devesh Sharma <devesh.sharma@broadcom.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 022/150] RDMA/bnxt_re: Fix qp async event reporting
Date:   Sat, 16 Nov 2019 10:45:20 -0500
Message-Id: <20191116154729.9573-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Devesh Sharma <devesh.sharma@broadcom.com>

[ Upstream commit 4c01f2e3a906a0d2d798be5751c331cf501bc129 ]

Reports affiliated async event on the qp-async event channel instead of
global event channel.

Signed-off-by: Devesh Sharma <devesh.sharma@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/main.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index bf811b23bc953..7d00b6a53ed8c 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -782,12 +782,17 @@ static void bnxt_re_dispatch_event(struct ib_device *ibdev, struct ib_qp *qp,
 	struct ib_event ib_event;
 
 	ib_event.device = ibdev;
-	if (qp)
+	if (qp) {
 		ib_event.element.qp = qp;
-	else
+		ib_event.event = event;
+		if (qp->event_handler)
+			qp->event_handler(&ib_event, qp->qp_context);
+
+	} else {
 		ib_event.element.port_num = port_num;
-	ib_event.event = event;
-	ib_dispatch_event(&ib_event);
+		ib_event.event = event;
+		ib_dispatch_event(&ib_event);
+	}
 }
 
 #define HWRM_QUEUE_PRI2COS_QCFG_INPUT_FLAGS_IVLAN      0x02
-- 
2.20.1

