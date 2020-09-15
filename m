Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8354A26B720
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgIPARw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:17:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbgIOOWr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:22:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F918222B6;
        Tue, 15 Sep 2020 14:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179478;
        bh=xb21JpmSL5z8X/r5tjQs7XjVUCwJ5WDFMTSWWTE5/FQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kC5SkNhu2Ek5RXJB7yzKEQbOkmMqBliTs44gAKxFZ02xRsYfUO8AUkfXY3wl5CEWb
         KOwAPPsnyxjuTcuYsg56M22qpdxHO5nCgNolZKnKL12/dKjQWu4ikVR3GpR/v9d36Z
         jPKWFwF9zC+9iRgwQS9BujD0yic7tLgOhRqfobiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 76/78] USB: serial: option: add support for SIM7070/SIM7080/SIM7090 modules
Date:   Tue, 15 Sep 2020 16:13:41 +0200
Message-Id: <20200915140637.412317053@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140633.552502750@linuxfoundation.org>
References: <20200915140633.552502750@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aleksander Morgado <aleksander@aleksander.es>

commit 1ac698790819b83f39fd7ea4f6cdabee9bdd7b38 upstream.

These modules have 2 different USB layouts:

The default layout with PID 0x9205 (AT+CUSBSELNV=1) exposes 4 TTYs and
an ECM interface:

  T:  Bus=02 Lev=01 Prnt=01 Port=02 Cnt=01 Dev#=  6 Spd=480 MxCh= 0
  D:  Ver= 2.00 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
  P:  Vendor=1e0e ProdID=9205 Rev=00.00
  S:  Manufacturer=SimTech, Incorporated
  S:  Product=SimTech SIM7080
  S:  SerialNumber=1234567890ABCDEF
  C:  #Ifs= 6 Cfg#= 1 Atr=e0 MxPwr=500mA
  I:  If#=0x0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
  I:  If#=0x1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
  I:  If#=0x2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
  I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
  I:  If#=0x4 Alt= 0 #EPs= 1 Cls=02(commc) Sub=06 Prot=00 Driver=cdc_ether
  I:  If#=0x5 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=cdc_ether

The purpose of each TTY is as follows:
 * ttyUSB0: DIAG/QCDM port.
 * ttyUSB1: GNSS data.
 * ttyUSB2: AT-capable port (control).
 * ttyUSB3: AT-capable port (data).

In the secondary layout with PID=0x9206 (AT+CUSBSELNV=86) the module
exposes 6 TTY ports:

  T:  Bus=02 Lev=01 Prnt=01 Port=02 Cnt=01 Dev#=  8 Spd=480 MxCh= 0
  D:  Ver= 2.00 Cls=02(commc) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
  P:  Vendor=1e0e ProdID=9206 Rev=00.00
  S:  Manufacturer=SimTech, Incorporated
  S:  Product=SimTech SIM7080
  S:  SerialNumber=1234567890ABCDEF
  C:  #Ifs= 6 Cfg#= 1 Atr=e0 MxPwr=500mA
  I:  If#=0x0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
  I:  If#=0x1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
  I:  If#=0x2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
  I:  If#=0x3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
  I:  If#=0x4 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
  I:  If#=0x5 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=option

The purpose of each TTY is as follows:
 * ttyUSB0: DIAG/QCDM port.
 * ttyUSB1: GNSS data.
 * ttyUSB2: AT-capable port (control).
 * ttyUSB3: QFLOG interface.
 * ttyUSB4: DAM interface.
 * ttyUSB5: AT-capable port (data).

Signed-off-by: Aleksander Morgado <aleksander@aleksander.es>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1823,6 +1823,8 @@ static const struct usb_device_id option
 	{ USB_DEVICE_INTERFACE_CLASS(0x1e0e, 0x9003, 0xff) },	/* Simcom SIM7500/SIM7600 MBIM mode */
 	{ USB_DEVICE_INTERFACE_CLASS(0x1e0e, 0x9011, 0xff),	/* Simcom SIM7500/SIM7600 RNDIS mode */
 	  .driver_info = RSVD(7) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x1e0e, 0x9205, 0xff) },	/* Simcom SIM7070/SIM7080/SIM7090 AT+ECM mode */
+	{ USB_DEVICE_INTERFACE_CLASS(0x1e0e, 0x9206, 0xff) },	/* Simcom SIM7070/SIM7080/SIM7090 AT-only mode */
 	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_X060S_X200),
 	  .driver_info = NCTRL(0) | NCTRL(1) | RSVD(4) },
 	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_X220_X500D),


