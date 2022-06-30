Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBB7561D34
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236537AbiF3OKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236538AbiF3OKH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:10:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7396973933;
        Thu, 30 Jun 2022 06:55:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8D9EB82AF4;
        Thu, 30 Jun 2022 13:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15524C34115;
        Thu, 30 Jun 2022 13:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597317;
        bh=LHDZBHb1Ju9Gni/2nZSD3+bfE3hqybPTDwnADGAhS1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I9HT6rEJIwljjrWI8IVyDKyEfFPomR4fztabl3ohlsqe83j7u18Z7G/zOj+/eJEGL
         kzKXrQL/Kn+9ib2dbF33M8EADYIPFBz30BNNheNP9vZnXIq5hDjsNhmExli9glJIyU
         na6VClQX+s9E6ZDxp2t4aSJWSRigTUbWj1Hq1vXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH 5.15 27/28] net: mscc: ocelot: allow unregistered IP multicast flooding to CPU
Date:   Thu, 30 Jun 2022 15:47:23 +0200
Message-Id: <20220630133233.728720736@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133232.926711493@linuxfoundation.org>
References: <20220630133232.926711493@linuxfoundation.org>
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

Since commit 4cf35a2b627a ("net: mscc: ocelot: fix broken IP multicast
flooding") from v5.12, unregistered IP multicast flooding is
configurable in the ocelot driver for bridged ports. However, by writing
0 to the PGID_MCIPV4 and PGID_MCIPV6 port masks at initialization time,
the CPU port module, for which ocelot_port_set_mcast_flood() is not
called, will have unknown IP multicast flooding disabled.

This makes it impossible for an application such as smcroute to work
properly, since all IP multicast traffic received on a standalone port
is treated as unregistered (and dropped).

Starting with commit 7569459a52c9 ("net: dsa: manage flooding on the CPU
ports"), the limitation above has been lifted, because when standalone
ports become IFF_PROMISC or IFF_ALLMULTI, ocelot_port_set_mcast_flood()
would be called on the CPU port module, so unregistered multicast is
flooded to the CPU on an as-needed basis.

But between v5.12 and v5.18, IP multicast flooding to the CPU has
remained broken, promiscuous or not.

Delete the inexplicable premature optimization of clearing PGID_MCIPV4
and PGID_MCIPV6 as part of the init sequence, and allow unregistered IP
multicast to be flooded freely to the CPU port module.

Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
Cc: stable@kernel.org
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mscc/ocelot.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2208,9 +2208,13 @@ int ocelot_init(struct ocelot *ocelot)
 		       ANA_PGID_PGID, PGID_MC);
 	ocelot_rmw_rix(ocelot, ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports)),
 		       ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports)),
+		       ANA_PGID_PGID, PGID_MCIPV4);
+	ocelot_rmw_rix(ocelot, ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports)),
+		       ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports)),
+		       ANA_PGID_PGID, PGID_MCIPV6);
+	ocelot_rmw_rix(ocelot, ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports)),
+		       ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports)),
 		       ANA_PGID_PGID, PGID_BC);
-	ocelot_write_rix(ocelot, 0, ANA_PGID_PGID, PGID_MCIPV4);
-	ocelot_write_rix(ocelot, 0, ANA_PGID_PGID, PGID_MCIPV6);
 
 	/* Allow manual injection via DEVCPU_QS registers, and byte swap these
 	 * registers endianness.


