Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B79DB493B0
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729355AbfFQV0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:26:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730301AbfFQV0y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:26:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F36BD20673;
        Mon, 17 Jun 2019 21:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806813;
        bh=FeheFKigpxGw75v9GJh3ld5FsQx3jZkBdirXQYlwRdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TvFhfNkHNJc9yiDZ1TnC1sP0NlOku2RZ5A57K+zhM3o0H9xPjUEgca4Rki8VKol12
         FB0mPXtwh3+k7nOwHa12iRmVT7keTc4R1/IS5cc6hotIcP0F1JAmFIvQlBdxDz2CwO
         3QvGAsEcmvTu4LnwjOvQDSRdOFZshqwe6xKvxG4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?J=C3=B6rgen=20Storvist?= <jorgen.storvist@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 64/75] USB: serial: option: add support for Simcom SIM7500/SIM7600 RNDIS mode
Date:   Mon, 17 Jun 2019 23:10:15 +0200
Message-Id: <20190617210755.531523682@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
References: <20190617210752.799453599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jörgen Storvist <jorgen.storvist@gmail.com>

commit 5417a7e482962952e622eabd60cd3600dd65dedf upstream.

Added IDs for Simcom SIM7500/SIM7600 series cellular module in RNDIS
mode. Reserved the interface for ADB.

T:  Bus=03 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  7 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1e0e ProdID=9011 Rev=03.18
S:  Manufacturer=SimTech, Incorporated
S:  Product=SimTech, Incorporated
S:  SerialNumber=0123456789ABCDEF
C:  #Ifs= 8 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#=0x0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=02 Prot=ff Driver=rndis_host
I:  If#=0x1 Alt= 0 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=rndis_host
I:  If#=0x2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x5 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x6 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x7 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)

Signed-off-by: Jörgen Storvist <jorgen.storvist@gmail.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1772,6 +1772,8 @@ static const struct usb_device_id option
 	{ USB_DEVICE(ALINK_VENDOR_ID, SIMCOM_PRODUCT_SIM7100E),
 	  .driver_info = RSVD(5) | RSVD(6) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x1e0e, 0x9003, 0xff) },	/* Simcom SIM7500/SIM7600 MBIM mode */
+	{ USB_DEVICE_INTERFACE_CLASS(0x1e0e, 0x9011, 0xff),	/* Simcom SIM7500/SIM7600 RNDIS mode */
+	  .driver_info = RSVD(7) },
 	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_X060S_X200),
 	  .driver_info = NCTRL(0) | NCTRL(1) | RSVD(4) },
 	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_X220_X500D),


