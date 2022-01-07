Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3CE4878F5
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 15:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbiAGOax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 09:30:53 -0500
Received: from mickerik.phytec.de ([195.145.39.210]:54722 "EHLO
        mickerik.phytec.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233190AbiAGOax (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 09:30:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; d=phytec.de; s=a4; c=relaxed/simple;
        q=dns/txt; i=@phytec.de; t=1641565852; x=1644157852;
        h=From:Sender:Reply-To:Subject:Date:Message-ID:To:CC:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ac+CllfB0vvLwGYoCTxoA2SBpZWaxy+NzPdGANpE5Q0=;
        b=ToIk+Y6/ZNQeg3/lX9xy9M6wWu9ws4DJ4GclycVuf5tHTClPMqlUhn+BjmG22mtD
        4LlM4INMxInqxgNEgWl4T5cOuLepwEJX1yUBJKgI3Bl6Wyds6WrIQoA/ttYkgOZH
        Lidnu9M4OUSNjIc9bvgikdopSd+9YC/RUoARwOxqiT4=;
X-AuditID: c39127d2-93d2170000002a63-69-61d84e9cc5aa
Received: from berlix.phytec.de (Berlix.phytec.de [172.16.0.117])
        (using TLS with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mickerik.phytec.de (PHYTEC Mail Gateway) with SMTP id F2.1D.10851.C9E48D16; Fri,  7 Jan 2022 15:30:52 +0100 (CET)
Received: from augenblix2.phytec.de (172.16.0.116) by Berlix.phytec.de
 (172.16.0.117) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Fri, 7 Jan
 2022 15:30:52 +0100
From:   Wadim Egorov <w.egorov@phytec.de>
To:     <stable@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4] net: phy: micrel: set soft_reset callback to genphy_soft_reset for KSZ8081
Date:   Fri, 7 Jan 2022 15:30:43 +0100
Message-ID: <20220107143043.2189378-1-w.egorov@phytec.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.16.0.116]
X-ClientProxiedBy: Berlix.phytec.de (172.16.0.117) To Berlix.phytec.de
 (172.16.0.117)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrELMWRmVeSWpSXmKPExsWyRoChVHeO341EgwWnhC2aF69ns1iw8RGj
        A5PH/rlr2D0+b5ILYIrisklJzcksSy3St0vgyrj16xVbwRyeiudPZBsYN3F1MXJySAiYSJx9
        sZW5i5GLQ0hgGZPElgmX2CGcp4wSBxbfZAKpYhNQl7iz4RsriC0iICMxvXUvWJxZQEHiUecG
        FhBbWCBeoqPjBpjNIqAi0TTvGTOIzStgKXH3yllWiG3yEjMvfWeHiAtKnJz5hAVijrxE89bZ
        zBC2hMTBFy/AbCGg+ItLy1kgehUk5v6eyAxhh0u8PfWbeQKjwCwko2YhGTULyagFjMyrGIVy
        M5OzU4sys/UKMipLUpP1UlI3MQLD8fBE9Us7GPvmeBxiZOJgPMQowcGsJMI7de+1RCHelMTK
        qtSi/Pii0pzU4kOM0hwsSuK893uYEoUE0hNLUrNTUwtSi2CyTBycUg2MGcyCM9ziDFkj73qm
        Cc3ZfqZvTtfmjzw20u8YlH9cbneVWqb58k5it5+14tySCVNEeuY/zV7eFBV31Hb+r7aXVeXv
        1XyuZO/+sVq8ZeImHvNW76Af3Ec7JA8dm1+36j8zg+2pG3f+n1unNY3X4g3P90msi3ccF46K
        Mq7t+TrvTq5lzkPPF5/qlViKMxINtZiLihMBiEFVljUCAAA=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Melki <christian.melki@t2data.com>

commit 764d31cacfe48440745c4bbb55a62ac9471c9f19 upstream.

Following a similar reinstate for the KSZ9031.

Older kernels would use the genphy_soft_reset if the PHY did not implement
a .soft_reset.

Bluntly removing that default may expose a lot of situations where various
PHYs/board implementations won't recover on various changes.
Like with this implementation during a 4.9.x to 5.4.x LTS transition.
I think it's a good thing to remove unwanted soft resets but wonder if it
did open a can of worms?

Atleast this fixes one iMX6 FEC/RMII/8081 combo.

Fixes: 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
Signed-off-by: Christian Melki <christian.melki@t2data.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20210224205536.9349-1-christian.melki@t2data.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Wadim Egorov <w.egorov@phytec.de>
---
 drivers/net/phy/micrel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 0b61d80ea3f8..18cc5e4280e8 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1096,6 +1096,7 @@ static struct phy_driver ksphy_driver[] = {
 	.probe		= kszphy_probe,
 	.config_init	= ksz8081_config_init,
 	.ack_interrupt	= kszphy_ack_interrupt,
+	.soft_reset	= genphy_soft_reset,
 	.config_intr	= kszphy_config_intr,
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
-- 
2.25.1

