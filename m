Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 820C74BE105
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347063AbiBUJDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:03:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348268AbiBUJCg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:02:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE412BB20;
        Mon, 21 Feb 2022 00:57:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AE3561137;
        Mon, 21 Feb 2022 08:57:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03608C340EB;
        Mon, 21 Feb 2022 08:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433850;
        bh=DFsLvK0i3BObqF26aZZdRrDS2/spMsYEUdcIUmBugTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgWFHK/DO84hIEo3lN1Nnkz0SjaX9/wA0OJmFm4rMIxkTZS2IfU1s6jrXSGqTFpC6
         RhL75qrfOOYSLyR7MPPhSZFdEya+dYFzBiXUwNgXyjDdusbUK/W8moo6TTPReyc44k
         BwG1q9p/1TMUtevR7sMCfG1PYRDCOsdwcSR4DrUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Slark Xiao <slark_xiao@163.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 57/58] net: usb: qmi_wwan: Add support for Dell DW5829e
Date:   Mon, 21 Feb 2022 09:49:50 +0100
Message-Id: <20220221084913.715265851@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084911.895146879@linuxfoundation.org>
References: <20220221084911.895146879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Slark Xiao <slark_xiao@163.com>

[ Upstream commit 8ecbb179286cbc91810c16caeb3396e06305cd0c ]

Dell DW5829e same as DW5821e except the CAT level.
DW5821e supports CAT16 but DW5829e supports CAT9.
Also, DW5829e includes normal and eSIM type.
Please see below test evidence:

T:  Bus=04 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  5 Spd=5000 MxCh= 0
D:  Ver= 3.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS= 9 #Cfgs=  1
P:  Vendor=413c ProdID=81e6 Rev=03.18
S:  Manufacturer=Dell Inc.
S:  Product=DW5829e Snapdragon X20 LTE
S:  SerialNumber=0123456789ABCDEF
C:  #Ifs= 6 Cfg#= 1 Atr=a0 MxPwr=896mA
I:  If#=0x0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
I:  If#=0x1 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=00 Prot=00 Driver=usbhid
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option

T:  Bus=04 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  7 Spd=5000 MxCh= 0
D:  Ver= 3.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS= 9 #Cfgs=  1
P:  Vendor=413c ProdID=81e4 Rev=03.18
S:  Manufacturer=Dell Inc.
S:  Product=DW5829e-eSIM Snapdragon X20 LTE
S:  SerialNumber=0123456789ABCDEF
C:  #Ifs= 6 Cfg#= 1 Atr=a0 MxPwr=896mA
I:  If#=0x0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
I:  If#=0x1 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=00 Prot=00 Driver=usbhid
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option

Signed-off-by: Slark Xiao <slark_xiao@163.com>
Acked-by: Bjørn Mork <bjorn@mork.no>
Link: https://lore.kernel.org/r/20220209024717.8564-1-slark_xiao@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 54b37a30df18b..c2e872f926f1c 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1358,6 +1358,8 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x413c, 0x81d7, 0)},	/* Dell Wireless 5821e */
 	{QMI_FIXED_INTF(0x413c, 0x81d7, 1)},	/* Dell Wireless 5821e preproduction config */
 	{QMI_FIXED_INTF(0x413c, 0x81e0, 0)},	/* Dell Wireless 5821e with eSIM support*/
+	{QMI_FIXED_INTF(0x413c, 0x81e4, 0)},	/* Dell Wireless 5829e with eSIM support*/
+	{QMI_FIXED_INTF(0x413c, 0x81e6, 0)},	/* Dell Wireless 5829e */
 	{QMI_FIXED_INTF(0x03f0, 0x4e1d, 8)},	/* HP lt4111 LTE/EV-DO/HSPA+ Gobi 4G Module */
 	{QMI_FIXED_INTF(0x03f0, 0x9d1d, 1)},	/* HP lt4120 Snapdragon X5 LTE */
 	{QMI_FIXED_INTF(0x22de, 0x9061, 3)},	/* WeTelecom WPD-600N */
-- 
2.34.1



