Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E7F59494C
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354198AbiHOXnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354349AbiHOXlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:41:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA4E2CC9B;
        Mon, 15 Aug 2022 13:13:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F24EB80EAD;
        Mon, 15 Aug 2022 20:13:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E76DC433C1;
        Mon, 15 Aug 2022 20:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594388;
        bh=8cOxfZWAtNuDvFzWnPkC9PTWdy6BTdwHBklb+CTafL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R5+P4EQLCNKg0YarRQPZxm3rgRlAWYBFlFhQHFBDZDxM7QsRpJswUTp/mhENPezoj
         U7b8Qgk0Rg+cN7gCT2IFvQdB+Y5fjcXdp3z6IChDwah+Ev3CC4t+4j023skzOmTFeu
         U1Vf27J2EpC7qP2/lTs70r+lyHoMIRVNBLurNQc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richie Pearn <richard.pearn@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0430/1157] net: dsa: felix: drop oversized frames with tc-taprio instead of hanging the port
Date:   Mon, 15 Aug 2022 19:56:26 +0200
Message-Id: <20220815180456.868248354@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 55a515b1f5a97df5704a1788fe97a4a740be2b9e ]

Currently, sending a packet into a time gate too small for it (or always
closed) causes the queue system to hold the frame forever. Even worse,
this frame isn't subject to aging either, because for that to happen, it
needs to be scheduled for transmission in the first place. But the frame
will consume buffer memory and frame references while it is forever held
in the queue system.

Before commit a4ae997adcbd ("net: mscc: ocelot: initialize watermarks to
sane defaults"), this behavior was somewhat subtle, as the switch had a
more intricately tuned default watermark configuration out of reset,
which did not allow any single port and tc to consume the entire switch
buffer space. Nonetheless, the held frames are still there, and they
reduce the total backplane capacity of the switch.

However, after the aforementioned commit, the behavior can be very
clearly seen, since we deliberately allow each {port, tc} to consume the
entire shared buffer of the switch minus the reservations (and we
disable all reservations by default). That is to say, we allow a
permanently closed tc-taprio gate to hang the entire switch.

A careful inspection of the documentation shows that the QSYS:Q_MAX_SDU
per-port-tc registers serve 2 purposes: one is for guard band calculation
(when zero, this falls back to QSYS:PORT_MAX_SDU), and the other is to
enable oversized frame dropping (when non-zero).

Currently the QSYS:Q_MAX_SDU registers are all zero, so oversized frame
dropping is disabled. The goal of the change is to enable it seamlessly.
For that, we need to hook into the MTU change, tc-taprio change, and
port link speed change procedures, since we depend on these variables.

Frames are not dropped on egress due to a queue system oversize
condition, instead that egress port is simply excluded from the mask of
valid destination ports for the packet. If there are no destination
ports at all, the ingress counter that increments is the generic
"drop_tail" in ethtool -S.

The issue exists in various forms since the tc-taprio offload was introduced.

Fixes: de143c0e274b ("net: dsa: felix: Configure Time-Aware Scheduler via taprio offload")
Reported-by: Richie Pearn <richard.pearn@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/felix.c         |   9 ++
 drivers/net/dsa/ocelot/felix.h         |   1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c | 201 +++++++++++++++++++++++++
 3 files changed, 211 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 3e07dc39007a..859196898a7d 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1553,9 +1553,18 @@ static void felix_txtstamp(struct dsa_switch *ds, int port,
 static int felix_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 {
 	struct ocelot *ocelot = ds->priv;
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	struct felix *felix = ocelot_to_felix(ocelot);
 
 	ocelot_port_set_maxlen(ocelot, port, new_mtu);
 
+	mutex_lock(&ocelot->tas_lock);
+
+	if (ocelot_port->taprio && felix->info->tas_guard_bands_update)
+		felix->info->tas_guard_bands_update(ocelot, port);
+
+	mutex_unlock(&ocelot->tas_lock);
+
 	return 0;
 }
 
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 9e07eb7ee28d..deb8dde1fc19 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -53,6 +53,7 @@ struct felix_info {
 				    struct phylink_link_state *state);
 	int	(*port_setup_tc)(struct dsa_switch *ds, int port,
 				 enum tc_setup_type type, void *type_data);
+	void	(*tas_guard_bands_update)(struct ocelot *ocelot, int port);
 	void	(*port_sched_speed_set)(struct ocelot *ocelot, int port,
 					u32 speed);
 	struct regmap *(*init_regmap)(struct ocelot *ocelot,
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 12792362bbee..643f13702dc7 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1127,9 +1127,199 @@ static void vsc9959_mdio_bus_free(struct ocelot *ocelot)
 	mdiobus_free(felix->imdio);
 }
 
+/* Extract shortest continuous gate open intervals in ns for each traffic class
+ * of a cyclic tc-taprio schedule. If a gate is always open, the duration is
+ * considered U64_MAX. If the gate is always closed, it is considered 0.
+ */
+static void vsc9959_tas_min_gate_lengths(struct tc_taprio_qopt_offload *taprio,
+					 u64 min_gate_len[OCELOT_NUM_TC])
+{
+	struct tc_taprio_sched_entry *entry;
+	u64 gate_len[OCELOT_NUM_TC];
+	int tc, i, n;
+
+	/* Initialize arrays */
+	for (tc = 0; tc < OCELOT_NUM_TC; tc++) {
+		min_gate_len[tc] = U64_MAX;
+		gate_len[tc] = 0;
+	}
+
+	/* If we don't have taprio, consider all gates as permanently open */
+	if (!taprio)
+		return;
+
+	n = taprio->num_entries;
+
+	/* Walk through the gate list twice to determine the length
+	 * of consecutively open gates for a traffic class, including
+	 * open gates that wrap around. We are just interested in the
+	 * minimum window size, and this doesn't change what the
+	 * minimum is (if the gate never closes, min_gate_len will
+	 * remain U64_MAX).
+	 */
+	for (i = 0; i < 2 * n; i++) {
+		entry = &taprio->entries[i % n];
+
+		for (tc = 0; tc < OCELOT_NUM_TC; tc++) {
+			if (entry->gate_mask & BIT(tc)) {
+				gate_len[tc] += entry->interval;
+			} else {
+				/* Gate closes now, record a potential new
+				 * minimum and reinitialize length
+				 */
+				if (min_gate_len[tc] > gate_len[tc])
+					min_gate_len[tc] = gate_len[tc];
+				gate_len[tc] = 0;
+			}
+		}
+	}
+}
+
+/* Update QSYS_PORT_MAX_SDU to make sure the static guard bands added by the
+ * switch (see the ALWAYS_GUARD_BAND_SCH_Q comment) are correct at all MTU
+ * values (the default value is 1518). Also, for traffic class windows smaller
+ * than one MTU sized frame, update QSYS_QMAXSDU_CFG to enable oversized frame
+ * dropping, such that these won't hang the port, as they will never be sent.
+ */
+static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	u64 min_gate_len[OCELOT_NUM_TC];
+	int speed, picos_per_byte;
+	u64 needed_bit_time_ps;
+	u32 val, maxlen;
+	u8 tas_speed;
+	int tc;
+
+	lockdep_assert_held(&ocelot->tas_lock);
+
+	val = ocelot_read_rix(ocelot, QSYS_TAG_CONFIG, port);
+	tas_speed = QSYS_TAG_CONFIG_LINK_SPEED_X(val);
+
+	switch (tas_speed) {
+	case OCELOT_SPEED_10:
+		speed = SPEED_10;
+		break;
+	case OCELOT_SPEED_100:
+		speed = SPEED_100;
+		break;
+	case OCELOT_SPEED_1000:
+		speed = SPEED_1000;
+		break;
+	case OCELOT_SPEED_2500:
+		speed = SPEED_2500;
+		break;
+	default:
+		return;
+	}
+
+	picos_per_byte = (USEC_PER_SEC * 8) / speed;
+
+	val = ocelot_port_readl(ocelot_port, DEV_MAC_MAXLEN_CFG);
+	/* MAXLEN_CFG accounts automatically for VLAN. We need to include it
+	 * manually in the bit time calculation, plus the preamble and SFD.
+	 */
+	maxlen = val + 2 * VLAN_HLEN;
+	/* Consider the standard Ethernet overhead of 8 octets preamble+SFD,
+	 * 4 octets FCS, 12 octets IFG.
+	 */
+	needed_bit_time_ps = (maxlen + 24) * picos_per_byte;
+
+	dev_dbg(ocelot->dev,
+		"port %d: max frame size %d needs %llu ps at speed %d\n",
+		port, maxlen, needed_bit_time_ps, speed);
+
+	vsc9959_tas_min_gate_lengths(ocelot_port->taprio, min_gate_len);
+
+	for (tc = 0; tc < OCELOT_NUM_TC; tc++) {
+		u32 max_sdu;
+
+		if (min_gate_len[tc] == U64_MAX /* Gate always open */ ||
+		    min_gate_len[tc] * 1000 > needed_bit_time_ps) {
+			/* Setting QMAXSDU_CFG to 0 disables oversized frame
+			 * dropping.
+			 */
+			max_sdu = 0;
+			dev_dbg(ocelot->dev,
+				"port %d tc %d min gate len %llu"
+				", sending all frames\n",
+				port, tc, min_gate_len[tc]);
+		} else {
+			/* If traffic class doesn't support a full MTU sized
+			 * frame, make sure to enable oversize frame dropping
+			 * for frames larger than the smallest that would fit.
+			 */
+			max_sdu = div_u64(min_gate_len[tc] * 1000,
+					  picos_per_byte);
+			/* A TC gate may be completely closed, which is a
+			 * special case where all packets are oversized.
+			 * Any limit smaller than 64 octets accomplishes this
+			 */
+			if (!max_sdu)
+				max_sdu = 1;
+			/* Take L1 overhead into account, but just don't allow
+			 * max_sdu to go negative or to 0. Here we use 20
+			 * because QSYS_MAXSDU_CFG_* already counts the 4 FCS
+			 * octets as part of packet size.
+			 */
+			if (max_sdu > 20)
+				max_sdu -= 20;
+			dev_info(ocelot->dev,
+				 "port %d tc %d min gate length %llu"
+				 " ns not enough for max frame size %d at %d"
+				 " Mbps, dropping frames over %d"
+				 " octets including FCS\n",
+				 port, tc, min_gate_len[tc], maxlen, speed,
+				 max_sdu);
+		}
+
+		/* ocelot_write_rix is a macro that concatenates
+		 * QSYS_MAXSDU_CFG_* with _RSZ, so we need to spell out
+		 * the writes to each traffic class
+		 */
+		switch (tc) {
+		case 0:
+			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_0,
+					 port);
+			break;
+		case 1:
+			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_1,
+					 port);
+			break;
+		case 2:
+			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_2,
+					 port);
+			break;
+		case 3:
+			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_3,
+					 port);
+			break;
+		case 4:
+			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_4,
+					 port);
+			break;
+		case 5:
+			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_5,
+					 port);
+			break;
+		case 6:
+			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_6,
+					 port);
+			break;
+		case 7:
+			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_7,
+					 port);
+			break;
+		}
+	}
+
+	ocelot_write_rix(ocelot, maxlen, QSYS_PORT_MAX_SDU, port);
+}
+
 static void vsc9959_sched_speed_set(struct ocelot *ocelot, int port,
 				    u32 speed)
 {
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u8 tas_speed;
 
 	switch (speed) {
@@ -1154,6 +1344,13 @@ static void vsc9959_sched_speed_set(struct ocelot *ocelot, int port,
 		       QSYS_TAG_CONFIG_LINK_SPEED(tas_speed),
 		       QSYS_TAG_CONFIG_LINK_SPEED_M,
 		       QSYS_TAG_CONFIG, port);
+
+	mutex_lock(&ocelot->tas_lock);
+
+	if (ocelot_port->taprio)
+		vsc9959_tas_guard_bands_update(ocelot, port);
+
+	mutex_unlock(&ocelot->tas_lock);
 }
 
 static void vsc9959_new_base_time(struct ocelot *ocelot, ktime_t base_time,
@@ -1213,6 +1410,8 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 		taprio_offload_free(ocelot_port->taprio);
 		ocelot_port->taprio = NULL;
 
+		vsc9959_tas_guard_bands_update(ocelot, port);
+
 		mutex_unlock(&ocelot->tas_lock);
 		return 0;
 	}
@@ -1287,6 +1486,7 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 		goto err;
 
 	ocelot_port->taprio = taprio_offload_get(taprio);
+	vsc9959_tas_guard_bands_update(ocelot, port);
 
 err:
 	mutex_unlock(&ocelot->tas_lock);
@@ -2314,6 +2514,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.port_modes		= vsc9959_port_modes,
 	.port_setup_tc		= vsc9959_port_setup_tc,
 	.port_sched_speed_set	= vsc9959_sched_speed_set,
+	.tas_guard_bands_update	= vsc9959_tas_guard_bands_update,
 	.init_regmap		= ocelot_regmap_init,
 };
 
-- 
2.35.1



