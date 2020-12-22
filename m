Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426042DEF1D
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbgLSM7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 07:59:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:46014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727970AbgLSM7J (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:59:09 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eldar Gasanov <eldargasanov2@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 08/49] net: mscc: ocelot: fix dropping of unknown IPv4 multicast on Seville
Date:   Sat, 19 Dec 2020 13:58:12 +0100
Message-Id: <20201219125345.082145392@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125344.671832095@linuxfoundation.org>
References: <20201219125344.671832095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit edd2410b165e2ef00b2264ae362edf7441ca929c ]

The current assumption is that the felix DSA driver has flooding knobs
per traffic class, while ocelot switchdev has a single flooding knob.
This was correct for felix VSC9959 and ocelot VSC7514, but with the
introduction of seville VSC9953, we see a switch driven by felix.c which
has a single flooding knob.

So it is clear that we must do what should have been done from the
beginning, which is not to overwrite the configuration done by ocelot.c
in felix, but instead to teach the common ocelot library about the
differences in our switches, and set up the flooding PGIDs centrally.

The effect that the bogus iteration through FELIX_NUM_TC has upon
seville is quite dramatic. ANA_FLOODING is located at 0x00b548, and
ANA_FLOODING_IPMC is located at 0x00b54c. So the bogus iteration will
actually overwrite ANA_FLOODING_IPMC when attempting to write
ANA_FLOODING[1]. There is no ANA_FLOODING[1] in sevile, just ANA_FLOODING.

And when ANA_FLOODING_IPMC is overwritten with a bogus value, the effect
is that ANA_FLOODING_IPMC gets the value of 0x0003CF7D:
	MC6_DATA = 61,
	MC6_CTRL = 61,
	MC4_DATA = 60,
	MC4_CTRL = 0.
Because MC4_CTRL is zero, this means that IPv4 multicast control packets
are not flooded, but dropped. An invalid configuration, and this is how
the issue was actually spotted.

Reported-by: Eldar Gasanov <eldargasanov2@gmail.com>
Reported-by: Maxim Kochetkov <fido_max@inbox.ru>
Tested-by: Eldar Gasanov <eldargasanov2@gmail.com>
Fixes: 84705fc16552 ("net: dsa: felix: introduce support for Seville VSC9953 switch")
Fixes: 3c7b51bd39b2 ("net: dsa: felix: allow flooding for all traffic classes")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20201204175416.1445937-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/ocelot/felix.c             |    7 -------
 drivers/net/dsa/ocelot/felix_vsc9959.c     |    1 +
 drivers/net/dsa/ocelot/seville_vsc9953.c   |    1 +
 drivers/net/ethernet/mscc/ocelot.c         |    9 +++++----
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |    1 +
 include/soc/mscc/ocelot.h                  |    3 +++
 6 files changed, 11 insertions(+), 11 deletions(-)

--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -579,7 +579,6 @@ static int felix_setup(struct dsa_switch
 	struct ocelot *ocelot = ds->priv;
 	struct felix *felix = ocelot_to_felix(ocelot);
 	int port, err;
-	int tc;
 
 	err = felix_init_structs(felix, ds->num_ports);
 	if (err)
@@ -621,12 +620,6 @@ static int felix_setup(struct dsa_switch
 	ocelot_write_rix(ocelot,
 			 ANA_PGID_PGID_PGID(GENMASK(ocelot->num_phys_ports, 0)),
 			 ANA_PGID_PGID, PGID_UC);
-	/* Setup the per-traffic class flooding PGIDs */
-	for (tc = 0; tc < FELIX_NUM_TC; tc++)
-		ocelot_write_rix(ocelot, ANA_FLOODING_FLD_MULTICAST(PGID_MC) |
-				 ANA_FLOODING_FLD_BROADCAST(PGID_MC) |
-				 ANA_FLOODING_FLD_UNICAST(PGID_UC),
-				 ANA_FLOODING, tc);
 
 	ds->mtu_enforcement_ingress = true;
 	ds->configure_vlan_while_not_filtering = true;
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1588,6 +1588,7 @@ static int felix_pci_probe(struct pci_de
 	pci_set_drvdata(pdev, felix);
 	ocelot = &felix->ocelot;
 	ocelot->dev = &pdev->dev;
+	ocelot->num_flooding_pgids = FELIX_NUM_TC;
 	felix->info = &felix_info_vsc9959;
 	felix->switch_base = pci_resource_start(pdev,
 						felix->info->switch_pci_bar);
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1042,6 +1042,7 @@ static int seville_probe(struct platform
 
 	ocelot = &felix->ocelot;
 	ocelot->dev = &pdev->dev;
+	ocelot->num_flooding_pgids = 1;
 	felix->info = &seville_info_vsc9953;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1485,10 +1485,11 @@ int ocelot_init(struct ocelot *ocelot)
 		     SYS_FRM_AGING_MAX_AGE(307692), SYS_FRM_AGING);
 
 	/* Setup flooding PGIDs */
-	ocelot_write_rix(ocelot, ANA_FLOODING_FLD_MULTICAST(PGID_MC) |
-			 ANA_FLOODING_FLD_BROADCAST(PGID_MC) |
-			 ANA_FLOODING_FLD_UNICAST(PGID_UC),
-			 ANA_FLOODING, 0);
+	for (i = 0; i < ocelot->num_flooding_pgids; i++)
+		ocelot_write_rix(ocelot, ANA_FLOODING_FLD_MULTICAST(PGID_MC) |
+				 ANA_FLOODING_FLD_BROADCAST(PGID_MC) |
+				 ANA_FLOODING_FLD_UNICAST(PGID_UC),
+				 ANA_FLOODING, i);
 	ocelot_write(ocelot, ANA_FLOODING_IPMC_FLD_MC6_DATA(PGID_MCIPV6) |
 		     ANA_FLOODING_IPMC_FLD_MC6_CTRL(PGID_MC) |
 		     ANA_FLOODING_IPMC_FLD_MC4_DATA(PGID_MCIPV4) |
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -1118,6 +1118,7 @@ static int mscc_ocelot_probe(struct plat
 	}
 
 	ocelot->num_phys_ports = of_get_child_count(ports);
+	ocelot->num_flooding_pgids = 1;
 
 	ocelot->vcap_is2_keys = vsc7514_vcap_is2_keys;
 	ocelot->vcap_is2_actions = vsc7514_vcap_is2_actions;
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -597,6 +597,9 @@ struct ocelot {
 	/* Keep track of the vlan port masks */
 	u32				vlan_mask[VLAN_N_VID];
 
+	/* Switches like VSC9959 have flooding per traffic class */
+	int				num_flooding_pgids;
+
 	/* In tables like ANA:PORT and the ANA:PGID:PGID mask,
 	 * the CPU is located after the physical ports (at the
 	 * num_phys_ports index).


