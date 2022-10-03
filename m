Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC69D5F29BF
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiJCHYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbiJCHXx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:23:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D5D4686F;
        Mon,  3 Oct 2022 00:17:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0431F60FA1;
        Mon,  3 Oct 2022 07:16:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E00C433D6;
        Mon,  3 Oct 2022 07:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781362;
        bh=VPla568IMQ+1ZdstS01XByFNf/Tc8/20hbJ/RF7NOK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dSSnwriN1yyaOHQe2PYPgxDYwbAy2py9zSrnEqYifPp7FVWGfpMSYdc8Ww2Lad+4A
         y72I/GGSKYM0iI3TwAIE/9KmIL48esdobrNVQ6uJGprcV5p3EupNwwD0f/HeRo/kbd
         e3G3uGtkjUjhN6tcxVhGVyCMdlf10b/rl9aXiAMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 094/101] net: mscc: ocelot: fix tagged VLAN refusal while under a VLAN-unaware bridge
Date:   Mon,  3 Oct 2022 09:11:30 +0200
Message-Id: <20221003070726.774746245@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 276d37eb449133bc22872b8f0a6f878e120deeff ]

Currently the following set of commands fails:

$ ip link add br0 type bridge # vlan_filtering 0
$ ip link set swp0 master br0
$ bridge vlan
port              vlan-id
swp0              1 PVID Egress Untagged
$ bridge vlan add dev swp0 vid 10
Error: mscc_ocelot_switch_lib: Port with more than one egress-untagged VLAN cannot have egress-tagged VLANs.

Dumping ocelot->vlans, one can see that the 2 egress-untagged VLANs on swp0 are
vid 1 (the bridge PVID) and vid 4094, a PVID used privately by the driver for
VLAN-unaware bridging. So this is why bridge vid 10 is refused, despite
'bridge vlan' showing a single egress untagged VLAN.

As mentioned in the comment added, having this private VLAN does not impose
restrictions to the hardware configuration, yet it is a bookkeeping problem.

There are 2 possible solutions.

One is to make the functions that operate on VLAN-unaware pvids:
- ocelot_add_vlan_unaware_pvid()
- ocelot_del_vlan_unaware_pvid()
- ocelot_port_setup_dsa_8021q_cpu()
- ocelot_port_teardown_dsa_8021q_cpu()
call something different than ocelot_vlan_member_(add|del)(), the latter being
the real problem, because it allocates a struct ocelot_bridge_vlan *vlan which
it adds to ocelot->vlans. We don't really *need* the private VLANs in
ocelot->vlans, it's just that we have the extra convenience of having the
vlan->portmask cached in software (whereas without these structures, we'd have
to create a raw ocelot_vlant_rmw_mask() procedure which reads back the current
port mask from hardware).

The other solution is to filter out the private VLANs from
ocelot_port_num_untagged_vlans(), since they aren't what callers care about.
We only need to do this to the mentioned function and not to
ocelot_port_num_tagged_vlans(), because private VLANs are never egress-tagged.

Nothing else seems to be broken in either solution, but the first one requires
more rework which will conflict with the net-next change  36a0bf443585 ("net:
mscc: ocelot: set up tag_8021q CPU ports independent of user port affinity"),
and I'd like to avoid that. So go with the other one.

Fixes: 54c319846086 ("net: mscc: ocelot: enforce FDB isolation when VLAN-unaware")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20220927122042.1100231-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 68991b021c56..c250ad6dc956 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -290,6 +290,13 @@ static int ocelot_port_num_untagged_vlans(struct ocelot *ocelot, int port)
 		if (!(vlan->portmask & BIT(port)))
 			continue;
 
+		/* Ignore the VLAN added by ocelot_add_vlan_unaware_pvid(),
+		 * because this is never active in hardware at the same time as
+		 * the bridge VLANs, which only matter in VLAN-aware mode.
+		 */
+		if (vlan->vid >= OCELOT_RSV_VLAN_RANGE_START)
+			continue;
+
 		if (vlan->untagged & BIT(port))
 			num_untagged++;
 	}
-- 
2.35.1



