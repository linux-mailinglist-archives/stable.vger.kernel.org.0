Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52612A8F18
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 06:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgKFFyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Nov 2020 00:54:53 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:40074 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726260AbgKFFyx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Nov 2020 00:54:53 -0500
X-UUID: 50d5a11850aa4c6fb9ed9d3c0ef08991-20201106
X-UUID: 50d5a11850aa4c6fb9ed9d3c0ef08991-20201106
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 742032322; Fri, 06 Nov 2020 13:54:46 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 6 Nov 2020 13:54:43 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 6 Nov 2020 13:54:41 +0800
From:   Macpaul Lin <macpaul.lin@mediatek.com>
To:     Alan Stern <stern@rowland.harvard.edu>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>
CC:     Ainge Hsu <ainge.hsu@mediatek.com>,
        Eddie Hung <eddie.hung@mediatek.com>,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Macpaul Lin <macpaul@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
        <stable@vger.kernel.org>
Subject: [RESEND PATCH v4] usb: mtu3: fix panic in mtu3_gadget_stop()
Date:   Fri, 6 Nov 2020 13:54:29 +0800
Message-ID: <1604642069-20961-1-git-send-email-macpaul.lin@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1598539328-1976-1-git-send-email-macpaul.lin@mediatek.com>
References: <1598539328-1976-1-git-send-email-macpaul.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 39034FCC61EDF9B6A654BEEF06F6764DB605319D12BBEBE5EA98C7A01A428BEF2000:8
X-MTK:  N
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
RESEND for v4:
  - Resend this patch by plain-text instead of MTK IT's default (base64)
    outgoing SMTP settings.
  - Add Acked-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Changes for v4:
  - Add a "Fixes:" line.  Thanks Felipe.
Changes for v3:
  - Call synchronize_irq() in mtu3_gadget_stop() instead of remembering
    callback function in mtu3_gadget_disconnect().
    Thanks for Alan's suggestion.
Changes for v2:
  - Check mtu_gadget_driver out of spin_lock might still not work.
    We use a temporary pointer to remember the callback function.

 drivers/usb/mtu3/mtu3_gadget.c |    1 +
 1 file changed, 1 insertions(+)

diff --git a/drivers/usb/mtu3/mtu3_gadget.c b/drivers/usb/mtu3/mtu3_gadget.c
index 1de5c9a..1ab3d3a 100644
--- a/drivers/usb/mtu3/mtu3_gadget.c
+++ b/drivers/usb/mtu3/mtu3_gadget.c
@@ -564,6 +564,7 @@ static int mtu3_gadget_stop(struct usb_gadget *g)
 
 	spin_unlock_irqrestore(&mtu->lock, flags);
 
+	synchronize_irq(mtu->irq);
 	return 0;
 }
 
-- 
1.7.9.5

