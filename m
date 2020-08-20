Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1914324B87D
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729840AbgHTLWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:22:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730494AbgHTKHa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:07:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9A652173E;
        Thu, 20 Aug 2020 10:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918050;
        bh=0ZrsPUjG0hdVMilu3PldGC8BakCU6TEwpGp5jBD+8ro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NqjFTAh/Wrwc9Pt4ei206QWCf0c3h9XOny8WMoImGMie0Wf96HiGEaJdxrY6uzKJc
         yrsUF4+2GWlIh0CePTrBYVz2LWgKBWOwosHQCSGgk3naW8MhpJsMqNCHvpGMSp2q14
         e/dbzRvmHCsh1ybb8RdJRHKPoPzugdqL9oGERoSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 036/228] net: gre: recompute gre csum for sctp over gre tunnels
Date:   Thu, 20 Aug 2020 11:20:11 +0200
Message-Id: <20200820091609.341714819@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 622e32b7d4a6492cf5c1f759ef833f817418f7b3 ]

The GRE tunnel can be used to transport traffic that does not rely on a
Internet checksum (e.g. SCTP). The issue can be triggered creating a GRE
or GRETAP tunnel and transmitting SCTP traffic ontop of it where CRC
offload has been disabled. In order to fix the issue we need to
recompute the GRE csum in gre_gso_segment() not relying on the inner
checksum.
The issue is still present when we have the CRC offload enabled.
In this case we need to disable the CRC offload if we require GRE
checksum since otherwise skb_checksum() will report a wrong value.

Fixes: 90017accff61 ("sctp: Add GSO support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/gre_offload.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -19,12 +19,12 @@ static struct sk_buff *gre_gso_segment(s
 				       netdev_features_t features)
 {
 	int tnl_hlen = skb_inner_mac_header(skb) - skb_transport_header(skb);
+	bool need_csum, need_recompute_csum, gso_partial;
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
 	u16 mac_offset = skb->mac_header;
 	__be16 protocol = skb->protocol;
 	u16 mac_len = skb->mac_len;
 	int gre_offset, outer_hlen;
-	bool need_csum, gso_partial;
 
 	if (!skb->encapsulation)
 		goto out;
@@ -45,6 +45,7 @@ static struct sk_buff *gre_gso_segment(s
 	skb->protocol = skb->inner_protocol;
 
 	need_csum = !!(skb_shinfo(skb)->gso_type & SKB_GSO_GRE_CSUM);
+	need_recompute_csum = skb->csum_not_inet;
 	skb->encap_hdr_csum = need_csum;
 
 	features &= skb->dev->hw_enc_features;
@@ -102,7 +103,15 @@ static struct sk_buff *gre_gso_segment(s
 		}
 
 		*(pcsum + 1) = 0;
-		*pcsum = gso_make_checksum(skb, 0);
+		if (need_recompute_csum && !skb_is_gso(skb)) {
+			__wsum csum;
+
+			csum = skb_checksum(skb, gre_offset,
+					    skb->len - gre_offset, 0);
+			*pcsum = csum_fold(csum);
+		} else {
+			*pcsum = gso_make_checksum(skb, 0);
+		}
 	} while ((skb = skb->next));
 out:
 	return segs;


