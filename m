Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC6D4BBAAD
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 15:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236098AbiBROdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 09:33:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235421AbiBROdl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 09:33:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5841125B2D0
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 06:33:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88E2F61B23
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 14:33:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61387C340E9;
        Fri, 18 Feb 2022 14:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645194799;
        bh=jYBBGW4D7GELNwiz2Odo2fDF9K92VTe24mdGYePPgSU=;
        h=Subject:To:Cc:From:Date:From;
        b=WZeMCZxlhWRHJWxzqjof7v2YbMQ3T8AyuehfqUVu/mh3ixSn6xmf+KDnWyqoPD739
         nRf1JHjyb6sWL5hemqRC+2vVHHpF+S44WCBYtiFzUpSW+7sipXDW7/2B+WLmWDOG9y
         91TfQLIyYKG4y4Bwjbb/UTnkXI6jbnBN/trZfczw=
Subject: FAILED: patch "[PATCH] net: dsa: lan9303: handle hwaccel VLAN tags" failed to apply to 5.10-stable tree
To:     mans@mansr.com, kuba@kernel.org, olteanv@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Feb 2022 15:33:17 +0100
Message-ID: <164519479713744@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 017b355bbdc6620fd8fe05fe297f553ce9d855ee Mon Sep 17 00:00:00 2001
From: Mans Rullgard <mans@mansr.com>
Date: Wed, 16 Feb 2022 12:46:34 +0000
Subject: [PATCH] net: dsa: lan9303: handle hwaccel VLAN tags

Check for a hwaccel VLAN tag on rx and use it if present.  Otherwise,
use __skb_vlan_pop() like the other tag parsers do.  This fixes the case
where the VLAN tag has already been consumed by the master.

Fixes: a1292595e006 ("net: dsa: add new DSA switch driver for the SMSC-LAN9303")
Signed-off-by: Mans Rullgard <mans@mansr.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/20220216124634.23123-1-mans@mansr.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/net/dsa/tag_lan9303.c b/net/dsa/tag_lan9303.c
index cb548188f813..98d7d7120bab 100644
--- a/net/dsa/tag_lan9303.c
+++ b/net/dsa/tag_lan9303.c
@@ -77,7 +77,6 @@ static struct sk_buff *lan9303_xmit(struct sk_buff *skb, struct net_device *dev)
 
 static struct sk_buff *lan9303_rcv(struct sk_buff *skb, struct net_device *dev)
 {
-	__be16 *lan9303_tag;
 	u16 lan9303_tag1;
 	unsigned int source_port;
 
@@ -87,14 +86,15 @@ static struct sk_buff *lan9303_rcv(struct sk_buff *skb, struct net_device *dev)
 		return NULL;
 	}
 
-	lan9303_tag = dsa_etype_header_pos_rx(skb);
-
-	if (lan9303_tag[0] != htons(ETH_P_8021Q)) {
-		dev_warn_ratelimited(&dev->dev, "Dropping packet due to invalid VLAN marker\n");
-		return NULL;
+	if (skb_vlan_tag_present(skb)) {
+		lan9303_tag1 = skb_vlan_tag_get(skb);
+		__vlan_hwaccel_clear_tag(skb);
+	} else {
+		skb_push_rcsum(skb, ETH_HLEN);
+		__skb_vlan_pop(skb, &lan9303_tag1);
+		skb_pull_rcsum(skb, ETH_HLEN);
 	}
 
-	lan9303_tag1 = ntohs(lan9303_tag[1]);
 	source_port = lan9303_tag1 & 0x3;
 
 	skb->dev = dsa_master_find_slave(dev, 0, source_port);
@@ -103,13 +103,6 @@ static struct sk_buff *lan9303_rcv(struct sk_buff *skb, struct net_device *dev)
 		return NULL;
 	}
 
-	/* remove the special VLAN tag between the MAC addresses
-	 * and the current ethertype field.
-	 */
-	skb_pull_rcsum(skb, 2 + 2);
-
-	dsa_strip_etype_header(skb, LAN9303_TAG_LEN);
-
 	if (!(lan9303_tag1 & LAN9303_TAG_RX_TRAPPED_TO_CPU))
 		dsa_default_offload_fwd_mark(skb);
 

