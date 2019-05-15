Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 624C41EF37
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732866AbfEOLbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:31:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732379AbfEOLbW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:31:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D701F2084F;
        Wed, 15 May 2019 11:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919881;
        bh=f+/E2dM8tseZgOi6tp1gOUPwluA21xqL5ItupbIbfPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qvuve4d970pqV9AeelC/vHeRiihj8Hxl7KIDQCgOuReK9XXIaXmJ4DgaF90a/RnR9
         CKUobI38OzkTaGRJCasR5YoloAKdi5KW2SYAVPR+ZtfjlPI1aOuyLlvm/RcCSLhYni
         x19ksNck+KbbwRWjIU6wnQ09El2TjZVoXEHKpRM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 122/137] aqc111: fix double endianness swap on BE
Date:   Wed, 15 May 2019 12:56:43 +0200
Message-Id: <20190515090702.572049973@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 2cf672709beb005f6e90cb4edbed6f2218ba953e ]

If you are using a function that does a swap in place,
you cannot just reuse the buffer on the assumption that it has
not been changed.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/aqc111.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -1428,7 +1428,7 @@ static int aqc111_resume(struct usb_inte
 {
 	struct usbnet *dev = usb_get_intfdata(intf);
 	struct aqc111_data *aqc111_data = dev->driver_priv;
-	u16 reg16;
+	u16 reg16, oldreg16;
 	u8 reg8;
 
 	netif_carrier_off(dev->net);
@@ -1444,9 +1444,11 @@ static int aqc111_resume(struct usb_inte
 	/* Configure RX control register => start operation */
 	reg16 = aqc111_data->rxctl;
 	reg16 &= ~SFR_RX_CTL_START;
+	/* needs to be saved in case endianness is swapped */
+	oldreg16 = reg16;
 	aqc111_write16_cmd_nopm(dev, AQ_ACCESS_MAC, SFR_RX_CTL, 2, &reg16);
 
-	reg16 |= SFR_RX_CTL_START;
+	reg16 = oldreg16 | SFR_RX_CTL_START;
 	aqc111_write16_cmd_nopm(dev, AQ_ACCESS_MAC, SFR_RX_CTL, 2, &reg16);
 
 	aqc111_set_phy_speed(dev, aqc111_data->autoneg,


