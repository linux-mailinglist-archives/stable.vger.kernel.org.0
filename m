Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F172950F886
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346428AbiDZJIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347101AbiDZJFP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:05:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1B9FC41B;
        Tue, 26 Apr 2022 01:44:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E877D60EC3;
        Tue, 26 Apr 2022 08:44:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B6BC385AC;
        Tue, 26 Apr 2022 08:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962648;
        bh=6XUd9kPN56YUg9VaXhuKM1HVFut7iIMOVAlX9l/yiZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M5H3jVQc2c1TyJRBSrq9yVehUVszstYbHmlpQKzwRi4MXan04HEXXPl7/lunejNck
         RADmnfg0zhXVrZ7B2m4rzKytE/+fqWa+duyXlAR/zJbnoo75s76NeJ+ynm+6sbwjqt
         xsHc5tx6XvMuixiuhqRx4EL6jHaKTcTOMaM9bV/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 042/146] net: mscc: ocelot: fix broken IP multicast flooding
Date:   Tue, 26 Apr 2022 10:20:37 +0200
Message-Id: <20220426081751.251746086@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 4cf35a2b627a020fe1a6b6fc7a6a12394644e474 ]

When the user runs:
bridge link set dev $br_port mcast_flood on

this command should affect not only L2 multicast, but also IPv4 and IPv6
multicast.

In the Ocelot switch, unknown multicast gets flooded according to
different PGIDs according to its type, and PGID_MC only handles L2
multicast. Therefore, by leaving PGID_MCIPV4 and PGID_MCIPV6 at their
default value of 0, unknown IP multicast traffic is never flooded.

Fixes: 421741ea5672 ("net: mscc: ocelot: offload bridge port flags to device")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20220415151950.219660-1-vladimir.oltean@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index fd3ceb74620d..a314040c1a6a 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2508,6 +2508,8 @@ static void ocelot_port_set_mcast_flood(struct ocelot *ocelot, int port,
 		val = BIT(port);
 
 	ocelot_rmw_rix(ocelot, val, BIT(port), ANA_PGID_PGID, PGID_MC);
+	ocelot_rmw_rix(ocelot, val, BIT(port), ANA_PGID_PGID, PGID_MCIPV4);
+	ocelot_rmw_rix(ocelot, val, BIT(port), ANA_PGID_PGID, PGID_MCIPV6);
 }
 
 static void ocelot_port_set_bcast_flood(struct ocelot *ocelot, int port,
-- 
2.35.1



