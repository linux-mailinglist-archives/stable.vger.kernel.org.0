Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5855388D9E
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbfHJUrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:47:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55060 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726843AbfHJUoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:04 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDY-00053W-El; Sat, 10 Aug 2019 21:44:00 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDM-0003eo-5i; Sat, 10 Aug 2019 21:43:48 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Ian Abbott" <abbotti@mev.co.uk>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.711785637@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 088/157] staging: comedi: vmk80xx: Fix possible
 double-free of ->usb_rx_buf
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 663d294b4768bfd89e529e069bffa544a830b5bf upstream.

`vmk80xx_alloc_usb_buffers()` is called from `vmk80xx_auto_attach()` to
allocate RX and TX buffers for USB transfers.  It allocates
`devpriv->usb_rx_buf` followed by `devpriv->usb_tx_buf`.  If the
allocation of `devpriv->usb_tx_buf` fails, it frees
`devpriv->usb_rx_buf`,  leaving the pointer set dangling, and returns an
error.  Later, `vmk80xx_detach()` will be called from the core comedi
module code to clean up.  `vmk80xx_detach()` also frees both
`devpriv->usb_rx_buf` and `devpriv->usb_tx_buf`, but
`devpriv->usb_rx_buf` may have already been freed, leading to a
double-free error.  Fix it by removing the call to
`kfree(devpriv->usb_rx_buf)` from `vmk80xx_alloc_usb_buffers()`, relying
on `vmk80xx_detach()` to free the memory.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/comedi/drivers/vmk80xx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -757,10 +757,8 @@ static int vmk80xx_alloc_usb_buffers(str
 
 	size = le16_to_cpu(devpriv->ep_tx->wMaxPacketSize);
 	devpriv->usb_tx_buf = kzalloc(size, GFP_KERNEL);
-	if (!devpriv->usb_tx_buf) {
-		kfree(devpriv->usb_rx_buf);
+	if (!devpriv->usb_tx_buf)
 		return -ENOMEM;
-	}
 
 	return 0;
 }

