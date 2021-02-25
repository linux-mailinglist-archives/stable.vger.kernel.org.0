Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C4F324D85
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 11:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbhBYKCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 05:02:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:35150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233734AbhBYJ7g (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 04:59:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D47F64F21;
        Thu, 25 Feb 2021 09:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614246929;
        bh=fCAN+h/NbCmdQzE9+XALKEyd32GFbAckkQ2+ot+svxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zrBCS3u4Bcanu181zS9TSN7QgEFHlv6X4MVwNoi9YHfhf0vzYFwEfD3d6FK8eMbNC
         Sz9NdMByHxNp1HP5H1Yps5imbPM8Z0UcRxN7E3KDjncN3JervexMmS23WAEr1ybxXn
         DWUcMir7PMh11D5VNmtLe/I280qxzWIaqx6t4VPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christoph Schemmel <christoph.schemmel@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 19/23] NET: usb: qmi_wwan: Adding support for Cinterion MV31
Date:   Thu, 25 Feb 2021 10:53:50 +0100
Message-Id: <20210225092517.445568197@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210225092516.531932232@linuxfoundation.org>
References: <20210225092516.531932232@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Schemmel <christoph.schemmel@gmail.com>

[ Upstream commit a4dc7eee9106a9d2a6e08b442db19677aa9699c7 ]

Adding support for Cinterion MV31 with PID 0x00B7.

T:  Bus=04 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#= 11 Spd=5000 MxCh= 0
D:  Ver= 3.20 Cls=ef(misc ) Sub=02 Prot=01 MxPS= 9 #Cfgs=  1
P:  Vendor=1e2d ProdID=00b7 Rev=04.14
S:  Manufacturer=Cinterion
S:  Product=Cinterion USB Mobile Broadband
S:  SerialNumber=b3246eed
C:  #Ifs= 4 Cfg#= 1 Atr=a0 MxPwr=896mA
I:  If#=0x0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
I:  If#=0x1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option

Signed-off-by: Christoph Schemmel <christoph.schemmel@gmail.com>
Link: https://lore.kernel.org/r/20210202084523.4371-1-christoph.schemmel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index ce73df4c137ea..b223536e07bed 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1332,6 +1332,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x1e2d, 0x0082, 5)},	/* Cinterion PHxx,PXxx (2 RmNet) */
 	{QMI_FIXED_INTF(0x1e2d, 0x0083, 4)},	/* Cinterion PHxx,PXxx (1 RmNet + USB Audio)*/
 	{QMI_QUIRK_SET_DTR(0x1e2d, 0x00b0, 4)},	/* Cinterion CLS8 */
+	{QMI_FIXED_INTF(0x1e2d, 0x00b7, 0)},	/* Cinterion MV31 RmNet */
 	{QMI_FIXED_INTF(0x413c, 0x81a2, 8)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card */
 	{QMI_FIXED_INTF(0x413c, 0x81a3, 8)},	/* Dell Wireless 5570 HSPA+ (42Mbps) Mobile Broadband Card */
 	{QMI_FIXED_INTF(0x413c, 0x81a4, 8)},	/* Dell Wireless 5570e HSPA+ (42Mbps) Mobile Broadband Card */
-- 
2.27.0



