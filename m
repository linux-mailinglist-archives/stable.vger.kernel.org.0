Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E77E38A8E4
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238505AbhETKzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239164AbhETKwX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:52:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC465617ED;
        Thu, 20 May 2021 10:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504822;
        bh=lKoKTgKtr5NCHeERk3WhuHy3SPTHX5GdrDmN1V3qPWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sbd+2DvuVVvTiCeZPYKKmGw+RggrDQ6otfRpFywl6FUi00MTbbXY/3qgnCF8Folfc
         +7Z0QNvEzZukwsERe2cEfOkLVB6rgl+ecgvBeUxrzqYJrdj5jz7wJNEmswy7WdInHA
         A8cYL5quIqdWX6MxP8+yKvoqranAz15OSK+LWQQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 096/240] usb: gadget: pch_udc: Replace cpu_to_le32() by lower_32_bits()
Date:   Thu, 20 May 2021 11:21:28 +0200
Message-Id: <20210520092111.912562822@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 91356fed6afd1c83bf0d3df1fc336d54e38f0458 ]

Either way ~0 will be in the correct byte order, hence
replace cpu_to_le32() by lower_32_bits(). Moreover,
it makes sparse happy, otherwise it complains:

.../pch_udc.c:1813:27: warning: incorrect type in assignment (different base types)
.../pch_udc.c:1813:27:    expected unsigned int [usertype] dataptr
.../pch_udc.c:1813:27:    got restricted __le32 [usertype]

Fixes: f646cf94520e ("USB device driver of Topcliff PCH")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210323153626.54908-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/pch_udc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/pch_udc.c b/drivers/usb/gadget/udc/pch_udc.c
index fe0887578117..b143830285f6 100644
--- a/drivers/usb/gadget/udc/pch_udc.c
+++ b/drivers/usb/gadget/udc/pch_udc.c
@@ -1786,7 +1786,7 @@ static struct usb_request *pch_udc_alloc_request(struct usb_ep *usbep,
 	}
 	/* prevent from using desc. - set HOST BUSY */
 	dma_desc->status |= PCH_UDC_BS_HST_BSY;
-	dma_desc->dataptr = cpu_to_le32(DMA_ADDR_INVALID);
+	dma_desc->dataptr = lower_32_bits(DMA_ADDR_INVALID);
 	req->td_data = dma_desc;
 	req->td_data_last = dma_desc;
 	req->chain_len = 1;
-- 
2.30.2



