Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4437F5495FE
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352909AbiFMMl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355966AbiFMMjR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:39:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F7E33892;
        Mon, 13 Jun 2022 04:09:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1BDCB80EA7;
        Mon, 13 Jun 2022 11:09:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30951C3411E;
        Mon, 13 Jun 2022 11:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118574;
        bh=BNGUQ1K4Z2kj5H83mdJV3f3F+GusUjPAud/n33f7kf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z36fv7C62kCFkaurT0/ItLt6IpjSg9E/edha0ZfR1xPeuIJH/RqN9U5JiHtcURVSo
         zcCVrKh8y5XV8wCcJxQA4hUN9ANMHEOcKcmzzSCqrVB1oTpm53RUu3xLbbJPjjo+5/
         MErxo1FFyHCWPtN6pRiXg3x0ykZUczItje1YiMwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/172] ip_gre: test csum_start instead of transport header
Date:   Mon, 13 Jun 2022 12:11:10 +0200
Message-Id: <20220613094916.720105325@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094850.166931805@linuxfoundation.org>
References: <20220613094850.166931805@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 8d21e9963bec1aad2280cdd034c8993033ef2948 ]

GRE with TUNNEL_CSUM will apply local checksum offload on
CHECKSUM_PARTIAL packets.

ipgre_xmit must validate csum_start after an optional skb_pull,
else lco_csum may trigger an overflow. The original check was

	if (csum && skb_checksum_start(skb) < skb->data)
		return -EINVAL;

This had false positives when skb_checksum_start is undefined:
when ip_summed is not CHECKSUM_PARTIAL. A discussed refinement
was straightforward

	if (csum && skb->ip_summed == CHECKSUM_PARTIAL &&
	    skb_checksum_start(skb) < skb->data)
		return -EINVAL;

But was eventually revised more thoroughly:
- restrict the check to the only branch where needed, in an
  uncommon GRE path that uses header_ops and calls skb_pull.
- test skb_transport_header, which is set along with csum_start
  in skb_partial_csum_set in the normal header_ops datapath.

Turns out skbs can arrive in this branch without the transport
header set, e.g., through BPF redirection.

Revise the check back to check csum_start directly, and only if
CHECKSUM_PARTIAL. Do leave the check in the updated location.
Check field regardless of whether TUNNEL_CSUM is configured.

Link: https://lore.kernel.org/netdev/YS+h%2FtqCJJiQei+W@shredder/
Link: https://lore.kernel.org/all/20210902193447.94039-2-willemdebruijn.kernel@gmail.com/T/#u
Fixes: 8a0ed250f911 ("ip_gre: validate csum_start only on pull")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Link: https://lore.kernel.org/r/20220606132107.3582565-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_gre.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 2a80038575d2..a7e32be8714f 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -624,21 +624,20 @@ static netdev_tx_t ipgre_xmit(struct sk_buff *skb,
 	}
 
 	if (dev->header_ops) {
-		const int pull_len = tunnel->hlen + sizeof(struct iphdr);
-
 		if (skb_cow_head(skb, 0))
 			goto free_skb;
 
 		tnl_params = (const struct iphdr *)skb->data;
 
-		if (pull_len > skb_transport_offset(skb))
-			goto free_skb;
-
 		/* Pull skb since ip_tunnel_xmit() needs skb->data pointing
 		 * to gre header.
 		 */
-		skb_pull(skb, pull_len);
+		skb_pull(skb, tunnel->hlen + sizeof(struct iphdr));
 		skb_reset_mac_header(skb);
+
+		if (skb->ip_summed == CHECKSUM_PARTIAL &&
+		    skb_checksum_start(skb) < skb->data)
+			goto free_skb;
 	} else {
 		if (skb_cow_head(skb, dev->needed_headroom))
 			goto free_skb;
-- 
2.35.1



