Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB3844A6378
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 19:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237328AbiBASRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 13:17:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241864AbiBASRW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 13:17:22 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C9CC06173E;
        Tue,  1 Feb 2022 10:17:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 17B24CE1A67;
        Tue,  1 Feb 2022 18:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BC1C340F0;
        Tue,  1 Feb 2022 18:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643739439;
        bh=H4fJ8W7e1YBjjMdcZHnOa2WOCTlG9kCx0mvZtTLxUmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hz3ctjTUPcLmf4cjLgWcfUb0BYj6XB094H+/roM3svK8WFfmHOifYHs63x4oBSFda
         XClGl9xPkHCi9A0uj+8CVojx1m62e3HHlQ5AynABL2LA5GBzYGtcvxU4zBFmp61wfo
         L0xCN7wRuRAPM2e233pM++OHtMeKNnyJ151nwr58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>, Ray Che <xijiache@gmail.com>,
        Willy Tarreau <w@1wt.eu>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.4 16/25] ipv4: avoid using shared IP generator for connected sockets
Date:   Tue,  1 Feb 2022 19:16:40 +0100
Message-Id: <20220201180822.677134289@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220201180822.148370751@linuxfoundation.org>
References: <20220201180822.148370751@linuxfoundation.org>
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
@@ -353,19 +353,18 @@ static inline void ip_select_ident_segs(
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


