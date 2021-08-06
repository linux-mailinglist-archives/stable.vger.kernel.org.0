Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5783E24EA
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243788AbhHFIPQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:15:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243727AbhHFIPH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:15:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BC03611B0;
        Fri,  6 Aug 2021 08:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237692;
        bh=AKWERcjtrAvwWQy4q8XKeRbtEAr4BgA0Qm2Sbx46Vao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kg4PLzfWXcopBMFURw20XPQ2BlGq1EgxSe4fvFsUTNHoSvVG6i+UDHEOjo6Lk+ut9
         H10E2iuGiVk4tuaQxsXnPMaqBiedgJ2w0vOrAvNPw7jmwV8sMuHB1Ph3+kDTzoZlLi
         ovoYqAVLPhaVxCooTV48dU2XmTgSAg40/C5PLJC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 4/6] net: Fix zero-copy head len calculation.
Date:   Fri,  6 Aug 2021 10:14:36 +0200
Message-Id: <20210806081109.080645847@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081108.939164003@linuxfoundation.org>
References: <20210806081108.939164003@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pravin B Shelar <pshelar@ovn.org>

[ Upstream commit a17ad0961706244dce48ec941f7e476a38c0e727 ]

In some cases skb head could be locked and entire header
data is pulled from skb. When skb_zerocopy() called in such cases,
following BUG is triggered. This patch fixes it by copying entire
skb in such cases.
This could be optimized incase this is performance bottleneck.

---8<---
kernel BUG at net/core/skbuff.c:2961!
invalid opcode: 0000 [#1] SMP PTI
CPU: 2 PID: 0 Comm: swapper/2 Tainted: G           OE     5.4.0-77-generic #86-Ubuntu
Hardware name: OpenStack Foundation OpenStack Nova, BIOS 1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:skb_zerocopy+0x37a/0x3a0
RSP: 0018:ffffbcc70013ca38 EFLAGS: 00010246
Call Trace:
 <IRQ>
 queue_userspace_packet+0x2af/0x5e0 [openvswitch]
 ovs_dp_upcall+0x3d/0x60 [openvswitch]
 ovs_dp_process_packet+0x125/0x150 [openvswitch]
 ovs_vport_receive+0x77/0xd0 [openvswitch]
 netdev_port_receive+0x87/0x130 [openvswitch]
 netdev_frame_hook+0x4b/0x60 [openvswitch]
 __netif_receive_skb_core+0x2b4/0xc90
 __netif_receive_skb_one_core+0x3f/0xa0
 __netif_receive_skb+0x18/0x60
 process_backlog+0xa9/0x160
 net_rx_action+0x142/0x390
 __do_softirq+0xe1/0x2d6
 irq_exit+0xae/0xb0
 do_IRQ+0x5a/0xf0
 common_interrupt+0xf/0xf

Code that triggered BUG:
int
skb_zerocopy(struct sk_buff *to, struct sk_buff *from, int len, int hlen)
{
        int i, j = 0;
        int plen = 0; /* length of skb->head fragment */
        int ret;
        struct page *page;
        unsigned int offset;

        BUG_ON(!from->head_frag && !hlen);

Signed-off-by: Pravin B Shelar <pshelar@ovn.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 7665154c85c2..58989a5ba362 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2243,8 +2243,11 @@ skb_zerocopy_headlen(const struct sk_buff *from)
 
 	if (!from->head_frag ||
 	    skb_headlen(from) < L1_CACHE_BYTES ||
-	    skb_shinfo(from)->nr_frags >= MAX_SKB_FRAGS)
+	    skb_shinfo(from)->nr_frags >= MAX_SKB_FRAGS) {
 		hlen = skb_headlen(from);
+		if (!hlen)
+			hlen = from->len;
+	}
 
 	if (skb_has_frag_list(from))
 		hlen = from->len;
-- 
2.30.2



