Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 274D8328419
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234759AbhCAQ2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:28:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:59974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237916AbhCAQYV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:24:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E04E864F42;
        Mon,  1 Mar 2021 16:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615682;
        bh=VKTIRyt0y8hEJ2G/49fn5QcVOLV6Hs8zJtrElO/639I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kx0/DUmZNY+Sej2fdReiLpJfmvk6IwDaYp2qSqOl8lmIWdPbc4nzM8y7RClSYrS7h
         tF/xrijtty5JIgqYpJdAAdbv75dWv2etrgrC5WBWOovC/VtEjLEWG+4dpb/R1q3IqP
         HC7b9TfwDOTdMvFsZqAPhSeejFU0HmPVUcuzmjyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Douglas Anderson <dianders@chromium.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 022/134] usb: dwc2: Make "trimming xfer length" a debug message
Date:   Mon,  1 Mar 2021 17:12:03 +0100
Message-Id: <20210301161014.659447810@linuxfoundation.org>
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
index c80bfd353758b..e39210bd97100 100644
--- a/drivers/usb/dwc2/hcd_intr.c
+++ b/drivers/usb/dwc2/hcd_intr.c
@@ -488,7 +488,7 @@ static int dwc2_update_urb_state(struct dwc2_hsotg *hsotg,
 						      &short_read);
 
 	if (urb->actual_length + xfer_length > urb->length) {
-		dev_warn(hsotg->dev, "%s(): trimming xfer length\n", __func__);
+		dev_dbg(hsotg->dev, "%s(): trimming xfer length\n", __func__);
 		xfer_length = urb->length - urb->actual_length;
 	}
 
-- 
2.27.0



