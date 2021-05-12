Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D68737C818
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238422AbhELQEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:04:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:40540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235418AbhELP7w (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:59:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6108B61CC6;
        Wed, 12 May 2021 15:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833542;
        bh=W/KrvFtTsKzdSRtSo9b7lroA1iHtpS2iEEngG+L8HL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SSLCrt78if20vP6DNQzqmAy/dDcSRAUHY6MSv2+ZWgTvmWfsiH2bAyOMjrvF3bH8r
         z46gozUQPtln/nYAwPTPx5VUsvLlRSl2+86ziAFUWutIqHNPH5ikolFVXGZrtZbQwD
         qwzo/mJTxzFM7nQ6ERBekZgyRrpClN4nwNB3y+yA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 192/601] usb: gadget: pch_udc: Replace cpu_to_le32() by lower_32_bits()
Date:   Wed, 12 May 2021 16:44:29 +0200
Message-Id: <20210512144834.156442832@linuxfoundation.org>
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
index 931a09fdbf6d..f6f8965c4f8c 100644
--- a/drivers/usb/gadget/udc/pch_udc.c
+++ b/drivers/usb/gadget/udc/pch_udc.c
@@ -1765,7 +1765,7 @@ static struct usb_request *pch_udc_alloc_request(struct usb_ep *usbep,
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



