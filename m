Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C755411AFC
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244641AbhITQyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:54:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:39768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244480AbhITQwN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:52:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CD1B6126A;
        Mon, 20 Sep 2021 16:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156580;
        bh=TH9Uqq0frq96kNIR/4jqQDsgvg16xDhg2iBSm7ZzbdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L4vg2nzyUiDq+QvrLYIxFqesBG1wz78+w20uryqGjhMRqUHP6rjin7uQ9KQRcSY00
         7cIBstOERfI2aLHM1Rv/q9INPKXf/URR43gI9WEHTf37zTatm/sQP4TR9JVcXvyznI
         995p5njD9PsgytJWKp34ddW4MlNCGi2+17Z2m3Yo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrius V <vezhlys@gmail.com>,
        Darek Strugacz <darek.strugacz@op.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 123/133] r6040: Restore MDIO clock frequency after MAC reset
Date:   Mon, 20 Sep 2021 18:43:21 +0200
Message-Id: <20210920163916.651851656@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
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
@@ -133,6 +133,8 @@
 #define PHY_ST		0x8A	/* PHY status register */
 #define MAC_SM		0xAC	/* MAC status machine */
 #define  MAC_SM_RST	0x0002	/* MAC status machine reset */
+#define MD_CSC		0xb6	/* MDC speed control register */
+#define  MD_CSC_DEFAULT	0x0030
 #define MAC_ID		0xBE	/* Identifier register */
 
 #define TX_DCNT		0x80	/* TX descriptor count */
@@ -369,8 +371,9 @@ static void r6040_reset_mac(struct r6040
 {
 	void __iomem *ioaddr = lp->base;
 	int limit = MAC_DEF_TIMEOUT;
-	u16 cmd;
+	u16 cmd, md_csc;
 
+	md_csc = ioread16(ioaddr + MD_CSC);
 	iowrite16(MAC_RST, ioaddr + MCR1);
 	while (limit--) {
 		cmd = ioread16(ioaddr + MCR1);
@@ -382,6 +385,10 @@ static void r6040_reset_mac(struct r6040
 	iowrite16(MAC_SM_RST, ioaddr + MAC_SM);
 	iowrite16(0, ioaddr + MAC_SM);
 	mdelay(5);
+
+	/* Restore MDIO clock frequency */
+	if (md_csc != MD_CSC_DEFAULT)
+		iowrite16(md_csc, ioaddr + MD_CSC);
 }
 
 static void r6040_init_mac_regs(struct net_device *dev)


