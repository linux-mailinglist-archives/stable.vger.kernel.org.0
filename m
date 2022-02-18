Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 074D94BB495
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 09:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbiBRIuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 03:50:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbiBRIuE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 03:50:04 -0500
X-Greylist: delayed 529 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 18 Feb 2022 00:49:46 PST
Received: from web-bm.overkiz.com (web-bm.overkiz.com [92.222.103.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3DB2B355E
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 00:49:46 -0800 (PST)
Received: from [192.168.1.59] (4.106.24.93.rev.sfr.net [93.24.106.4])
        (Authenticated sender: m.gardet@overkiz.com)
        by web-bm.overkiz.com (Postfix) with ESMTPSA id C62521BF29E;
        Fri, 18 Feb 2022 09:40:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=overkiz.com;
        s=202003; t=1645173655;
        bh=tt1OZE2467H9Oj86Mg3przdN6Oyucs5eVviM2qRRc1s=;
        h=Date:From:To:Cc:Subject:From;
        b=D1gPMRTOQqyy5ZLtB7QrsCnHeka6f2Q2waIMzVgTAAD0qETWL2QN8ynLYWSOdD/eg
         QmHUQrNlUX994SuzcyGjsxK9K0wKtXS9GOCcdsba0KJOsZ5M1JBQ8CyhbpAxoU+ygr
         dLVFVLGtjtObiiE7+wnKJGMABZz9bLgP1YPZol+UgPOxYgyqz6/ER8BAHXmtC0WZTo
         Gbg5tHSM31xxxAvHPUHCsq4f9QUBg4/UPU9TL/gR92UTTMaAHEc30yti77HbQCKij9
         mlYEzI5jfJZraK8RgjUdNwxoIJ2VOGZcMxuqNPWr+YISGz2Qs7fWnwO4ZbgS4X5d1K
         WMl5TNJKUyNxg==
Message-ID: <b8147153-5bcc-8a6d-7aac-5c0abbd43379@overkiz.com>
Date:   Fri, 18 Feb 2022 09:40:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.0
From:   Mickael GARDET <m.gardet@overkiz.com>
To:     stable@vger.kernel.org
Cc:     =?UTF-8?Q?K=c3=a9vin_Raymond?= <k.raymond@overkiz.com>,
        gregkh@linuxfoundation.org, Tudor.Ambarus@microchip.com
Content-Language: fr
Subject: Atmel UART with dma enabled does not work on branch 5.4.Y from
 version 5.4.174.
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Bm-Milter-Handled: f125012e-72d2-4729-b87c-a5ab9341072c
X-Bm-Transport-Timestamp: 1645173655975
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

we observed a regression on our atmel platforms on branch 5.4.Y from 
version 5.4.174.
uarts are no longer functional if DMA is enabled.

the following patch
Commit e6af9b05bec63cd4d1de2a33968cd0be2a91282a dmaengine: at_xdmac: 
Start transfer for cyclic channels in issue_pending
Link:
https://lore.kernel.org/r/20211215110115.191749-3-tudor.ambarus@microchip.com
has not been backported but is needed if the patch
Commit 4f4b9b5895614eb2e2b5f4cab7858f44bd113e1b tty: serial: atmel: Call 
dma_async_issue_pending()
Link: 
https://lore.kernel.org/r/20211125090028.786832-4-tudor.ambarus@microchip.com
is applied.

enclosed commit fix this issue and work for me.

Best regards,
Mickael GARDET

 From 9877f93c066be8c2f4e33a6edd4dfa3d6d6974d9 Mon Sep 17 00:00:00 2001
From: Tudor Ambarus <tudor.ambarus@microchip.com>
Date: Wed, 15 Dec 2021 13:01:05 +0200
Subject: [PATCH] dmaengine: at_xdmac: Start transfer for cyclic channels 
in issue_pending

commit e6af9b05bec63cd4d1de2a33968cd0be2a91282a upstream.

Cyclic channels must too call issue_pending in order to start a transfer.
Start the transfer in issue_pending regardless of the type of channel.
This wrongly worked before, because in the past the transfer was started
at tx_submit level when only a desc in the transfer list.

Fixes: e1f7c9eee707 ("dmaengine: at_xdmac: creation of the atmel 
eXtended DMA Controller driver")
Change-Id: If1bf3e13329cebb9904ae40620f6cf2b7f06fe9f
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: 
https://lore.kernel.org/r/20211215110115.191749-3-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
---
drivers/dma/at_xdmac.c | 6 ++++--
1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/at_xdmac.c b/drivers/dma/at_xdmac.c
index f63d141481a3..9aae6b3da356 100644
--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -1726,11 +1726,13 @@ static irqreturn_t at_xdmac_interrupt(int irq,
void *dev_id)
static void at_xdmac_issue_pending(struct dma_chan *chan)
{
struct at_xdmac_chan *atchan = to_at_xdmac_chan(chan);
+    unsigned long flags;

dev_dbg(chan2dev(&atchan->chan), "%s\n", __func__);

-    if (!at_xdmac_chan_is_cyclic(atchan))
-        at_xdmac_advance_work(atchan);
+    spin_lock_irqsave(&atchan->lock, flags);
+    at_xdmac_advance_work(atchan);
+    spin_unlock_irqrestore(&atchan->lock, flags);

return;
}

base-commit: 7b3eb66d0daf61e91cccdb2fe5d271ae5adc5a76

-- 
2.35.1

