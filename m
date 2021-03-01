Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17043287C8
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238516AbhCAR2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:28:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:45400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238162AbhCARXf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:23:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2710965078;
        Mon,  1 Mar 2021 16:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617343;
        bh=VBSfaSsgDivuPf2j2RhXALOMfXS1LctaSU9IZcsq7Y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PqJjroz0JSxnIxNes9DnGD1Wzkl8+2ZsNj4bkiqlTcaDDTtBEHy7cUQ13f7nA0vv9
         5rT9pzhtnZLtbO/VgJvRg1ZZLYLAC7qZ3A/yRTetOqmJD9xwNrQi4SY1bbT6GdNfiE
         BsPSnuKPAlIv+xay5X37/AlEfF4iKaXzZB0VM/FI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Douglas Anderson <dianders@chromium.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 041/340] usb: dwc2: Do not update data length if it is 0 on inbound transfers
Date:   Mon,  1 Mar 2021 17:09:45 +0100
Message-Id: <20210301161050.346754152@linuxfoundation.org>
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

[ Upstream commit 415fa1c7305dedbb345e2cc8ac91769bc1c83f1a ]

The DWC2 documentation states that transfers with zero data length should
set the number of packets to 1 and the transfer length to 0. This is not
currently the case for inbound transfers: the transfer length is set to
the maximum packet length. This can have adverse effects if the chip
actually does transfer data as it is programmed to do. Follow chip
documentation and keep the transfer length set to 0 in that situation.

Fixes: 56f5b1cff22a1 ("staging: Core files for the DWC2 driver")
Tested-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Link: https://lore.kernel.org/r/20210113112052.17063-2-nsaenzjulienne@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/hcd.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index 81afe553aa666..a91f2aa24118a 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -1313,19 +1313,20 @@ static void dwc2_hc_start_transfer(struct dwc2_hsotg *hsotg,
 			if (num_packets > max_hc_pkt_count) {
 				num_packets = max_hc_pkt_count;
 				chan->xfer_len = num_packets * chan->max_packet;
+			} else if (chan->ep_is_in) {
+				/*
+				 * Always program an integral # of max packets
+				 * for IN transfers.
+				 * Note: This assumes that the input buffer is
+				 * aligned and sized accordingly.
+				 */
+				chan->xfer_len = num_packets * chan->max_packet;
 			}
 		} else {
 			/* Need 1 packet for transfer length of 0 */
 			num_packets = 1;
 		}
 
-		if (chan->ep_is_in)
-			/*
-			 * Always program an integral # of max packets for IN
-			 * transfers
-			 */
-			chan->xfer_len = num_packets * chan->max_packet;
-
 		if (chan->ep_type == USB_ENDPOINT_XFER_INT ||
 		    chan->ep_type == USB_ENDPOINT_XFER_ISOC)
 			/*
-- 
2.27.0



