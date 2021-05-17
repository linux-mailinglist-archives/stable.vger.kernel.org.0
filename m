Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 554563837DF
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244591AbhEQPrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:47:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344757AbhEQPph (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:45:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52A776135B;
        Mon, 17 May 2021 14:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262633;
        bh=MBOQYnE2mOI5zp9tE0zlOseQc4zBVgAXWE1oPuGi4DU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mThUfNtTUf6MfeVdKKkqwW1iBRHzjp6KFMYvH4pt3fftyt7RF+m8wsjBmR2JzkJ9x
         OHw6azSgNZZWI/063GaArPunCUiFrqQWYSBcFZQ9cqtjRBC/X3o4J7N0XRvlq1xD08
         eYHt7zH4RezTeNMQWF6qmISkZHr87DgAV9R01d1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcel Hamer <marcel@solidxs.se>
Subject: [PATCH 5.10 240/289] usb: dwc3: omap: improve extcon initialization
Date:   Mon, 17 May 2021 16:02:45 +0200
Message-Id: <20210517140313.243962395@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcel Hamer <marcel@solidxs.se>

commit e17b02d4970913233d543c79c9c66e72cac05bdd upstream.

When extcon is used in combination with dwc3, it is assumed that the dwc3
registers are untouched and as such are only configured if VBUS is valid
or ID is tied to ground.

In case VBUS is not valid or ID is floating, the registers are not
configured as such during driver initialization, causing a wrong
default state during boot.

If the registers are not in a default state, because they are for
instance touched by a boot loader, this can cause for a kernel error.

Signed-off-by: Marcel Hamer <marcel@solidxs.se>
Link: https://lore.kernel.org/r/20210427122118.1948340-1-marcel@solidxs.se
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-omap.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -437,8 +437,13 @@ static int dwc3_omap_extcon_register(str
 
 		if (extcon_get_state(edev, EXTCON_USB) == true)
 			dwc3_omap_set_mailbox(omap, OMAP_DWC3_VBUS_VALID);
+		else
+			dwc3_omap_set_mailbox(omap, OMAP_DWC3_VBUS_OFF);
+
 		if (extcon_get_state(edev, EXTCON_USB_HOST) == true)
 			dwc3_omap_set_mailbox(omap, OMAP_DWC3_ID_GROUND);
+		else
+			dwc3_omap_set_mailbox(omap, OMAP_DWC3_ID_FLOAT);
 
 		omap->edev = edev;
 	}


