Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D02F4148427
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390482AbgAXLVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:21:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:60492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391113AbgAXLVq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:21:46 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A315E2075D;
        Fri, 24 Jan 2020 11:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864906;
        bh=ftcCIxrW9EcKlGFII//tyH9/abyun8fO6YP+v0AspWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xd4/SmS103mq3uREKeHMqGezASfaL1+Bj5EMlD/Sze/6DPvxqPbaVtLUmlr7ugPkG
         eF9utU/NJj74RdyTjnTn3fMkbgqxrTiWMey8MiDluUxHDoKXTr4PeDd/BqEDnAnQLc
         3CxfEsr2YQxJteGp+uNL1M0vOo9Jja06H6xiOAmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagiv Ozeri <sagiv.ozeri@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 384/639] RDMA/qedr: Fix incorrect device rate.
Date:   Fri, 24 Jan 2020 10:29:14 +0100
Message-Id: <20200124093135.059026389@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagiv Ozeri <sagiv.ozeri@marvell.com>

[ Upstream commit 69054666df0a9b4e8331319f98b6b9a88bc3fcc4 ]

Use the correct enum value introduced in commit 12113a35ada6 ("IB/core:
Add HDR speed enum") Prior to this change a 50Gbps port would show 40Gbps.

This patch also cleaned up the redundant redefiniton of ib speeds for
qedr.

Fixes: 12113a35ada6 ("IB/core: Add HDR speed enum")
Signed-off-by: Sagiv Ozeri <sagiv.ozeri@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 8fd8b97348bfe..38fe2f7413757 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -158,54 +158,47 @@ int qedr_query_device(struct ib_device *ibdev,
 	return 0;
 }
 
-#define QEDR_SPEED_SDR		(1)
-#define QEDR_SPEED_DDR		(2)
-#define QEDR_SPEED_QDR		(4)
-#define QEDR_SPEED_FDR10	(8)
-#define QEDR_SPEED_FDR		(16)
-#define QEDR_SPEED_EDR		(32)
-
 static inline void get_link_speed_and_width(int speed, u8 *ib_speed,
 					    u8 *ib_width)
 {
 	switch (speed) {
 	case 1000:
-		*ib_speed = QEDR_SPEED_SDR;
+		*ib_speed = IB_SPEED_SDR;
 		*ib_width = IB_WIDTH_1X;
 		break;
 	case 10000:
-		*ib_speed = QEDR_SPEED_QDR;
+		*ib_speed = IB_SPEED_QDR;
 		*ib_width = IB_WIDTH_1X;
 		break;
 
 	case 20000:
-		*ib_speed = QEDR_SPEED_DDR;
+		*ib_speed = IB_SPEED_DDR;
 		*ib_width = IB_WIDTH_4X;
 		break;
 
 	case 25000:
-		*ib_speed = QEDR_SPEED_EDR;
+		*ib_speed = IB_SPEED_EDR;
 		*ib_width = IB_WIDTH_1X;
 		break;
 
 	case 40000:
-		*ib_speed = QEDR_SPEED_QDR;
+		*ib_speed = IB_SPEED_QDR;
 		*ib_width = IB_WIDTH_4X;
 		break;
 
 	case 50000:
-		*ib_speed = QEDR_SPEED_QDR;
-		*ib_width = IB_WIDTH_4X;
+		*ib_speed = IB_SPEED_HDR;
+		*ib_width = IB_WIDTH_1X;
 		break;
 
 	case 100000:
-		*ib_speed = QEDR_SPEED_EDR;
+		*ib_speed = IB_SPEED_EDR;
 		*ib_width = IB_WIDTH_4X;
 		break;
 
 	default:
 		/* Unsupported */
-		*ib_speed = QEDR_SPEED_SDR;
+		*ib_speed = IB_SPEED_SDR;
 		*ib_width = IB_WIDTH_1X;
 	}
 }
-- 
2.20.1



