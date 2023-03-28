Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 828FF6CC2A7
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233294AbjC1Or0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233335AbjC1OrL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:47:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFA0C163
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:46:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A402AB81D68
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59B9C4339B;
        Tue, 28 Mar 2023 14:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014810;
        bh=O7QVPbE0xq5jOwrACmNR6ofwUb7EHygjsID5IcW4PWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QfBLS4jhs6kI2i2fOu5mZ91GLx5Vr6oMnxibjP8GsBiYNOICD5CyM8U6XL6H2Ntbq
         Oc93t50QVtyAKa5w4mQYIN7HWnBNEKMT7a9ptQ8WysXvBSPpwIcuMgnevXyDDximNJ
         vb/3NxB5+WmjxtuL1eewSzUeY6NnofUEJIShHhFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 060/240] net: dsa: report rx_bytes unadjusted for ETH_HLEN
Date:   Tue, 28 Mar 2023 16:40:23 +0200
Message-Id: <20230328142622.222558129@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit a8eff03545d4cef12ae66a1905627c1818a0f81a ]

We collect the software statistics counters for RX bytes (reported to
/proc/net/dev and to ethtool -S $dev | grep 'rx_bytes: ") at a time when
skb->len has already been adjusted by the eth_type_trans() ->
skb_pull_inline(skb, ETH_HLEN) call to exclude the L2 header.

This means that when connecting 2 DSA interfaces back to back and
sending 1 packet with length 100, the sending interface will report
tx_bytes as incrementing by 100, and the receiving interface will report
rx_bytes as incrementing by 86.

Since accounting for that in scripts is quirky and is something that
would be DSA-specific behavior (requiring users to know that they are
running on a DSA interface in the first place), the proposal is that we
treat it as a bug and fix it.

This design bug has always existed in DSA, according to my analysis:
commit 91da11f870f0 ("net: Distributed Switch Architecture protocol
support") also updates skb->dev->stats.rx_bytes += skb->len after the
eth_type_trans() call. Technically, prior to Florian's commit
a86d8becc3f0 ("net: dsa: Factor bottom tag receive functions"), each and
every vendor-specific tagging protocol driver open-coded the same bug,
until the buggy code was consolidated into something resembling what can
be seen now. So each and every driver should have its own Fixes: tag,
because of their different histories until the convergence point.
I'm not going to do that, for the sake of simplicity, but just blame the
oldest appearance of buggy code.

There are 2 ways to fix the problem. One is the obvious way, and the
other is how I ended up doing it. Obvious would have been to move
dev_sw_netstats_rx_add() one line above eth_type_trans(), and below
skb_push(skb, ETH_HLEN). But DSA processing is not as simple as that.
We count the bytes after removing everything DSA-related from the
packet, to emulate what the packet's length was, on the wire, when the
user port received it.

When eth_type_trans() executes, dsa_untag_bridge_pvid() has not run yet,
so in case the switch driver requests this behavior - commit
412a1526d067 ("net: dsa: untag the bridge pvid from rx skbs") has the
details - the obvious variant of the fix wouldn't have worked, because
the positioning there would have also counted the not-yet-stripped VLAN
header length, something which is absent from the packet as seen on the
wire (there it may be untagged, whereas software will see it as
PVID-tagged).

Fixes: f613ed665bb3 ("net: dsa: Add support for 64-bit statistics")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag.c b/net/dsa/tag.c
index b2fba1a003ce3..5105a5ff58fa2 100644
--- a/net/dsa/tag.c
+++ b/net/dsa/tag.c
@@ -114,7 +114,7 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
 		skb = nskb;
 	}
 
-	dev_sw_netstats_rx_add(skb->dev, skb->len);
+	dev_sw_netstats_rx_add(skb->dev, skb->len + ETH_HLEN);
 
 	if (dsa_skb_defer_rx_timestamp(p, skb))
 		return 0;
-- 
2.39.2



