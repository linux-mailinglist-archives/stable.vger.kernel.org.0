Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3079F1CAEAB
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729317AbgEHMpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:45:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728686AbgEHMpi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:45:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D140A21473;
        Fri,  8 May 2020 12:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941938;
        bh=KvLHU9qvwL40HmI3IBQBsHdnpHTg5jiXzNUjFjv4S2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lwaiAdy576b3Lme93prMwen/sMBIp9IftaJjWi7Yy/uahnmZPAeEWYbtpXmuIxcD2
         c4ppN1n9wz0PysQ2CVVuAYJel3aIn6QvK5IEgy0ZqzsDVnyfAFgeakog5zsGl3aW2z
         EYlrSWSKJW9ujvEYRvpKEQFsaPuBpUuubl5elDT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Herbert <tom@herbertland.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 193/312] ipv6: fix checksum annotation in udp6_csum_init
Date:   Fri,  8 May 2020 14:33:04 +0200
Message-Id: <20200508123138.026787779@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

commit c148d16369ff0095eca950d17968ba1d56a47b53 upstream.

Cc: Tom Herbert <tom@herbertland.com>
Fixes: 4068579e1e098fa ("net: Implmement RFC 6936 (zero RX csums for UDP/IPv6")
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv6/ip6_checksum.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/ipv6/ip6_checksum.c
+++ b/net/ipv6/ip6_checksum.c
@@ -84,9 +84,12 @@ int udp6_csum_init(struct sk_buff *skb,
 	 * we accept a checksum of zero here. When we find the socket
 	 * for the UDP packet we'll check if that socket allows zero checksum
 	 * for IPv6 (set by socket option).
+	 *
+	 * Note, we are only interested in != 0 or == 0, thus the
+	 * force to int.
 	 */
-	return skb_checksum_init_zero_check(skb, proto, uh->check,
-					   ip6_compute_pseudo);
+	return (__force int)skb_checksum_init_zero_check(skb, proto, uh->check,
+							 ip6_compute_pseudo);
 }
 EXPORT_SYMBOL(udp6_csum_init);
 


