Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0393138314B
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239866AbhEQOgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:36:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:43850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240308AbhEQOdw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:33:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 851786191F;
        Mon, 17 May 2021 14:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260990;
        bh=YJbURjksO0jdbLJvRyfqdFJ0W2nk8ljx8q+OLPu88rU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=toGe3JIOIYbTCHyhj9PH1yDXJ4aLByCcE54Q/Ih5kbM3jYzH1OxM5hY20W89ULmsM
         RDcfc7v82znjTFS9qI+aajI4DKK65rE3H/WZxr445pMDNzmYOjaWIrsGOQPs44mkvG
         /yX3ZLVmvrv8iz9GJajtEmdM8RCbLiH41Au9V4FM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@kernel.org>,
        Jack Pham <jackp@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 285/363] usb: dwc3: gadget: Free gadget structure only after freeing endpoints
Date:   Mon, 17 May 2021 16:02:31 +0200
Message-Id: <20210517140312.241588347@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Pham <jackp@codeaurora.org>

[ Upstream commit bb9c74a5bd1462499fe5ccb1e3c5ac40dcfa9139 ]

As part of commit e81a7018d93a ("usb: dwc3: allocate gadget structure
dynamically") the dwc3_gadget_release() was added which will free
the dwc->gadget structure upon the device's removal when
usb_del_gadget_udc() is called in dwc3_gadget_exit().

However, simply freeing the gadget results a dangling pointer
situation: the endpoints created in dwc3_gadget_init_endpoints()
have their dep->endpoint.ep_list members chained off the list_head
anchored at dwc->gadget->ep_list.  Thus when dwc->gadget is freed,
the first dwc3_ep in the list now has a dangling prev pointer and
likewise for the next pointer of the dwc3_ep at the tail of the list.
The dwc3_gadget_free_endpoints() that follows will result in a
use-after-free when it calls list_del().

This was caught by enabling KASAN and performing a driver unbind.
The recent commit 568262bf5492 ("usb: dwc3: core: Add shutdown
callback for dwc3") also exposes this as a panic during shutdown.

There are a few possibilities to fix this.  One could be to perform
a list_del() of the gadget->ep_list itself which removes it from
the rest of the dwc3_ep chain.

Another approach is what this patch does, by splitting up the
usb_del_gadget_udc() call into its separate "del" and "put"
components.  This allows dwc3_gadget_free_endpoints() to be
called before the gadget is finally freed with usb_put_gadget().

Fixes: e81a7018d93a ("usb: dwc3: allocate gadget structure dynamically")
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Jack Pham <jackp@codeaurora.org>
Link: https://lore.kernel.org/r/20210501093558.7375-1-jackp@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index f85eda6bc988..5fd27160c336 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -4024,8 +4024,9 @@ int dwc3_gadget_init(struct dwc3 *dwc)
 
 void dwc3_gadget_exit(struct dwc3 *dwc)
 {
-	usb_del_gadget_udc(dwc->gadget);
+	usb_del_gadget(dwc->gadget);
 	dwc3_gadget_free_endpoints(dwc);
+	usb_put_gadget(dwc->gadget);
 	dma_free_coherent(dwc->sysdev, DWC3_BOUNCE_SIZE, dwc->bounce,
 			  dwc->bounce_addr);
 	kfree(dwc->setup_buf);
-- 
2.30.2



