Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1957561D4B
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236074AbiF3ODA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236092AbiF3OBK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:01:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD6F44A19;
        Thu, 30 Jun 2022 06:52:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16BFEB82AD8;
        Thu, 30 Jun 2022 13:52:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9DBC34115;
        Thu, 30 Jun 2022 13:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597160;
        bh=u1ywSzVSilu7GMLPyEDimJOTV+WvCymWm8pFnXBhA68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LZ31oP4YzTk6XFPFbofkQtmCUQulbnJCxYabQ7zaKQsYCq7nYE2YTGpIw7YP9Ir6A
         pl3A498sO4QLPo4f75mS43X5Pyl3Id6bJs+nhp4d2mkTO6bQNfGqkOQaHPALxxb6WE
         ulUMIzHAb4N7QSDVdq2d2nM4ieyO1nh9A3c1Kfpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH 4.19 47/49] net: mscc: ocelot: allow unregistered IP multicast flooding
Date:   Thu, 30 Jun 2022 15:47:00 +0200
Message-Id: <20220630133235.258443194@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133233.910803744@linuxfoundation.org>
References: <20220630133233.910803744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Flooding of unregistered IP multicast has been broken (both to other
switch ports and to the CPU) since the ocelot driver introduction, and
up until commit 4cf35a2b627a ("net: mscc: ocelot: fix broken IP
multicast flooding"), a bug fix for commit 421741ea5672 ("net: mscc:
ocelot: offload bridge port flags to device") from v5.12.

The driver used to set PGID_MCIPV4 and PGID_MCIPV6 to the empty port
mask (0), which made unregistered IPv4/IPv6 multicast go nowhere, and
without ever modifying that port mask at runtime.

The expectation is that such packets are treated as broadcast, and
flooded according to the forwarding domain (to the CPU if the port is
standalone, or to the CPU and other bridged ports, if under a bridge).

Since the aforementioned commit, the limitation has been lifted by
responding to SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS events emitted by the
bridge. As for host flooding, DSA synthesizes another call to
ocelot_port_bridge_flags() on the NPI port which ensures that the CPU
gets the unregistered multicast traffic it might need, for example for
smcroute to work between standalone ports.

But between v4.18 and v5.12, IP multicast flooding has remained unfixed.

Delete the inexplicable premature optimization of clearing PGID_MCIPV4
and PGID_MCIPV6 as part of the init sequence, and allow unregistered IP
multicast to be flooded freely according to the forwarding domain
established by PGID_SRC, by explicitly programming PGID_MCIPV4 and
PGID_MCIPV6 towards all physical ports plus the CPU port module.

Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
Cc: stable@kernel.org
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mscc/ocelot.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1733,8 +1733,12 @@ int ocelot_init(struct ocelot *ocelot)
 	ocelot_write_rix(ocelot,
 			 ANA_PGID_PGID_PGID(GENMASK(ocelot->num_phys_ports, 0)),
 			 ANA_PGID_PGID, PGID_MC);
-	ocelot_write_rix(ocelot, 0, ANA_PGID_PGID, PGID_MCIPV4);
-	ocelot_write_rix(ocelot, 0, ANA_PGID_PGID, PGID_MCIPV6);
+	ocelot_write_rix(ocelot,
+			 ANA_PGID_PGID_PGID(GENMASK(ocelot->num_phys_ports, 0)),
+			 ANA_PGID_PGID, PGID_MCIPV4);
+	ocelot_write_rix(ocelot,
+			 ANA_PGID_PGID_PGID(GENMASK(ocelot->num_phys_ports, 0)),
+			 ANA_PGID_PGID, PGID_MCIPV6);
 
 	/* CPU port Injection/Extraction configuration */
 	ocelot_write_rix(ocelot, QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE |


