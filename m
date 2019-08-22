Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFD0499A54
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390702AbfHVRMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:12:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390688AbfHVRJK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:09:10 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4902023406;
        Thu, 22 Aug 2019 17:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493749;
        bh=+IwE1oT+vmcEXCETz+J54K2pOa7K0ACqbqKZbQcAVmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oq4Kr3g4j23QdQ+6pAGUGa63LOZMTwtD9uQZJJIeIG9SSbX8oogTwUn+VMUfuWGvZ
         kYwlXqxJlrISW9A1rgqy+fEyK8uiZKMEwaTv/n1DDo95dKJ1uK7e2p+IinKmWjqKrb
         fDtLOnLKShfkXnAS12X7J5lKx0JWDkOrg5sk0wtM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Dan Williams <dan.j.williams@intel.com>,
        Lars Melin <larsm17@gmail.com>,
        Marcel Partap <mpartap@gmx.net>,
        Merlijn Wajer <merlijn@wizzup.org>,
        Michael Scott <hashcode0f@gmail.com>,
        NeKit <nekit1000@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sre@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 102/135] USB: serial: option: Add Motorola modem UARTs
Date:   Thu, 22 Aug 2019 13:07:38 -0400
Message-Id: <20190822170811.13303-103-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

commit 6caf0be40a707689e8ff8824fdb96ef77685b1ba upstream.

On Motorola Mapphone devices such as Droid 4 there are five USB ports
that do not use the same layout as Gobi 1K/2K/etc devices listed in
qcserial.c. So we should use qcaux.c or option.c as noted by
Dan Williams <dan.j.williams@intel.com>.

As the Motorola USB serial ports have an interrupt endpoint as shown
with lsusb -v, we should use option.c instead of qcaux.c as pointed out
by Johan Hovold <johan@kernel.org>.

The ff/ff/ff interfaces seem to always be UARTs on Motorola devices.
For the other interfaces, class 0x0a (CDC Data) should not in general
be added as they are typically part of a multi-interface function as
noted earlier by Bjørn Mork <bjorn@mork.no>.

However, looking at the Motorola mapphone kernel code, the mdm6600 0x0a
class is only used for flashing the modem firmware, and there are no
other interfaces. So I've added that too with more details below as it
works just fine.

The ttyUSB ports on Droid 4 are:

ttyUSB0 DIAG, CQDM-capable
ttyUSB1 MUX or NMEA, no response
ttyUSB2 MUX or NMEA, no response
ttyUSB3 TCMD
ttyUSB4 AT-capable

The ttyUSB0 is detected as QCDM capable by ModemManager. I think
it's only used for debugging with ModemManager --debug for sending
custom AT commands though. ModemManager already can manage data
connection using the USB QMI ports that are already handled by the
qmi_wwan.c driver.

To enable the MUX or NMEA ports, it seems that something needs to be
done additionally to enable them, maybe via the DIAG or TCMD port.
It might be just a NVRAM setting somewhere, but I have no idea what
NVRAM settings may need changing for that.

The TCMD port seems to be a Motorola custom protocol for testing
the modem and to configure it's NVRAM and seems to work just fine
based on a quick test with a minimal tcmdrw tool I wrote.

The voice modem AT-capable port seems to provide only partial
support, and no PM support compared to the TS 27.010 based UART
wired directly to the modem.

The UARTs added with this change are the same product IDs as the
Motorola Mapphone Android Linux kernel mdm6600_id_table. I don't
have any mdm9600 based devices, so I have only tested these on
mdm6600 based droid 4.

Then for the class 0x0a (CDC Data) mode, the Motorola Mapphone Android
Linux kernel driver moto_flashqsc.c just seems to change the
port->bulk_out_size to 8K from the default. And is only used for
flashing the modem firmware it seems.

I've verified that flashing the modem with signed firmware works just
fine with the option driver after manually toggling the GPIO pins, so
I've added droid 4 modem flashing mode to the option driver. I've not
added the other devices listed in moto_flashqsc.c in case they really
need different port->bulk_out_size. Those can be added as they get
tested to work for flashing the modem.

After this patch the output of /sys/kernel/debug/usb/devices has
the following for normal 22b8:2a70 mode including the related qmi_wwan
interfaces:

T:  Bus=01 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=12   MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=22b8 ProdID=2a70 Rev= 0.00
S:  Manufacturer=Motorola, Incorporated
S:  Product=Flash MZ600
C:* #Ifs= 9 Cfg#= 1 Atr=e0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
E:  Ad=81(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
E:  Ad=83(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
E:  Ad=84(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
E:  Ad=85(I) Atr=03(Int.) MxPS=  64 Ivl=5ms
E:  Ad=86(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=05(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 5 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=fb Prot=ff Driver=qmi_wwan
E:  Ad=87(I) Atr=03(Int.) MxPS=  64 Ivl=5ms
E:  Ad=88(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=06(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 6 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=fb Prot=ff Driver=qmi_wwan
E:  Ad=89(I) Atr=03(Int.) MxPS=  64 Ivl=5ms
E:  Ad=8a(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=07(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 7 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=fb Prot=ff Driver=qmi_wwan
E:  Ad=8b(I) Atr=03(Int.) MxPS=  64 Ivl=5ms
E:  Ad=8c(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=08(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 8 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=fb Prot=ff Driver=qmi_wwan
E:  Ad=8d(I) Atr=03(Int.) MxPS=  64 Ivl=5ms
E:  Ad=8e(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=09(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms

In 22b8:900e "qc_dload" mode the device shows up as:

T:  Bus=01 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=12   MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=22b8 ProdID=900e Rev= 0.00
S:  Manufacturer=Motorola, Incorporated
S:  Product=Flash MZ600
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
E:  Ad=81(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms

And in 22b8:4281 "ram_downloader" mode the device shows up as:

T:  Bus=01 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=12   MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=22b8 ProdID=4281 Rev= 0.00
S:  Manufacturer=Motorola, Incorporated
S:  Product=Flash MZ600
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=0a(data ) Sub=00 Prot=fc Driver=option
E:  Ad=81(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms

Cc: Bjørn Mork <bjorn@mork.no>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Lars Melin <larsm17@gmail.com>
Cc: Marcel Partap <mpartap@gmx.net>
Cc: Merlijn Wajer <merlijn@wizzup.org>
Cc: Michael Scott <hashcode0f@gmail.com>
Cc: NeKit <nekit1000@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Sebastian Reichel <sre@kernel.org>
Tested-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 699cab453fbf6..38e920ac7f820 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -968,6 +968,11 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x7B) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x7C) },
 
+	/* Motorola devices */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x22b8, 0x2a70, 0xff, 0xff, 0xff) },	/* mdm6600 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x22b8, 0x2e0a, 0xff, 0xff, 0xff) },	/* mdm9600 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x22b8, 0x4281, 0x0a, 0x00, 0xfc) },	/* mdm ram dl */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x22b8, 0x900e, 0xff, 0xff, 0xff) },	/* mdm qc dl */
 
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V640) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V620) },
-- 
2.20.1

