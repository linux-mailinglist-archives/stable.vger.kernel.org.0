Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C898188041
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728201AbgCQLIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:08:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727985AbgCQLId (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:08:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 026DA20714;
        Tue, 17 Mar 2020 11:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443313;
        bh=oYlJ/+maEHa0xWlzuU7+Of2QabBVaF4ZAeipEBOTno0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QarJ5xHXAeJwsvqYE/jI7c3S0eIJTBU3G2u97veGJwW9s9Xr0g98DFXIrG9LSyPFL
         6KzbR2HFXLQTzmBvUsfqwBef8ViZKUNRXEtBSRLZLluzSvzyWbW/30TbhdiX09wBcu
         cGENez/wJEg3sCPCLFkw1ZnFJI6KdrLhJHB4sgyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 043/151] net: hns3: fix "tc qdisc del" failed issue
Date:   Tue, 17 Mar 2020 11:54:13 +0100
Message-Id: <20200317103329.673291992@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

[ Upstream commit 5eb01ddfcfb25e6ebc404a41deae946bde776731 ]

The HNS3 driver supports to configure TC numbers and TC to priority
map via "tc" tool. But when delete the rule, will fail, because
the HNS3 driver needs at least one TC, but the "tc" tool sets TC
number to zero when delete.

This patch makes sure that the TC number is at least one.

Fixes: 30d240dfa2e8 ("net: hns3: Add mqprio hardware offload support in hns3 driver")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1675,7 +1675,7 @@ static int hns3_setup_tc(struct net_devi
 	netif_dbg(h, drv, netdev, "setup tc: num_tc=%u\n", tc);
 
 	return (kinfo->dcb_ops && kinfo->dcb_ops->setup_tc) ?
-		kinfo->dcb_ops->setup_tc(h, tc, prio_tc) : -EOPNOTSUPP;
+		kinfo->dcb_ops->setup_tc(h, tc ? tc : 1, prio_tc) : -EOPNOTSUPP;
 }
 
 static int hns3_nic_setup_tc(struct net_device *dev, enum tc_setup_type type,


