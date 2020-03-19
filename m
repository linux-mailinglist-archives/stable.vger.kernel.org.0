Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCD3618B42D
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgCSNHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:07:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727889AbgCSNHT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:07:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E16620784;
        Thu, 19 Mar 2020 13:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623238;
        bh=HzLo+Jos6C/IUQ1umLfn9I6FpIiCDS3Vicju/9z1JYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VNLX0Ao7fkjm5j7brLTmOuPllo2yU5PlAnOV1YExUgupa3JN9Qd6qSnxuFHBbz4ue
         K9D1husf960+RcKLIi0QEQSLYSXFxphverdGxLjnR0nl/UyPI0Qrp+CmQd22gr5u30
         nNABBlxDrNIlrdRU8F5hkRO5ttWSmpC9Ywwrfz8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 54/93] batman-adv: Avoid nullptr dereference in dat after vlan_insert_tag
Date:   Thu, 19 Mar 2020 13:59:58 +0100
Message-Id: <20200319123942.039622354@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123924.795019515@linuxfoundation.org>
References: <20200319123924.795019515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

commit 60154a1e0495ffb8343a95cefe1e874634572fa8 upstream.

vlan_insert_tag can return NULL on errors. The distributed arp table code
therefore has to check the return value of vlan_insert_tag for NULL before
it can safely operate on this pointer.

Fixes: be1db4f6615b ("batman-adv: make the Distributed ARP Table vlan aware")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/distributed-arp-table.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -993,9 +993,12 @@ bool batadv_dat_snoop_outgoing_arp_reque
 		if (!skb_new)
 			goto out;
 
-		if (vid & BATADV_VLAN_HAS_TAG)
+		if (vid & BATADV_VLAN_HAS_TAG) {
 			skb_new = vlan_insert_tag(skb_new, htons(ETH_P_8021Q),
 						  vid & VLAN_VID_MASK);
+			if (!skb_new)
+				goto out;
+		}
 
 		skb_reset_mac_header(skb_new);
 		skb_new->protocol = eth_type_trans(skb_new,
@@ -1073,9 +1076,12 @@ bool batadv_dat_snoop_incoming_arp_reque
 	 */
 	skb_reset_mac_header(skb_new);
 
-	if (vid & BATADV_VLAN_HAS_TAG)
+	if (vid & BATADV_VLAN_HAS_TAG) {
 		skb_new = vlan_insert_tag(skb_new, htons(ETH_P_8021Q),
 					  vid & VLAN_VID_MASK);
+		if (!skb_new)
+			goto out;
+	}
 
 	/* To preserve backwards compatibility, the node has choose the outgoing
 	 * format based on the incoming request packet type. The assumption is


