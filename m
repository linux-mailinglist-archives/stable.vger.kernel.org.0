Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFC6588D63
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfHJUpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:45:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55422 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726916AbfHJUoI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:08 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDe-00058O-Oo; Sat, 10 Aug 2019 21:44:06 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDK-0003cL-Jz; Sat, 10 Aug 2019 21:43:46 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Steffen Klassert" <steffen.klassert@secunet.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.680261960@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 061/157] xfrm4: Fix header checks in _decode_session4.
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

commit 1a14f1e5550a341f76e5c8f596e9b5f8a886dfbc upstream.

We skip the header informations if the data pointer points
already behind the header in question for some protocols.
This is because we call pskb_may_pull with a negative value
converted to unsigened int from pskb_may_pull in this case.
Skipping the header informations can lead to incorrect policy
lookups, so fix it by a check of the data pointer position
before we call pskb_may_pull.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/xfrm4_policy.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/net/ipv4/xfrm4_policy.c
+++ b/net/ipv4/xfrm4_policy.c
@@ -131,7 +131,8 @@ _decode_session4(struct sk_buff *skb, st
 			break;
 
 		case IPPROTO_ICMP:
-			if (pskb_may_pull(skb, xprth + 2 - skb->data)) {
+			if (xprth + 2 < skb->data ||
+			    pskb_may_pull(skb, xprth + 2 - skb->data)) {
 				u8 *icmp = xprth;
 
 				fl4->fl4_icmp_type = icmp[0];
@@ -140,7 +141,8 @@ _decode_session4(struct sk_buff *skb, st
 			break;
 
 		case IPPROTO_ESP:
-			if (pskb_may_pull(skb, xprth + 4 - skb->data)) {
+			if (xprth + 4 < skb->data ||
+			    pskb_may_pull(skb, xprth + 4 - skb->data)) {
 				__be32 *ehdr = (__be32 *)xprth;
 
 				fl4->fl4_ipsec_spi = ehdr[0];
@@ -148,7 +150,8 @@ _decode_session4(struct sk_buff *skb, st
 			break;
 
 		case IPPROTO_AH:
-			if (pskb_may_pull(skb, xprth + 8 - skb->data)) {
+			if (xprth + 8 < skb->data ||
+			    pskb_may_pull(skb, xprth + 8 - skb->data)) {
 				__be32 *ah_hdr = (__be32 *)xprth;
 
 				fl4->fl4_ipsec_spi = ah_hdr[1];
@@ -156,7 +159,8 @@ _decode_session4(struct sk_buff *skb, st
 			break;
 
 		case IPPROTO_COMP:
-			if (pskb_may_pull(skb, xprth + 4 - skb->data)) {
+			if (xprth + 4 < skb->data ||
+			    pskb_may_pull(skb, xprth + 4 - skb->data)) {
 				__be16 *ipcomp_hdr = (__be16 *)xprth;
 
 				fl4->fl4_ipsec_spi = htonl(ntohs(ipcomp_hdr[1]));
@@ -164,7 +168,8 @@ _decode_session4(struct sk_buff *skb, st
 			break;
 
 		case IPPROTO_GRE:
-			if (pskb_may_pull(skb, xprth + 12 - skb->data)) {
+			if (xprth + 12 < skb->data ||
+			    pskb_may_pull(skb, xprth + 12 - skb->data)) {
 				__be16 *greflags = (__be16 *)xprth;
 				__be32 *gre_hdr = (__be32 *)xprth;
 

