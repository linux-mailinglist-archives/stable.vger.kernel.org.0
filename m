Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591BA409287
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245203AbhIMOMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:12:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:59956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345153AbhIMOKA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:10:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0EF96124D;
        Mon, 13 Sep 2021 13:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540504;
        bh=iROBwrTyeLFDxNp08ASFLBO0T3JBIXrkaaErhQ9G5Hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=veXrATK52odJZWWTb0kJKQ3E0NYm3efjcMLXO4V8fcKa7Mgop+Wu+JmuzUcvU3ran
         1x7Z0kyyYqhsJwDRV6R5pc0PeNIs3r9Tr5pcj37MWHa+laq/OjUCJboaft/qlGQXLx
         3FKoL0nhwtswsEFLhELvQtdnZ/M6h8M20VZPwAuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 220/300] octeontx2-pf: Dont install VLAN offload rule if netdev is down
Date:   Mon, 13 Sep 2021 15:14:41 +0200
Message-Id: <20210913131116.792731061@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

[ Upstream commit 05209e3570e452cdaa644e8398a8875b6a91051d ]

Whenever user changes interface MAC address both default DMAC based
MCAM rule and VLAN offload (for strip) rules are updated with new
MAC address. To update or install VLAN offload rule PF driver needs
interface's receive channel info, which is retrieved from admin
function at the time of NIXLF initialization.

If user changes MAC address before interface is UP, VLAN offload rule
installation will fail and throw error as receive channel is not valid.
To avoid this, skip VLAN offload rule installation if netdev is not UP.
This rule will anyway be reinslatted as part of open() call.

Fixes: fd9d7859db6c ("octeontx2-pf: Implement ingress/egress VLAN offload")
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 16ba457197a2..871404f3b8d3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -208,7 +208,8 @@ int otx2_set_mac_address(struct net_device *netdev, void *p)
 	if (!otx2_hw_set_mac_addr(pfvf, addr->sa_data)) {
 		memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
 		/* update dmac field in vlan offload rule */
-		if (pfvf->flags & OTX2_FLAG_RX_VLAN_SUPPORT)
+		if (netif_running(netdev) &&
+		    pfvf->flags & OTX2_FLAG_RX_VLAN_SUPPORT)
 			otx2_install_rxvlan_offload_flow(pfvf);
 	} else {
 		return -EPERM;
-- 
2.30.2



