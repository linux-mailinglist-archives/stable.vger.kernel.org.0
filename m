Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E9921FA36
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729603AbgGNSuh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:50:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729762AbgGNSug (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:50:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8750522B2A;
        Tue, 14 Jul 2020 18:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752636;
        bh=x+mqtEHtr5pU8xTmp/nbCT3JM8PHRKS4d7TuIXMaZ5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QhjhqPNkC3Cw3QPyxE6ajeoXvPgVVvqnu49jzHKi5OzTBFwhQQVfM7IDBecXViGgs
         llpbfYmhUh+W5I3KyvnTTEag+y+Jh8CEgYI97XMxRI8JrRUBWZS1iq4zfmxy8HB7/O
         xyqKyvDOH2YBcvasR9RYxUf9mG929ypXZEHb0FNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 054/109] net: hns3: fix use-after-free when doing self test
Date:   Tue, 14 Jul 2020 20:43:57 +0200
Message-Id: <20200714184108.104116242@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184105.507384017@linuxfoundation.org>
References: <20200714184105.507384017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

[ Upstream commit a06656211304fec653c1931c2ca6d644013b5bbb ]

Enable promisc mode of PF, set VF link state to enable, and
run iperf of the VF, then do self test of the PF. The self test
will fail with a low frequency, and may cause a use-after-free
problem.

[   87.142126] selftest:000004a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   87.159722] ==================================================================
[   87.174187] BUG: KASAN: use-after-free in hex_dump_to_buffer+0x140/0x608
[   87.187600] Read of size 1 at addr ffff003b22828000 by task ethtool/1186
[   87.201012]
[   87.203978] CPU: 7 PID: 1186 Comm: ethtool Not tainted 5.5.0-rc4-gfd51c473-dirty #4
[   87.219306] Hardware name: Huawei TaiShan 2280 V2/BC82AMDA, BIOS TA BIOS 2280-A CS V2.B160.01 01/15/2020
[   87.238292] Call trace:
[   87.243173]  dump_backtrace+0x0/0x280
[   87.250491]  show_stack+0x24/0x30
[   87.257114]  dump_stack+0xe8/0x140
[   87.263911]  print_address_description.isra.8+0x70/0x380
[   87.274538]  __kasan_report+0x12c/0x230
[   87.282203]  kasan_report+0xc/0x18
[   87.288999]  __asan_load1+0x60/0x68
[   87.295969]  hex_dump_to_buffer+0x140/0x608
[   87.304332]  print_hex_dump+0x140/0x1e0
[   87.312000]  hns3_lb_check_skb_data+0x168/0x170
[   87.321060]  hns3_clean_rx_ring+0xa94/0xfe0
[   87.329422]  hns3_self_test+0x708/0x8c0

The length of packet sent by the selftest process is only
128 + 14 bytes, and the min buffer size of a BD is 256 bytes,
and the receive process will make sure the packet sent by
the selftest process is in the linear part, so only check
the linear part in hns3_lb_check_skb_data().

So fix this use-after-free by using skb_headlen() to dump
skb->data instead of skb->len.

Fixes: c39c4d98dc65 ("net: hns3: Add mac loopback selftest support in hns3 driver")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 52c9d204fe3d9..34e5448d59f6f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -174,18 +174,21 @@ static void hns3_lb_check_skb_data(struct hns3_enet_ring *ring,
 {
 	struct hns3_enet_tqp_vector *tqp_vector = ring->tqp_vector;
 	unsigned char *packet = skb->data;
+	u32 len = skb_headlen(skb);
 	u32 i;
 
-	for (i = 0; i < skb->len; i++)
+	len = min_t(u32, len, HNS3_NIC_LB_TEST_PACKET_SIZE);
+
+	for (i = 0; i < len; i++)
 		if (packet[i] != (unsigned char)(i & 0xff))
 			break;
 
 	/* The packet is correctly received */
-	if (i == skb->len)
+	if (i == HNS3_NIC_LB_TEST_PACKET_SIZE)
 		tqp_vector->rx_group.total_packets++;
 	else
 		print_hex_dump(KERN_ERR, "selftest:", DUMP_PREFIX_OFFSET, 16, 1,
-			       skb->data, skb->len, true);
+			       skb->data, len, true);
 
 	dev_kfree_skb_any(skb);
 }
-- 
2.25.1



