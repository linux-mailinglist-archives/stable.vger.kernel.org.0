Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE4A177FDB
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732277AbgCCRxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:53:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:33768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732282AbgCCRxQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:53:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56B342072D;
        Tue,  3 Mar 2020 17:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257995;
        bh=OfcuyefYI3hSHKkMabhA0vDxDytTX9d3JOM+9rGO+fw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UAHOqC00BLY7qAFAla4NBKY8+RQyPRsmfUjawDaBy3vkpDE4ic2uUcnLcVeZMGczE
         sE6dp24YMAyJfbhCi9oqz4k9csCu+0/NHmtiUcj25CIEL6OmV5JH4FzhMyvPHoOpPB
         hsyMsi8h12e0N2pH18VWA1EITTZqIyIUHi1WRajo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars Melin <larsm17@gmail.com>,
        Aleksander Morgado <aleksander@aleksander.es>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 031/152] qmi_wwan: re-add DW5821e pre-production variant
Date:   Tue,  3 Mar 2020 18:42:09 +0100
Message-Id: <20200303174305.972706595@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>

[ Upstream commit 88bf54603f6f2c137dfee1abf6436ceac3528d2d ]

Commit f25e1392fdb5 removed the support for the pre-production variant
of the Dell DW5821e to avoid probing another USB interface unnecessarily.
However, the pre-production samples are found in the wild, and this lack
of support is causing problems for users of such samples.  It is therefore
necessary to support both variants.

Matching on both interfaces 0 and 1 is not expected to cause any problem
with either variant, as only the QMI function will be probed successfully
on either.  Interface 1 will be rejected based on the HID class for the
production variant:

T:  Bus=01 Lev=03 Prnt=04 Port=00 Cnt=01 Dev#= 16 Spd=480 MxCh= 0
D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  2
P:  Vendor=413c ProdID=81d7 Rev=03.18
S:  Manufacturer=DELL
S:  Product=DW5821e Snapdragon X20 LTE
S:  SerialNumber=0123456789ABCDEF
C:  #Ifs= 6 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
I:  If#= 1 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=00 Prot=00 Driver=usbhid
I:  If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#= 5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option

And interface 0 will be rejected based on too few endpoints for the
pre-production variant:

T: Bus=01 Lev=02 Prnt=02 Port=03 Cnt=03 Dev#= 7 Spd=480 MxCh= 0
D: Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs= 2
P: Vendor=413c ProdID=81d7 Rev= 3.18
S: Manufacturer=DELL
S: Product=DW5821e Snapdragon X20 LTE
S: SerialNumber=0123456789ABCDEF
C: #Ifs= 5 Cfg#= 1 Atr=a0 MxPwr=500mA
I: If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=
I: If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
I: If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I: If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I: If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option

Fixes: f25e1392fdb5 ("qmi_wwan: fix interface number for DW5821e production firmware")
Link: https://whrl.pl/Rf0vNk
Reported-by: Lars Melin <larsm17@gmail.com>
Cc: Aleksander Morgado <aleksander@aleksander.es>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 9485c8d1de8a3..839cef720cf64 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1363,6 +1363,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x413c, 0x81b6, 8)},	/* Dell Wireless 5811e */
 	{QMI_FIXED_INTF(0x413c, 0x81b6, 10)},	/* Dell Wireless 5811e */
 	{QMI_FIXED_INTF(0x413c, 0x81d7, 0)},	/* Dell Wireless 5821e */
+	{QMI_FIXED_INTF(0x413c, 0x81d7, 1)},	/* Dell Wireless 5821e preproduction config */
 	{QMI_FIXED_INTF(0x413c, 0x81e0, 0)},	/* Dell Wireless 5821e with eSIM support*/
 	{QMI_FIXED_INTF(0x03f0, 0x4e1d, 8)},	/* HP lt4111 LTE/EV-DO/HSPA+ Gobi 4G Module */
 	{QMI_FIXED_INTF(0x03f0, 0x9d1d, 1)},	/* HP lt4120 Snapdragon X5 LTE */
-- 
2.20.1



