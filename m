Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25ABC38AB0E
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239618AbhETLUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:20:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240174AbhETLSE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:18:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1A05613DE;
        Thu, 20 May 2021 10:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505395;
        bh=j8tFkUalTSrNyBkFIfYGnN44fW6MIQg7uDgQV/KITSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OnfjW3zcX+0FZAtqjZworIIBzGArpRX9VpWXrgXEKYVTR1QjF1lqR8p9Gn3YCXXty
         ekka81E9RL1eT6CMpwHBIiGjeWkHDhyZNalXqesu4w1odI6r3nEoSCL9qUlGGSOwEU
         J2ES8d0RTNQayDwWQ0Nds17KFt5eKlmcGS1dgDeQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 081/190] usb: gadget: pch_udc: Check for DMA mapping error
Date:   Thu, 20 May 2021 11:22:25 +0200
Message-Id: <20210520092104.877298249@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 4a28d77e359009b846951b06f7c0d8eec8dce298 ]

DMA mapping might fail, we have to check it with dma_mapping_error().
Otherwise DMA-API is not happy:

  DMA-API: pch_udc 0000:02:02.4: device driver failed to check map error[device address=0x00000000027ee678] [size=64 bytes] [mapped as single]

Fixes: abab0c67c061 ("usb: pch_udc: Fixed issue which does not work with g_serial")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210323153626.54908-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/pch_udc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/pch_udc.c b/drivers/usb/gadget/udc/pch_udc.c
index 152c2ee0ca50..5301de1c5d31 100644
--- a/drivers/usb/gadget/udc/pch_udc.c
+++ b/drivers/usb/gadget/udc/pch_udc.c
@@ -3003,7 +3003,7 @@ static int init_dma_pools(struct pch_udc_dev *dev)
 	dev->dma_addr = dma_map_single(&dev->pdev->dev, dev->ep0out_buf,
 				       UDC_EP0OUT_BUFF_SIZE * 4,
 				       DMA_FROM_DEVICE);
-	return 0;
+	return dma_mapping_error(&dev->pdev->dev, dev->dma_addr);
 }
 
 static int pch_udc_start(struct usb_gadget *g,
-- 
2.30.2



