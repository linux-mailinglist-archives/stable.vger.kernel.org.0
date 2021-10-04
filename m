Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66C5420ED3
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236552AbhJDN25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:28:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236880AbhJDN1L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:27:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B73B461B56;
        Mon,  4 Oct 2021 13:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353116;
        bh=YE1zx6nVgkP8CuYGLxll0ajKOtAaprvH74dQUHfl4IM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1GFQp6aYyVd4IcHPN8Oi4cAaEYQJreCZMZ24xvsqmBnWJHrLX+jpv7hsGap5lEiCG
         Q3C03oQOEwtkqgveQjgU6zsnuxeWw86RsD2x61ZB1/3dWVxBxBqXnF2eixzKp+hnVz
         8/KV4aopiqUYIByBTsPSV76+aa++VC4S0wzA3i2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 62/93] net: hns3: fix always enable rx vlan filter problem after selftest
Date:   Mon,  4 Oct 2021 14:53:00 +0200
Message-Id: <20211004125036.611141592@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

[ Upstream commit 27bf4af69fcb9845fb2f0076db5d562ec072e70f ]

Currently, the rx vlan filter will always be disabled before selftest and
be enabled after selftest as the rx vlan filter feature is fixed on in
old device earlier than V3.

However, this feature is not fixed in some new devices and it can be
disabled by user. In this case, it is wrong if rx vlan filter is enabled
after selftest. So fix it.

Fixes: bcc26e8dc432 ("net: hns3: remove unused code in hns3_self_test()")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 436d777cce06..cd0d7a546957 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -336,7 +336,8 @@ static void hns3_selftest_prepare(struct net_device *ndev,
 
 #if IS_ENABLED(CONFIG_VLAN_8021Q)
 	/* Disable the vlan filter for selftest does not support it */
-	if (h->ae_algo->ops->enable_vlan_filter)
+	if (h->ae_algo->ops->enable_vlan_filter &&
+	    ndev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
 		h->ae_algo->ops->enable_vlan_filter(h, false);
 #endif
 
@@ -361,7 +362,8 @@ static void hns3_selftest_restore(struct net_device *ndev, bool if_running)
 		h->ae_algo->ops->halt_autoneg(h, false);
 
 #if IS_ENABLED(CONFIG_VLAN_8021Q)
-	if (h->ae_algo->ops->enable_vlan_filter)
+	if (h->ae_algo->ops->enable_vlan_filter &&
+	    ndev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
 		h->ae_algo->ops->enable_vlan_filter(h, true);
 #endif
 
-- 
2.33.0



