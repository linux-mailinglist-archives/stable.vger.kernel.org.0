Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4419943A297
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236475AbhJYTuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:50:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235807AbhJYTrj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:47:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFFB26120F;
        Mon, 25 Oct 2021 19:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190834;
        bh=Irk5BOovECyv1i+k+iUluUzu19D7+zndtv6i3g6hng0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KZ+5c71JTieLgiUTrT+yI/mVGp5ettiH3iIya/ZmKdSn89UFCrAknISfNHYoXHieS
         gAJZYt5VoYqed7FDwRZKIqytQW6kNZWCoj7JU7zX3kpfhEBxx9WTdccbK0iKxfXMxv
         DgGfuE/ZGm9r1Dx5PSd+xPiXZ3F39tGOp6PLCkmk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richie Pearn <richard.pearn@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        ClaudiuManoilclaudiu.manoil@nxp.com
Subject: [PATCH 5.14 064/169] net: enetc: make sure all traffic classes can send large frames
Date:   Mon, 25 Oct 2021 21:14:05 +0200
Message-Id: <20211025191025.620627045@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit e378f4967c8edd64c680f2e279cb646ee06b6f2d ]

The enetc driver does not implement .ndo_change_mtu, instead it
configures the MAC register field PTC{Traffic Class}MSDUR[MAXSDU]
statically to a large value during probe time.

The driver used to configure only the max SDU for traffic class 0, and
that was fine while the driver could only use traffic class 0. But with
the introduction of mqprio, sending a large frame into any other TC than
0 is broken.

This patch fixes that by replicating per traffic class the static
configuration done in enetc_configure_port_mac().

Fixes: cbe9e835946f ("enetc: Enable TC offloading with mqprio")
Reported-by: Richie Pearn <richard.pearn@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: <Claudiu Manoil <claudiu.manoil@nxp.com>
Link: https://lore.kernel.org/r/20211020173340.1089992-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index cf00709caea4..3ac324509f43 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -517,10 +517,13 @@ static void enetc_port_si_configure(struct enetc_si *si)
 
 static void enetc_configure_port_mac(struct enetc_hw *hw)
 {
+	int tc;
+
 	enetc_port_wr(hw, ENETC_PM0_MAXFRM,
 		      ENETC_SET_MAXFRM(ENETC_RX_MAXFRM_SIZE));
 
-	enetc_port_wr(hw, ENETC_PTCMSDUR(0), ENETC_MAC_MAXFRM_SIZE);
+	for (tc = 0; tc < 8; tc++)
+		enetc_port_wr(hw, ENETC_PTCMSDUR(tc), ENETC_MAC_MAXFRM_SIZE);
 
 	enetc_port_wr(hw, ENETC_PM0_CMD_CFG, ENETC_PM0_CMD_PHY_TX_EN |
 		      ENETC_PM0_CMD_TXP	| ENETC_PM0_PROMISC);
-- 
2.33.0



