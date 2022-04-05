Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE124F2CBD
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242020AbiDEIgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239566AbiDEIUO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8E36376;
        Tue,  5 Apr 2022 01:16:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A00A60AFB;
        Tue,  5 Apr 2022 08:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B323C385A0;
        Tue,  5 Apr 2022 08:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146591;
        bh=R8BSE0mKHCk/KFQuqrQfNXP7Z6hcnqedSgjDwk4Zock=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kj/fFUFyhXzQO2OhFbVpu6RmMNi9kNUPnOTUFXXkYEYWAcoWZy3O55O83Q7atjL5Z
         887Deh7sY+2/51MVzc+pZz5Xlh9XWPD3fbj4EzCo7Vjg7dg9b5vR7dqoMc9yC1sZYx
         FCFfOnAaq5d5j48hBr7OEQLA4FYbcM1Zaa9SYGs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Chen <chenhao288@hisilicon.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0819/1126] net: hns3: add NULL pointer check for hns3_set/get_ringparam()
Date:   Tue,  5 Apr 2022 09:26:06 +0200
Message-Id: <20220405070431.602796664@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

[ Upstream commit 4d07c5936c2508ddd1cfd49b0a91d94cb4d1f0e8 ]

When pci devices init failed and haven't reinit, priv->ring is
NULL and hns3_set/get_ringparam() will access priv->ring. it
causes call trace.

So, add NULL pointer check for hns3_set/get_ringparam() to
avoid this situation.

Fixes: 5668abda0931 ("net: hns3: add support for set_ringparam")
Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 1f6d6faeec24..cbf36cc86803 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -651,8 +651,8 @@ static void hns3_get_ringparam(struct net_device *netdev,
 	struct hnae3_handle *h = priv->ae_handle;
 	int rx_queue_index = h->kinfo.num_tqps;
 
-	if (hns3_nic_resetting(netdev)) {
-		netdev_err(netdev, "dev resetting!");
+	if (hns3_nic_resetting(netdev) || !priv->ring) {
+		netdev_err(netdev, "failed to get ringparam value, due to dev resetting or uninited\n");
 		return;
 	}
 
@@ -1072,8 +1072,14 @@ static int hns3_check_ringparam(struct net_device *ndev,
 {
 #define RX_BUF_LEN_2K 2048
 #define RX_BUF_LEN_4K 4096
-	if (hns3_nic_resetting(ndev))
+
+	struct hns3_nic_priv *priv = netdev_priv(ndev);
+
+	if (hns3_nic_resetting(ndev) || !priv->ring) {
+		netdev_err(ndev, "failed to set ringparam value, due to dev resetting or uninited\n");
 		return -EBUSY;
+	}
+
 
 	if (param->rx_mini_pending || param->rx_jumbo_pending)
 		return -EINVAL;
-- 
2.34.1



