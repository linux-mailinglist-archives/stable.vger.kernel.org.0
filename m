Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E88038A386
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbhETJxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:53:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234176AbhETJvP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:51:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D73AA613FE;
        Thu, 20 May 2021 09:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503345;
        bh=oF2Tz55Ij5ff9V8BVJ40bw56T6GathFVj6A2gUf6qNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HEWk6JtvZh7wde0xCwmMSNyiTkkMYM01qHKVyyZExmqajjolE8TtSmxVXkKtCU+J8
         g2mkxlOsGlOyWlTE8CQUmVPtg4AGXrlBgeqRBt03ruplmA8927+wq6SEuxLo9VTNMG
         IibdptRbl1gjcCLfL3OT8ssfyaHhtKvMhgZCFerc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 178/425] usb: gadget: pch_udc: Replace cpu_to_le32() by lower_32_bits()
Date:   Thu, 20 May 2021 11:19:07 +0200
Message-Id: <20210520092137.284333681@linuxfoundation.org>
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
index 8e304e9845d9..527814361c3d 100644
--- a/drivers/usb/gadget/udc/pch_udc.c
+++ b/drivers/usb/gadget/udc/pch_udc.c
@@ -1782,7 +1782,7 @@ static struct usb_request *pch_udc_alloc_request(struct usb_ep *usbep,
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



