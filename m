Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0FC94BE611
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351625AbiBUJtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:49:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353187AbiBUJsP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:48:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1AEA25E85;
        Mon, 21 Feb 2022 01:22:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7FBA60F93;
        Mon, 21 Feb 2022 09:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB90AC340EB;
        Mon, 21 Feb 2022 09:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435343;
        bh=UgqOh3DNQl0jLTXWGK/2TY830ollRlfmr4U5TQRvB2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=znMkkFBWh8+isaPbL990A+y2o8w4jdC5OCeg9lV8Z7T8Wq9fwSJLvbygheCWGH9un
         IcMUXQCoksvAzVpKhVNISE1J9hKDk3Sc3bHqWh0SZQfKZ8DyNWvGmL4DnlO5KsIgJX
         ChMyKcjWjhqF4ANBmqy2+IhaCA6N13sVb04hQMro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 130/227] net: mscc: ocelot: fix use-after-free in ocelot_vlan_del()
Date:   Mon, 21 Feb 2022 09:49:09 +0100
Message-Id: <20220221084939.177603703@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
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

commit ef57640575406f57f5b3393cf57f457b0ace837e upstream.

ocelot_vlan_member_del() will free the struct ocelot_bridge_vlan, so if
this is the same as the port's pvid_vlan which we access afterwards,
what we're accessing is freed memory.

Fix the bug by determining whether to clear ocelot_port->pvid_vlan prior
to calling ocelot_vlan_member_del().

Fixes: d4004422f6f9 ("net: mscc: ocelot: track the port pvid using a pointer")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mscc/ocelot.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -480,14 +480,18 @@ EXPORT_SYMBOL(ocelot_vlan_add);
 int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	bool del_pvid = false;
 	int err;
 
+	if (ocelot_port->pvid_vlan && ocelot_port->pvid_vlan->vid == vid)
+		del_pvid = true;
+
 	err = ocelot_vlan_member_del(ocelot, port, vid);
 	if (err)
 		return err;
 
 	/* Ingress */
-	if (ocelot_port->pvid_vlan && ocelot_port->pvid_vlan->vid == vid)
+	if (del_pvid)
 		ocelot_port_set_pvid(ocelot, port, NULL);
 
 	/* Egress */


