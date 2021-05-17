Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0433835D8
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242316AbhEQPZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:25:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:41350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244924AbhEQPWg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:22:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A58B8613AC;
        Mon, 17 May 2021 14:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262110;
        bh=gKMpMf3gz74yna0MMct72I2wOxJOuxUhgHeuDtqBqeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XVblxDBeL0QMBipuL3jLs19Jb1orEmwZDJVNZFQv1TBpbDl1GHwLxtnLBwERYSiCV
         UXoNgJSjXl9l5fp/ggq8DwS/kinrxEQbyNhJgvvhaX8BA8dge+j/DTmRqo+lfF+jGT
         698jAO83r4oxfMeD9jf5TbxB/Q49YkTMtdVXFkVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ramesh Babu B <ramesh.babu.b@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 196/329] net: stmmac: Clear receive all(RA) bit when promiscuous mode is off
Date:   Mon, 17 May 2021 16:01:47 +0200
Message-Id: <20210517140308.755499813@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ramesh Babu B <ramesh.babu.b@intel.com>

[ Upstream commit 4c7a94286ef7ac7301d633f17519fb1bb89d7550 ]

In promiscuous mode Receive All bit is set in GMAC packet filter register,
but outside promiscuous mode Receive All bit is not cleared,
which resulted in all network packets are received when toggle (ON/OFF)
the promiscuous mode.

Fixes: e0f9956a3862 ("net: stmmac: Add option for VLAN filter fail queue enable")
Signed-off-by: Ramesh Babu B <ramesh.babu.b@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 29f765a246a0..aaf37598cbd3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -638,6 +638,7 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 	value &= ~GMAC_PACKET_FILTER_PCF;
 	value &= ~GMAC_PACKET_FILTER_PM;
 	value &= ~GMAC_PACKET_FILTER_PR;
+	value &= ~GMAC_PACKET_FILTER_RA;
 	if (dev->flags & IFF_PROMISC) {
 		/* VLAN Tag Filter Fail Packets Queuing */
 		if (hw->vlan_fail_q_en) {
-- 
2.30.2



