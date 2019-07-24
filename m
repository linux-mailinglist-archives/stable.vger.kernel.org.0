Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4380C73842
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbfGXT1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:27:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727195AbfGXT1f (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:27:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63F36218EA;
        Wed, 24 Jul 2019 19:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996454;
        bh=G/XVuCesdXq1fHz55fcAyE0FQZwiqcpuAxHc3Jf90E0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PQzSJ9VCd+cnPbdCo2x7RZC5dc9l6VxiRtvnrAgg451OuT3l/8vWSaK5I2qWm5sIy
         2esqU/xTlsE6e/0P+FcEuPoe9kzInwcrPMSqmcRxmJSAARqCGjadc2iV8xohUrslHC
         BcVM2T1t/QruOizVAz2y9NQ5PIknq01gMS1kKTlk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 102/413] net: hns3: fix for dereferencing before null checking
Date:   Wed, 24 Jul 2019 21:16:33 +0200
Message-Id: <20190724191742.502496346@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 757188005f905664b0186b88cf26a7e844190a63 ]

The netdev is dereferenced before null checking in the function
hns3_setup_tc.

This patch moves the dereferencing after the null checking.

Fixes: 76ad4f0ee747 ("net: hns3: Add support of HNS3 Ethernet Driver for hip08 SoC")

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 5611b990ac34..d18ad7b48a31 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1514,12 +1514,12 @@ static void hns3_nic_get_stats64(struct net_device *netdev,
 static int hns3_setup_tc(struct net_device *netdev, void *type_data)
 {
 	struct tc_mqprio_qopt_offload *mqprio_qopt = type_data;
-	struct hnae3_handle *h = hns3_get_handle(netdev);
-	struct hnae3_knic_private_info *kinfo = &h->kinfo;
 	u8 *prio_tc = mqprio_qopt->qopt.prio_tc_map;
+	struct hnae3_knic_private_info *kinfo;
 	u8 tc = mqprio_qopt->qopt.num_tc;
 	u16 mode = mqprio_qopt->mode;
 	u8 hw = mqprio_qopt->qopt.hw;
+	struct hnae3_handle *h;
 
 	if (!((hw == TC_MQPRIO_HW_OFFLOAD_TCS &&
 	       mode == TC_MQPRIO_MODE_CHANNEL) || (!hw && tc == 0)))
@@ -1531,6 +1531,9 @@ static int hns3_setup_tc(struct net_device *netdev, void *type_data)
 	if (!netdev)
 		return -EINVAL;
 
+	h = hns3_get_handle(netdev);
+	kinfo = &h->kinfo;
+
 	return (kinfo->dcb_ops && kinfo->dcb_ops->setup_tc) ?
 		kinfo->dcb_ops->setup_tc(h, tc, prio_tc) : -EOPNOTSUPP;
 }
-- 
2.20.1



