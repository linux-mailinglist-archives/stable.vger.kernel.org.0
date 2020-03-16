Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B35418759E
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 23:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732811AbgCPWbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 18:31:13 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:49130 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732766AbgCPWbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 18:31:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584397871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uARxoxuf57M7jaNAmrQwaT8jhUPe4rLyPULTsuoQiQI=;
        b=kvNkBQMZX+3xH1miNKQIigiJml3xCiJP+w6QQCnbnWJcgx0FFrcrzdI7yPy/ZoeahS5eEi
        BZIjjmEWbPXQTcAlQh6/Qp8ro9ijg3gDpujQHK65haBKI9cUGP6zf7Bl1chb1i7O3RACFB
        jEOecugMJ6OL6eVizNt05WcnLMFVlGI=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.9 02/24] batman-adv: Fix transmission of final, 16th fragment
Date:   Mon, 16 Mar 2020 23:30:43 +0100
Message-Id: <20200316223105.6333-3-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316223105.6333-1-sven@narfation.org>
References: <20200316223105.6333-1-sven@narfation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Lüssing <linus.luessing@c0d3.blue>

commit 51c6b429c0c95e67edd1cb0b548c5cf6a6604763 upstream.

Trying to split and transmit a unicast packet in 16 parts will fail for
the final fragment: After having sent the 15th one with a frag_packet.no
index of 14, we will increase the the index to 15 - and return with an
error code immediately, even though one more fragment is due for
transmission and allowed.

Fixing this issue by moving the check before incrementing the index.

While at it, adding an unlikely(), because the check is actually more of
an assertion.

Fixes: ee75ed88879a ("batman-adv: Fragment and send skbs larger than mtu")
Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/fragmentation.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/batman-adv/fragmentation.c b/net/batman-adv/fragmentation.c
index 384a1014da07..f3ad92b06247 100644
--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -490,6 +490,12 @@ int batadv_frag_send_packet(struct sk_buff *skb,
 
 	/* Eat and send fragments from the tail of skb */
 	while (skb->len > max_fragment_size) {
+		/* The initial check in this function should cover this case */
+		if (frag_header.no == BATADV_FRAG_MAX_FRAGMENTS - 1) {
+			ret = -1;
+			goto out;
+		}
+
 		skb_fragment = batadv_frag_create(skb, &frag_header, mtu);
 		if (!skb_fragment)
 			goto out;
@@ -507,12 +513,6 @@ int batadv_frag_send_packet(struct sk_buff *skb,
 		}
 
 		frag_header.no++;
-
-		/* The initial check in this function should cover this case */
-		if (frag_header.no == BATADV_FRAG_MAX_FRAGMENTS - 1) {
-			ret = -1;
-			goto out;
-		}
 	}
 
 	/* Make room for the fragment header. */
-- 
2.20.1

