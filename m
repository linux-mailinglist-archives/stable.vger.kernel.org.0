Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46355593F19
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbiHOVIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244915AbiHOVFb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:05:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9C9D5985;
        Mon, 15 Aug 2022 12:14:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E32C60EF0;
        Mon, 15 Aug 2022 19:14:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107E2C433D6;
        Mon, 15 Aug 2022 19:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590898;
        bh=A8eKkdgs0YzVymdzU8dECFJ/F2mnGOelqyLESFLxkg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZlobHPjJbJyUj7aggrQ4WqEt+h7413xB5O+NFXeev0KXOw3ID5qPSDuTns9vbn3rK
         IU9juZtqhjZ0zTXbW9jseeoQ512DjPENpCF5vYn60F669X4neXEjQm1SCVtGue/TxV
         3qbhsojs1KhaNSQaQ9TM50H7JgvSyBA9/+1ymsi4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0407/1095] net: dsa: felix: keep reference on entire tc-taprio config
Date:   Mon, 15 Aug 2022 19:56:46 +0200
Message-Id: <20220815180446.545983881@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index f21d9ff40af3..3d86f061802d 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1207,6 +1207,9 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 			       QSYS_TAG_CONFIG_INIT_GATE_STATE_M,
 			       QSYS_TAG_CONFIG, port);
 
+		taprio_offload_free(ocelot_port->taprio);
+		ocelot_port->taprio = NULL;
+
 		mutex_unlock(&ocelot->tas_lock);
 		return 0;
 	}
@@ -1255,8 +1258,6 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 		       QSYS_TAG_CONFIG_SCH_TRAFFIC_QUEUES_M,
 		       QSYS_TAG_CONFIG, port);
 
-	ocelot_port->base_time = taprio->base_time;
-
 	vsc9959_new_base_time(ocelot, taprio->base_time,
 			      taprio->cycle_time, &base_ts);
 	ocelot_write(ocelot, base_ts.tv_nsec, QSYS_PARAM_CFG_REG_1);
@@ -1279,6 +1280,10 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 	ret = readx_poll_timeout(vsc9959_tas_read_cfg_status, ocelot, val,
 				 !(val & QSYS_TAS_PARAM_CFG_CTRL_CONFIG_CHANGE),
 				 10, 100000);
+	if (ret)
+		goto err;
+
+	ocelot_port->taprio = taprio_offload_get(taprio);
 
 err:
 	mutex_unlock(&ocelot->tas_lock);
@@ -1288,17 +1293,18 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 
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
@@ -1312,11 +1318,8 @@ static void vsc9959_tas_clock_adjust(struct ocelot *ocelot)
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
index b944fc670c72..c90a9a2f77a9 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -659,6 +659,8 @@ struct ocelot_port {
 	/* VLAN that untagged frames are classified to, on ingress */
 	const struct ocelot_bridge_vlan	*pvid_vlan;
 
+	struct tc_taprio_qopt_offload	*taprio;
+
 	phy_interface_t			phy_mode;
 
 	unsigned int			ptp_skbs_in_flight;
@@ -679,9 +681,6 @@ struct ocelot_port {
 	int				bridge_num;
 
 	int				speed;
-
-	/* Store the AdminBaseTime of EST fetched from userspace. */
-	s64				base_time;
 };
 
 struct ocelot {
-- 
2.35.1



