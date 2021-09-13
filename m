Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 001C44095EC
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346541AbhIMOqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:46:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346499AbhIMOmH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:42:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FDA761A10;
        Mon, 13 Sep 2021 13:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541383;
        bh=Jy7Q7Blf6tB2CjW2U9cPUJWfvPp+fLiGIafG/3WybSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1KcC1I4UenpvIuJpW9sL/W9T4yXaNrfgT3w0K0GKA2n+Co78rUL74F036AEi/dlcp
         r1Ap0398uWIk0ejHTbx2T3tEak24lrE16nq5BO7j/L7E+KcYGvWgMjQieJnngIs3y5
         84qxkfYG6iJUPzbSOuEmBbgW6pXY/BMy58lknLUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 243/334] octeontx2-pf: Dont install VLAN offload rule if netdev is down
Date:   Mon, 13 Sep 2021 15:14:57 +0200
Message-Id: <20210913131121.622934113@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
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
index 70fcc1fd962f..692099793005 100644
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
 		/* update dmac address in ntuple and DMAC filter list */
 		if (pfvf->flags & OTX2_FLAG_DMACFLTR_SUPPORT)
-- 
2.30.2



