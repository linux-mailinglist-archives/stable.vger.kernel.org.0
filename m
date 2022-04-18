Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E15505115
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbiDRMbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238817AbiDRM0f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:26:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A7B12759;
        Mon, 18 Apr 2022 05:20:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6C56B80ED6;
        Mon, 18 Apr 2022 12:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36FA3C385A7;
        Mon, 18 Apr 2022 12:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284443;
        bh=vhKExvIQrbJBdlaP1JzvwlQFvp3uGz/rl9Ht0Bu1+qU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GBWCjftAgM/0uiyGo3dIC6cTPIYKFYnRAZNiX9oh2TqbFYetjUOi70jFc7P1HIsVn
         /OuAvD4bqiSBs6Ww7GmV0y43hfu1Y3YB13OmBTBRh6pQFj/dT8BT/m8GkEdzj29AVn
         ftYoobwW0iwvHqRl7CVJkS7owLqw7v/kFX1iMPG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Willi <martin@strongswan.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 117/219] macvlan: Fix leaking skb in source mode with nodst option
Date:   Mon, 18 Apr 2022 14:11:26 +0200
Message-Id: <20220418121210.174324412@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Willi <martin@strongswan.org>

[ Upstream commit e16b859872b87650bb55b12cca5a5fcdc49c1442 ]

The MACVLAN receive handler clones skbs to all matching source MACVLAN
interfaces, before it passes the packet along to match on destination
based MACVLANs.

When using the MACVLAN nodst mode, passing the packet to destination based
MACVLANs is omitted and the handler returns with RX_HANDLER_CONSUMED.
However, the passed skb is not freed, leaking for any packet processed
with the nodst option.

Properly free the skb when consuming packets to fix that leak.

Fixes: 427f0c8c194b ("macvlan: Add nodst option to macvlan type source")
Signed-off-by: Martin Willi <martin@strongswan.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macvlan.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 6ef5f77be4d0..c83664b28d89 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -460,8 +460,10 @@ static rx_handler_result_t macvlan_handle_frame(struct sk_buff **pskb)
 			return RX_HANDLER_CONSUMED;
 		*pskb = skb;
 		eth = eth_hdr(skb);
-		if (macvlan_forward_source(skb, port, eth->h_source))
+		if (macvlan_forward_source(skb, port, eth->h_source)) {
+			kfree_skb(skb);
 			return RX_HANDLER_CONSUMED;
+		}
 		src = macvlan_hash_lookup(port, eth->h_source);
 		if (src && src->mode != MACVLAN_MODE_VEPA &&
 		    src->mode != MACVLAN_MODE_BRIDGE) {
@@ -480,8 +482,10 @@ static rx_handler_result_t macvlan_handle_frame(struct sk_buff **pskb)
 		return RX_HANDLER_PASS;
 	}
 
-	if (macvlan_forward_source(skb, port, eth->h_source))
+	if (macvlan_forward_source(skb, port, eth->h_source)) {
+		kfree_skb(skb);
 		return RX_HANDLER_CONSUMED;
+	}
 	if (macvlan_passthru(port))
 		vlan = list_first_or_null_rcu(&port->vlans,
 					      struct macvlan_dev, list);
-- 
2.35.1



