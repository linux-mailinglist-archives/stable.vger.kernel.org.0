Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F5F31BD25
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhBOPlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:41:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:50308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231536AbhBOPh7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:37:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E50464E9F;
        Mon, 15 Feb 2021 15:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403220;
        bh=Pd7h/U7/M3RxVtpr8jsgR0IbIbSsimLYD+f4JCFotas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ypHj6AroglvqX2mLlw/YL9vKLIcqGmSGXNWfwdV6Di2O1XUteN/3PPCANrFig2A30
         9Lm6crbne9GQ8WY9FL1YW3a4c8EpZBhVeJfuOJ214ZYbPCIzfxHP1UtZ9xd0zWd/1M
         nAiFHvnYk/v4SkeZEtwlItEsxl3J621mozLCO/hk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 072/104] net: dsa: felix: implement port flushing on .phylink_mac_link_down
Date:   Mon, 15 Feb 2021 16:27:25 +0100
Message-Id: <20210215152721.781023964@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit eb4733d7cffc547e08fe5a216e4f03663bb71108 ]

There are several issues which may be seen when the link goes down while
forwarding traffic, all of which can be attributed to the fact that the
port flushing procedure from the reference manual was not closely
followed.

With flow control enabled on both the ingress port and the egress port,
it may happen when a link goes down that Ethernet packets are in flight.
In flow control mode, frames are held back and not dropped. When there
is enough traffic in flight (example: iperf3 TCP), then the ingress port
might enter congestion and never exit that state. This is a problem,
because it is the egress port's link that went down, and that has caused
the inability of the ingress port to send packets to any other port.
This is solved by flushing the egress port's queues when it goes down.

There is also a problem when performing stream splitting for
IEEE 802.1CB traffic (not yet upstream, but a sort of multicast,
basically). There, if one port from the destination ports mask goes
down, splitting the stream towards the other destinations will no longer
be performed. This can be traced down to this line:

	ocelot_port_writel(ocelot_port, 0, DEV_MAC_ENA_CFG);

which should have been instead, as per the reference manual:

	ocelot_port_rmwl(ocelot_port, 0, DEV_MAC_ENA_CFG_RX_ENA,
			 DEV_MAC_ENA_CFG);

Basically only DEV_MAC_ENA_CFG_RX_ENA should be disabled, but not
DEV_MAC_ENA_CFG_TX_ENA - I don't have further insight into why that is
the case, but apparently multicasting to several ports will cause issues
if at least one of them doesn't have DEV_MAC_ENA_CFG_TX_ENA set.

I am not sure what the state of the Ocelot VSC7514 driver is, but
probably not as bad as Felix/Seville, since VSC7514 uses phylib and has
the following in ocelot_adjust_link:

	if (!phydev->link)
		return;

therefore the port is not really put down when the link is lost, unlike
the DSA drivers which use .phylink_mac_link_down for that.

Nonetheless, I put ocelot_port_flush() in the common ocelot.c because it
needs to access some registers from drivers/net/ethernet/mscc/ocelot_rew.h
which are not exported in include/soc/mscc/ and a bugfix patch should
probably not move headers around.

Fixes: bdeced75b13f ("net: dsa: felix: Add PCS operations for PHYLINK")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/felix.c        | 17 ++++++++-
 drivers/net/ethernet/mscc/ocelot.c    | 54 +++++++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_io.c |  8 ++++
 include/soc/mscc/ocelot.h             |  2 +
 4 files changed, 80 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index c444ef3da3e24..89d7c9b231863 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -214,9 +214,24 @@ static void felix_phylink_mac_link_down(struct dsa_switch *ds, int port,
 {
 	struct ocelot *ocelot = ds->priv;
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	int err;
+
+	ocelot_port_rmwl(ocelot_port, 0, DEV_MAC_ENA_CFG_RX_ENA,
+			 DEV_MAC_ENA_CFG);
 
-	ocelot_port_writel(ocelot_port, 0, DEV_MAC_ENA_CFG);
 	ocelot_fields_write(ocelot, port, QSYS_SWITCH_PORT_MODE_PORT_ENA, 0);
+
+	err = ocelot_port_flush(ocelot, port);
+	if (err)
+		dev_err(ocelot->dev, "failed to flush port %d: %d\n",
+			port, err);
+
+	/* Put the port in reset. */
+	ocelot_port_writel(ocelot_port,
+			   DEV_CLOCK_CFG_MAC_TX_RST |
+			   DEV_CLOCK_CFG_MAC_RX_RST |
+			   DEV_CLOCK_CFG_LINK_SPEED(OCELOT_SPEED_1000),
+			   DEV_CLOCK_CFG);
 }
 
 static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index d4768dcb6c699..aa400b925b08e 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -348,6 +348,60 @@ static void ocelot_vlan_init(struct ocelot *ocelot)
 	}
 }
 
+static u32 ocelot_read_eq_avail(struct ocelot *ocelot, int port)
+{
+	return ocelot_read_rix(ocelot, QSYS_SW_STATUS, port);
+}
+
+int ocelot_port_flush(struct ocelot *ocelot, int port)
+{
+	int err, val;
+
+	/* Disable dequeuing from the egress queues */
+	ocelot_rmw_rix(ocelot, QSYS_PORT_MODE_DEQUEUE_DIS,
+		       QSYS_PORT_MODE_DEQUEUE_DIS,
+		       QSYS_PORT_MODE, port);
+
+	/* Disable flow control */
+	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, 0);
+
+	/* Disable priority flow control */
+	ocelot_fields_write(ocelot, port,
+			    QSYS_SWITCH_PORT_MODE_TX_PFC_ENA, 0);
+
+	/* Wait at least the time it takes to receive a frame of maximum length
+	 * at the port.
+	 * Worst-case delays for 10 kilobyte jumbo frames are:
+	 * 8 ms on a 10M port
+	 * 800 μs on a 100M port
+	 * 80 μs on a 1G port
+	 * 32 μs on a 2.5G port
+	 */
+	usleep_range(8000, 10000);
+
+	/* Disable half duplex backpressure. */
+	ocelot_rmw_rix(ocelot, 0, SYS_FRONT_PORT_MODE_HDX_MODE,
+		       SYS_FRONT_PORT_MODE, port);
+
+	/* Flush the queues associated with the port. */
+	ocelot_rmw_gix(ocelot, REW_PORT_CFG_FLUSH_ENA, REW_PORT_CFG_FLUSH_ENA,
+		       REW_PORT_CFG, port);
+
+	/* Enable dequeuing from the egress queues. */
+	ocelot_rmw_rix(ocelot, 0, QSYS_PORT_MODE_DEQUEUE_DIS, QSYS_PORT_MODE,
+		       port);
+
+	/* Wait until flushing is complete. */
+	err = read_poll_timeout(ocelot_read_eq_avail, val, !val,
+				100, 2000000, false, ocelot, port);
+
+	/* Clear flushing again. */
+	ocelot_rmw_gix(ocelot, 0, REW_PORT_CFG_FLUSH_ENA, REW_PORT_CFG, port);
+
+	return err;
+}
+EXPORT_SYMBOL(ocelot_port_flush);
+
 void ocelot_adjust_link(struct ocelot *ocelot, int port,
 			struct phy_device *phydev)
 {
diff --git a/drivers/net/ethernet/mscc/ocelot_io.c b/drivers/net/ethernet/mscc/ocelot_io.c
index 0acb459484185..ea4e83410fe4d 100644
--- a/drivers/net/ethernet/mscc/ocelot_io.c
+++ b/drivers/net/ethernet/mscc/ocelot_io.c
@@ -71,6 +71,14 @@ void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg)
 }
 EXPORT_SYMBOL(ocelot_port_writel);
 
+void ocelot_port_rmwl(struct ocelot_port *port, u32 val, u32 mask, u32 reg)
+{
+	u32 cur = ocelot_port_readl(port, reg);
+
+	ocelot_port_writel(port, (cur & (~mask)) | val, reg);
+}
+EXPORT_SYMBOL(ocelot_port_rmwl);
+
 u32 __ocelot_target_read_ix(struct ocelot *ocelot, enum ocelot_target target,
 			    u32 reg, u32 offset)
 {
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 49b46df476f2c..4971b45860a4d 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -703,6 +703,7 @@ struct ocelot_policer {
 /* I/O */
 u32 ocelot_port_readl(struct ocelot_port *port, u32 reg);
 void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
+void ocelot_port_rmwl(struct ocelot_port *port, u32 val, u32 mask, u32 reg);
 u32 __ocelot_read_ix(struct ocelot *ocelot, u32 reg, u32 offset);
 void __ocelot_write_ix(struct ocelot *ocelot, u32 val, u32 reg, u32 offset);
 void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u32 mask, u32 reg,
@@ -731,6 +732,7 @@ int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset);
 int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 		       struct ethtool_ts_info *info);
 void ocelot_set_ageing_time(struct ocelot *ocelot, unsigned int msecs);
+int ocelot_port_flush(struct ocelot *ocelot, int port);
 void ocelot_adjust_link(struct ocelot *ocelot, int port,
 			struct phy_device *phydev);
 int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port, bool enabled,
-- 
2.27.0



