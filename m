Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB224507F2
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbfFXKMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:12:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:38290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730055AbfFXKGM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:06:12 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3080208E3;
        Mon, 24 Jun 2019 10:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370771;
        bh=GQIqOJoLrWOHgb9iG6OJt8URd/S+GLaWZyR0/LD9Jvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iI+8TDsyf+gczjSB7UAzK9O6kGknqcX1TsmyaILYQTznokqE4vwc8R2W6RQQ6b67R
         Vbvuv7phdMnWN01y/wKEXJ+VwclAYoW3ajL3kSLgsl3wmNKH/ix2ETVIvr1ZK07W1n
         s1rTR6Osh/IxrIiOH68MMACw+Wq4ladFNbsPKGbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonglong Liu <liuyonglong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 50/90] net: hns: Fix loopback test failed at copper ports
Date:   Mon, 24 Jun 2019 17:56:40 +0800
Message-Id: <20190624092317.482478718@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2e1f164861e500f4e068a9d909bbd3fcc7841483 ]

When doing a loopback test at copper ports, the serdes loopback
and the phy loopback will fail, because of the adjust link had
not finished, and phy not ready.

Adds sleep between adjust link and test process to fix it.

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
index e2710ff48fb0..1fa0cd527ead 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
@@ -339,6 +339,7 @@ static int __lb_setup(struct net_device *ndev,
 static int __lb_up(struct net_device *ndev,
 		   enum hnae_loop loop_mode)
 {
+#define NIC_LB_TEST_WAIT_PHY_LINK_TIME 300
 	struct hns_nic_priv *priv = netdev_priv(ndev);
 	struct hnae_handle *h = priv->ae_handle;
 	int speed, duplex;
@@ -365,6 +366,9 @@ static int __lb_up(struct net_device *ndev,
 
 	h->dev->ops->adjust_link(h, speed, duplex);
 
+	/* wait adjust link done and phy ready */
+	msleep(NIC_LB_TEST_WAIT_PHY_LINK_TIME);
+
 	return 0;
 }
 
-- 
2.20.1



