Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4D9918B7B1
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbgCSNLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:11:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727842AbgCSNLw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:11:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64A8520722;
        Thu, 19 Mar 2020 13:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623511;
        bh=Kb7fu7PYqOmi+PMi6/qbQKNeLIiO/nDBdwRaB6hj8Tk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FK0abZiH2ZZxgKu6wsSP9ptuOCMD3OKijHqS9uDAWicoa+iix4CgN3ywC5jgMwrER
         pr9StKjccuG86pyTDo9pMVIUikcrWAY9FSrNynFaOjUABgCK/oTk8hZMpdof/0wCnZ
         8kkI8swJYnu6oubdiUbAjjF80YyJ67gKO1GxeG9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Linus=20L=FCssing?= <linus.luessing@c0d3.blue>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.9 52/90] batman-adv: Fix transmission of final, 16th fragment
Date:   Thu, 19 Mar 2020 14:00:14 +0100
Message-Id: <20200319123944.516623028@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123928.635114118@linuxfoundation.org>
References: <20200319123928.635114118@linuxfoundation.org>
User-Agent: quilt/0.66
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/fragmentation.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -490,6 +490,12 @@ int batadv_frag_send_packet(struct sk_bu
 
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
@@ -507,12 +513,6 @@ int batadv_frag_send_packet(struct sk_bu
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


