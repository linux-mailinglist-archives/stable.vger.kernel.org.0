Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2986C10B8D8
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729245AbfK0Ur0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:47:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:60204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729361AbfK0UrZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:47:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5844121844;
        Wed, 27 Nov 2019 20:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887644;
        bh=lk+Xh0MaiD1FoRGNeq29i40Di3Mj0VgeUVYmCBBoJno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uvQBAJSlpgLRfrMvSxwxf780O9h1NeZ9QP1pyN+qs2J0yn3JBsr1YbPvU/2d6ldjS
         CGuUTyPmwoINRkR/TaTM8KQ9FDN6IrHAH3bG0Kjy1fsySS/GuG/zCl+x1ymElLvsVb
         h9UkXupJUN1ZLhn5wMWlxTxnHUoG4EA8S/sw+eaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Devesh Sharma <devesh.sharma@broadcom.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 038/211] RDMA/bnxt_re: Fix qp async event reporting
Date:   Wed, 27 Nov 2019 21:29:31 +0100
Message-Id: <20191127203055.742074665@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



