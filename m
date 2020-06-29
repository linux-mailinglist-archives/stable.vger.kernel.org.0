Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C5320DA96
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732253AbgF2T6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:58:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387598AbgF2TkS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 195D22481D;
        Mon, 29 Jun 2020 15:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444338;
        bh=w6apJk8AfKAn6zaaO5RkNTDJ2S+KinzX00mJQQ4CrxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GwBEgawYLlSxIR59SIGFf1XtWY+CRaW3aQUKYVcZnNprG4TK9Ye8aQgsTqOgdNsaG
         OLMWdsCU+G1KRNLX0SePI2QNIhCVTFvFoMKToquT1HKmHK7zoHFvHUJQAiBX69KYOf
         s8d5oEvd6p11/nl5L3n0Cwrz5LGrWkMm+OynJ8HY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeremy Kerr <jk@ozlabs.org>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 013/178] net: usb: ax88179_178a: fix packet alignment padding
Date:   Mon, 29 Jun 2020 11:22:38 -0400
Message-Id: <20200629152523.2494198-14-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Kerr <jk@ozlabs.org>

[ Upstream commit e869e7a17798d85829fa7d4f9bbe1eebd4b2d3f6 ]

Using a AX88179 device (0b95:1790), I see two bytes of appended data on
every RX packet. For example, this 48-byte ping, using 0xff as a
payload byte:

  04:20:22.528472 IP 192.168.1.1 > 192.168.1.2: ICMP echo request, id 2447, seq 1, length 64
	0x0000:  000a cd35 ea50 000a cd35 ea4f 0800 4500
	0x0010:  0054 c116 4000 4001 f63e c0a8 0101 c0a8
	0x0020:  0102 0800 b633 098f 0001 87ea cd5e 0000
	0x0030:  0000 dcf2 0600 0000 0000 ffff ffff ffff
	0x0040:  ffff ffff ffff ffff ffff ffff ffff ffff
	0x0050:  ffff ffff ffff ffff ffff ffff ffff ffff
	0x0060:  ffff 961f

Those last two bytes - 96 1f - aren't part of the original packet.

In the ax88179 RX path, the usbnet rx_fixup function trims a 2-byte
'alignment pseudo header' from the start of the packet, and sets the
length from a per-packet field populated by hardware. It looks like that
length field *includes* the 2-byte header; the current driver assumes
that it's excluded.

This change trims the 2-byte alignment header after we've set the packet
length, so the resulting packet length is correct. While we're moving
the comment around, this also fixes the spelling of 'pseudo'.

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ax88179_178a.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index daa54486ab094..df2f7cc6dc03a 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1387,10 +1387,10 @@ static int ax88179_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		}
 
 		if (pkt_cnt == 0) {
-			/* Skip IP alignment psudo header */
-			skb_pull(skb, 2);
 			skb->len = pkt_len;
-			skb_set_tail_pointer(skb, pkt_len);
+			/* Skip IP alignment pseudo header */
+			skb_pull(skb, 2);
+			skb_set_tail_pointer(skb, skb->len);
 			skb->truesize = pkt_len + sizeof(struct sk_buff);
 			ax88179_rx_checksum(skb, pkt_hdr);
 			return 1;
@@ -1399,8 +1399,9 @@ static int ax88179_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		ax_skb = skb_clone(skb, GFP_ATOMIC);
 		if (ax_skb) {
 			ax_skb->len = pkt_len;
-			ax_skb->data = skb->data + 2;
-			skb_set_tail_pointer(ax_skb, pkt_len);
+			/* Skip IP alignment pseudo header */
+			skb_pull(ax_skb, 2);
+			skb_set_tail_pointer(ax_skb, ax_skb->len);
 			ax_skb->truesize = pkt_len + sizeof(struct sk_buff);
 			ax88179_rx_checksum(ax_skb, pkt_hdr);
 			usbnet_skb_return(dev, ax_skb);
-- 
2.25.1

