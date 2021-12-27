Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123CF47FDAB
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 14:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbhL0NmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 08:42:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbhL0NmT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 08:42:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69F4C06173E
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 05:42:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A695DB81032
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 13:42:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06CAC36AEA;
        Mon, 27 Dec 2021 13:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640612536;
        bh=MSWzW8fD1wGRg0ZZ7NNUR9bDvy0XprTbflHG4vQpO7E=;
        h=Subject:To:Cc:From:Date:From;
        b=Xa1G5Nn5BMjhcJGYgC6yiIWP4WKgb5LEY9e10P4lGj74coFyffUXX3z8ZFTcb1bV+
         6h67q6NPdUos9V4K+GKEKRDWGC5y42s0GXdOIZZsplYL9Y+FvMfvL7P1XcmwsujQ4v
         jSdWeRlRC6U/do8vvZK64WwtRKEvsS4/qsuypIRw=
Subject: FAILED: patch "[PATCH] net: dsa: tag_ocelot: use traffic class to map priority on" failed to apply to 5.15-stable tree
To:     xiaoliang.yang_1@nxp.com, kuba@kernel.org,
        marouen.ghodhbane@nxp.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Dec 2021 14:42:14 +0100
Message-ID: <1640612534109106@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ae2778a64724f77fd6cad674461a045fb3307df7 Mon Sep 17 00:00:00 2001
From: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Date: Thu, 23 Dec 2021 15:22:11 +0800
Subject: [PATCH] net: dsa: tag_ocelot: use traffic class to map priority on
 injected header

For Ocelot switches, the CPU injected frames have an injection header
where it can specify the QoS class of the packet and the DSA tag, now it
uses the SKB priority to set that. If a traffic class to priority
mapping is configured on the netdevice (with mqprio for example ...), it
won't be considered for CPU injected headers. This patch make the QoS
class aligned to the priority to traffic class mapping if it exists.

Fixes: 8dce89aa5f32 ("net: dsa: ocelot: add tagger for Ocelot/Felix switches")
Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Signed-off-by: Marouen Ghodhbane <marouen.ghodhbane@nxp.com>
Link: https://lore.kernel.org/r/20211223072211.33130-1-xiaoliang.yang_1@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index de1c849a0a70..4ed74d509d6a 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -47,9 +47,13 @@ static void ocelot_xmit_common(struct sk_buff *skb, struct net_device *netdev,
 	void *injection;
 	__be32 *prefix;
 	u32 rew_op = 0;
+	u64 qos_class;
 
 	ocelot_xmit_get_vlan_info(skb, dp, &vlan_tci, &tag_type);
 
+	qos_class = netdev_get_num_tc(netdev) ?
+		    netdev_get_prio_tc_map(netdev, skb->priority) : skb->priority;
+
 	injection = skb_push(skb, OCELOT_TAG_LEN);
 	prefix = skb_push(skb, OCELOT_SHORT_PREFIX_LEN);
 
@@ -57,7 +61,7 @@ static void ocelot_xmit_common(struct sk_buff *skb, struct net_device *netdev,
 	memset(injection, 0, OCELOT_TAG_LEN);
 	ocelot_ifh_set_bypass(injection, 1);
 	ocelot_ifh_set_src(injection, ds->num_ports);
-	ocelot_ifh_set_qos_class(injection, skb->priority);
+	ocelot_ifh_set_qos_class(injection, qos_class);
 	ocelot_ifh_set_vlan_tci(injection, vlan_tci);
 	ocelot_ifh_set_tag_type(injection, tag_type);
 

