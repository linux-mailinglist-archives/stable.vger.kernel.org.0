Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45BD41D0CB4
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732751AbgEMJq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:46:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732730AbgEMJq4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:46:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3215420740;
        Wed, 13 May 2020 09:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363215;
        bh=7+ERR58qtP0Taf+nilPY80hBVVqMfzujDkJgWpGVnnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DsITpYvqnbVYe6fpqAvx3VeXkyMJuLMtrfz8CDTNDSgeZQlc1sbxmrgCbdP3BKqXU
         NTC5hbuMSnWl93FKYgxmHNNx0GmjYLUI4y1dgfoPP9tDaJkfCX4o8SDDYXRzGGGhAD
         7xcgbLALrzG9yLi+ifPBZzo5Syebp1En7Z04Rwjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, George Spelvin <lkml@sdf.org>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.19 33/48] batman-adv: fix batadv_nc_random_weight_tq
Date:   Wed, 13 May 2020 11:44:59 +0200
Message-Id: <20200513094400.031666955@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094351.100352960@linuxfoundation.org>
References: <20200513094351.100352960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George Spelvin <lkml@sdf.org>

commit fd0c42c4dea54335967c5a86f15fc064235a2797 upstream.

and change to pseudorandom numbers, as this is a traffic dithering
operation that doesn't need crypto-grade.

The previous code operated in 4 steps:

1. Generate a random byte 0 <= rand_tq <= 255
2. Multiply it by BATADV_TQ_MAX_VALUE - tq
3. Divide by 255 (= BATADV_TQ_MAX_VALUE)
4. Return BATADV_TQ_MAX_VALUE - rand_tq

This would apperar to scale (BATADV_TQ_MAX_VALUE - tq) by a random
value between 0/255 and 255/255.

But!  The intermediate value between steps 3 and 4 is stored in a u8
variable.  So it's truncated, and most of the time, is less than 255, after
which the division produces 0.  Specifically, if tq is odd, the product is
always even, and can never be 255.  If tq is even, there's exactly one
random byte value that will produce a product byte of 255.

Thus, the return value is 255 (511/512 of the time) or 254 (1/512
of the time).

If we assume that the truncation is a bug, and the code is meant to scale
the input, a simpler way of looking at it is that it's returning a random
value between tq and BATADV_TQ_MAX_VALUE, inclusive.

Well, we have an optimized function for doing just that.

Fixes: 3c12de9a5c75 ("batman-adv: network coding - code and transmit packets if possible")
Signed-off-by: George Spelvin <lkml@sdf.org>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/batman-adv/network-coding.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/net/batman-adv/network-coding.c
+++ b/net/batman-adv/network-coding.c
@@ -1021,15 +1021,8 @@ static struct batadv_nc_path *batadv_nc_
  */
 static u8 batadv_nc_random_weight_tq(u8 tq)
 {
-	u8 rand_val, rand_tq;
-
-	get_random_bytes(&rand_val, sizeof(rand_val));
-
 	/* randomize the estimated packet loss (max TQ - estimated TQ) */
-	rand_tq = rand_val * (BATADV_TQ_MAX_VALUE - tq);
-
-	/* normalize the randomized packet loss */
-	rand_tq /= BATADV_TQ_MAX_VALUE;
+	u8 rand_tq = prandom_u32_max(BATADV_TQ_MAX_VALUE + 1 - tq);
 
 	/* convert to (randomized) estimated tq again */
 	return BATADV_TQ_MAX_VALUE - rand_tq;


