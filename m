Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E54A688D6A
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbfHJUpp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:45:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55430 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726917AbfHJUoI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:08 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDe-00053h-Pe; Sat, 10 Aug 2019 21:44:06 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDK-0003cQ-Li; Sat, 10 Aug 2019 21:43:46 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Steffen Klassert" <steffen.klassert@secunet.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.86940932@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 062/157] xfrm4: Reload skb header pointers after
 calling pskb_may_pull.
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Klassert <steffen.klassert@secunet.com>

commit ea673a4d3a337184f3c314dcc6300bf02f39e077 upstream.

A call to pskb_may_pull may change the pointers into the packet,
so reload the pointers after the call.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/xfrm4_policy.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

--- a/net/ipv4/xfrm4_policy.c
+++ b/net/ipv4/xfrm4_policy.c
@@ -123,7 +123,10 @@ _decode_session4(struct sk_buff *skb, st
 		case IPPROTO_DCCP:
 			if (xprth + 4 < skb->data ||
 			    pskb_may_pull(skb, xprth + 4 - skb->data)) {
-				__be16 *ports = (__be16 *)xprth;
+				__be16 *ports;
+
+				xprth = skb_network_header(skb) + iph->ihl * 4;
+				ports = (__be16 *)xprth;
 
 				fl4->fl4_sport = ports[!!reverse];
 				fl4->fl4_dport = ports[!reverse];
@@ -133,7 +136,10 @@ _decode_session4(struct sk_buff *skb, st
 		case IPPROTO_ICMP:
 			if (xprth + 2 < skb->data ||
 			    pskb_may_pull(skb, xprth + 2 - skb->data)) {
-				u8 *icmp = xprth;
+				u8 *icmp;
+
+				xprth = skb_network_header(skb) + iph->ihl * 4;
+				icmp = xprth;
 
 				fl4->fl4_icmp_type = icmp[0];
 				fl4->fl4_icmp_code = icmp[1];
@@ -143,7 +149,10 @@ _decode_session4(struct sk_buff *skb, st
 		case IPPROTO_ESP:
 			if (xprth + 4 < skb->data ||
 			    pskb_may_pull(skb, xprth + 4 - skb->data)) {
-				__be32 *ehdr = (__be32 *)xprth;
+				__be32 *ehdr;
+
+				xprth = skb_network_header(skb) + iph->ihl * 4;
+				ehdr = (__be32 *)xprth;
 
 				fl4->fl4_ipsec_spi = ehdr[0];
 			}
@@ -152,7 +161,10 @@ _decode_session4(struct sk_buff *skb, st
 		case IPPROTO_AH:
 			if (xprth + 8 < skb->data ||
 			    pskb_may_pull(skb, xprth + 8 - skb->data)) {
-				__be32 *ah_hdr = (__be32 *)xprth;
+				__be32 *ah_hdr;
+
+				xprth = skb_network_header(skb) + iph->ihl * 4;
+				ah_hdr = (__be32 *)xprth;
 
 				fl4->fl4_ipsec_spi = ah_hdr[1];
 			}
@@ -161,7 +173,10 @@ _decode_session4(struct sk_buff *skb, st
 		case IPPROTO_COMP:
 			if (xprth + 4 < skb->data ||
 			    pskb_may_pull(skb, xprth + 4 - skb->data)) {
-				__be16 *ipcomp_hdr = (__be16 *)xprth;
+				__be16 *ipcomp_hdr;
+
+				xprth = skb_network_header(skb) + iph->ihl * 4;
+				ipcomp_hdr = (__be16 *)xprth;
 
 				fl4->fl4_ipsec_spi = htonl(ntohs(ipcomp_hdr[1]));
 			}
@@ -170,8 +185,12 @@ _decode_session4(struct sk_buff *skb, st
 		case IPPROTO_GRE:
 			if (xprth + 12 < skb->data ||
 			    pskb_may_pull(skb, xprth + 12 - skb->data)) {
-				__be16 *greflags = (__be16 *)xprth;
-				__be32 *gre_hdr = (__be32 *)xprth;
+				__be16 *greflags;
+				__be32 *gre_hdr;
+
+				xprth = skb_network_header(skb) + iph->ihl * 4;
+				greflags = (__be16 *)xprth;
+				gre_hdr = (__be32 *)xprth;
 
 				if (greflags[0] & GRE_KEY) {
 					if (greflags[0] & GRE_CSUM)

