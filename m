Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12C72ABBEB
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730776AbgKINc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:32:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:60332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731356AbgKINHa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:07:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A31B720789;
        Mon,  9 Nov 2020 13:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927250;
        bh=olIar1ovB4S5zgnoj94RxmBX8zIrmlgcSkMMshtvHyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ev2CcnNwFl4dkS+wB9UepG/pGQSx3rCOhHdJBOgBuqXj0wAN0dVsQZgWEwoU6kga
         Wj5GXp+HtsOSVwNT1tXt8j4/dYkIcraHe8LcKhRutso6zWPUB7klXfWGzsKAP0bS7L
         ejZ1bzZqMgs5k+I1VVPYCZH8QZpCc5W0aWGlQnLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Macpaul Lin <macpaul.lin@mediatek.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 4.14 44/48] usb: mtu3: fix panic in mtu3_gadget_stop()
Date:   Mon,  9 Nov 2020 13:55:53 +0100
Message-Id: <20201109125018.928083163@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125016.734107741@linuxfoundation.org>
References: <20201109125016.734107741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Macpaul Lin <macpaul.lin@mediatek.com>

commit 20914919ad31849ee2b9cfe0428f4a20335c9e2a upstream.

This patch fixes a possible issue when mtu3_gadget_stop()
already assigned NULL to mtu->gadget_driver during mtu_gadget_disconnect().

[<ffffff9008161974>] notifier_call_chain+0xa4/0x128
[<ffffff9008161fd4>] __atomic_notifier_call_chain+0x84/0x138
[<ffffff9008162ec0>] notify_die+0xb0/0x120
[<ffffff900809e340>] die+0x1f8/0x5d0
[<ffffff90080d03b4>] __do_kernel_fault+0x19c/0x280
[<ffffff90080d04dc>] do_bad_area+0x44/0x140
[<ffffff90080d0f9c>] do_translation_fault+0x4c/0x90
[<ffffff9008080a78>] do_mem_abort+0xb8/0x258
[<ffffff90080849d0>] el1_da+0x24/0x3c
[<ffffff9009bde01c>] mtu3_gadget_disconnect+0xac/0x128
[<ffffff9009bd576c>] mtu3_irq+0x34c/0xc18
[<ffffff90082ac03c>] __handle_irq_event_percpu+0x2ac/0xcd0
[<ffffff90082acae0>] handle_irq_event_percpu+0x80/0x138
[<ffffff90082acc44>] handle_irq_event+0xac/0x148
[<ffffff90082b71cc>] handle_fasteoi_irq+0x234/0x568
[<ffffff90082a8708>] generic_handle_irq+0x48/0x68
[<ffffff90082a96ac>] __handle_domain_irq+0x264/0x1740
[<ffffff90080819f4>] gic_handle_irq+0x14c/0x250
[<ffffff9008084cec>] el1_irq+0xec/0x194
[<ffffff90085b985c>] dma_pool_alloc+0x6e4/0xae0
[<ffffff9008d7f890>] cmdq_mbox_pool_alloc_impl+0xb0/0x238
[<ffffff9008d80904>] cmdq_pkt_alloc_buf+0x2dc/0x7c0
[<ffffff9008d80f60>] cmdq_pkt_add_cmd_buffer+0x178/0x270
[<ffffff9008d82320>] cmdq_pkt_perf_begin+0x108/0x148
[<ffffff9008d824d8>] cmdq_pkt_create+0x178/0x1f0
[<ffffff9008f96230>] mtk_crtc_config_default_path+0x328/0x7a0
[<ffffff90090246cc>] mtk_drm_idlemgr_kick+0xa6c/0x1460
[<ffffff9008f9bbb4>] mtk_drm_crtc_atomic_begin+0x1a4/0x1a68
[<ffffff9008e8df9c>] drm_atomic_helper_commit_planes+0x154/0x878
[<ffffff9008f2fb70>] mtk_atomic_complete.isra.16+0xe80/0x19c8
[<ffffff9008f30910>] mtk_atomic_commit+0x258/0x898
[<ffffff9008ef142c>] drm_atomic_commit+0xcc/0x108
[<ffffff9008ef7cf0>] drm_mode_atomic_ioctl+0x1c20/0x2580
[<ffffff9008ebc768>] drm_ioctl_kernel+0x118/0x1b0
[<ffffff9008ebcde8>] drm_ioctl+0x5c0/0x920
[<ffffff900863b030>] do_vfs_ioctl+0x188/0x1820
[<ffffff900863c754>] SyS_ioctl+0x8c/0xa0

Fixes: df2069acb005 ("usb: Add MediaTek USB3 DRD driver")
Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
Acked-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1604642069-20961-1-git-send-email-macpaul.lin@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/mtu3/mtu3_gadget.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/mtu3/mtu3_gadget.c
+++ b/drivers/usb/mtu3/mtu3_gadget.c
@@ -581,6 +581,7 @@ static int mtu3_gadget_stop(struct usb_g
 
 	spin_unlock_irqrestore(&mtu->lock, flags);
 
+	synchronize_irq(mtu->irq);
 	return 0;
 }
 


