Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAA3FF387
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbfKPPl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:41:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:45320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728049AbfKPPl4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:41:56 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C06DC2084C;
        Sat, 16 Nov 2019 15:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918916;
        bh=N6n1vejcjZHQsQPa2gtPju+sXlhGmVg6/fyj4DwkZCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DWAAZuMg6V3d8LWqETHEg9d/DUOkl2ZdWb/GLiPW1Drv2WAOsRKdUNwss2BxH/Pss
         MzlvVjDKjIcjQn49Cn5UYF0dyh5FnV7VaTU9D47XvEv3jrCfMo7Rru2beK/rS0Xw1y
         WolKpug1qa7QsuETe42xYyUPQcPVWb5GAmAO087Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Devesh Sharma <devesh.sharma@broadcom.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 039/237] RDMA/bnxt_re: Fix qp async event reporting
Date:   Sat, 16 Nov 2019 10:37:54 -0500
Message-Id: <20191116154113.7417-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
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
index 22bd9784fa2ea..7ffad368c5fa1 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -989,12 +989,17 @@ static void bnxt_re_dispatch_event(struct ib_device *ibdev, struct ib_qp *qp,
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

