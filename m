Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697BC3836EC
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245090AbhEQPh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:37:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243296AbhEQPfa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:35:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E4D261CE8;
        Mon, 17 May 2021 14:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262389;
        bh=MBOQYnE2mOI5zp9tE0zlOseQc4zBVgAXWE1oPuGi4DU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=naz4a9dfShmDbhMByPGqr2NROoJUELZRR4E0GpndFounC+GR2I9dxZ8GUxYUet29v
         Tf/dvEu+k1Ro9H5Y/Ap7FotKQ2RsWmUYdeaxen3oI67KMOjuI6+KTAFRBHygvLrbup
         mK/tdBou1y1f0LKCBHwuDfmMJi0KVC5WBAU2SqCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcel Hamer <marcel@solidxs.se>
Subject: [PATCH 5.11 281/329] usb: dwc3: omap: improve extcon initialization
Date:   Mon, 17 May 2021 16:03:12 +0200
Message-Id: <20210517140311.611750179@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
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


