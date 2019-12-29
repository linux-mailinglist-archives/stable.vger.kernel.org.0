Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 687C712C4AF
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbfL2Rbu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:31:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:59586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729231AbfL2Rbt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:31:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A66920722;
        Sun, 29 Dec 2019 17:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640709;
        bh=Zdm2lWzGzdb9q+A3Dpzyyy8VkTXq2OqbnjRt4PXS9UY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RVSWndvz0fwzGDrT++2AVBJC5WHRrd2aee2Y8nT/2QDOHQwXB/yQ4Rtqr+SgNxvZ3
         F0dA+ftVY73Af5hmZegSahYQvM5kv1tIB4hgFeGz/KUmWGBCHGHRglKFR9OaIYb5lZ
         Tc5S4MmH9D6vCEqQLO1DTKF3+VPkKdE3bg9DGP1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 106/219] net: hns3: add struct netdev_queue debug info for TX timeout
Date:   Sun, 29 Dec 2019 18:18:28 +0100
Message-Id: <20191229162524.709507582@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit 647522a5ef6401dcdb8ec417421e43fb21910167 ]

When there is a TX timeout, we can tell if the driver or stack
has stopped the queue by looking at state field, and when has
the last packet transmited by looking at trans_start field.

So this patch prints these two field in the
hns3_get_tx_timeo_queue_info().

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 0788e78747d9..1aaf6e2a3b39 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1474,6 +1474,9 @@ static bool hns3_get_tx_timeo_queue_info(struct net_device *ndev)
 		    time_after(jiffies,
 			       (trans_start + ndev->watchdog_timeo))) {
 			timeout_queue = i;
+			netdev_info(ndev, "queue state: 0x%lx, delta msecs: %u\n",
+				    q->state,
+				    jiffies_to_msecs(jiffies - trans_start));
 			break;
 		}
 	}
-- 
2.20.1



