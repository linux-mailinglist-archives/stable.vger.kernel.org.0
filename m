Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12F0150F588
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243376AbiDZIxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347267AbiDZIvQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:51:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4919E55BF;
        Tue, 26 Apr 2022 01:40:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA2E7B81CF0;
        Tue, 26 Apr 2022 08:40:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16685C385A4;
        Tue, 26 Apr 2022 08:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962402;
        bh=rliS89dJcyrybqgaURTUi7V7HnjX9oapKH2QCwTkQFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=19pFd4clz6loMObAvdmjh3zADxkvWhf2qz+7YYpqOXadAA3LI0FE9ncyhBHJeoMlU
         zai9Up9CCiTsBylY4HKXbH17VcdG/8Fk45hxWoNWplKzkLXFAkf5m9oGEvpqK8yKcL
         tiLbCi0Qf7pHbH5468x14YsT6g/e3mFBTihAvSMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/124] net: mscc: ocelot: fix broken IP multicast flooding
Date:   Tue, 26 Apr 2022 10:20:45 +0200
Message-Id: <20220426081748.555271039@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
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
index 6aad0953e8fe..a59300d9e000 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1932,6 +1932,8 @@ static void ocelot_port_set_mcast_flood(struct ocelot *ocelot, int port,
 		val = BIT(port);
 
 	ocelot_rmw_rix(ocelot, val, BIT(port), ANA_PGID_PGID, PGID_MC);
+	ocelot_rmw_rix(ocelot, val, BIT(port), ANA_PGID_PGID, PGID_MCIPV4);
+	ocelot_rmw_rix(ocelot, val, BIT(port), ANA_PGID_PGID, PGID_MCIPV6);
 }
 
 static void ocelot_port_set_bcast_flood(struct ocelot *ocelot, int port,
-- 
2.35.1



