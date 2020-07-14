Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D314521FBB7
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731002AbgGNS4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:56:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:54644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730368AbgGNS4g (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:56:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74E7122B2B;
        Tue, 14 Jul 2020 18:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752996;
        bh=q48lzcsda5IIe9qnR2s7M5wcre/hEwczDqOY/2h///Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E870+L8WwygmajrwoeTXyp0w1JkCBkPB0PQUvf+IwbK4NJwYfjTZUQ9GLLLGpYBj5
         y3wAXqIrLP8sppmPVQda+F50LU9QVYOrzrDfFfxehFHdLL+hurAuwpsqVfBBAcLsQJ
         veuGcc7BjlJtHS1s2yURM6mwuVU+/55uTfdf3d5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 079/166] net: hns3: add a missing uninit debugfs when unload driver
Date:   Tue, 14 Jul 2020 20:44:04 +0200
Message-Id: <20200714184119.633369313@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>

[ Upstream commit e22b5e728bbb179b912d3a3cd5c25894a89a26a2 ]

When unloading driver, if flag HNS3_NIC_STATE_INITED has been
already cleared, the debugfs will not be uninitialized, so fix it.

Fixes: b2292360bb2a ("net: hns3: Add debugfs framework registration")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index da98fd7c8eca5..3003eecd5263b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4153,9 +4153,8 @@ static void hns3_client_uninit(struct hnae3_handle *handle, bool reset)
 
 	hns3_put_ring_config(priv);
 
-	hns3_dbg_uninit(handle);
-
 out_netdev_free:
+	hns3_dbg_uninit(handle);
 	free_netdev(netdev);
 }
 
-- 
2.25.1



