Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76BE045BEDB
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343997AbhKXMvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:51:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:55390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346386AbhKXMtK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:49:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D184604D1;
        Wed, 24 Nov 2021 12:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756930;
        bh=vPBkvRyu0hlmEOvMNAmh1m+NgAK0FlWN1Xdi6lv4ucU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rkajSQsLAdBhQjHK/M9sQ7iO7I5Hgly9DUscajaZb/aCPbx97teb3FToc5hVubKTL
         HZn6fnhCjQh0v9Tnq37kV9JqwiGeQ+qVvInNLz0w9GhJJqZTNL2xftkRW3ZMLHA2CA
         At7dVP6L/Epk9O2h06PKbKxijPyBUQ2LURa/cnBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.14 247/251] batman-adv: Dont always reallocate the fragmentation skb head
Date:   Wed, 24 Nov 2021 12:58:09 +0100
Message-Id: <20211124115718.925473066@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

commit 992b03b88e36254e26e9a4977ab948683e21bd9f upstream.

When a packet is fragmented by batman-adv, the original batman-adv header
is not modified. Only a new fragmentation is inserted between the original
one and the ethernet header. The code must therefore make sure that it has
a writable region of this size in the skbuff head.

But it is not useful to always reallocate the skbuff by this size even when
there would be more than enough headroom still in the skb. The reallocation
is just to costly during in this codepath.

Fixes: ee75ed88879a ("batman-adv: Fragment and send skbs larger than mtu")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/fragmentation.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -538,13 +538,14 @@ int batadv_frag_send_packet(struct sk_bu
 		frag_header.no++;
 	}
 
-	/* Make room for the fragment header. */
-	if (batadv_skb_head_push(skb, header_size) < 0 ||
-	    pskb_expand_head(skb, header_size + ETH_HLEN, 0, GFP_ATOMIC) < 0) {
-		ret = -ENOMEM;
+	/* make sure that there is at least enough head for the fragmentation
+	 * and ethernet headers
+	 */
+	ret = skb_cow_head(skb, ETH_HLEN + header_size);
+	if (ret < 0)
 		goto put_primary_if;
-	}
 
+	skb_push(skb, header_size);
 	memcpy(skb->data, &frag_header, header_size);
 
 	/* Send the last fragment */


