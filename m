Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A353C18B812
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgCSNHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:07:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727843AbgCSNHH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:07:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CC4120757;
        Thu, 19 Mar 2020 13:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623227;
        bh=mEhCeYo5+LyTd6CUmygiuKW71GgnuF7c5fWXGTZcf60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jxJ/B30IWwFJ/+1ZK4i0MHui+bnFzAfznoaN2b5HJZqR9ecN2NadjWRd1RCkagREE
         takREfTGHSJyhB2a4+uVipKFqvYB0U79u8NfJDLrlAZ6AkhkhwXoelazMd/wOJddj8
         3EKuqQYbK0HF4CQRkfdvIBoBXwt8V1HFHJpCf+dQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 51/93] batman-adv: Fix ICMP RR ethernet access after skb_linearize
Date:   Thu, 19 Mar 2020 13:59:55 +0100
Message-Id: <20200319123941.177718976@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123924.795019515@linuxfoundation.org>
References: <20200319123924.795019515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

commit 3b55e4422087f9f7b241031d758a0c65584e4297 upstream.

The skb_linearize may reallocate the skb. This makes the calculated pointer
for ethhdr invalid. But it the pointer is used later to fill in the RR
field of the batadv_icmp_packet_rr packet.

Instead re-evaluate eth_hdr after the skb_linearize+skb_cow to fix the
pointer and avoid the invalid read.

Fixes: da6b8c20a5b8 ("batman-adv: generalize batman-adv icmp packet handling")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/routing.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -359,6 +359,7 @@ int batadv_recv_icmp_packet(struct sk_bu
 		if (skb_cow(skb, ETH_HLEN) < 0)
 			goto out;
 
+		ethhdr = eth_hdr(skb);
 		icmph = (struct batadv_icmp_header *)skb->data;
 		icmp_packet_rr = (struct batadv_icmp_packet_rr *)icmph;
 		if (icmp_packet_rr->rr_cur >= BATADV_RR_LEN)


