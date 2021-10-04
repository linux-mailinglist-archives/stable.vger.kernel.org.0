Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1BD420BE6
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 14:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbhJDNBD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:01:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233957AbhJDM7b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 08:59:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D920E6140B;
        Mon,  4 Oct 2021 12:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352244;
        bh=IM0GVIETrA1TCgyu+Y0HSv9K4DcNrkaq6dSy2MZMlhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v0WjgaxQ+AbTWyf70q7erOVSuTrtWaczGHAOgIW+K+TjsX+bioaOtE7cKvWTkoM6Z
         3z5QHtgbye1cxuS2GG+oLNoeBGHK0Soz6eWQ0CoIiT4GoUUeqq+PqZBzCt3ARABN/K
         Mj8KKxTTwZ8cRy8OL1S4Gy2SLuQVME70+BdLu+bs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Slark Xiao <slark_xiao@163.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 12/57] USB: serial: option: add device id for Foxconn T99W265
Date:   Mon,  4 Oct 2021 14:51:56 +0200
Message-Id: <20211004125029.321831253@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125028.940212411@linuxfoundation.org>
References: <20211004125028.940212411@linuxfoundation.org>
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
@@ -2059,6 +2059,8 @@ static const struct usb_device_id option
 	  .driver_info = RSVD(0) | RSVD(1) | RSVD(6) },
 	{ USB_DEVICE(0x0489, 0xe0b5),						/* Foxconn T77W968 ESIM */
 	  .driver_info = RSVD(0) | RSVD(1) | RSVD(6) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x0489, 0xe0db, 0xff),			/* Foxconn T99W265 MBIM */
+	  .driver_info = RSVD(3) },
 	{ USB_DEVICE(0x1508, 0x1001),						/* Fibocom NL668 (IOT version) */
 	  .driver_info = RSVD(4) | RSVD(5) | RSVD(6) },
 	{ USB_DEVICE(0x2cb7, 0x0104),						/* Fibocom NL678 series */


