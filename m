Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A351A5B7045
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbiIMOYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbiIMOXy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:23:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158FC6578;
        Tue, 13 Sep 2022 07:15:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 354D1CE1270;
        Tue, 13 Sep 2022 14:14:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C91C433D7;
        Tue, 13 Sep 2022 14:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078448;
        bh=t0MYGahz6egJ+awirWYXXG27TOSlM335JIW1IsPfz5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nWFeeJ/hB8dPMWuYnb/Wo+djU/RoWUrsiAih+AF/kggQe6gWvxscfazoobXNN6O2V
         v7YKbjiljpacmCsux+WA+1GGTOjg49EAcO5MbXTBNZJwURMZAQTtMXIAM85iZzLCBH
         we7Qu1/CV3/X3n3O2SSbCpMbspUAx86BVw64yc1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 144/192] net: dsa: felix: disable cut-through forwarding for frames oversized for tc-taprio
Date:   Tue, 13 Sep 2022 16:04:10 +0200
Message-Id: <20220913140417.194627266@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

[ Upstream commit 843794bbdef83955ae5b43dfafc355c3786e2145 ]

Experimentally, it looks like when QSYS_QMAXSDU_CFG_7 is set to 605,
frames even way larger than 601 octets are transmitted even though these
should be considered as oversized, according to the documentation, and
dropped.

Since oversized frame dropping depends on frame size, which is only
known at the EOF stage, and therefore not at SOF when cut-through
forwarding begins, it means that the switch cannot take QSYS_QMAXSDU_CFG_*
into consideration for traffic classes that are cut-through.

Since cut-through forwarding has no UAPI to control it, and the driver
enables it based on the mantra "if we can, then why not", the strategy
is to alter vsc9959_cut_through_fwd() to take into consideration which
tc's have oversize frame dropping enabled, and disable cut-through for
them. Then, from vsc9959_tas_guard_bands_update(), we re-trigger the
cut-through determination process.

There are 2 strategies for vsc9959_cut_through_fwd() to determine
whether a tc has oversized dropping enabled or not. One is to keep a bit
mask of traffic classes per port, and the other is to read back from the
hardware registers (a non-zero value of QSYS_QMAXSDU_CFG_* means the
feature is enabled). We choose reading back from registers, because
struct ocelot_port is shared with drivers (ocelot, seville) that don't
support either cut-through nor tc-taprio, and we don't have a felix
specific extension of struct ocelot_port. Furthermore, reading registers
from the Felix hardware is quite cheap, since they are memory-mapped.

Fixes: 55a515b1f5a9 ("net: dsa: felix: drop oversized frames with tc-taprio instead of hanging the port")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 122 ++++++++++++++++---------
 1 file changed, 79 insertions(+), 43 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 6439b56f381f9..2a5822c619ef3 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1471,6 +1471,65 @@ static void vsc9959_tas_min_gate_lengths(struct tc_taprio_qopt_offload *taprio,
 			min_gate_len[tc] = 0;
 }
 
+/* ocelot_write_rix is a macro that concatenates QSYS_MAXSDU_CFG_* with _RSZ,
+ * so we need to spell out the register access to each traffic class in helper
+ * functions, to simplify callers
+ */
+static void vsc9959_port_qmaxsdu_set(struct ocelot *ocelot, int port, int tc,
+				     u32 max_sdu)
+{
+	switch (tc) {
+	case 0:
+		ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_0,
+				 port);
+		break;
+	case 1:
+		ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_1,
+				 port);
+		break;
+	case 2:
+		ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_2,
+				 port);
+		break;
+	case 3:
+		ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_3,
+				 port);
+		break;
+	case 4:
+		ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_4,
+				 port);
+		break;
+	case 5:
+		ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_5,
+				 port);
+		break;
+	case 6:
+		ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_6,
+				 port);
+		break;
+	case 7:
+		ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_7,
+				 port);
+		break;
+	}
+}
+
+static u32 vsc9959_port_qmaxsdu_get(struct ocelot *ocelot, int port, int tc)
+{
+	switch (tc) {
+	case 0: return ocelot_read_rix(ocelot, QSYS_QMAXSDU_CFG_0, port);
+	case 1: return ocelot_read_rix(ocelot, QSYS_QMAXSDU_CFG_1, port);
+	case 2: return ocelot_read_rix(ocelot, QSYS_QMAXSDU_CFG_2, port);
+	case 3: return ocelot_read_rix(ocelot, QSYS_QMAXSDU_CFG_3, port);
+	case 4: return ocelot_read_rix(ocelot, QSYS_QMAXSDU_CFG_4, port);
+	case 5: return ocelot_read_rix(ocelot, QSYS_QMAXSDU_CFG_5, port);
+	case 6: return ocelot_read_rix(ocelot, QSYS_QMAXSDU_CFG_6, port);
+	case 7: return ocelot_read_rix(ocelot, QSYS_QMAXSDU_CFG_7, port);
+	default:
+		return 0;
+	}
+}
+
 /* Update QSYS_PORT_MAX_SDU to make sure the static guard bands added by the
  * switch (see the ALWAYS_GUARD_BAND_SCH_Q comment) are correct at all MTU
  * values (the default value is 1518). Also, for traffic class windows smaller
@@ -1527,6 +1586,8 @@ static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
 
 	vsc9959_tas_min_gate_lengths(ocelot_port->taprio, min_gate_len);
 
+	mutex_lock(&ocelot->fwd_domain_lock);
+
 	for (tc = 0; tc < OCELOT_NUM_TC; tc++) {
 		u32 max_sdu;
 
@@ -1569,47 +1630,14 @@ static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
 				 max_sdu);
 		}
 
-		/* ocelot_write_rix is a macro that concatenates
-		 * QSYS_MAXSDU_CFG_* with _RSZ, so we need to spell out
-		 * the writes to each traffic class
-		 */
-		switch (tc) {
-		case 0:
-			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_0,
-					 port);
-			break;
-		case 1:
-			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_1,
-					 port);
-			break;
-		case 2:
-			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_2,
-					 port);
-			break;
-		case 3:
-			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_3,
-					 port);
-			break;
-		case 4:
-			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_4,
-					 port);
-			break;
-		case 5:
-			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_5,
-					 port);
-			break;
-		case 6:
-			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_6,
-					 port);
-			break;
-		case 7:
-			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_7,
-					 port);
-			break;
-		}
+		vsc9959_port_qmaxsdu_set(ocelot, port, tc, max_sdu);
 	}
 
 	ocelot_write_rix(ocelot, maxlen, QSYS_PORT_MAX_SDU, port);
+
+	ocelot->ops->cut_through_fwd(ocelot);
+
+	mutex_unlock(&ocelot->fwd_domain_lock);
 }
 
 static void vsc9959_sched_speed_set(struct ocelot *ocelot, int port,
@@ -2709,7 +2737,7 @@ static void vsc9959_cut_through_fwd(struct ocelot *ocelot)
 {
 	struct felix *felix = ocelot_to_felix(ocelot);
 	struct dsa_switch *ds = felix->ds;
-	int port, other_port;
+	int tc, port, other_port;
 
 	lockdep_assert_held(&ocelot->fwd_domain_lock);
 
@@ -2753,19 +2781,27 @@ static void vsc9959_cut_through_fwd(struct ocelot *ocelot)
 				min_speed = other_ocelot_port->speed;
 		}
 
-		/* Enable cut-through forwarding for all traffic classes. */
-		if (ocelot_port->speed == min_speed)
+		/* Enable cut-through forwarding for all traffic classes that
+		 * don't have oversized dropping enabled, since this check is
+		 * bypassed in cut-through mode.
+		 */
+		if (ocelot_port->speed == min_speed) {
 			val = GENMASK(7, 0);
 
+			for (tc = 0; tc < OCELOT_NUM_TC; tc++)
+				if (vsc9959_port_qmaxsdu_get(ocelot, port, tc))
+					val &= ~BIT(tc);
+		}
+
 set:
 		tmp = ocelot_read_rix(ocelot, ANA_CUT_THRU_CFG, port);
 		if (tmp == val)
 			continue;
 
 		dev_dbg(ocelot->dev,
-			"port %d fwd mask 0x%lx speed %d min_speed %d, %s cut-through forwarding\n",
+			"port %d fwd mask 0x%lx speed %d min_speed %d, %s cut-through forwarding on TC mask 0x%x\n",
 			port, mask, ocelot_port->speed, min_speed,
-			val ? "enabling" : "disabling");
+			val ? "enabling" : "disabling", val);
 
 		ocelot_write_rix(ocelot, val, ANA_CUT_THRU_CFG, port);
 	}
-- 
2.35.1



