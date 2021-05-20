Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711B938A3A4
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbhETJz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:55:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234466AbhETJwq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:52:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E09DE61601;
        Thu, 20 May 2021 09:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503376;
        bh=pIdcIqEUIRduHdoT43B04D5dv8gNxed6rqYGRPiCl0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ymfcsFs2poHsQQfxYnOrCQgiAVT8g7Jhx3/hE3STeYwqeb/YyBJnxU1ARb1lJWeRu
         F+4xSJB+IxLy7WdJcSZpFO0GnbFowOuHfqH6i8+pM0ne1EB6ZPSrZVvhqKY7f0Jtnk
         ijl3I+zt5Mg6daZoqmaemPLsPz6yBDZq0mrusyQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Tao Ren <rentao.bupt@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 194/425] usb: gadget: aspeed: fix dma map failure
Date:   Thu, 20 May 2021 11:19:23 +0200
Message-Id: <20210520092137.796753364@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tao Ren <rentao.bupt@gmail.com>

[ Upstream commit bd4d607044b961cecbf8c4c2f3bb5da4fb156993 ]

Currently the virtual port_dev device is passed to DMA API, and this is
wrong because the device passed to DMA API calls must be the actual
hardware device performing the DMA.

The patch replaces usb_gadget_map_request/usb_gadget_unmap_request APIs
with usb_gadget_map_request_by_dev/usb_gadget_unmap_request_by_dev APIs
so the DMA capable platform device can be passed to the DMA APIs.

The patch fixes below backtrace detected on Facebook AST2500 OpenBMC
platforms:

[<80106550>] show_stack+0x20/0x24
[<80106868>] dump_stack+0x28/0x30
[<80823540>] __warn+0xfc/0x110
[<8011ac30>] warn_slowpath_fmt+0xb0/0xc0
[<8011ad44>] dma_map_page_attrs+0x24c/0x314
[<8016a27c>] usb_gadget_map_request_by_dev+0x100/0x1e4
[<805cedd8>] usb_gadget_map_request+0x1c/0x20
[<805cefbc>] ast_vhub_epn_queue+0xa0/0x1d8
[<7f02f710>] usb_ep_queue+0x48/0xc4
[<805cd3e8>] ecm_do_notify+0xf8/0x248
[<7f145920>] ecm_set_alt+0xc8/0x1d0
[<7f145c34>] composite_setup+0x680/0x1d30
[<7f00deb8>] ast_vhub_ep0_handle_setup+0xa4/0x1bc
[<7f02ee94>] ast_vhub_dev_irq+0x58/0x84
[<7f0309e0>] ast_vhub_irq+0xb0/0x1c8
[<7f02e118>] __handle_irq_event_percpu+0x50/0x19c
[<8015e5bc>] handle_irq_event_percpu+0x38/0x8c
[<8015e758>] handle_irq_event+0x38/0x4c

Fixes: 7ecca2a4080c ("usb/gadget: Add driver for Aspeed SoC virtual hub")
Reviewed-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Tao Ren <rentao.bupt@gmail.com>
Link: https://lore.kernel.org/r/20210331045831.28700-1-rentao.bupt@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/aspeed-vhub/core.c | 3 ++-
 drivers/usb/gadget/udc/aspeed-vhub/epn.c  | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/udc/aspeed-vhub/core.c b/drivers/usb/gadget/udc/aspeed-vhub/core.c
index db3628be38c0..902e61be4d64 100644
--- a/drivers/usb/gadget/udc/aspeed-vhub/core.c
+++ b/drivers/usb/gadget/udc/aspeed-vhub/core.c
@@ -36,6 +36,7 @@ void ast_vhub_done(struct ast_vhub_ep *ep, struct ast_vhub_req *req,
 		   int status)
 {
 	bool internal = req->internal;
+	struct ast_vhub *vhub = ep->vhub;
 
 	EPVDBG(ep, "completing request @%p, status %d\n", req, status);
 
@@ -46,7 +47,7 @@ void ast_vhub_done(struct ast_vhub_ep *ep, struct ast_vhub_req *req,
 
 	if (req->req.dma) {
 		if (!WARN_ON(!ep->dev))
-			usb_gadget_unmap_request(&ep->dev->gadget,
+			usb_gadget_unmap_request_by_dev(&vhub->pdev->dev,
 						 &req->req, ep->epn.is_in);
 		req->req.dma = 0;
 	}
diff --git a/drivers/usb/gadget/udc/aspeed-vhub/epn.c b/drivers/usb/gadget/udc/aspeed-vhub/epn.c
index ae853cf36966..931f540a747e 100644
--- a/drivers/usb/gadget/udc/aspeed-vhub/epn.c
+++ b/drivers/usb/gadget/udc/aspeed-vhub/epn.c
@@ -376,7 +376,7 @@ static int ast_vhub_epn_queue(struct usb_ep* u_ep, struct usb_request *u_req,
 	if (ep->epn.desc_mode ||
 	    ((((unsigned long)u_req->buf & 7) == 0) &&
 	     (ep->epn.is_in || !(u_req->length & (u_ep->maxpacket - 1))))) {
-		rc = usb_gadget_map_request(&ep->dev->gadget, u_req,
+		rc = usb_gadget_map_request_by_dev(&vhub->pdev->dev, u_req,
 					    ep->epn.is_in);
 		if (rc) {
 			dev_warn(&vhub->pdev->dev,
-- 
2.30.2



