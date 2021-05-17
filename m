Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDDF382EB4
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238085AbhEQOKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:10:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238126AbhEQOIQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:08:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A06D460720;
        Mon, 17 May 2021 14:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260394;
        bh=X3FQxJdww4G9BL4nHozkNPwQLtFFvOmKCWJyeQ5Rj5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1As1900R37PuqTzAVVBVRZ2Wg+NZT4G3KIc0idtTDxalvFN6WqT+aYgh29MqczK3o
         8DdUAy6oG6Iu+L7vDFZ5mtLf0VXp8p3r4k5jPcxRl4E1V4QF/ZPmbpUY3Xcpj8HzxU
         aH/YZF20a8mUCJoIQiaIqoHD+ebV/HbPY7RgUuNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 060/363] net: fec: use mac-managed PHY PM
Date:   Mon, 17 May 2021 15:58:46 +0200
Message-Id: <20210517140304.641672342@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 557d5dc83f6831b4e54d141e9b121850406f9a60 ]

Use the new mac_managed_pm flag to work around an issue with KSZ8081 PHY
that becomes unstable when a soft reset is triggered during aneg.

Reported-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Tested-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 3db882322b2b..70aea9c274fe 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2048,6 +2048,8 @@ static int fec_enet_mii_probe(struct net_device *ndev)
 	fep->link = 0;
 	fep->full_duplex = 0;
 
+	phy_dev->mac_managed_pm = 1;
+
 	phy_attached_info(phy_dev);
 
 	return 0;
@@ -3864,6 +3866,7 @@ static int __maybe_unused fec_resume(struct device *dev)
 		netif_device_attach(ndev);
 		netif_tx_unlock_bh(ndev);
 		napi_enable(&fep->napi);
+		phy_init_hw(ndev->phydev);
 		phy_start(ndev->phydev);
 	}
 	rtnl_unlock();
-- 
2.30.2



