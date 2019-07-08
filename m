Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD1C621B2
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbfGHPSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:18:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733069AbfGHPSg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:18:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DCD0216F4;
        Mon,  8 Jul 2019 15:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599115;
        bh=v714mcTwKX99GzSCD9GYd5HAmHyrZPlW1ZQaSAEQNhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hhSqsMqbQVy6blTxEsBXlRUgrZv3D9Ev+U+26S8Jz3yVn7y+NeoOvoY7aAb5trceG
         WQODFXuaoQXcpbynWy0tQtXDEJOsVHDDr0Sok6HKQnHeu0Ty3T6xgTMjatAKYCU4rj
         8ffpn6zwNpQA2ZKnxut3ajkiKuYdpeg7ljhptuiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 011/102] IB/rdmavt: Fix alloc_qpn() WARN_ON()
Date:   Mon,  8 Jul 2019 17:12:04 +0200
Message-Id: <20190708150526.650080202@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
References: <20190708150525.973820964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



