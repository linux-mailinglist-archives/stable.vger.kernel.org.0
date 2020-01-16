Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30D6E13E25F
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732952AbgAPQz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:55:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:40680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729368AbgAPQz2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:55:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 492852176D;
        Thu, 16 Jan 2020 16:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193727;
        bh=2xRJRWDQlQ6lgY7clO/7aQlHd9NaMYeMsWsqynNKo3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cknxyQGl+PdMwEB1PSUAey06jw/z+vNIrTqFiLzOs/KFFIql5aE3fsVcbwIq7LmN2
         CgK+c1pJfYKpV9TovmA1hO69Tj7AfwXWhXXkucZ3ZMd/aXCDZzYZF4YnZq0N9SHoYp
         6r2DE/e6f4i05lXxx15QiNdFvCyv6roDPdYDb0Xs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Estrin <alex.estrin@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        "Michael J . Ruhl" <michael.j.ruhl@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 020/671] IB/hfi1: Add mtu check for operational data VLs
Date:   Thu, 16 Jan 2020 11:44:11 -0500
Message-Id: <20200116165502.8838-20-sashal@kernel.org>
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

From: Alex Estrin <alex.estrin@intel.com>

[ Upstream commit eb50130964e8c1379f37c3d3bab33a411ec62e98 ]

Since Virtual Lanes BCT credits and MTU are set through separate MADs, we
have to ensure both are valid, and data VLs are ready for transmission
before we allow port transition to Armed state.

Fixes: 5e2d6764a729 ("IB/hfi1: Verify port data VLs credits on transition to Armed")
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Alex Estrin <alex.estrin@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/chip.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 6b8935361133..b09a4b1cf397 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -10580,12 +10580,29 @@ void set_link_down_reason(struct hfi1_pportdata *ppd, u8 lcl_reason,
 	}
 }
 
-/*
- * Verify if BCT for data VLs is non-zero.
+/**
+ * data_vls_operational() - Verify if data VL BCT credits and MTU
+ *			    are both set.
+ * @ppd: pointer to hfi1_pportdata structure
+ *
+ * Return: true - Ok, false -otherwise.
  */
 static inline bool data_vls_operational(struct hfi1_pportdata *ppd)
 {
-	return !!ppd->actual_vls_operational;
+	int i;
+	u64 reg;
+
+	if (!ppd->actual_vls_operational)
+		return false;
+
+	for (i = 0; i < ppd->vls_supported; i++) {
+		reg = read_csr(ppd->dd, SEND_CM_CREDIT_VL + (8 * i));
+		if ((reg && !ppd->dd->vld[i].mtu) ||
+		    (!reg && ppd->dd->vld[i].mtu))
+			return false;
+	}
+
+	return true;
 }
 
 /*
@@ -10698,7 +10715,8 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 
 		if (!data_vls_operational(ppd)) {
 			dd_dev_err(dd,
-				   "%s: data VLs not operational\n", __func__);
+				   "%s: Invalid data VL credits or mtu\n",
+				   __func__);
 			ret = -EINVAL;
 			break;
 		}
-- 
2.20.1

