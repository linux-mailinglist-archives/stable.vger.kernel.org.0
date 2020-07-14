Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4F021FA34
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbgGNSuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:50:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729603AbgGNSud (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:50:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6AD3207F5;
        Tue, 14 Jul 2020 18:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752633;
        bh=Ptx4lwXhCmZB7hb4xyroUfIKSsS43kLVDvqBrOxrLYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nsvY6as4zC992SJX7bH6vTEFHH1EZvAbnrem01MSry9jVKbRCv/0h+mhtTrcz954o
         OwsEIgy7b4kRnfjOueeHCcb6loS0n9Yjr8hMGpKjMoSp7u1PpUMT82JTAqtaBk7Af/
         d8Qw7BjX4KzJJh8vSvc3F5/Ibdvp+8jc+qi6cLBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 053/109] net: hns3: add a missing uninit debugfs when unload driver
Date:   Tue, 14 Jul 2020 20:43:56 +0200
Message-Id: <20200714184108.057006787@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184105.507384017@linuxfoundation.org>
References: <20200714184105.507384017@linuxfoundation.org>
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
index 403e0f089f2af..37537c3020806 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3993,9 +3993,8 @@ static void hns3_client_uninit(struct hnae3_handle *handle, bool reset)
 
 	hns3_put_ring_config(priv);
 
-	hns3_dbg_uninit(handle);
-
 out_netdev_free:
+	hns3_dbg_uninit(handle);
 	free_netdev(netdev);
 }
 
-- 
2.25.1



