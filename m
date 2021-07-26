Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75BA13D57AD
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 12:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbhGZKAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 06:00:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:38260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231639AbhGZKAM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 06:00:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E499A60F22;
        Mon, 26 Jul 2021 10:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627296041;
        bh=g71XIQZNB+qbsdXqa4hHiwrF+31KjHSU7Yhjs9FRCKw=;
        h=Subject:To:Cc:From:Date:From;
        b=l2q9RG4OUJzzR/ewTJVLzTPpunR5MIRvbZNgqoGzPHqb2Rh3+MY/LkmEeH2/gb9/m
         B4jobBlNr4kMiDlCXsMyeNfPL7LQ3/daDc4TIxty2JhzuT9GjQyBFVLMoDRKdzdT7B
         xUznn26qbNHrY0lL7PI4C1kU0y8QaKsheU8Z1Omc=
Subject: FAILED: patch "[PATCH] net: dsa: sja1105: fix address learning getting disabled on" failed to apply to 5.13-stable tree
To:     vladimir.oltean@nxp.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 26 Jul 2021 12:40:38 +0200
Message-ID: <162729603820813@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.13-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b0b33b048dcfbd7da82c3cde4fab02751dfab4d6 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Tue, 13 Jul 2021 12:37:19 +0300
Subject: [PATCH] net: dsa: sja1105: fix address learning getting disabled on
 the CPU port

In May 2019 when commit 640f763f98c2 ("net: dsa: sja1105: Add support
for Spanning Tree Protocol") was introduced, the comment that "STP does
not get called for the CPU port" was true. This changed after commit
0394a63acfe2 ("net: dsa: enable and disable all ports") in August 2019
and went largely unnoticed, because the sja1105_bridge_stp_state_set()
method did nothing different compared to the static setup done by
sja1105_init_mac_settings().

With the ability to turn address learning off introduced by the blamed
commit, there is a new priv->learn_ena port mask in the driver. When
sja1105_bridge_stp_state_set() gets called and we are in
BR_STATE_LEARNING or later, address learning is enabled or not depending
on priv->learn_ena & BIT(port).

So what happens is that priv->learn_ena is not being set from anywhere
for the CPU port, and the static configuration done by
sja1105_init_mac_settings() is being overwritten.

To solve this, acknowledge that the static configuration of STP state is
no longer necessary because the STP state is being set by the DSA core
now, but what is necessary is to set priv->learn_ena for the CPU port.

Fixes: 4d9423549501 ("net: dsa: sja1105: offload bridge port flags to device")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 4f0545605f6b..ced8c9cb29c2 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -122,14 +122,12 @@ static int sja1105_init_mac_settings(struct sja1105_private *priv)
 
 	for (i = 0; i < ds->num_ports; i++) {
 		mac[i] = default_mac;
-		if (i == dsa_upstream_port(priv->ds, i)) {
-			/* STP doesn't get called for CPU port, so we need to
-			 * set the I/O parameters statically.
-			 */
-			mac[i].dyn_learn = true;
-			mac[i].ingress = true;
-			mac[i].egress = true;
-		}
+
+		/* Let sja1105_bridge_stp_state_set() keep address learning
+		 * enabled for the CPU port.
+		 */
+		if (dsa_is_cpu_port(ds, i))
+			priv->learn_ena |= BIT(i);
 	}
 
 	return 0;

