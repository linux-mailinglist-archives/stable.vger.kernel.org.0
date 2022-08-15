Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C3D5947BE
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354201AbiHOXnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354348AbiHOXlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:41:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03642E6B9;
        Mon, 15 Aug 2022 13:13:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55841B810C5;
        Mon, 15 Aug 2022 20:13:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7883C433C1;
        Mon, 15 Aug 2022 20:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594385;
        bh=9YcrSY0ccmTSCkV6ToNpbT+7OHRZ3Y+T71RjINZt2B8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DDtjHfGHXSpnp2Sok2hIaIjEnvs0JJUnTRCGOlsIn7uNPfzCB2qMRCnUp+og42ar0
         2Jyea5Npg+3RYxg4IHek4ikPPHTGi6TX7UET2G61XfXMV+nsE2P682HkjaKnv1fyFP
         A2IyWSnOJKHDMJqkYy5YmLMVTT+wcBtuKsc86bLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0429/1157] net: dsa: felix: keep reference on entire tc-taprio config
Date:   Mon, 15 Aug 2022 19:56:25 +0200
Message-Id: <20220815180456.822364639@linuxfoundation.org>
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

[ Upstream commit 1c9017e44af2eee94b1001af18c401ae440ad77c ]

In a future change we will need to remember the entire tc-taprio config
on all ports rather than just the base time, so use the
taprio_offload_get() helper function to replace ocelot_port->base_time
with ocelot_port->taprio.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 23 +++++++++++++----------
 include/soc/mscc/ocelot.h              |  5 ++---
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 693cd6ffbace..12792362bbee 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1210,6 +1210,9 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 			       QSYS_TAG_CONFIG_INIT_GATE_STATE_M,
 			       QSYS_TAG_CONFIG, port);
 
+		taprio_offload_free(ocelot_port->taprio);
+		ocelot_port->taprio = NULL;
+
 		mutex_unlock(&ocelot->tas_lock);
 		return 0;
 	}
@@ -1258,8 +1261,6 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 		       QSYS_TAG_CONFIG_SCH_TRAFFIC_QUEUES_M,
 		       QSYS_TAG_CONFIG, port);
 
-	ocelot_port->base_time = taprio->base_time;
-
 	vsc9959_new_base_time(ocelot, taprio->base_time,
 			      taprio->cycle_time, &base_ts);
 	ocelot_write(ocelot, base_ts.tv_nsec, QSYS_PARAM_CFG_REG_1);
@@ -1282,6 +1283,10 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 	ret = readx_poll_timeout(vsc9959_tas_read_cfg_status, ocelot, val,
 				 !(val & QSYS_TAS_PARAM_CFG_CTRL_CONFIG_CHANGE),
 				 10, 100000);
+	if (ret)
+		goto err;
+
+	ocelot_port->taprio = taprio_offload_get(taprio);
 
 err:
 	mutex_unlock(&ocelot->tas_lock);
@@ -1291,17 +1296,18 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 
 static void vsc9959_tas_clock_adjust(struct ocelot *ocelot)
 {
+	struct tc_taprio_qopt_offload *taprio;
 	struct ocelot_port *ocelot_port;
 	struct timespec64 base_ts;
-	u64 cycletime;
 	int port;
 	u32 val;
 
 	mutex_lock(&ocelot->tas_lock);
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		val = ocelot_read_rix(ocelot, QSYS_TAG_CONFIG, port);
-		if (!(val & QSYS_TAG_CONFIG_ENABLE))
+		ocelot_port = ocelot->ports[port];
+		taprio = ocelot_port->taprio;
+		if (!taprio)
 			continue;
 
 		ocelot_rmw(ocelot,
@@ -1315,11 +1321,8 @@ static void vsc9959_tas_clock_adjust(struct ocelot *ocelot)
 			       QSYS_TAG_CONFIG_INIT_GATE_STATE_M,
 			       QSYS_TAG_CONFIG, port);
 
-		cycletime = ocelot_read(ocelot, QSYS_PARAM_CFG_REG_4);
-		ocelot_port = ocelot->ports[port];
-
-		vsc9959_new_base_time(ocelot, ocelot_port->base_time,
-				      cycletime, &base_ts);
+		vsc9959_new_base_time(ocelot, taprio->base_time,
+				      taprio->cycle_time, &base_ts);
 
 		ocelot_write(ocelot, base_ts.tv_nsec, QSYS_PARAM_CFG_REG_1);
 		ocelot_write(ocelot, lower_32_bits(base_ts.tv_sec),
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 3737570116c3..ac151ecc7f19 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -670,6 +670,8 @@ struct ocelot_port {
 	/* VLAN that untagged frames are classified to, on ingress */
 	const struct ocelot_bridge_vlan	*pvid_vlan;
 
+	struct tc_taprio_qopt_offload	*taprio;
+
 	phy_interface_t			phy_mode;
 
 	unsigned int			ptp_skbs_in_flight;
@@ -692,9 +694,6 @@ struct ocelot_port {
 	int				bridge_num;
 
 	int				speed;
-
-	/* Store the AdminBaseTime of EST fetched from userspace. */
-	s64				base_time;
 };
 
 struct ocelot {
-- 
2.35.1



