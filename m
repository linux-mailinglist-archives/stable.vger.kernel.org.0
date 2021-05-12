Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9747F37C6A2
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234959AbhELPwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:52:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237278AbhELPtA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:49:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11B73619C3;
        Wed, 12 May 2021 15:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833103;
        bh=u0+drFlL5SR+U3f8e1NzS7+1i28uq2XpJdaKsNVA7YI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QMtO/xv6AW/r1aATEzguDs+uDItZgHkWZbnjBGCQPWWXm992YE5Xoa2ubyvWysOjg
         VaYq5RGWE9yRSH1VGqoC6vVIVro6Or/GHCtCqbWWoaN+9TSir0WMGFsOwgziHypSPz
         TZzmo1fpVxW5L6bwLhkYj5l6rf8ColV/HjalwoFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 5.11 019/601] usb: xhci-mtk: remove or operator for setting schedule parameters
Date:   Wed, 12 May 2021 16:41:36 +0200
Message-Id: <20210512144828.456601269@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

commit 5fa5827566e3affa1657ccf9b22706c06a5d021a upstream.

Side effect may happen if use or operator to set schedule parameters
when the parameters are already set before. Set them directly due to
other bits are reserved.

Fixes: 54f6a8af3722 ("usb: xhci-mtk: skip dropping bandwidth of unchecked endpoints")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/d287899e6beb2fc1bfb8900c75a872f628ecde55.1615170625.git.chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mtk-sch.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/xhci-mtk-sch.c
+++ b/drivers/usb/host/xhci-mtk-sch.c
@@ -643,7 +643,7 @@ int xhci_mtk_add_ep_quirk(struct usb_hcd
 		 */
 		if (usb_endpoint_xfer_int(&ep->desc)
 			|| usb_endpoint_xfer_isoc(&ep->desc))
-			ep_ctx->reserved[0] |= cpu_to_le32(EP_BPKTS(1));
+			ep_ctx->reserved[0] = cpu_to_le32(EP_BPKTS(1));
 
 		return 0;
 	}
@@ -730,10 +730,10 @@ int xhci_mtk_check_bandwidth(struct usb_
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


