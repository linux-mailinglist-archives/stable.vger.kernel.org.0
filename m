Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1027F18B819
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbgCSNiI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:38:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727878AbgCSNHQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:07:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BD6820772;
        Thu, 19 Mar 2020 13:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623235;
        bh=JrmUqTgMon90qUzbBMJ2CgVIQapLMr7+IEomIsc6lNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RSzIu4E2lDAY8kOhF34XMz4//dg8Cbk3ighaYGtzbjfUaOkFbD2ZCZISvIxhJGig4
         UJX3Xk0tVu77mrH9PIZhqVYkYxTjMEvwyebBmXlHrvQYmQ/XA1p9SaVtmoGQLSXblm
         w6qyn7DuI9Xm3IanZWsKHq4u38jXVUVDlRjHSkGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 53/93] batman-adv: Avoid nullptr dereference in bla after vlan_insert_tag
Date:   Thu, 19 Mar 2020 13:59:57 +0100
Message-Id: <20200319123941.828317784@linuxfoundation.org>
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

commit 10c78f5854d361ded4736c1831948e0a5f67b932 upstream.

vlan_insert_tag can return NULL on errors. The bridge loop avoidance code
therefore has to check the return value of vlan_insert_tag for NULL before
it can safely operate on this pointer.

Fixes: 23721387c409 ("batman-adv: add basic bridge loop avoidance code")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bridge_loop_avoidance.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -352,9 +352,12 @@ static void batadv_bla_send_claim(struct
 		break;
 	}
 
-	if (vid & BATADV_VLAN_HAS_TAG)
+	if (vid & BATADV_VLAN_HAS_TAG) {
 		skb = vlan_insert_tag(skb, htons(ETH_P_8021Q),
 				      vid & VLAN_VID_MASK);
+		if (!skb)
+			goto out;
+	}
 
 	skb_reset_mac_header(skb);
 	skb->protocol = eth_type_trans(skb, soft_iface);


