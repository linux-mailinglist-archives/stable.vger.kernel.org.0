Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE94289E7
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389593AbfEWTSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:18:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389588AbfEWTSX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:18:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8E93217D9;
        Thu, 23 May 2019 19:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639102;
        bh=tT3A7MgSY8GySfsmmxxmN0nbp6Jz1o10Gaxx8+h9/P8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jRagaAofvKJOwYReE0dTB02G+CyPx3qwADDirPta6zElNOC+eX6v9DnM4jXObFBMV
         fEZDI+EgMPtg7IfNEjK8LMNHZ7SvjbZhkggD3RxR0xVjTlCCmtulYsr6lzWzduRjhy
         s8ni1luJ1U0EC+zy7NmpeeVsYIf2lKuFkKQE+6+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 087/114] esp4: add length check for UDP encapsulation
Date:   Thu, 23 May 2019 21:06:26 +0200
Message-Id: <20190523181739.478982228@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181731.372074275@linuxfoundation.org>
References: <20190523181731.372074275@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8dfb4eba4100e7cdd161a8baef2d8d61b7a7e62e ]

esp_output_udp_encap can produce a length that doesn't fit in the 16
bits of a UDP header's length field. In that case, we'll send a
fragmented packet whose length is larger than IP_MAX_MTU (resulting in
"Oversized IP packet" warnings on receive) and with a bogus UDP
length.

To prevent this, add a length check to esp_output_udp_encap and return
 -EMSGSIZE on failure.

This seems to be older than git history.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/esp4.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 12a43a5369a54..114f9def1ec54 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -223,7 +223,7 @@ static void esp_output_fill_trailer(u8 *tail, int tfclen, int plen, __u8 proto)
 	tail[plen - 1] = proto;
 }
 
-static void esp_output_udp_encap(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *esp)
+static int esp_output_udp_encap(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *esp)
 {
 	int encap_type;
 	struct udphdr *uh;
@@ -231,6 +231,7 @@ static void esp_output_udp_encap(struct xfrm_state *x, struct sk_buff *skb, stru
 	__be16 sport, dport;
 	struct xfrm_encap_tmpl *encap = x->encap;
 	struct ip_esp_hdr *esph = esp->esph;
+	unsigned int len;
 
 	spin_lock_bh(&x->lock);
 	sport = encap->encap_sport;
@@ -238,11 +239,14 @@ static void esp_output_udp_encap(struct xfrm_state *x, struct sk_buff *skb, stru
 	encap_type = encap->encap_type;
 	spin_unlock_bh(&x->lock);
 
+	len = skb->len + esp->tailen - skb_transport_offset(skb);
+	if (len + sizeof(struct iphdr) >= IP_MAX_MTU)
+		return -EMSGSIZE;
+
 	uh = (struct udphdr *)esph;
 	uh->source = sport;
 	uh->dest = dport;
-	uh->len = htons(skb->len + esp->tailen
-		  - skb_transport_offset(skb));
+	uh->len = htons(len);
 	uh->check = 0;
 
 	switch (encap_type) {
@@ -259,6 +263,8 @@ static void esp_output_udp_encap(struct xfrm_state *x, struct sk_buff *skb, stru
 
 	*skb_mac_header(skb) = IPPROTO_UDP;
 	esp->esph = esph;
+
+	return 0;
 }
 
 int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *esp)
@@ -272,8 +278,12 @@ int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 	int tailen = esp->tailen;
 
 	/* this is non-NULL only with UDP Encapsulation */
-	if (x->encap)
-		esp_output_udp_encap(x, skb, esp);
+	if (x->encap) {
+		int err = esp_output_udp_encap(x, skb, esp);
+
+		if (err < 0)
+			return err;
+	}
 
 	if (!skb_cloned(skb)) {
 		if (tailen <= skb_tailroom(skb)) {
-- 
2.20.1



