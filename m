Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E823E8096
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235609AbhHJRu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:50:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:60930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233715AbhHJRsy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:48:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26C2761185;
        Tue, 10 Aug 2021 17:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617292;
        bh=i90K1F3cN9255PTEE8cgq6ze8clGUsHG29sCiNHzhOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wQGTeI+VFzLFFlfP4V3ymSo6Q46Tgq7y9e2rK4oqGPKy3JAdkNs2uSVCxPiHWSHmo
         ZRd41/sSLMZCqGFaQaBh+xISO406EZG6Zyyl3Pt6TrgD7Lb10x/HY6acv4wnNdR/rM
         jfxd1ouxRux3Z/cSiHkKpZX8gp6noksY3li/K1v0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harshvardhan Jha <harshvardhan.jha@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 130/135] net: qede: Fix end of loop tests for list_for_each_entry
Date:   Tue, 10 Aug 2021 19:31:04 +0200
Message-Id: <20210810173000.220428504@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harshvardhan Jha <harshvardhan.jha@oracle.com>

[ Upstream commit 795e3d2ea68e489ee7039ac29e98bfea0e34a96c ]

The list_for_each_entry() iterator, "vlan" in this code, can never be
NULL so the warning will never be printed.

Signed-off-by: Harshvardhan Jha <harshvardhan.jha@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede_filter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index c59b72c90293..a2e4dfb5cb44 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -831,7 +831,7 @@ int qede_configure_vlan_filters(struct qede_dev *edev)
 int qede_vlan_rx_kill_vid(struct net_device *dev, __be16 proto, u16 vid)
 {
 	struct qede_dev *edev = netdev_priv(dev);
-	struct qede_vlan *vlan = NULL;
+	struct qede_vlan *vlan;
 	int rc = 0;
 
 	DP_VERBOSE(edev, NETIF_MSG_IFDOWN, "Removing vlan 0x%04x\n", vid);
@@ -842,7 +842,7 @@ int qede_vlan_rx_kill_vid(struct net_device *dev, __be16 proto, u16 vid)
 		if (vlan->vid == vid)
 			break;
 
-	if (!vlan || (vlan->vid != vid)) {
+	if (list_entry_is_head(vlan, &edev->vlan_list, list)) {
 		DP_VERBOSE(edev, (NETIF_MSG_IFUP | NETIF_MSG_IFDOWN),
 			   "Vlan isn't configured\n");
 		goto out;
-- 
2.30.2



