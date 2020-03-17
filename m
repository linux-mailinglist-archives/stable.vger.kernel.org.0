Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4796189209
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbgCQX2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:28:09 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53676 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727131AbgCQX2J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:28:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RBgOKhBj6G8fFGvefZ9C5G4eVj0Jn0ZFh9ioRjnE5mI=;
        b=mMCedX8uir4Uz2H5SgwkgXWux/9U8Wax14d/LKskgcLotJBpHkJGzJ6L2WBsIR/giC9SB4
        ctuCPNvpchW3K4X+4aLir4xHONqCweB33b+RNTCBdSvpXkQagDeFB91/d3EgUqdaDZqeac
        I8gnNeasYWC2BkTLSbLhHLqVv1qhQPM=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 26/48] batman-adv: Fix transmission of final, 16th fragment
Date:   Wed, 18 Mar 2020 00:27:12 +0100
Message-Id: <20200317232734.6127-27-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
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
Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 net/batman-adv/fragmentation.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/batman-adv/fragmentation.c b/net/batman-adv/fragmentation.c
index 8605e3c7958d..9751b207b01f 100644
--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -480,6 +480,10 @@ bool batadv_frag_send_packet(struct sk_buff *skb,
 
 	/* Eat and send fragments from the tail of skb */
 	while (skb->len > max_fragment_size) {
+		/* The initial check in this function should cover this case */
+		if (frag_header.no == BATADV_FRAG_MAX_FRAGMENTS - 1)
+			goto out_err;
+
 		skb_fragment = batadv_frag_create(skb, &frag_header, mtu);
 		if (!skb_fragment)
 			goto out_err;
@@ -490,10 +494,6 @@ bool batadv_frag_send_packet(struct sk_buff *skb,
 		batadv_send_skb_packet(skb_fragment, neigh_node->if_incoming,
 				       neigh_node->addr);
 		frag_header.no++;
-
-		/* The initial check in this function should cover this case */
-		if (frag_header.no == BATADV_FRAG_MAX_FRAGMENTS - 1)
-			goto out_err;
 	}
 
 	/* Make room for the fragment header. */
-- 
2.20.1

