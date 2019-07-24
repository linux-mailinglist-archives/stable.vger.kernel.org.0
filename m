Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73F1273F3D
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387870AbfGXTa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:30:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388313AbfGXTaZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:30:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F79122ADA;
        Wed, 24 Jul 2019 19:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996624;
        bh=Dtick/1/1iMuvyDoKWd6sv+u6OqzDl5t9BHNS5KFBTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LWsJYGqn9J7srGExVI+xCkyiyT2P1HsumtdEq47PDSlMOdcuDibZijW/HBm54N0dA
         PCCbxrIxJzKhUHCwUFfqivJBaGfCpmjfSB3MuHmxQsQIS9J66a6UTwznJt7DtCc5S9
         xORmTukWNr7mR01PkWgJC495u3FrSTOF6ut1K0ak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 159/413] mt76: mt7615: do not process rx packets if the device is not initialized
Date:   Wed, 24 Jul 2019 21:17:30 +0200
Message-Id: <20190724191746.466298707@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2dcb79cde6129d948a237ef7b48a73a0c82f1e01 ]

Fix following crash that occurs when the driver is processing rx packets
while the device is not initialized yet

$ rmmod mt7615e
[   67.210261] mt7615e 0000:01:00.0: Message -239 (seq 2) timeout
$ modprobe mt7615e
[   72.406937] bus=0x1, slot = 0x0, irq=0x16
[   72.436590] CPU 0 Unable to handle kernel paging request at virtual address 00000004, epc == 8eec4240, ra == 8eec41e0
[   72.450291] mt7615e 0000:01:00.0: Firmware is not ready for download
[   72.457724] Oops[#1]:
[   72.470494] mt7615e: probe of 0000:01:00.0 failed with error -5
[   72.474829] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.14.114 #0
[   72.498702] task: 805769e0 task.stack: 80564000
[   72.507709] $ 0   : 00000000 00000001 00000000 00000001
[   72.518106] $ 4   : 8f704dbc 00000000 00000000 8f7046c0
[   72.528500] $ 8   : 00000024 8045e98c 81210008 11000000
[   72.538895] $12   : 8fc09f60 00000008 00000019 00000033
[   72.549289] $16   : 8f704d80 e00000ff 8f0c7800 3c182406
[   72.559684] $20   : 00000006 8ee615a0 4e000108 00000000
[   72.570078] $24   : 0000004c 8000cf94
[   72.580474] $28   : 80564000 8fc09e38 00000001 8eec41e0
[   72.590869] Hi    : 00000001
[   72.596582] Lo    : 00000000
[   72.602319] epc   : 8eec4240 mt7615_mac_fill_rx+0xac/0x494 [mt7615e]
[   72.614953] ra    : 8eec41e0 mt7615_mac_fill_rx+0x4c/0x494 [mt7615e]
[   72.627580] Status: 11008403 KERNEL EXL IE
[   72.635899] Cause : 40800008 (ExcCode 02)
[   72.643860] BadVA : 00000004
[   72.649573] PrId  : 0001992f (MIPS 1004Kc)
[   72.657704] Modules linked in: mt7615e pppoe ppp_async pppox ppp_generic nf_conntrack_ipv6 mt76x2e mt76x2_common mt76x02_lib mt7603e mt76 mac80211 iptable_nat ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_mu]
[   72.792717] Process swapper/0 (pid: 0, threadinfo=80564000, task=805769e0, tls=00000000)
[   72.808799] Stack : 8f0c7800 00000800 8f0c7800 8032b874 00000000 40000000 8f704d80 8ee615a0
[   72.825428]         8dc88010 00000001 8ee615e0 8eec09b0 8dc88010 8032b914 8f3aee80 80567d20
[   72.842055]         00000000 8ee615e0 40000000 8f0c7800 00000108 8eec9944 00000000 00000000
[   72.858682]         80508f10 80510000 00000001 80567d20 8ee615a0 00000000 00000000 8ee61c00
[   72.875308]         8ee61c40 00000040 80610000 80580000 00000000 8ee615dc 8ee61a68 00000001
[   72.891936]         ...
[   72.896793] Call Trace:
[   72.901649] [<8eec4240>] mt7615_mac_fill_rx+0xac/0x494 [mt7615e]
[   72.913602] [<8eec09b0>] mt7615_queue_rx_skb+0xe4/0x12c [mt7615e]
[   72.925734] [<8eec9944>] mt76_dma_cleanup+0x390/0x42c [mt76]
[   72.936988] Code: ae020018  8ea20004  24030001 <94420004> a602002a  8ea20004  90420000  14430003  a2020034
[   72.956390]
[   72.959676] ---[ end trace f176967739edb19f ]---

Fixes: 04b8e65922f6 ("mt76: add mac80211 driver for MT7615 PCIe-based chipsets")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index b8f48d10f27a..a27bc6791aa7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -96,6 +96,9 @@ int mt7615_mac_fill_rx(struct mt7615_dev *dev, struct sk_buff *skb)
 	bool unicast, remove_pad, insert_ccmp_hdr = false;
 	int i, idx;
 
+	if (!test_bit(MT76_STATE_RUNNING, &dev->mt76.state))
+		return -EINVAL;
+
 	memset(status, 0, sizeof(*status));
 
 	unicast = (rxd1 & MT_RXD1_NORMAL_ADDR_TYPE) == MT_RXD1_NORMAL_U2M;
-- 
2.20.1



