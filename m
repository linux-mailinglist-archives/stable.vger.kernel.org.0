Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5473287D6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238545AbhCAR2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:28:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:48868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238246AbhCARYB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:24:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 086CB64FA1;
        Mon,  1 Mar 2021 16:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617346;
        bh=dbmBbJIQd5Su2jJKkyvUXkfSRniCgdQy9uxz8YeJee8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uAxgnaHRZiooDzDGmSQJ2pROnhtIo9vSU/opF3T9wL18zk7QO/KbPCU+lEa6qA7V3
         yZsBirA9ok4fSDugF2sp2NdHFK6z9O+LDhb8LC1FJTFQ9JSdX1OgwxrglQoTJoblYg
         kCroKH49ibJNHqlqbNRDoRaGp/rIbzHa2Ec9w4YA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Boris ARZUR <boris@konbu.org>,
        Douglas Anderson <dianders@chromium.org>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 042/340] usb: dwc2: Abort transaction after errors with unknown reason
Date:   Mon,  1 Mar 2021 17:09:46 +0100
Message-Id: <20210301161050.397469871@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
index a052d39b4375e..12819e019e13c 100644
--- a/drivers/usb/dwc2/hcd_intr.c
+++ b/drivers/usb/dwc2/hcd_intr.c
@@ -1977,6 +1977,18 @@ error:
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



