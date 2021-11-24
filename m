Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4B3445BAD0
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243651AbhKXMOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:14:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:48678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243404AbhKXMOB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:14:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2C2F610A7;
        Wed, 24 Nov 2021 12:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755716;
        bh=RmU1RKhWGmFAK1Q1T8wTJbB4N/UMxf29ae1zfCjXNsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JGRcQJun4NOvtFV9N0HvEtPh7+4I3Hp11lsaEx/WzelP7kVbiTDcYmCGiJhjiUEK3
         OqtQ8B6Wcj9jElUGnsoG12akQp5RfQVrAPC/r/9ccYYxa50WzboWCb4od4Pee9kzUd
         3mzgU639B9MjLadicblF/tWEIH7nsg3L5Rjvm/bE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amitkumar Karwar <akarwar@marvell.com>,
        Johan Hovold <johan@kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.9 032/207] mwifiex: fix division by zero in fw download path
Date:   Wed, 24 Nov 2021 12:55:03 +0100
Message-Id: <20211124115704.988689931@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
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
@@ -473,6 +473,22 @@ static int mwifiex_usb_probe(struct usb_
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
 
 	ret = mwifiex_add_card(card, &add_remove_card_sem, &usb_ops,


