Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195FE49A98E
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349888AbiAYDXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:23:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60884 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387300AbiAXUgp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:36:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9962361535;
        Mon, 24 Jan 2022 20:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E593C340E5;
        Mon, 24 Jan 2022 20:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056604;
        bh=3qRhBNKvmScCvIXd2l25/NHmnMaxhw46rXHT+wEJ4FI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=03FZaYNnx/ws72i2VEhRnqhbO6BjBdwrj2pOREZLW4Ph/68Pp6o5xEJE4+Bb9qJV4
         8wTUi77MhHtrgr2kkulYIjjCah6/t28EcYUshgkMzWpFaRfh0pONWmZVGAzqM4JXcQ
         AAexJQdFMK6As+2zCMPn3yD2EkebW+e6TwvHn32w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brendan Dolan-Gavitt <brendandg@nyu.edu>,
        Zekun Shen <bruceshenzk@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 506/846] rsi: Fix use-after-free in rsi_rx_done_handler()
Date:   Mon, 24 Jan 2022 19:40:23 +0100
Message-Id: <20220124184118.485199605@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zekun Shen <bruceshenzk@gmail.com>

[ Upstream commit b07e3c6ebc0c20c772c0f54042e430acec2945c3 ]

When freeing rx_cb->rx_skb, the pointer is not set to NULL,
a later rsi_rx_done_handler call will try to read the freed
address.
This bug will very likley lead to double free, although
detected early as use-after-free bug.

The bug is triggerable with a compromised/malfunctional usb
device. After applying the patch, the same input no longer
triggers the use-after-free.

Attached is the kasan report from fuzzing.

BUG: KASAN: use-after-free in rsi_rx_done_handler+0x354/0x430 [rsi_usb]
Read of size 4 at addr ffff8880188e5930 by task modprobe/231
Call Trace:
 <IRQ>
 dump_stack+0x76/0xa0
 print_address_description.constprop.0+0x16/0x200
 ? rsi_rx_done_handler+0x354/0x430 [rsi_usb]
 ? rsi_rx_done_handler+0x354/0x430 [rsi_usb]
 __kasan_report.cold+0x37/0x7c
 ? dma_direct_unmap_page+0x90/0x110
 ? rsi_rx_done_handler+0x354/0x430 [rsi_usb]
 kasan_report+0xe/0x20
 rsi_rx_done_handler+0x354/0x430 [rsi_usb]
 __usb_hcd_giveback_urb+0x1e4/0x380
 usb_giveback_urb_bh+0x241/0x4f0
 ? __usb_hcd_giveback_urb+0x380/0x380
 ? apic_timer_interrupt+0xa/0x20
 tasklet_action_common.isra.0+0x135/0x330
 __do_softirq+0x18c/0x634
 ? handle_irq_event+0xcd/0x157
 ? handle_edge_irq+0x1eb/0x7b0
 irq_exit+0x114/0x140
 do_IRQ+0x91/0x1e0
 common_interrupt+0xf/0xf
 </IRQ>

Reported-by: Brendan Dolan-Gavitt <brendandg@nyu.edu>
Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/YXxQL/vIiYcZUu/j@10-18-43-117.dynapool.wireless.nyu.edu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 6821ea9918956..3cca1823c458a 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -269,8 +269,12 @@ static void rsi_rx_done_handler(struct urb *urb)
 	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)rx_cb->data;
 	int status = -EINVAL;
 
+	if (!rx_cb->rx_skb)
+		return;
+
 	if (urb->status) {
 		dev_kfree_skb(rx_cb->rx_skb);
+		rx_cb->rx_skb = NULL;
 		return;
 	}
 
@@ -294,8 +298,10 @@ out:
 	if (rsi_rx_urb_submit(dev->priv, rx_cb->ep_num, GFP_ATOMIC))
 		rsi_dbg(ERR_ZONE, "%s: Failed in urb submission", __func__);
 
-	if (status)
+	if (status) {
 		dev_kfree_skb(rx_cb->rx_skb);
+		rx_cb->rx_skb = NULL;
+	}
 }
 
 static void rsi_rx_urb_kill(struct rsi_hw *adapter, u8 ep_num)
-- 
2.34.1



