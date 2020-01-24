Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFAE147B7D
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732937AbgAXJoA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:44:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:42210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733222AbgAXJn7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:43:59 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF18D208C4;
        Fri, 24 Jan 2020 09:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859039;
        bh=jGwO946hnkbxfCDBaBTF3xZhe8EH95ey0IIxD0aqfyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G/kkdojf2r7pt3bKB7wJZ4DKY80XM72+LbaysftfjkssTLxDMbNe0MX68B8egjmoX
         08AK+02uL2JfmAbX2PL0qSlgtpeLpd4870KbVNdnJ0DAJcVSA0HGazOnNk/HCJvmhB
         cReGGW7/lektoA3yllChb8o8rFrQU0aqu5x8imCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        Alex Estrin <alex.estrin@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 015/343] IB/hfi1: Add mtu check for operational data VLs
Date:   Fri, 24 Jan 2020 10:27:13 +0100
Message-Id: <20200124092921.631892177@linuxfoundation.org>
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
index 9f78bb07744c7..4a0b7c0034771 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -10552,12 +10552,29 @@ void set_link_down_reason(struct hfi1_pportdata *ppd, u8 lcl_reason,
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
@@ -10662,7 +10679,8 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 
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



