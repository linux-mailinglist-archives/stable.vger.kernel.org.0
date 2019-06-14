Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B682A46947
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 22:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfFNUbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 16:31:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727952AbfFNUau (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 16:30:50 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2528D2184E;
        Fri, 14 Jun 2019 20:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544250;
        bh=emo5NoVAJUMx3vVnWPrQjV4K8lZvK7IDblvuixJL9h4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o3/u3R2cs1b83lL5F+Kh583Hoq+VFZ6rid8WzbAtrip6F39BfxiIFdt/4s7yYPkVi
         fYBqN419/bqNpPq/oItzM7Fwgp0JMhjjHyZ51C6jXFzx2iq1XwPTY3W7eKTaNU/fP0
         4NLMI2jwqshMtxn0rEV7CiSP8BdcR5TC7Ow/Ts50=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Marciniszyn <mike.marciniszyn@intel.com>,
        "Michael J . Ruhl" <michael.j.ruhl@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.4 03/10] IB/hfi1: Insure freeze_work work_struct is canceled on shutdown
Date:   Fri, 14 Jun 2019 16:30:39 -0400
Message-Id: <20190614203046.28077-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614203046.28077-1-sashal@kernel.org>
References: <20190614203046.28077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

[ Upstream commit 6d517353c70bb0818b691ca003afdcb5ee5ea44e ]

By code inspection, the freeze_work is never canceled.

Fix by adding a cancel_work_sync in the shutdown path to insure it is no
longer running.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rdma/hfi1/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index e48981994b10..e1531feb6c5d 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -5906,6 +5906,7 @@ void hfi1_quiet_serdes(struct hfi1_pportdata *ppd)
 
 	/* disable the port */
 	clear_rcvctrl(dd, RCV_CTRL_RCV_PORT_ENABLE_SMASK);
+	cancel_work_sync(&ppd->freeze_work);
 }
 
 static inline int init_cpu_counters(struct hfi1_devdata *dd)
-- 
2.20.1

