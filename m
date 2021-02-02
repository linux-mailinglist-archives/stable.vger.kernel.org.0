Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A0830C88B
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 18:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233998AbhBBRyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 12:54:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:49178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233973AbhBBOJi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:09:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25D0F6502F;
        Tue,  2 Feb 2021 13:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273836;
        bh=JpdlOipREusccAO2Fc5zQZ3djvUBfXcAP7LVC+6cwXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xDJDwtphRh3Rn6sXiF1vU6kYTEj5t6CXz21zdANE/oTS5txgVmzv+PctvEjkYVmhA
         IIB0NVNvhrDzgwTadlxX7so12AYM8UG+XL4O/9G23RMY1+L+aIzVJyz4gNojgb2Qbl
         LiU2MAT9ZfjSFnCTyPsewKmHOhX83CBc1p7+hbJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Jakub Kicinski <kubakici@wp.pl>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.9 19/32] mt7601u: fix kernel crash unplugging the device
Date:   Tue,  2 Feb 2021 14:38:42 +0100
Message-Id: <20210202132942.788675345@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.035179752@linuxfoundation.org>
References: <20210202132942.035179752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

commit 0acb20a5438c36e0cf2b8bf255f314b59fcca6ef upstream.

The following crash log can occur unplugging the usb dongle since,
after the urb poison in mt7601u_free_tx_queue(), usb_submit_urb() will
always fail resulting in a skb kfree while the skb has been already
queued.

Fix the issue enqueuing the skb only if usb_submit_urb() succeed.

Hardware name: Hewlett-Packard 500-539ng/2B2C, BIOS 80.06 04/01/2015
Workqueue: usb_hub_wq hub_event
RIP: 0010:skb_trim+0x2c/0x30
RSP: 0000:ffffb4c88005bba8 EFLAGS: 00010206
RAX: 000000004ad483ee RBX: ffff9a236625dee0 RCX: 000000000000662f
RDX: 000000000000000c RSI: 0000000000000000 RDI: ffff9a2343179300
RBP: ffff9a2343179300 R08: 0000000000000001 R09: 0000000000000000
R10: ffff9a23748f7840 R11: 0000000000000001 R12: ffff9a236625e4d4
R13: ffff9a236625dee0 R14: 0000000000001080 R15: 0000000000000008
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd410a34ef8 CR3: 00000001416ee001 CR4: 00000000001706f0
Call Trace:
 mt7601u_tx_status+0x3e/0xa0 [mt7601u]
 mt7601u_dma_cleanup+0xca/0x110 [mt7601u]
 mt7601u_cleanup+0x22/0x30 [mt7601u]
 mt7601u_disconnect+0x22/0x60 [mt7601u]
 usb_unbind_interface+0x8a/0x270
 ? kernfs_find_ns+0x35/0xd0
 __device_release_driver+0x17a/0x230
 device_release_driver+0x24/0x30
 bus_remove_device+0xdb/0x140
 device_del+0x18b/0x430
 ? kobject_put+0x98/0x1d0
 usb_disable_device+0xc6/0x1f0
 usb_disconnect.cold+0x7e/0x20a
 hub_event+0xbf3/0x1870
 process_one_work+0x1b6/0x350
 worker_thread+0x53/0x3e0
 ? process_one_work+0x350/0x350
 kthread+0x11b/0x140
 ? __kthread_bind_mask+0x60/0x60
 ret_from_fork+0x22/0x30

Fixes: 23377c200b2eb ("mt7601u: fix possible memory leak when the device is disconnected")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Acked-by: Jakub Kicinski <kubakici@wp.pl>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/3b85219f669a63a8ced1f43686de05915a580489.1610919247.git.lorenzo@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mediatek/mt7601u/dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt7601u/dma.c
+++ b/drivers/net/wireless/mediatek/mt7601u/dma.c
@@ -318,7 +318,6 @@ static int mt7601u_dma_submit_tx(struct
 	}
 
 	e = &q->e[q->end];
-	e->skb = skb;
 	usb_fill_bulk_urb(e->urb, usb_dev, snd_pipe, skb->data, skb->len,
 			  mt7601u_complete_tx, q);
 	ret = usb_submit_urb(e->urb, GFP_ATOMIC);
@@ -336,6 +335,7 @@ static int mt7601u_dma_submit_tx(struct
 
 	q->end = (q->end + 1) % q->entries;
 	q->used++;
+	e->skb = skb;
 
 	if (q->used >= q->entries)
 		ieee80211_stop_queue(dev->hw, skb_get_queue_mapping(skb));


