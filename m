Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956D832D423
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 14:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbhCDN1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 08:27:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:47110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235094AbhCDN1c (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 08:27:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA17764F21;
        Thu,  4 Mar 2021 13:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614864412;
        bh=lg6tqSU2HTWwyV3FgjNK7XlYEbcYvLdT7cvSOXtsjrk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KBeJM7pDE9F8IchvVZQM2VT729nDdHa1WHHqseepqBatNSJRUMiqW8BT/ylrEzLV2
         l7LFijeQNBlYW9JOJ9cNuCnc8wrgTceeyjOlO0Js6nkO/fDB381//lGJn4wwtNgb3N
         sjuBMiv8F0rjbLWvu1frf2Jtky1lxlJDSn1qYgNg=
Date:   Thu, 4 Mar 2021 14:26:49 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Lech Perczak <lech.perczak@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: Re: [PATCH 5.10 491/663] USB: serial: option: update interface
 mapping for ZTE P685M
Message-ID: <YEDgGY/VwiDM1jec@kroah.com>
References: <20210301161141.760350206@linuxfoundation.org>
 <20210301161206.139213430@linuxfoundation.org>
 <07edca19-417d-4dab-adeb-cae7b2b17708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <07edca19-417d-4dab-adeb-cae7b2b17708@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 04, 2021 at 12:58:19AM +0100, Lech Perczak wrote:
> Hi,
> 
> On 2021-03-01 at 17:12, Greg Kroah-Hartman wrote:
> > From: Lech Perczak <lech.perczak@gmail.com>
> > 
> > commit 6420a569504e212d618d4a4736e2c59ed80a8478 upstream.
> > 
> > This patch prepares for qmi_wwan driver support for the device.
> > Previously "option" driver mapped itself to interfaces 0 and 3 (matching
> > ff/ff/ff), while interface 3 is in fact a QMI port.
> > Interfaces 1 and 2 (matching ff/00/00) expose AT commands,
> > and weren't supported previously at all.
> > Without this patch, a possible conflict would exist if device ID was
> > added to qmi_wwan driver for interface 3.
> > 
> > Update and simplify device ID to match interfaces 0-2 directly,
> > to expose QCDM (0), PCUI (1), and modem (2) ports and avoid conflict
> > with QMI (3), and ADB (4).
> > 
> > The modem is used inside ZTE MF283+ router and carriers identify it as
> > such.
> > Interface mapping is:
> > 0: QCDM, 1: AT (PCUI), 2: AT (Modem), 3: QMI, 4: ADB
> > 
> > T:  Bus=02 Lev=02 Prnt=02 Port=05 Cnt=01 Dev#=  3 Spd=480  MxCh= 0
> > D:  Ver= 2.01 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> > P:  Vendor=19d2 ProdID=1275 Rev=f0.00
> > S:  Manufacturer=ZTE,Incorporated
> > S:  Product=ZTE Technologies MSM
> > S:  SerialNumber=P685M510ZTED0000CP&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&0
> > C:* #Ifs= 5 Cfg#= 1 Atr=a0 MxPwr=500mA
> > I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
> > E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> > E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> > I:* If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> > E:  Ad=83(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
> > E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> > E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> > I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> > E:  Ad=85(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
> > E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> > E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> > I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
> > E:  Ad=87(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
> > E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> > E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> > I:* If#= 4 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
> > E:  Ad=88(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> > E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> > 
> > Cc: Johan Hovold <johan@kernel.org>
> > Cc: Bjørn Mork <bjorn@mork.no>
> > Signed-off-by: Lech Perczak <lech.perczak@gmail.com>
> > Link: https://lore.kernel.org/r/20210207005443.12936-1-lech.perczak@gmail.com
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >   drivers/usb/serial/option.c |    3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > --- a/drivers/usb/serial/option.c
> > +++ b/drivers/usb/serial/option.c
> > @@ -1569,7 +1569,8 @@ static const struct usb_device_id option
> >   	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1272, 0xff, 0xff, 0xff) },
> >   	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1273, 0xff, 0xff, 0xff) },
> >   	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1274, 0xff, 0xff, 0xff) },
> > -	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1275, 0xff, 0xff, 0xff) },
> > +	{ USB_DEVICE(ZTE_VENDOR_ID, 0x1275),	/* ZTE P685M */
> > +	  .driver_info = RSVD(3) | RSVD(4) },
> >   	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1276, 0xff, 0xff, 0xff) },
> >   	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1277, 0xff, 0xff, 0xff) },
> >   	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1278, 0xff, 0xff, 0xff) },
> > 
> > 
> If this patch is selected, then 88eee9b7b42e69fb622ddb3ff6f37e8e4347f5b2
> ("net: usb: qmi_wwan: support ZTE P685M modem")
> probably should be selected, too. This patch frees up an interface to be
> claimed by qmi_wwan driver by the mentioned patch.
> The mentioned patch only adds a device ID to qmi_wwan driver.
> 
> In my opinion, those two should come in pair. Regarding version, I think
> that backporting to 5.4.y and later is enough, as OpenWrt,
> from which those patches originate is currently on 5.4.y on the target
> requiring it, and will move to 5.10.y soon.
> Backporting this would certainly make OpenWrt folks happy, however I don't
> insist on it.

Now queued up, thanks.

greg k-h
