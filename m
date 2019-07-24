Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12B4073FE0
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389330AbfGXUgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:36:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726911AbfGXTZM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:25:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0FD5218EA;
        Wed, 24 Jul 2019 19:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996311;
        bh=ocsnzTKUFD7oyLLLFRv/6GKVWY/hqsru1x4UcvrHu5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ukWMBxPFjvH3ZA/ry+2tXKtIn38RutpF93D+X0B7VgK3+jGBDMJXPMrd3HGhVbQQO
         6ZyDGn1hPAthnYAjGuwxLWYvecNWC2FxriQ2zGLTM83d66Ep5U9Nc6nbiSRFIbsFf0
         M310ZsA66YZuv6m+F5Pg0I3DRDtCFXRyk2w5HteU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 052/413] net: dsa: sja1105: Fix broken fixed-link interfaces on user ports
Date:   Wed, 24 Jul 2019 21:15:43 +0200
Message-Id: <20190724191739.194639131@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit af7cd0366ee994e8b35985d407261dc0ed9dfb4d ]

PHYLIB and PHYLINK handle fixed-link interfaces differently. PHYLIB
wraps them in a software PHY ("pseudo fixed link") phydev construct such
that .adjust_link driver callbacks see an unified API. Whereas PHYLINK
simply creates a phylink_link_state structure and passes it to
.mac_config.

At the time the driver was introduced, DSA was using PHYLIB for the
CPU/cascade ports (the ones with no net devices) and PHYLINK for
everything else.

As explained below:

commit aab9c4067d2389d0adfc9c53806437df7b0fe3d5
Author: Florian Fainelli <f.fainelli@gmail.com>
Date:   Thu May 10 13:17:36 2018 -0700

  net: dsa: Plug in PHYLINK support

  Drivers that utilize fixed links for user-facing ports (e.g: bcm_sf2)
  will need to implement phylink_mac_ops from now on to preserve
  functionality, since PHYLINK *does not* create a phy_device instance
  for fixed links.

In the above patch, DSA guards the .phylink_mac_config callback against
a NULL phydev pointer.  Therefore, .adjust_link is not called in case of
a fixed-link user port.

This patch fixes the situation by converting the driver from using
.adjust_link to .phylink_mac_config.  This can be done now in a unified
fashion for both slave and CPU/cascade ports because DSA now uses
PHYLINK for all ports.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 1c3959efebc4..844e038f3dc6 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -734,15 +734,16 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 	return sja1105_clocking_setup_port(priv, port);
 }
 
-static void sja1105_adjust_link(struct dsa_switch *ds, int port,
-				struct phy_device *phydev)
+static void sja1105_mac_config(struct dsa_switch *ds, int port,
+			       unsigned int link_an_mode,
+			       const struct phylink_link_state *state)
 {
 	struct sja1105_private *priv = ds->priv;
 
-	if (!phydev->link)
+	if (!state->link)
 		sja1105_adjust_port_config(priv, port, 0, false);
 	else
-		sja1105_adjust_port_config(priv, port, phydev->speed, true);
+		sja1105_adjust_port_config(priv, port, state->speed, true);
 }
 
 static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
@@ -1515,9 +1516,9 @@ static int sja1105_set_ageing_time(struct dsa_switch *ds,
 static const struct dsa_switch_ops sja1105_switch_ops = {
 	.get_tag_protocol	= sja1105_get_tag_protocol,
 	.setup			= sja1105_setup,
-	.adjust_link		= sja1105_adjust_link,
 	.set_ageing_time	= sja1105_set_ageing_time,
 	.phylink_validate	= sja1105_phylink_validate,
+	.phylink_mac_config	= sja1105_mac_config,
 	.get_strings		= sja1105_get_strings,
 	.get_ethtool_stats	= sja1105_get_ethtool_stats,
 	.get_sset_count		= sja1105_get_sset_count,
-- 
2.20.1



