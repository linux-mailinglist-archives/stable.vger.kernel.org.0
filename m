Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FD833203F
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 09:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhCIIG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 03:06:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:36108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhCIIGb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Mar 2021 03:06:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F8D765228;
        Tue,  9 Mar 2021 08:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615277191;
        bh=lX4raUcXKug+BeYTdNomU2Wx4SEjVgBBSguss9HhV4M=;
        h=Subject:To:From:Date:From;
        b=gywiUFdMhamGVHaoqfzo1Yhq7pzXqRN4pEzEewCp34djK6VaHu0pL8cojbDYu/SVb
         7O1NfprVYp3E9QuM/dilE5z8WpnZG5WHUgdJtVvHbZWO+3fZcEdK+sllWoZxSAo1Qu
         LS25As3MPVYYprI3KqqULGNaxtH7NRUJuukyBcjE=
Subject: patch "usb: xhci-mtk: remove or operator for setting schedule parameters" added to usb-next
To:     chunfeng.yun@mediatek.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 09 Mar 2021 09:06:27 +0100
Message-ID: <16152771878204@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: xhci-mtk: remove or operator for setting schedule parameters

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From f6e1ab32bf6843c592ac6e241f89caf90b132b76 Mon Sep 17 00:00:00 2001
From: Chunfeng Yun <chunfeng.yun@mediatek.com>
Date: Mon, 8 Mar 2021 10:51:50 +0800
Subject: usb: xhci-mtk: remove or operator for setting schedule parameters

Side effect may happen if use or operator to set schedule parameters
when the parameters are already set before. Set them directly due to
other bits are reserved.

Fixes: 54f6a8af3722 ("usb: xhci-mtk: skip dropping bandwidth of unchecked endpoints")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/d287899e6beb2fc1bfb8900c75a872f628ecde55.1615170625.git.chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mtk-sch.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci-mtk-sch.c b/drivers/usb/host/xhci-mtk-sch.c
index b45e5bf08997..5891f56c64da 100644
--- a/drivers/usb/host/xhci-mtk-sch.c
+++ b/drivers/usb/host/xhci-mtk-sch.c
@@ -643,7 +643,7 @@ int xhci_mtk_add_ep_quirk(struct usb_hcd *hcd, struct usb_device *udev,
 		 */
 		if (usb_endpoint_xfer_int(&ep->desc)
 			|| usb_endpoint_xfer_isoc(&ep->desc))
-			ep_ctx->reserved[0] |= cpu_to_le32(EP_BPKTS(1));
+			ep_ctx->reserved[0] = cpu_to_le32(EP_BPKTS(1));
 
 		return 0;
 	}
@@ -730,10 +730,10 @@ int xhci_mtk_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
 		list_move_tail(&sch_ep->endpoint, &sch_bw->bw_ep_list);
 
 		ep_ctx = xhci_get_ep_ctx(xhci, virt_dev->in_ctx, ep_index);
-		ep_ctx->reserved[0] |= cpu_to_le32(EP_BPKTS(sch_ep->pkts)
+		ep_ctx->reserved[0] = cpu_to_le32(EP_BPKTS(sch_ep->pkts)
 			| EP_BCSCOUNT(sch_ep->cs_count)
 			| EP_BBM(sch_ep->burst_mode));
-		ep_ctx->reserved[1] |= cpu_to_le32(EP_BOFFSET(sch_ep->offset)
+		ep_ctx->reserved[1] = cpu_to_le32(EP_BOFFSET(sch_ep->offset)
 			| EP_BREPEAT(sch_ep->repeat));
 
 		xhci_dbg(xhci, " PKTS:%x, CSCOUNT:%x, BM:%x, OFFSET:%x, REPEAT:%x\n",
-- 
2.30.1


