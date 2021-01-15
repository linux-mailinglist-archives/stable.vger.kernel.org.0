Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7B52F7A3D
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387994AbhAOMha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:37:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:44748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732178AbhAOMh3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:37:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D789221F7;
        Fri, 15 Jan 2021 12:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714207;
        bh=TwlCLI91+roOyx2gOJpmumBeWQkOK3Q5qczQ17G+7r4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R032hQVFE7lfBLHaUcPwEONfacIur5k9pugqC0VpdPdldKp+L506RE6ppouPOvSBM
         2/IeD5i8FQAFc3v9m2NyeA3QFYZ2pNnSCcm+JhT1QZJ8VTWh/5UeRt4cfJxC2x0NKF
         DsPhz6YpFYM81LegH1RXNwOT90QP31NL2PLIchZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 005/103] RDMA/hns: Avoid filling sl in high 3 bits of vlan_id
Date:   Fri, 15 Jan 2021 13:26:58 +0100
Message-Id: <20210115122006.311218730@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Weihang Li <liweihang@huawei.com>

[ Upstream commit 94a8c4dfcdb2b4fcb3dfafc39c1033a0b4637c86 ]

Only the low 12 bits of vlan_id is valid, and service level has been
filled in Address Vector. So there is no need to fill sl in vlan_id in
Address Vector.

Fixes: 7406c0036f85 ("RDMA/hns: Only record vlan info for HIP08")
Link: https://lore.kernel.org/r/1607650657-35992-5-git-send-email-liweihang@huawei.com
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_ah.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_ah.c b/drivers/infiniband/hw/hns/hns_roce_ah.c
index 7dd3b6097226f..174b19e397124 100644
--- a/drivers/infiniband/hw/hns/hns_roce_ah.c
+++ b/drivers/infiniband/hw/hns/hns_roce_ah.c
@@ -36,9 +36,6 @@
 #include <rdma/ib_cache.h>
 #include "hns_roce_device.h"
 
-#define VLAN_SL_MASK 7
-#define VLAN_SL_SHIFT 13
-
 static inline u16 get_ah_udp_sport(const struct rdma_ah_attr *ah_attr)
 {
 	u32 fl = ah_attr->grh.flow_label;
@@ -81,18 +78,12 @@ int hns_roce_create_ah(struct ib_ah *ibah, struct rdma_ah_init_attr *init_attr,
 
 	/* HIP08 needs to record vlan info in Address Vector */
 	if (hr_dev->pci_dev->revision <= PCI_REVISION_ID_HIP08) {
-		ah->av.vlan_en = 0;
-
 		ret = rdma_read_gid_l2_fields(ah_attr->grh.sgid_attr,
 					      &ah->av.vlan_id, NULL);
 		if (ret)
 			return ret;
 
-		if (ah->av.vlan_id < VLAN_N_VID) {
-			ah->av.vlan_en = 1;
-			ah->av.vlan_id |= (rdma_ah_get_sl(ah_attr) & VLAN_SL_MASK) <<
-					  VLAN_SL_SHIFT;
-		}
+		ah->av.vlan_en = ah->av.vlan_id < VLAN_N_VID;
 	}
 
 	return ret;
-- 
2.27.0



