Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0506289B5
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389952AbfEWTUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:20:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389320AbfEWTUF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:20:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8115920863;
        Thu, 23 May 2019 19:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639204;
        bh=j76IkWE9AdtdEXWowbstZiPP1/GJVpj2Dzen8v6AmWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MG8/7l/2Knf/PTEF1AmIv8pm/z0KIZNQjDK08l6whJcBQ4/fjIuuoRq9IHke5aEYl
         B3UGEM5e120RJ8ZvtyfoRvjAZ6XXi3D7kYQ2SF0zWgy0rkIUJzfW3a9+0HhrGCBbd+
         /6BzouUYduWPER28ILHoM8cA+zWh3JuZEsDgCQZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 006/139] net: test nouarg before dereferencing zerocopy pointers
Date:   Thu, 23 May 2019 21:04:54 +0200
Message-Id: <20190523181721.096190957@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 185ce5c38ea76f29b6bd9c7c8c7a5e5408834920 ]

Zerocopy skbs without completion notification were added for packet
sockets with PACKET_TX_RING user buffers. Those signal completion
through the TP_STATUS_USER bit in the ring. Zerocopy annotation was
added only to avoid premature notification after clone or orphan, by
triggering a copy on these paths for these packets.

The mechanism had to define a special "no-uarg" mode because packet
sockets already use skb_uarg(skb) == skb_shinfo(skb)->destructor_arg
for a different pointer.

Before deferencing skb_uarg(skb), verify that it is a real pointer.

Fixes: 5cd8d46ea1562 ("packet: copy user buffers before orphan or clone")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1366,10 +1366,12 @@ static inline void skb_zcopy_clear(struc
 	struct ubuf_info *uarg = skb_zcopy(skb);
 
 	if (uarg) {
-		if (uarg->callback == sock_zerocopy_callback) {
+		if (skb_zcopy_is_nouarg(skb)) {
+			/* no notification callback */
+		} else if (uarg->callback == sock_zerocopy_callback) {
 			uarg->zerocopy = uarg->zerocopy && zerocopy;
 			sock_zerocopy_put(uarg);
-		} else if (!skb_zcopy_is_nouarg(skb)) {
+		} else {
 			uarg->callback(uarg, zerocopy);
 		}
 
@@ -2627,7 +2629,8 @@ static inline int skb_orphan_frags(struc
 {
 	if (likely(!skb_zcopy(skb)))
 		return 0;
-	if (skb_uarg(skb)->callback == sock_zerocopy_callback)
+	if (!skb_zcopy_is_nouarg(skb) &&
+	    skb_uarg(skb)->callback == sock_zerocopy_callback)
 		return 0;
 	return skb_copy_ubufs(skb, gfp_mask);
 }


