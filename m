Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302DE3287C7
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238512AbhCAR2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:28:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:45482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238163AbhCARXf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:23:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA44164F9F;
        Mon,  1 Mar 2021 16:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617349;
        bh=mL09YJig77HNu0qIaVI95NMHTCeHIlURYFfYIByCyUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pgFW8+prZrD00YyqUXlhsL92Bq+ZNiwp7L7+sRqlyYgn4adKDaZ470NhF8o9G1mnX
         NZA9Kh2qBTJQYXnRqogyMUK3jLrqqnJw0BWIQFXlZFvU9nCdx8eWzoW9oS0kjqRBxw
         QQi2uLrva/Y0wRvuEiZnxkSQUIK1JjSTEIZ6wGh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Douglas Anderson <dianders@chromium.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 043/340] usb: dwc2: Make "trimming xfer length" a debug message
Date:   Mon,  1 Mar 2021 17:09:47 +0100
Message-Id: <20210301161050.448600684@linuxfoundation.org>
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

[ Upstream commit 1a9e38cabd80356ffb98c2c88fec528ea9644fd5 ]

With some USB network adapters, such as DM96xx, the following message
is seen for each maximum size receive packet.

dwc2 ff540000.usb: dwc2_update_urb_state(): trimming xfer length

This happens because the packet size requested by the driver is 1522
bytes, wMaxPacketSize is 64, the dwc2 driver configures the chip to
receive 24*64 = 1536 bytes, and the chip does indeed send more than
1522 bytes of data. Since the event does not indicate an error condition,
the message is just noise. Demote it to debug level.

Fixes: 7359d482eb4d3 ("staging: HCD files for the DWC2 driver")
Tested-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Link: https://lore.kernel.org/r/20210113112052.17063-4-nsaenzjulienne@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/hcd_intr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/hcd_intr.c b/drivers/usb/dwc2/hcd_intr.c
index 12819e019e13c..d5f4ec1b73b15 100644
--- a/drivers/usb/dwc2/hcd_intr.c
+++ b/drivers/usb/dwc2/hcd_intr.c
@@ -500,7 +500,7 @@ static int dwc2_update_urb_state(struct dwc2_hsotg *hsotg,
 						      &short_read);
 
 	if (urb->actual_length + xfer_length > urb->length) {
-		dev_warn(hsotg->dev, "%s(): trimming xfer length\n", __func__);
+		dev_dbg(hsotg->dev, "%s(): trimming xfer length\n", __func__);
 		xfer_length = urb->length - urb->actual_length;
 	}
 
-- 
2.27.0



