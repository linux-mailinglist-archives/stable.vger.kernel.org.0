Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E03E114811B
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389098AbgAXLRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:17:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:53936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390104AbgAXLRE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:17:04 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 681C820708;
        Fri, 24 Jan 2020 11:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864624;
        bh=dt2aUeAnOuR6nsScLL5PS0QdtRNnLCddn33jhGEuJJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fDnK054l6CCILchWFwuJuzLYgo+0XFRJQEIZZiBwpmMyaC6QUm+OUcHx6KyHY7UJO
         zR5MpTs+GNlqxVmTw9pcUqtYVAEpMYNaXvaa/1Po3q00PatLT+6LXH+tmwOJ2gd9Tz
         kWpP9cu4070QP6tsr6q7EjO8+5EP8WUnWar0dPyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 318/639] net: hns3: fix loop condition of hns3_get_tx_timeo_queue_info()
Date:   Fri, 24 Jan 2020 10:28:08 +0100
Message-Id: <20200124093126.856911532@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit fa6c4084b98b82c98cada0f0d5c9f8577579f962 ]

In function hns3_get_tx_timeo_queue_info(), it should use
netdev->num_tx_queues, instead of netdve->real_num_tx_queues
as the loop limitation.

Fixes: 424eb834a9be ("net: hns3: Unified HNS3 {VF|PF} Ethernet Driver for hip08 SoC")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 10fa7f5df57e7..3eb8b85f6afb6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1464,7 +1464,7 @@ static bool hns3_get_tx_timeo_queue_info(struct net_device *ndev)
 	int i;
 
 	/* Find the stopped queue the same way the stack does */
-	for (i = 0; i < ndev->real_num_tx_queues; i++) {
+	for (i = 0; i < ndev->num_tx_queues; i++) {
 		struct netdev_queue *q;
 		unsigned long trans_start;
 
-- 
2.20.1



