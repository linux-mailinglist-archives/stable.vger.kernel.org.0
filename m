Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7C545130E
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343811AbhKOTp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:45:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:44606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245324AbhKOTUE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAB976354C;
        Mon, 15 Nov 2021 18:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001140;
        bh=3GcBuAxfBAEuz+0i0xtrfhjyFYeLcVFcmutChpvWn+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WzwHeCZ3t4ueoXVOfEITENaZW3k/4pSamg9ef9PLpDdPz+k08oKnL9bcjRZ0QuW8Y
         CJApqw8n8rU1CUuvJku0G4aiNZVm72xBayGgk1Afl3rxGYrZt31zlo4XRq7QEYERZY
         WlPKtUpC/5tegNO+MAAoMp0W9gvNL5KUVXfvEgDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amitkumar Karwar <akarwar@marvell.com>,
        Johan Hovold <johan@kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.15 076/917] mwifiex: fix division by zero in fw download path
Date:   Mon, 15 Nov 2021 17:52:51 +0100
Message-Id: <20211115165431.339569381@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 89f8765a11d8df49296d92c404067f9b5c58ee26 upstream.

Add the missing endpoint sanity checks to probe() to avoid division by
zero in mwifiex_write_data_sync() in case a malicious device has broken
descriptors (or when doing descriptor fuzz testing).

Only add checks for the firmware-download boot stage, which require both
command endpoints, for now. The driver looks like it will handle a
missing endpoint during normal operation without oopsing, albeit not
very gracefully as it will try to submit URBs to the default pipe and
fail.

Note that USB core will reject URBs submitted for endpoints with zero
wMaxPacketSize but that drivers doing packet-size calculations still
need to handle this (cf. commit 2548288b4fb0 ("USB: Fix: Don't skip
endpoint descriptors with maxpacket=0")).

Fixes: 4daffe354366 ("mwifiex: add support for Marvell USB8797 chipset")
Cc: stable@vger.kernel.org      # 3.5
Cc: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211027080819.6675-4-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/mwifiex/usb.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -505,6 +505,22 @@ static int mwifiex_usb_probe(struct usb_
 		}
 	}
 
+	switch (card->usb_boot_state) {
+	case USB8XXX_FW_DNLD:
+		/* Reject broken descriptors. */
+		if (!card->rx_cmd_ep || !card->tx_cmd_ep)
+			return -ENODEV;
+		if (card->bulk_out_maxpktsize == 0)
+			return -ENODEV;
+		break;
+	case USB8XXX_FW_READY:
+		/* Assume the driver can handle missing endpoints for now. */
+		break;
+	default:
+		WARN_ON(1);
+		return -ENODEV;
+	}
+
 	usb_set_intfdata(intf, card);
 
 	ret = mwifiex_add_card(card, &card->fw_done, &usb_ops,


