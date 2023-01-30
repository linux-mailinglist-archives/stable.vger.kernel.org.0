Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D2268123E
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237517AbjA3OTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237585AbjA3OTP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:19:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284E338678
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:18:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E352B811D2
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7594AC4339B;
        Mon, 30 Jan 2023 14:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088246;
        bh=mpFuFh6JFmkTAooGvPqZ0lyTgxxdn+1xfdLelFQpU1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KuyAR3hwBehilefVrxsBJoaOujMKlS/46huxWeEKnUMXPJ+60U3fbj3c0/fbqkYiR
         tqJx3GmayAwgo2Wrt5ocGTUZr5GznQoj0oP50jLoD4KnFAodlbw17hedvZRydCHwKv
         DU9Nyf4MJQxlt6nvOi5dTMET/CRB+DDuSxNprs9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gergely Risko <gergely.risko@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 163/204] ipv6: fix reachability confirmation with proxy_ndp
Date:   Mon, 30 Jan 2023 14:52:08 +0100
Message-Id: <20230130134323.723987888@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gergely Risko <gergely.risko@gmail.com>

commit 9f535c870e493841ac7be390610ff2edec755762 upstream.

When proxying IPv6 NDP requests, the adverts to the initial multicast
solicits are correct and working.  On the other hand, when later a
reachability confirmation is requested (on unicast), no reply is sent.

This causes the neighbor entry expiring on the sending node, which is
mostly a non-issue, as a new multicast request is sent.  There are
routers, where the multicast requests are intentionally delayed, and in
these environments the current implementation causes periodic packet
loss for the proxied endpoints.

The root cause is the erroneous decrease of the hop limit, as this
is checked in ndisc.c and no answer is generated when it's 254 instead
of the correct 255.

Cc: stable@vger.kernel.org
Fixes: 46c7655f0b56 ("ipv6: decrease hop limit counter in ip6_forward()")
Signed-off-by: Gergely Risko <gergely.risko@gmail.com>
Tested-by: Gergely Risko <gergely.risko@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_output.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -527,7 +527,20 @@ int ip6_forward(struct sk_buff *skb)
 	    pneigh_lookup(&nd_tbl, net, &hdr->daddr, skb->dev, 0)) {
 		int proxied = ip6_forward_proxy_check(skb);
 		if (proxied > 0) {
-			hdr->hop_limit--;
+			/* It's tempting to decrease the hop limit
+			 * here by 1, as we do at the end of the
+			 * function too.
+			 *
+			 * But that would be incorrect, as proxying is
+			 * not forwarding.  The ip6_input function
+			 * will handle this packet locally, and it
+			 * depends on the hop limit being unchanged.
+			 *
+			 * One example is the NDP hop limit, that
+			 * always has to stay 255, but other would be
+			 * similar checks around RA packets, where the
+			 * user can even change the desired limit.
+			 */
 			return ip6_input(skb);
 		} else if (proxied < 0) {
 			__IP6_INC_STATS(net, idev, IPSTATS_MIB_INDISCARDS);


