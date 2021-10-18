Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1B6431EB7
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbhJROFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:05:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234773AbhJROCy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 10:02:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 420B361A57;
        Mon, 18 Oct 2021 13:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564597;
        bh=zvjs20sOg4WIawD97wRDFk2JlaVcAWA3whOAUNX5+0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JZV2ZosctdurZsFuiNL265gcgjLOvnP9uRL1HveSHIYGZQeai2KgyMZy4shmt4Qwi
         8XorYzr8b33ORqy59+s5qSaKoPJ0PNg1Xyq1r6E3Xowsq6Jaisdbn9yygl1kM8MfmF
         Qi53KpDI98OHY7Mx5xxeCPKbD7eyWZRm6k+ciAKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.14 150/151] net: dsa: felix: break at first CPU port during init and teardown
Date:   Mon, 18 Oct 2021 15:25:29 +0200
Message-Id: <20211018132345.533806301@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 8d5f7954b7c8de54902a8beda141064a7e2e6ee0 upstream.

The NXP LS1028A switch has two Ethernet ports towards the CPU, but only
one of them is capable of acting as an NPI port at a time (inject and
extract packets using DSA tags).

However, using the alternative ocelot-8021q tagging protocol, it should
be possible to use both CPU ports symmetrically, but for that we need to
mark both ports in the device tree as DSA masters.

In the process of doing that, it can be seen that traffic to/from the
network stack gets broken, and this is because the Felix driver iterates
through all DSA CPU ports and configures them as NPI ports. But since
there can only be a single NPI port, we effectively end up in a
situation where DSA thinks the default CPU port is the first one, but
the hardware port configured to be an NPI is the last one.

I would like to treat this as a bug, because if the updated device trees
are going to start circulating, it would be really good for existing
kernels to support them, too.

Fixes: adb3dccf090b ("net: dsa: felix: convert to the new .change_tag_protocol DSA API")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/ocelot/felix.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -271,12 +271,12 @@ static void felix_8021q_cpu_port_deinit(
  */
 static int felix_setup_mmio_filtering(struct felix *felix)
 {
-	unsigned long user_ports = 0, cpu_ports = 0;
+	unsigned long user_ports = dsa_user_ports(felix->ds);
 	struct ocelot_vcap_filter *redirect_rule;
 	struct ocelot_vcap_filter *tagging_rule;
 	struct ocelot *ocelot = &felix->ocelot;
 	struct dsa_switch *ds = felix->ds;
-	int port, ret;
+	int cpu = -1, port, ret;
 
 	tagging_rule = kzalloc(sizeof(struct ocelot_vcap_filter), GFP_KERNEL);
 	if (!tagging_rule)
@@ -289,12 +289,15 @@ static int felix_setup_mmio_filtering(st
 	}
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		if (dsa_is_user_port(ds, port))
-			user_ports |= BIT(port);
-		if (dsa_is_cpu_port(ds, port))
-			cpu_ports |= BIT(port);
+		if (dsa_is_cpu_port(ds, port)) {
+			cpu = port;
+			break;
+		}
 	}
 
+	if (cpu < 0)
+		return -EINVAL;
+
 	tagging_rule->key_type = OCELOT_VCAP_KEY_ETYPE;
 	*(__be16 *)tagging_rule->key.etype.etype.value = htons(ETH_P_1588);
 	*(__be16 *)tagging_rule->key.etype.etype.mask = htons(0xffff);
@@ -330,7 +333,7 @@ static int felix_setup_mmio_filtering(st
 		 * the CPU port module
 		 */
 		redirect_rule->action.mask_mode = OCELOT_MASK_MODE_REDIRECT;
-		redirect_rule->action.port_mask = cpu_ports;
+		redirect_rule->action.port_mask = BIT(cpu);
 	} else {
 		/* Trap PTP packets only to the CPU port module (which is
 		 * redirected to the NPI port)
@@ -1241,6 +1244,7 @@ static int felix_setup(struct dsa_switch
 		 * there's no real point in checking for errors.
 		 */
 		felix_set_tag_protocol(ds, port, felix->tag_proto);
+		break;
 	}
 
 	ds->mtu_enforcement_ingress = true;
@@ -1277,6 +1281,7 @@ static void felix_teardown(struct dsa_sw
 			continue;
 
 		felix_del_tag_protocol(ds, port, felix->tag_proto);
+		break;
 	}
 
 	ocelot_devlink_sb_unregister(ocelot);


