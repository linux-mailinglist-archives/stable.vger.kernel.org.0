Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2B8499AD1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355296AbiAXVrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456713AbiAXVjy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:39:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81078C0419C9;
        Mon, 24 Jan 2022 12:26:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EBD66150F;
        Mon, 24 Jan 2022 20:26:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204DAC340E5;
        Mon, 24 Jan 2022 20:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055990;
        bh=O59Wt/hOMkwJpFVVFf+WeiotE2h/uvQbmmOt8NKRTKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rs86k6QKrpdl8+0F2tbYq7Kh7KV1n9lge02wXZ16yw0VQEdPQiP2mH5O8d3tBX+bS
         c7/GUuBqnf4e8S6h/YHIrnyObMRqWjhf++ilFUW/Qih6eFK2JBYobxbHukCn8EOCCJ
         nhrc/DMC11ZrXqw7XarXj+RL8OYZvFUr6Ze+3IfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        John Keeping <john@metanate.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 326/846] usb: dwc2: gadget: initialize max_speed from params
Date:   Mon, 24 Jan 2022 19:37:23 +0100
Message-Id: <20220124184112.151733041@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Keeping <john@metanate.com>

[ Upstream commit 92ef98a4caacad6d4a1490dda45d81ae5ccf5bc9 ]

DWC2 may be paired with a full-speed PHY which is not capable of
high-speed operation.  Report this correctly to the gadget core by
setting max_speed from the core parameters.

Prior to commit 5324bad66f09f ("usb: dwc2: gadget: implement
udc_set_speed()") this didn't cause the hardware to be configured
incorrectly, although the speed may have been reported incorrectly.  But
after that commit params.speed is updated based on a value passed in by
the gadget core which may set it to a faster speed than is supported by
the hardware.  Initialising the max_speed parameter ensures the speed
passed to dwc2_gadget_set_speed() will be one supported by the hardware.

Fixes: 5324bad66f09f ("usb: dwc2: gadget: implement udc_set_speed()")
Acked-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Signed-off-by: John Keeping <john@metanate.com>
Link: https://lore.kernel.org/r/20220106115731.1473909-1-john@metanate.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/gadget.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 2190225bf3da2..ea0d2d6139a68 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -4974,7 +4974,18 @@ int dwc2_gadget_init(struct dwc2_hsotg *hsotg)
 		hsotg->params.g_np_tx_fifo_size);
 	dev_dbg(dev, "RXFIFO size: %d\n", hsotg->params.g_rx_fifo_size);
 
-	hsotg->gadget.max_speed = USB_SPEED_HIGH;
+	switch (hsotg->params.speed) {
+	case DWC2_SPEED_PARAM_LOW:
+		hsotg->gadget.max_speed = USB_SPEED_LOW;
+		break;
+	case DWC2_SPEED_PARAM_FULL:
+		hsotg->gadget.max_speed = USB_SPEED_FULL;
+		break;
+	default:
+		hsotg->gadget.max_speed = USB_SPEED_HIGH;
+		break;
+	}
+
 	hsotg->gadget.ops = &dwc2_hsotg_gadget_ops;
 	hsotg->gadget.name = dev_name(dev);
 	hsotg->remote_wakeup_allowed = 0;
-- 
2.34.1



