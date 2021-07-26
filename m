Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 090393D623B
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234763AbhGZPfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:35:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234926AbhGZPeB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:34:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 465AF60F9C;
        Mon, 26 Jul 2021 16:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316059;
        bh=euXaBl3Soy6w/GSZsgYYP0G1nCVgFl0J0F0NJ5sHROU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fvqs8TSBdOACP/2QFA5R4QY5Hg3lw6g1/KyQcFR9Mlch8JuvPhysbft+l08BZb/NE
         vM4hiMbrVj/ogEbXvAL7w4Hd47ENNIiwv2R/9rIPcBUyKrRDw8q5oTUp0WxNgJ8IIs
         8ErZgDVxH9siANC0p40gTWgjr4hqy2MziiIKJSDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Subject: [PATCH 5.13 172/223] usb: dwc2: gadget: Fix sending zero length packet in DDMA mode.
Date:   Mon, 26 Jul 2021 17:39:24 +0200
Message-Id: <20210726153851.826031048@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>

commit d53dc38857f6dbefabd9eecfcbf67b6eac9a1ef4 upstream.

Sending zero length packet in DDMA mode perform by DMA descriptor
by setting SP (short packet) flag.

For DDMA in function dwc2_hsotg_complete_in() does not need to send
zlp.

Tested by USBCV MSC tests.

Fixes: f71b5e2533de ("usb: dwc2: gadget: fix zero length packet transfers")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Link: https://lore.kernel.org/r/967bad78c55dd2db1c19714eee3d0a17cf99d74a.1626777738.git.Minas.Harutyunyan@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/gadget.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2749,12 +2749,14 @@ static void dwc2_hsotg_complete_in(struc
 		return;
 	}
 
-	/* Zlp for all endpoints, for ep0 only in DATA IN stage */
+	/* Zlp for all endpoints in non DDMA, for ep0 only in DATA IN stage */
 	if (hs_ep->send_zlp) {
-		dwc2_hsotg_program_zlp(hsotg, hs_ep);
 		hs_ep->send_zlp = 0;
-		/* transfer will be completed on next complete interrupt */
-		return;
+		if (!using_desc_dma(hsotg)) {
+			dwc2_hsotg_program_zlp(hsotg, hs_ep);
+			/* transfer will be completed on next complete interrupt */
+			return;
+		}
 	}
 
 	if (hs_ep->index == 0 && hsotg->ep0_state == DWC2_EP0_DATA_IN) {


