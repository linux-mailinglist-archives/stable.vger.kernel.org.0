Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE1DC41250A
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353510AbhITSlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:41:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1381719AbhITSjN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:39:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E65D6127A;
        Mon, 20 Sep 2021 17:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159033;
        bh=leO96kbURlF2o9JVp1cR10FCQGvL+ciEs8fPANnyStg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IBK/dckzI2ZeHgXHXjoSDc9hEZpgs3Ch/czSt+EFOiOjEvDV0vx2tuRUq6vkqtGKu
         VtuEaLB+hjSlxKDP5EggE737cQPjzowcg5bgaaoN543SjWybhSj4Fdwmk0lQJXg/6i
         Z1jNGl4pDZ+xkitLqT/uXNCRHPF4IVKze6e1JATE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrius V <vezhlys@gmail.com>,
        Darek Strugacz <darek.strugacz@op.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 045/168] r6040: Restore MDIO clock frequency after MAC reset
Date:   Mon, 20 Sep 2021 18:43:03 +0200
Message-Id: <20210920163923.126693900@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit e3f0cc1a945fcefec0c7c9d9dfd028a51daa1846 upstream.

A number of users have reported that they were not able to get the PHY
to successfully link up, especially after commit c36757eb9dee ("net:
phy: consider AN_RESTART status when reading link status") where we
stopped reading just BMSR, but we also read BMCR to determine the link
status.

Andrius at NetBSD did a wonderful job at debugging the problem
and found out that the MDIO bus clock frequency would be incorrectly set
back to its default value which would prevent the MDIO bus controller
from reading PHY registers properly. Back when we only read BMSR, if we
read all 1s, we could falsely indicate a link status, though in general
there is a cable plugged in, so this went unnoticed. After a second read
of BMCR was added, a wrong read will lead to the inability to determine
a link UP condition which is when it started to be visibly broken, even
if it was long before that.

The fix consists in restoring the value of the MD_CSR register that was
set prior to the MAC reset.

Link: http://gnats.netbsd.org/cgi-bin/query-pr-single.pl?number=53494
Fixes: 90f750a81a29 ("r6040: consolidate MAC reset to its own function")
Reported-by: Andrius V <vezhlys@gmail.com>
Reported-by: Darek Strugacz <darek.strugacz@op.pl>
Tested-by: Darek Strugacz <darek.strugacz@op.pl>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/rdc/r6040.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/rdc/r6040.c
+++ b/drivers/net/ethernet/rdc/r6040.c
@@ -119,6 +119,8 @@
 #define PHY_ST		0x8A	/* PHY status register */
 #define MAC_SM		0xAC	/* MAC status machine */
 #define  MAC_SM_RST	0x0002	/* MAC status machine reset */
+#define MD_CSC		0xb6	/* MDC speed control register */
+#define  MD_CSC_DEFAULT	0x0030
 #define MAC_ID		0xBE	/* Identifier register */
 
 #define TX_DCNT		0x80	/* TX descriptor count */
@@ -355,8 +357,9 @@ static void r6040_reset_mac(struct r6040
 {
 	void __iomem *ioaddr = lp->base;
 	int limit = MAC_DEF_TIMEOUT;
-	u16 cmd;
+	u16 cmd, md_csc;
 
+	md_csc = ioread16(ioaddr + MD_CSC);
 	iowrite16(MAC_RST, ioaddr + MCR1);
 	while (limit--) {
 		cmd = ioread16(ioaddr + MCR1);
@@ -368,6 +371,10 @@ static void r6040_reset_mac(struct r6040
 	iowrite16(MAC_SM_RST, ioaddr + MAC_SM);
 	iowrite16(0, ioaddr + MAC_SM);
 	mdelay(5);
+
+	/* Restore MDIO clock frequency */
+	if (md_csc != MD_CSC_DEFAULT)
+		iowrite16(md_csc, ioaddr + MD_CSC);
 }
 
 static void r6040_init_mac_regs(struct net_device *dev)


