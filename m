Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5BB328424
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234809AbhCAQ3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:29:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:60806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231910AbhCAQYq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:24:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C60664F40;
        Mon,  1 Mar 2021 16:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615672;
        bh=WopnfO5HRx1/A0J/KxrUzLQNnL3KBU6oSZypNV6j12k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gVR/pFKpBvd11iv9OHwblGpxZ7jsRW9wFdd1HBH0BY6hG6SRiv1JOd2NmqHhfKBwz
         vcQt8eHSMaHIWFr7kXHOIZyYXLj9RLtETiEA6EL8P2wCl2aLDosX9aqB4bFYRMZ/Hd
         4nIfs1uf5jeK5tx+SisrsxYLW596qt2sPHXYCwW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Douglas Anderson <dianders@chromium.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 020/134] usb: dwc2: Do not update data length if it is 0 on inbound transfers
Date:   Mon,  1 Mar 2021 17:12:01 +0100
Message-Id: <20210301161014.563617406@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
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
index 120c8f716acf8..f2c7cd22b73f2 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -1425,19 +1425,20 @@ static void dwc2_hc_start_transfer(struct dwc2_hsotg *hsotg,
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



