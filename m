Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB4E106F10
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730560AbfKVK4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:56:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:43958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730559AbfKVK4O (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:56:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC79220715;
        Fri, 22 Nov 2019 10:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420174;
        bh=gutRD8FjO+NOt2w15Y7GDagDA5jpzhXSAfDnjcZSmPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XVHPeXtSh/NAVV5ktn2GIQrUdCmn4kFUNAboNxtBHQ2fN9i4CFMSCU3JhPGij6VWA
         hvkkOD3r5DqfRcz+EXGTC1DJ0XI5KnJem+2Nw0Am8KVZwmyIg09UxHwx+DWWADjvQZ
         nevqDgUEQhluQ6jUZrX8ok1YeUlLZ2orIkzJuzA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 019/220] net: hns3: Fix for netdev not up problem when setting mtu
Date:   Fri, 22 Nov 2019 11:26:24 +0100
Message-Id: <20191122100913.907959746@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit 93d8daf460183871a965dae339839d9e35d44309 ]

Currently hns3_nic_change_mtu will try to down the netdev before
setting mtu, and it does not up the netdev when the setting fails,
which causes netdev not up problem.

This patch fixes it by not returning when the setting fails.

Fixes: a8e8b7ff3517 ("net: hns3: Add support to change MTU in HNS3 hardware")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 0ccfa6a845353..a5e3d38f18230 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1447,13 +1447,11 @@ static int hns3_nic_change_mtu(struct net_device *netdev, int new_mtu)
 	}
 
 	ret = h->ae_algo->ops->set_mtu(h, new_mtu);
-	if (ret) {
+	if (ret)
 		netdev_err(netdev, "failed to change MTU in hardware %d\n",
 			   ret);
-		return ret;
-	}
-
-	netdev->mtu = new_mtu;
+	else
+		netdev->mtu = new_mtu;
 
 	/* if the netdev was running earlier, bring it up again */
 	if (if_running && hns3_nic_net_open(netdev))
-- 
2.20.1



