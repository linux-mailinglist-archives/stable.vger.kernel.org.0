Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80D3F4696B
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 22:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbfFNUcw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 16:32:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:53828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727808AbfFNUak (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 16:30:40 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADB9421850;
        Fri, 14 Jun 2019 20:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544239;
        bh=RDi7NUx0l+VvW0cC95RGyMyl/v/L1HkZdUHr8haQOBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ukYUd6vYexjbNYzDdV3VukkiVsmRtnEF90PuiYZvvaTq8X5g/fC/l1BM935AR1IOD
         eu2Or6uCygbIMCu1Q8WDthwhMNRxJNt41M0cXN+a5KHGrtL1O7l2T8oD4UrI+bplck
         EM1bJphyhbnS3boGIG8GkI8DEoN41gjjMotW5gxw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 04/18] IB/rdmavt: Fix alloc_qpn() WARN_ON()
Date:   Fri, 14 Jun 2019 16:30:20 -0400
Message-Id: <20190614203037.27910-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614203037.27910-1-sashal@kernel.org>
References: <20190614203037.27910-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

[ Upstream commit 2abae62a26a265129b364d8c1ef3be55e2c01309 ]

The qpn allocation logic has a WARN_ON() that intends to detect the use of
an index that will introduce bits in the lower order bits of the QOS bits
in the QPN.

Unfortunately, it has the following bugs:
- it misfires when wrapping QPN allocation for non-QOS
- it doesn't correctly detect low order QOS bits (despite the comment)

The WARN_ON() should not be applied to non-QOS (qos_shift == 1).

Additionally, it SHOULD test the qpn bits per the table below:

2 data VLs:   [qp7, qp6, qp5, qp4, qp3, qp2, qp1] ^
              [  0,   0,   0,   0,   0,   0, sc0],  qp bit 1 always 0*
3-4 data VLs: [qp7, qp6, qp5, qp4, qp3, qp2, qp1] ^
              [  0,   0,   0,   0,   0, sc1, sc0], qp bits [21] always 0
5-8 data VLs: [qp7, qp6, qp5, qp4, qp3, qp2, qp1] ^
              [  0,   0,   0,   0, sc2, sc1, sc0] qp bits [321] always 0

Fix by qualifying the warning for qos_shift > 1 and producing the correct
mask to insure the above bits are zero without generating a superfluous
warning.

Fixes: 501edc42446e ("IB/rdmavt: Correct warning during QPN allocation")
Reviewed-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rdmavt/qp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 6500c3b5a89c..8b330b53d636 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -370,7 +370,8 @@ static int alloc_qpn(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
 			offset = qpt->incr | ((offset & 1) ^ 1);
 		}
 		/* there can be no set bits in low-order QoS bits */
-		WARN_ON(offset & (BIT(rdi->dparms.qos_shift) - 1));
+		WARN_ON(rdi->dparms.qos_shift > 1 &&
+			offset & ((BIT(rdi->dparms.qos_shift - 1) - 1) << 1));
 		qpn = mk_qpn(qpt, map, offset);
 	}
 
-- 
2.20.1

