Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3860C472408
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbhLMJdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:33:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233847AbhLMJdU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:33:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284F6C061748;
        Mon, 13 Dec 2021 01:33:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8F76B80E0E;
        Mon, 13 Dec 2021 09:33:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E54C341CD;
        Mon, 13 Dec 2021 09:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639387997;
        bh=5t8scmo4m+XuF42L3XZDTsP6ozDM7kPXw2gUi9HJSEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cj6osa/klwa0t7XzOEdkE1tePzE80chpmsIPO8qpz1DQpOn8hkepygdd5uw6SC8g5
         XLXkeuo2hePvQmx4NwO4lDvz6v40SMcgfl0OV5T7RdBrFgrLOyhAU+CS62H073gxN8
         2LoD1pHSLq2aLp3ZSLM3a+dUef+DAo4bTT97EbJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Pavel Hofman <pavel.hofman@ivitera.com>
Subject: [PATCH 4.4 30/37] usb: core: config: fix validation of wMaxPacketValue entries
Date:   Mon, 13 Dec 2021 10:30:08 +0100
Message-Id: <20211213092926.358935422@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092925.380184671@linuxfoundation.org>
References: <20211213092925.380184671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Hofman <pavel.hofman@ivitera.com>

commit 1a3910c80966e4a76b25ce812f6bea0ef1b1d530 upstream.

The checks performed by commit aed9d65ac327 ("USB: validate
wMaxPacketValue entries in endpoint descriptors") require that initial
value of the maxp variable contains both maximum packet size bits
(10..0) and multiple-transactions bits (12..11). However, the existing
code assings only the maximum packet size bits. This patch assigns all
bits of wMaxPacketSize to the variable.

Fixes: aed9d65ac327 ("USB: validate wMaxPacketValue entries in endpoint descriptors")
Cc: stable <stable@vger.kernel.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Pavel Hofman <pavel.hofman@ivitera.com>
Link: https://lore.kernel.org/r/20211210085219.16796-1-pavel.hofman@ivitera.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/config.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -375,7 +375,7 @@ static int usb_parse_endpoint(struct dev
 	 * the USB-2 spec requires such endpoints to have wMaxPacketSize = 0
 	 * (see the end of section 5.6.3), so don't warn about them.
 	 */
-	maxp = usb_endpoint_maxp(&endpoint->desc);
+	maxp = le16_to_cpu(endpoint->desc.wMaxPacketSize);
 	if (maxp == 0 && !(usb_endpoint_xfer_isoc(d) && asnum == 0)) {
 		dev_warn(ddev, "config %d interface %d altsetting %d endpoint 0x%X has invalid wMaxPacketSize 0\n",
 		    cfgno, inum, asnum, d->bEndpointAddress);


