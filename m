Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815FA4BE2D3
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236560AbiBUJwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:52:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351959AbiBUJu7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:50:59 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8A235DCD;
        Mon, 21 Feb 2022 01:22:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6FEECCE0E89;
        Mon, 21 Feb 2022 09:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6113DC340E9;
        Mon, 21 Feb 2022 09:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435368;
        bh=Qtr7JHf3mAjs2WT0nfBTCq+aPz6bs4dbO5nGkwPHaEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UBrYpWV5fiZbCUGbC6mVMne/WQPDCQUMfie/wu5fDopW9JnhW4FDGLpLL5tYBBqe9
         ZaN+yUX9IrTyq83fMpErzh/CMoQVJeOFiQ83oyfxsX18id+J658zyZMxexRxkIh1cM
         aFolRAFZB5GVz+e4kdfuanSHazrHrkp/5E8XQp38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mans Rullgard <mans@mansr.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.16 112/227] net: dsa: lan9303: handle hwaccel VLAN tags
Date:   Mon, 21 Feb 2022 09:48:51 +0100
Message-Id: <20220221084938.583562326@linuxfoundation.org>
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

From: Mans Rullgard <mans@mansr.com>

commit 017b355bbdc6620fd8fe05fe297f553ce9d855ee upstream.

Check for a hwaccel VLAN tag on rx and use it if present.  Otherwise,
use __skb_vlan_pop() like the other tag parsers do.  This fixes the case
where the VLAN tag has already been consumed by the master.

Fixes: a1292595e006 ("net: dsa: add new DSA switch driver for the SMSC-LAN9303")
Signed-off-by: Mans Rullgard <mans@mansr.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/20220216124634.23123-1-mans@mansr.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/tag_lan9303.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

--- a/net/dsa/tag_lan9303.c
+++ b/net/dsa/tag_lan9303.c
@@ -77,7 +77,6 @@ static struct sk_buff *lan9303_xmit(stru
 
 static struct sk_buff *lan9303_rcv(struct sk_buff *skb, struct net_device *dev)
 {
-	__be16 *lan9303_tag;
 	u16 lan9303_tag1;
 	unsigned int source_port;
 
@@ -87,14 +86,15 @@ static struct sk_buff *lan9303_rcv(struc
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
@@ -103,13 +103,6 @@ static struct sk_buff *lan9303_rcv(struc
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
 


