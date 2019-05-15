Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C89E41F3CE
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbfEOLAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:00:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727423AbfEOLA2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:00:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C790F2173C;
        Wed, 15 May 2019 11:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918027;
        bh=8h2+eYVUnwyN4zDs1fgarkI9kYsmPRaRdslM8QT/jos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q+6qT4ifrae2jSw/+nlSqBmycaLP1NGKdaGRFZLS8zTxcmED0QvJxxrPaq3tcBI5D
         jZ07NnD8PilBP06xUbJb5Ocbs1F8+wEjgFCl46I7HYXTYxfRyp2P3Y1nsiNvVSdmW6
         mFWydShBAs8lBMz75erA8jM0c8RfYtQibxYbh2z8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Guido Kiener <guido.kiener@rohde-schwarz.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 3.18 15/86] usb: gadget: net2280: Fix overrun of OUT messages
Date:   Wed, 15 May 2019 12:54:52 +0200
Message-Id: <20190515090645.715262232@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090642.339346723@linuxfoundation.org>
References: <20190515090642.339346723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9d6a54c1430647355a5e23434881b2ca3d192b48 ]

The OUT endpoint normally blocks (NAK) subsequent packets when a
short packet was received and returns an incomplete queue entry to
the gadget driver. Thereby the gadget driver can detect a short packet
when reading queue entries with a length that is not equal to a
multiple of packet size.

The start_queue() function enables receiving OUT packets regardless of
the content of the OUT FIFO. This results in a race: With the current
code, it's possible that the "!ep->is_in && (readl(&ep->regs->ep_stat)
& BIT(NAK_OUT_PACKETS))" test in start_dma() will fail, then a short
packet will be received, and then start_queue() will call
stop_out_naking(). That's what we don't want (OUT naking gets turned
off while there is data in the FIFO) because then the next driver
request might receive a mixture of old and new packets.

With the patch, this race can't occur because the FIFO's state is
tested after we know that OUT naking is already turned on, and OUT
naking is stopped only when both of the conditions are met.  This
ensures that all received data is delivered to the gadget driver,
which can detect a short packet now before new packets are appended
to the last short packet.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Guido Kiener <guido.kiener@rohde-schwarz.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/usb/gadget/udc/net2280.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/udc/net2280.c b/drivers/usb/gadget/udc/net2280.c
index 8d13337e2dde..931765208286 100644
--- a/drivers/usb/gadget/udc/net2280.c
+++ b/drivers/usb/gadget/udc/net2280.c
@@ -800,9 +800,6 @@ static void start_queue(struct net2280_ep *ep, u32 dmactl, u32 td_dma)
 	(void) readl(&ep->dev->pci->pcimstctl);
 
 	writel(BIT(DMA_START), &dma->dmastat);
-
-	if (!ep->is_in)
-		stop_out_naking(ep);
 }
 
 static void start_dma(struct net2280_ep *ep, struct net2280_request *req)
@@ -841,6 +838,7 @@ static void start_dma(struct net2280_ep *ep, struct net2280_request *req)
 			writel(BIT(DMA_START), &dma->dmastat);
 			return;
 		}
+		stop_out_naking(ep);
 	}
 
 	tmp = dmactl_default;
-- 
2.19.1



