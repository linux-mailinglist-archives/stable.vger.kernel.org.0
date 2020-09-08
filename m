Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B25E3261C6F
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730987AbgIHTTz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:19:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730887AbgIHQCg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:02:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E93623DC3;
        Tue,  8 Sep 2020 15:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579461;
        bh=z65jUTjMim3bra8SfcrvPj1oYBeAfZCmk/MkBq0obTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yTs5h6aosYH4uyCGL+GqsJZhw2SVSzeYmbeKEy6EA+4NThY/vX+Xp/9gXkj1YOUg9
         MPlrfR0k0DXlgbAX67R5Q2K2fHoA1scpWRO+AKyXVvOu0AkDJ6bVLo7u44Wu3udx0H
         Iy7L5Vamu9RuNdHeUftpWObkEWCdr7cIFxlXeVhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 088/186] net: ethernet: ti: am65-cpsw: fix rmii 100Mbit link mode
Date:   Tue,  8 Sep 2020 17:23:50 +0200
Message-Id: <20200908152245.910885103@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit c2f89219f559502c9292d79f695bab9dcec532d1 ]

In RMII link mode it's required to set bit 15 IFCTL_A in MAC_SL MAC_CONTROL
register to enable support for 100Mbit link speed.

Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 88832277edd5a..c7c9980e02604 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -172,6 +172,8 @@ void am65_cpsw_nuss_adjust_link(struct net_device *ndev)
 		if (phy->speed == 10 && phy_interface_is_rgmii(phy))
 			/* Can be used with in band mode only */
 			mac_control |= CPSW_SL_CTL_EXT_EN;
+		if (phy->speed == 100 && phy->interface == PHY_INTERFACE_MODE_RMII)
+			mac_control |= CPSW_SL_CTL_IFCTL_A;
 		if (phy->duplex)
 			mac_control |= CPSW_SL_CTL_FULLDUPLEX;
 
-- 
2.25.1



