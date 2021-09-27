Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077B3419A01
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235859AbhI0RGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:06:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235861AbhI0RFp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:05:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35C3C60F46;
        Mon, 27 Sep 2021 17:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762247;
        bh=iKMWTf6Aovb7NfIQc1w2JiEwar/E+TOzVoBWKnmjd/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O6RssO6Mm93as58z47OIJUHtSKOr+1PTjfy36AkPZBPlyLHMcsDzirzuoKwI7AWk+
         Qqy9nhXAnN/YHzQH9J7w5HjeseRMXkzpPkHS+3HYPDcoDE4SCmIjmnHOva6KZIkt78
         VcH7a35siPthqmBxdIKQVOkN20bxGXNGjUWFEJEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Slark Xiao <slark_xiao@163.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 18/68] USB: serial: option: add device id for Foxconn T99W265
Date:   Mon, 27 Sep 2021 19:02:14 +0200
Message-Id: <20210927170220.584598479@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
References: <20210927170219.901812470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Slark Xiao <slark_xiao@163.com>

commit 9e3eed534f8235a4a596a9dae5b8a6425d81ea1a upstream.

Adding support for Foxconn device T99W265 for enumeration with
PID 0xe0db.

usb-devices output for 0xe0db
T:  Bus=04 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#= 19 Spd=5000 MxCh= 0
D:  Ver= 3.20 Cls=ef(misc ) Sub=02 Prot=01 MxPS= 9 #Cfgs=  1
P:  Vendor=0489 ProdID=e0db Rev=05.04
S:  Manufacturer=Microsoft
S:  Product=Generic Mobile Broadband Adapter
S:  SerialNumber=6c50f452
C:  #Ifs= 5 Cfg#= 1 Atr=a0 MxPwr=896mA
I:  If#=0x0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=0e Prot=00 Driver=cdc_mbim
I:  If#=0x1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
I:  If#=0x3 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#=0x4 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option

if0/1: MBIM, if2:Diag, if3:GNSS, if4: Modem

Signed-off-by: Slark Xiao <slark_xiao@163.com>
Link: https://lore.kernel.org/r/20210917110106.9852-1-slark_xiao@163.com
[ johan: use USB_DEVICE_INTERFACE_CLASS(), amend comment ]
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2075,6 +2075,8 @@ static const struct usb_device_id option
 	  .driver_info = RSVD(0) | RSVD(1) | RSVD(6) },
 	{ USB_DEVICE(0x0489, 0xe0b5),						/* Foxconn T77W968 ESIM */
 	  .driver_info = RSVD(0) | RSVD(1) | RSVD(6) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x0489, 0xe0db, 0xff),			/* Foxconn T99W265 MBIM */
+	  .driver_info = RSVD(3) },
 	{ USB_DEVICE(0x1508, 0x1001),						/* Fibocom NL668 (IOT version) */
 	  .driver_info = RSVD(4) | RSVD(5) | RSVD(6) },
 	{ USB_DEVICE(0x2cb7, 0x0104),						/* Fibocom NL678 series */


