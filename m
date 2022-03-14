Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6F5A4D8453
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241689AbiCNMXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243184AbiCNMUV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:20:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73DCD5371F;
        Mon, 14 Mar 2022 05:15:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D043460B80;
        Mon, 14 Mar 2022 12:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E04C340E9;
        Mon, 14 Mar 2022 12:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260127;
        bh=r4aKVxRcS5UDMIkz1JVImxpE6sxrwYcacVNnbS5lCcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rIJHET9P6oso9arXDAvEV/gLp8SuTlnVRcWXJLj+OuepYAKo3u/FupdSgdqjFi0TF
         4tmBfOap8DzamNEcUHnl+rk8SYQ/ZJKpNhM3g2/F9QMEmE/37tmLkSzrTTLZjmokVR
         xng/SeeQIZjvg3mA5SjihW4ENvY3/vlAcJpQaemA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 024/121] esp: Fix BEET mode inter address family tunneling on GSO
Date:   Mon, 14 Mar 2022 12:53:27 +0100
Message-Id: <20220314112744.804502231@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 053c8fdf2c930efdff5496960842bbb5c34ad43a ]

The xfrm{4,6}_beet_gso_segment() functions did not correctly set the
SKB_GSO_IPXIP4 and SKB_GSO_IPXIP6 gso types for the address family
tunneling case. Fix this by setting these gso types.

Fixes: 384a46ea7bdc7 ("esp4: add gso_segment for esp4 beet mode")
Fixes: 7f9e40eb18a99 ("esp6: add gso_segment for esp6 beet mode")
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/esp4_offload.c | 3 +++
 net/ipv6/esp6_offload.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 8e4e9aa12130..dad5d29a6a8d 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -159,6 +159,9 @@ static struct sk_buff *xfrm4_beet_gso_segment(struct xfrm_state *x,
 			skb_shinfo(skb)->gso_type |= SKB_GSO_TCPV4;
 	}
 
+	if (proto == IPPROTO_IPV6)
+		skb_shinfo(skb)->gso_type |= SKB_GSO_IPXIP4;
+
 	__skb_pull(skb, skb_transport_offset(skb));
 	ops = rcu_dereference(inet_offloads[proto]);
 	if (likely(ops && ops->callbacks.gso_segment))
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index a349d4798077..302170882382 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -198,6 +198,9 @@ static struct sk_buff *xfrm6_beet_gso_segment(struct xfrm_state *x,
 			ipv6_skip_exthdr(skb, 0, &proto, &frag);
 	}
 
+	if (proto == IPPROTO_IPIP)
+		skb_shinfo(skb)->gso_type |= SKB_GSO_IPXIP6;
+
 	__skb_pull(skb, skb_transport_offset(skb));
 	ops = rcu_dereference(inet6_offloads[proto]);
 	if (likely(ops && ops->callbacks.gso_segment))
-- 
2.34.1



