Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 704BF6242E
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388504AbfGHP1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:27:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731675AbfGHP1I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:27:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58B192173E;
        Mon,  8 Jul 2019 15:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599627;
        bh=LpADHqXs6Y2jo3/LMrstxucMUzahlOU05lZHtleKCuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lH+0xO3Pb9vxjzcRlKq+UDscR/tT0VNV1VbhPr8ylgZUK+P0KuAC1EkgSNp+hELsi
         qFNyeGrq+QZc+iObR/Y61mhwc9XHPeiOdRFeuozbuNfWAHJcs1rXnoYitEglvmjcyq
         NIheZNWXbN4rJN+HYKBe4qx0JgbBsfOk0Eig7p98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sylvain Lemieux <slemieux.tyco@gmail.com>,
        James Grant <jamesg@zaltys.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 23/90] usb: gadget: udc: lpc32xx: allocate descriptor with GFP_ATOMIC
Date:   Mon,  8 Jul 2019 17:12:50 +0200
Message-Id: <20190708150523.803932293@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit fbc318afadd6e7ae2252d6158cf7d0c5a2132f7d ]

Gadget drivers may queue request in interrupt context. This would lead to
a descriptor allocation in that context. In that case we would hit
BUG_ON(in_interrupt()) in __get_vm_area_node.

Also remove the unnecessary cast.

Acked-by: Sylvain Lemieux <slemieux.tyco@gmail.com>
Tested-by: James Grant <jamesg@zaltys.org>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/lpc32xx_udc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/udc/lpc32xx_udc.c b/drivers/usb/gadget/udc/lpc32xx_udc.c
index b0781771704e..eafc2a00c96a 100644
--- a/drivers/usb/gadget/udc/lpc32xx_udc.c
+++ b/drivers/usb/gadget/udc/lpc32xx_udc.c
@@ -922,8 +922,7 @@ static struct lpc32xx_usbd_dd_gad *udc_dd_alloc(struct lpc32xx_udc *udc)
 	dma_addr_t			dma;
 	struct lpc32xx_usbd_dd_gad	*dd;
 
-	dd = (struct lpc32xx_usbd_dd_gad *) dma_pool_alloc(
-			udc->dd_cache, (GFP_KERNEL | GFP_DMA), &dma);
+	dd = dma_pool_alloc(udc->dd_cache, GFP_ATOMIC | GFP_DMA, &dma);
 	if (dd)
 		dd->this_dma = dma;
 
-- 
2.20.1



