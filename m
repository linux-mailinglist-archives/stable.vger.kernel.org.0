Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01FBA59D73F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348569AbiHWJMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348017AbiHWJJX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:09:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE8386040;
        Tue, 23 Aug 2022 01:30:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD3AC6132D;
        Tue, 23 Aug 2022 08:29:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A46C433C1;
        Tue, 23 Aug 2022 08:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243360;
        bh=3vRw/BXbTpCY3pAOH5G0TmoFZPMnb7qpDQLIiyyHYBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hGOLD5lkdNG8dD57ye2Tea8uLD5Vl2TB9ESXIlkryG+NLQ/rn24puih4JD8mObYJd
         X1/tqNmgdzUnww3h4Xtbh0cET+g7v/EQ2HNOegm9VA8fenFWHwFM7ml8DXubmP9Ewj
         wf8+CFAXgC6yZzqw/engf/SuJYtBLQKGoz9LIt1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 252/365] net: mscc: ocelot: fix race between ndo_get_stats64 and ocelot_check_stats_work
Date:   Tue, 23 Aug 2022 10:02:33 +0200
Message-Id: <20220823080128.729548690@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

[ Upstream commit 18d8e67df184081bc6ce6220a2dd965cfd3d7e6b ]

The 2 methods can run concurrently, and one will change the window of
counters (SYS_STAT_CFG_STAT_VIEW) that the other sees. The fix is
similar to what commit 7fbf6795d127 ("net: mscc: ocelot: fix mutex lock
error during ethtool stats read") has done for ethtool -S.

Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 9d8cea16245e..6b9d37138844 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -726,6 +726,8 @@ static void ocelot_get_stats64(struct net_device *dev,
 	struct ocelot *ocelot = priv->port.ocelot;
 	int port = priv->port.index;
 
+	spin_lock(&ocelot->stats_lock);
+
 	/* Configure the port to read the stats from */
 	ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(port),
 		     SYS_STAT_CFG);
@@ -758,6 +760,8 @@ static void ocelot_get_stats64(struct net_device *dev,
 	stats->tx_dropped = ocelot_read(ocelot, SYS_COUNT_TX_DROPS) +
 			    ocelot_read(ocelot, SYS_COUNT_TX_AGING);
 	stats->collisions = ocelot_read(ocelot, SYS_COUNT_TX_COLLISION);
+
+	spin_unlock(&ocelot->stats_lock);
 }
 
 static int ocelot_port_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
-- 
2.35.1



