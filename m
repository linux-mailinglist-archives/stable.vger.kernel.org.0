Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0BF2E3D39
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439160AbgL1OKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:10:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:45022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439139AbgL1OKz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:10:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33C0B207CC;
        Mon, 28 Dec 2020 14:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164639;
        bh=mv87hgKbwt3ZbIdN6Zipbqm2WF/r5TFlQIJ92unKSf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gE+0CdoyWi4+bCXC3HICLjjN2KVs2Sw/uWtqI6AQ5bVdKh3adu24xZOSODa7ntJQI
         98E/PvG19T35eXOZrK3pNtQeIa2OFDcROOoEVfMZ93eyDmxUwZjsAsxd8oJpgb+mjr
         MPhU2QG8DzJVzZL3a4mUgp9FrTWwupVIs2zXP05E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 215/717] RDMA/hns: Fix missing fields in address vector
Date:   Mon, 28 Dec 2020 13:43:33 +0100
Message-Id: <20201228125031.275513057@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Weihang Li <liweihang@huawei.com>

[ Upstream commit fba429fcf9a5e0c4ec2523ecf4cf18bc0507fcbc ]

Traffic class and hop limit in address vector is not assigned from GRH,
but it will be filled into UD SQ WQE. So the hardware will get a wrong
value.

Fixes: 82e620d9c3a0 ("RDMA/hns: Modify the data structure of hns_roce_av")
Link: https://lore.kernel.org/r/1605526408-6936-3-git-send-email-liweihang@huawei.com
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_ah.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_ah.c b/drivers/infiniband/hw/hns/hns_roce_ah.c
index 3be80d42e03a9..d65ff6aa322fa 100644
--- a/drivers/infiniband/hw/hns/hns_roce_ah.c
+++ b/drivers/infiniband/hw/hns/hns_roce_ah.c
@@ -64,18 +64,20 @@ int hns_roce_create_ah(struct ib_ah *ibah, struct rdma_ah_init_attr *init_attr,
 	struct hns_roce_ah *ah = to_hr_ah(ibah);
 	int ret = 0;
 
-	memcpy(ah->av.mac, ah_attr->roce.dmac, ETH_ALEN);
-
 	ah->av.port = rdma_ah_get_port_num(ah_attr);
 	ah->av.gid_index = grh->sgid_index;
 
 	if (rdma_ah_get_static_rate(ah_attr))
 		ah->av.stat_rate = IB_RATE_10_GBPS;
 
-	memcpy(ah->av.dgid, grh->dgid.raw, HNS_ROCE_GID_SIZE);
-	ah->av.sl = rdma_ah_get_sl(ah_attr);
+	ah->av.hop_limit = grh->hop_limit;
 	ah->av.flowlabel = grh->flow_label;
 	ah->av.udp_sport = get_ah_udp_sport(ah_attr);
+	ah->av.sl = rdma_ah_get_sl(ah_attr);
+	ah->av.tclass = grh->traffic_class;
+
+	memcpy(ah->av.dgid, grh->dgid.raw, HNS_ROCE_GID_SIZE);
+	memcpy(ah->av.mac, ah_attr->roce.dmac, ETH_ALEN);
 
 	/* HIP08 needs to record vlan info in Address Vector */
 	if (hr_dev->pci_dev->revision <= PCI_REVISION_ID_HIP08) {
-- 
2.27.0



