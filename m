Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E91E561D72
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236404AbiF3OG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236431AbiF3OF5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:05:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461964D16F;
        Thu, 30 Jun 2022 06:54:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB27662005;
        Thu, 30 Jun 2022 13:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54B9C34115;
        Thu, 30 Jun 2022 13:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597240;
        bh=MN6iCT5yYY3Cx/dd3nAqdid5+V43uTKmGhUbJ6Qrbn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zwF57qaXk1gsuzauB093EG7eEifhX8CzKSIOHUcQUdQy84uOj5RUmevkdRxJM2VME
         Xnc5BWw5ZiwxcIjsorpQGZK8jkoMK2RMn9EF2y+QElI1hRtYLPEZAcpksmumCML6+f
         O6e2XEFLfh4+LAXF43Mzilm/alvMl+22ilbGpYYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH 5.10 12/12] net: mscc: ocelot: allow unregistered IP multicast flooding
Date:   Thu, 30 Jun 2022 15:47:17 +0200
Message-Id: <20220630133231.055686574@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133230.676254336@linuxfoundation.org>
References: <20220630133230.676254336@linuxfoundation.org>
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
@@ -1593,8 +1593,12 @@ int ocelot_init(struct ocelot *ocelot)
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
 
 	/* Allow manual injection via DEVCPU_QS registers, and byte swap these
 	 * registers endianness.


