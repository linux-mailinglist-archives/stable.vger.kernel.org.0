Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A0232837D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237623AbhCAQTd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:19:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:56642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237161AbhCAQSn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:18:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DC7864E2E;
        Mon,  1 Mar 2021 16:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615395;
        bh=GmnblxptMkMgd7Za98MrQffmPiEKld5qkIm7QRR2hco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uUOw4ECqP/K/7lHSBvwC63WY2PdfhAy27AB56Rs9Oiv1mxnZaZ/h+AbhWKvpp9//Z
         J3qlj3ZqTwF+V6FmgTnNXO2Knqq8Cq0nkBNNBt3L4SdyKrn37FvI3IHRxc+CjWnK4Y
         h5Iz9+mwNURvR9zj+fLegAgZYGL7D6mwqMtW9pkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Boris ARZUR <boris@konbu.org>,
        Douglas Anderson <dianders@chromium.org>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 14/93] usb: dwc2: Abort transaction after errors with unknown reason
Date:   Mon,  1 Mar 2021 17:12:26 +0100
Message-Id: <20210301161007.608100546@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161006.881950696@linuxfoundation.org>
References: <20210301161006.881950696@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit f74b68c61cbc4b2245022fcce038509333d63f6f ]

In some situations, the following error messages are reported.

dwc2 ff540000.usb: dwc2_hc_chhltd_intr_dma: Channel 1 - ChHltd set, but reason is unknown
dwc2 ff540000.usb: hcint 0x00000002, intsts 0x04000021

This is sometimes followed by:

dwc2 ff540000.usb: dwc2_update_urb_state_abn(): trimming xfer length

and then:

WARNING: CPU: 0 PID: 0 at kernel/v4.19/drivers/usb/dwc2/hcd.c:2913
			dwc2_assign_and_init_hc+0x98c/0x990

The warning suggests that an odd buffer address is to be used for DMA.

After an error is observed, the receive buffer may be full
(urb->actual_length >= urb->length). However, the urb is still left in
the queue unless three errors were observed in a row. When it is queued
again, the dwc2 hcd code translates this into a 1-block transfer.
If urb->actual_length (ie the total expected receive length) is not
DMA-aligned, the buffer pointer programmed into the chip will be
unaligned. This results in the observed warning.

To solve the problem, abort input transactions after an error with
unknown cause if the entire packet was already received. This may be
a bit drastic, but we don't really know why the transfer was aborted
even though the entire packet was received. Aborting the transfer in
this situation is less risky than accepting a potentially corrupted
packet.

With this patch in place, the 'ChHltd set' and 'trimming xfer length'
messages are still observed, but there are no more transfer attempts
with odd buffer addresses.

Fixes: 151d0cbdbe860 ("usb: dwc2: make the scheduler handle excessive NAKs better")
Cc: Boris ARZUR <boris@konbu.org>
Cc: Douglas Anderson <dianders@chromium.org>
Tested-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Link: https://lore.kernel.org/r/20210113112052.17063-3-nsaenzjulienne@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/hcd_intr.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/usb/dwc2/hcd_intr.c b/drivers/usb/dwc2/hcd_intr.c
index 51866f3f20522..84487548918f9 100644
--- a/drivers/usb/dwc2/hcd_intr.c
+++ b/drivers/usb/dwc2/hcd_intr.c
@@ -1915,6 +1915,18 @@ error:
 		qtd->error_count++;
 		dwc2_update_urb_state_abn(hsotg, chan, chnum, qtd->urb,
 					  qtd, DWC2_HC_XFER_XACT_ERR);
+		/*
+		 * We can get here after a completed transaction
+		 * (urb->actual_length >= urb->length) which was not reported
+		 * as completed. If that is the case, and we do not abort
+		 * the transfer, a transfer of size 0 will be enqueued
+		 * subsequently. If urb->actual_length is not DMA-aligned,
+		 * the buffer will then point to an unaligned address, and
+		 * the resulting behavior is undefined. Bail out in that
+		 * situation.
+		 */
+		if (qtd->urb->actual_length >= qtd->urb->length)
+			qtd->error_count = 3;
 		dwc2_hcd_save_data_toggle(hsotg, chan, chnum, qtd);
 		dwc2_halt_channel(hsotg, chan, qtd, DWC2_HC_XFER_XACT_ERR);
 	}
-- 
2.27.0



