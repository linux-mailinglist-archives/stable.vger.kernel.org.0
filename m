Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C635054BD
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241234AbiDRNLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241069AbiDRNF2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:05:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E641340E6;
        Mon, 18 Apr 2022 05:46:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E697B80E44;
        Mon, 18 Apr 2022 12:46:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EDD6C385A1;
        Mon, 18 Apr 2022 12:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285981;
        bh=GEUZwU1+OofwnIqaqCFJ4mK78qVbnAHx4M3E9BKheew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LSbOdhr/wEJaaZtpAY+oX3QkR1OMZJTGJ8zgOd1RaY0ju4dwKkTS7nK7fqWWB4c7C
         vOozQkmQfp9yN0G9+2uVGlEuDcOscZ81puMlFJrtCQXeBq66cGTP+yicmVIp21SoWo
         O6PtmCAfMQPxJVmoSP9CihgOBE+ksHJUysdofAFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 03/32] veth: Ensure eth header is in skbs linear part
Date:   Mon, 18 Apr 2022 14:13:43 +0200
Message-Id: <20220418121127.228153394@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121127.127656835@linuxfoundation.org>
References: <20220418121127.127656835@linuxfoundation.org>
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

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 726e2c5929de841fdcef4e2bf995680688ae1b87 ]

After feeding a decapsulated packet to a veth device with act_mirred,
skb_headlen() may be 0. But veth_xmit() calls __dev_forward_skb(),
which expects at least ETH_HLEN byte of linear data (as
__dev_forward_skb2() calls eth_type_trans(), which pulls ETH_HLEN bytes
unconditionally).

Use pskb_may_pull() to ensure veth_xmit() respects this constraint.

kernel BUG at include/linux/skbuff.h:2328!
RIP: 0010:eth_type_trans+0xcf/0x140
Call Trace:
 <IRQ>
 __dev_forward_skb2+0xe3/0x160
 veth_xmit+0x6e/0x250 [veth]
 dev_hard_start_xmit+0xc7/0x200
 __dev_queue_xmit+0x47f/0x520
 ? skb_ensure_writable+0x85/0xa0
 ? skb_mpls_pop+0x98/0x1c0
 tcf_mirred_act+0x442/0x47e [act_mirred]
 tcf_action_exec+0x86/0x140
 fl_classify+0x1d8/0x1e0 [cls_flower]
 ? dma_pte_clear_level+0x129/0x1a0
 ? dma_pte_clear_level+0x129/0x1a0
 ? prb_fill_curr_block+0x2f/0xc0
 ? skb_copy_bits+0x11a/0x220
 __tcf_classify+0x58/0x110
 tcf_classify_ingress+0x6b/0x140
 __netif_receive_skb_core.constprop.0+0x47d/0xfd0
 ? __iommu_dma_unmap_swiotlb+0x44/0x90
 __netif_receive_skb_one_core+0x3d/0xa0
 netif_receive_skb+0x116/0x170
 be_process_rx+0x22f/0x330 [be2net]
 be_poll+0x13c/0x370 [be2net]
 __napi_poll+0x2a/0x170
 net_rx_action+0x22f/0x2f0
 __do_softirq+0xca/0x2a8
 __irq_exit_rcu+0xc1/0xe0
 common_interrupt+0x83/0xa0

Fixes: e314dbdc1c0d ("[NET]: Virtual ethernet device driver.")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 76e834ca54e7..ea999a663933 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -188,7 +188,7 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	rcu_read_lock();
 	rcv = rcu_dereference(priv->peer);
-	if (unlikely(!rcv)) {
+	if (unlikely(!rcv) || !pskb_may_pull(skb, ETH_HLEN)) {
 		kfree_skb(skb);
 		goto drop;
 	}
-- 
2.35.1



