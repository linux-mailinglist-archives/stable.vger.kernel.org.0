Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8473C531655
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240635AbiEWRaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242120AbiEWR10 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:27:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8397B9E7;
        Mon, 23 May 2022 10:22:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 448E8608C0;
        Mon, 23 May 2022 17:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45745C385A9;
        Mon, 23 May 2022 17:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326558;
        bh=59034JlVFmmJqNI8BkjyG9GauHmmps4h9zRtuWOswGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RdGqb1jFhmmmQ3hsUV9Yl2oIfqJaAyg+nkfJOSnvsUmTX1NbIjd/1MGAedwBGTNw5
         D4C5QPOmiHeLg1YmnNyfK3LLjJ63E4P8WpVC0ccF5hC/ljFMVlts+27gQdMsqGJ9G7
         JyMS5GjOG4v5QE2Z4Q5UQWWt5cimsyzl2wHgwk7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lina Wang <lina.wang@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 119/132] net: fix wrong network header length
Date:   Mon, 23 May 2022 19:05:28 +0200
Message-Id: <20220523165843.283511092@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lina Wang <lina.wang@mediatek.com>

[ Upstream commit cf3ab8d4a797960b4be20565abb3bcd227b18a68 ]

When clatd starts with ebpf offloaing, and NETIF_F_GRO_FRAGLIST is enable,
several skbs are gathered in skb_shinfo(skb)->frag_list. The first skb's
ipv6 header will be changed to ipv4 after bpf_skb_proto_6_to_4,
network_header\transport_header\mac_header have been updated as ipv4 acts,
but other skbs in frag_list didnot update anything, just ipv6 packets.

udp_queue_rcv_skb will call skb_segment_list to traverse other skbs in
frag_list and make sure right udp payload is delivered to user space.
Unfortunately, other skbs in frag_list who are still ipv6 packets are
updated like the first skb and will have wrong transport header length.

e.g.before bpf_skb_proto_6_to_4,the first skb and other skbs in frag_list
has the same network_header(24)& transport_header(64), after
bpf_skb_proto_6_to_4, ipv6 protocol has been changed to ipv4, the first
skb's network_header is 44,transport_header is 64, other skbs in frag_list
didnot change.After skb_segment_list, the other skbs in frag_list has
different network_header(24) and transport_header(44), so there will be 20
bytes different from original,that is difference between ipv6 header and
ipv4 header. Just change transport_header to be the same with original.

Actually, there are two solutions to fix it, one is traversing all skbs
and changing every skb header in bpf_skb_proto_6_to_4, the other is
modifying frag_list skb's header in skb_segment_list. Considering
efficiency, adopt the second one--- when the first skb and other skbs in
frag_list has different network_header length, restore them to make sure
right udp payload is delivered to user space.

Signed-off-by: Lina Wang <lina.wang@mediatek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e4badc189e37..7ef0f5a8ab03 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3873,7 +3873,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 	unsigned int delta_len = 0;
 	struct sk_buff *tail = NULL;
 	struct sk_buff *nskb, *tmp;
-	int err;
+	int len_diff, err;
 
 	skb_push(skb, -skb_network_offset(skb) + offset);
 
@@ -3913,9 +3913,11 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 		skb_push(nskb, -skb_network_offset(nskb) + offset);
 
 		skb_release_head_state(nskb);
+		len_diff = skb_network_header_len(nskb) - skb_network_header_len(skb);
 		__copy_skb_header(nskb, skb);
 
 		skb_headers_offset_update(nskb, skb_headroom(nskb) - skb_headroom(skb));
+		nskb->transport_header += len_diff;
 		skb_copy_from_linear_data_offset(skb, -tnl_hlen,
 						 nskb->data - tnl_hlen,
 						 offset + tnl_hlen);
-- 
2.35.1



