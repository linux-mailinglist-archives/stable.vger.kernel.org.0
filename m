Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF1104A43C2
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377618AbiAaLYM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:24:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39204 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359243AbiAaLVG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:21:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83716B82A65;
        Mon, 31 Jan 2022 11:21:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E09C340E8;
        Mon, 31 Jan 2022 11:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628061;
        bh=IcZM6Y5BA+nG06mDGCAzua8aJeNr5MqdlLu67IuS6E0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FR37TlbaocXM0gM+RfnYJw3eI3JJM1EaBGcWxwvuR6HbCc9YzX6Y7hsjp7nNygOc+
         Oq8XFE5oHgWC0PKIg7r3jR2IPodvJkO30HdOxDiHN4Vf3gA9TXLw24mboQd46MhpzJ
         fdBkDIXNFT4nrrgCQUyO9tuD2c/w5oVUbIRzh8Zs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>, Ray Che <xijiache@gmail.com>,
        Willy Tarreau <w@1wt.eu>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.16 112/200] ipv4: avoid using shared IP generator for connected sockets
Date:   Mon, 31 Jan 2022 11:56:15 +0100
Message-Id: <20220131105237.351177146@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 23f57406b82de51809d5812afd96f210f8b627f3 upstream.

ip_select_ident_segs() has been very conservative about using
the connected socket private generator only for packets with IP_DF
set, claiming it was needed for some VJ compression implementations.

As mentioned in this referenced document, this can be abused.
(Ref: Off-Path TCP Exploits of the Mixed IPID Assignment)

Before switching to pure random IPID generation and possibly hurt
some workloads, lets use the private inet socket generator.

Not only this will remove one vulnerability, this will also
improve performance of TCP flows using pmtudisc==IP_PMTUDISC_DONT

Fixes: 73f156a6e8c1 ("inetpeer: get rid of ip_id_count")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reported-by: Ray Che <xijiache@gmail.com>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ip.h |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -525,19 +525,18 @@ static inline void ip_select_ident_segs(
 {
 	struct iphdr *iph = ip_hdr(skb);
 
+	/* We had many attacks based on IPID, use the private
+	 * generator as much as we can.
+	 */
+	if (sk && inet_sk(sk)->inet_daddr) {
+		iph->id = htons(inet_sk(sk)->inet_id);
+		inet_sk(sk)->inet_id += segs;
+		return;
+	}
 	if ((iph->frag_off & htons(IP_DF)) && !skb->ignore_df) {
-		/* This is only to work around buggy Windows95/2000
-		 * VJ compression implementations.  If the ID field
-		 * does not change, they drop every other packet in
-		 * a TCP stream using header compression.
-		 */
-		if (sk && inet_sk(sk)->inet_daddr) {
-			iph->id = htons(inet_sk(sk)->inet_id);
-			inet_sk(sk)->inet_id += segs;
-		} else {
-			iph->id = 0;
-		}
+		iph->id = 0;
 	} else {
+		/* Unfortunately we need the big hammer to get a suitable IPID */
 		__ip_select_ident(net, iph, segs);
 	}
 }


