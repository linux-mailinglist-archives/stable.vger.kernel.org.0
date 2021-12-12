Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73298471A8A
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 14:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhLLN5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 08:57:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49576 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbhLLN5W (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 08:57:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3F9CB80CAA
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 13:57:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C93C341C6;
        Sun, 12 Dec 2021 13:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639317440;
        bh=tr0Bw+pzRo1P+R4hOEkgNgnAEzvQaVjFzuZgahHXN/g=;
        h=Subject:To:From:Date:From;
        b=aHCkkUnqWn+skhcvNSZ3UzYWbt3d9IM9hnSpZC5SY0HO4/sHpYQV63kay0YlAZbXE
         AKgL0+YLMhGs/2/+JUG8J3kxSp1hWlIsidW3uKgCA9q+lDW4MJdiccts+Zq1BH3NR/
         XBFXt21oSyMUs2r8wdTNnq2koRtbHulfW1VW3k1g=
Subject: patch "usb: core: config: fix validation of wMaxPacketValue entries" added to usb-linus
To:     pavel.hofman@ivitera.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 12 Dec 2021 14:57:15 +0100
Message-ID: <1639317435245206@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: core: config: fix validation of wMaxPacketValue entries

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1a3910c80966e4a76b25ce812f6bea0ef1b1d530 Mon Sep 17 00:00:00 2001
From: Pavel Hofman <pavel.hofman@ivitera.com>
Date: Fri, 10 Dec 2021 09:52:18 +0100
Subject: usb: core: config: fix validation of wMaxPacketValue entries

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
 drivers/usb/core/config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
index 16b1fd9dc60c..e3c3a73e1ed8 100644
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -406,7 +406,7 @@ static int usb_parse_endpoint(struct device *ddev, int cfgno,
 	 * the USB-2 spec requires such endpoints to have wMaxPacketSize = 0
 	 * (see the end of section 5.6.3), so don't warn about them.
 	 */
-	maxp = usb_endpoint_maxp(&endpoint->desc);
+	maxp = le16_to_cpu(endpoint->desc.wMaxPacketSize);
 	if (maxp == 0 && !(usb_endpoint_xfer_isoc(d) && asnum == 0)) {
 		dev_warn(ddev, "config %d interface %d altsetting %d endpoint 0x%X has invalid wMaxPacketSize 0\n",
 		    cfgno, inum, asnum, d->bEndpointAddress);
-- 
2.34.1


