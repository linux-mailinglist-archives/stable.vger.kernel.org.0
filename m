Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1F951A776
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355041AbiEDRFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355080AbiEDREG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:04:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1554DF4D;
        Wed,  4 May 2022 09:52:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FE8BB827A5;
        Wed,  4 May 2022 16:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02A0C385A4;
        Wed,  4 May 2022 16:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683148;
        bh=Ug3fk8Vt8Pk8CQvWev9QH73Z1POTQgfDaPxABlOgu54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X5nA5xhaK2W8cl4kOXyGM2ey1LOqIbDAjS1WQJ0WJ0LGg+TSsa5T5xnZkbs5hkMbp
         ubvm65JhQkOaeh/5rNPVpkGz7MYsojXkk9YTMXBanVaGoQEMpvCaiw3YaKwE9gUHSj
         GJ+Uyl6fmu9l00AFSMQoB4vmI5aGULbJ9V1cd/Rs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Slark Xiao <slark_xiao@163.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 006/177] USB: serial: option: add support for Cinterion MV32-WA/MV32-WB
Date:   Wed,  4 May 2022 18:43:19 +0200
Message-Id: <20220504153054.244199917@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Slark Xiao <slark_xiao@163.com>

commit b4a64ed6e7b857317070fcb9d87ff5d4a73be3e8 upstream.

Add support for Cinterion device MV32-WA/MV32-WB. MV32-WA PID is
0x00F1, and MV32-WB PID is 0x00F2.

Test evidence as below:
T:  Bus=04 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  4 Spd=5000 MxCh= 0
D:  Ver= 3.20 Cls=ef(misc ) Sub=02 Prot=01 MxPS= 9 #Cfgs=  1
P:  Vendor=1e2d ProdID=00f1 Rev=05.04
S:  Manufacturer=Cinterion
S:  Product=Cinterion PID 0x00F1 USB Mobile Broadband
S:  SerialNumber=78ada8c4
C:  #Ifs= 6 Cfg#= 1 Atr=a0 MxPwr=896mA
I:  If#=0x0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=0e Prot=00 Driver=cdc_mbim
I:  If#=0x1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
I:  If#=0x3 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=60 Driver=option
I:  If#=0x5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option

T:  Bus=04 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  3 Spd=5000 MxCh= 0
D:  Ver= 3.20 Cls=ef(misc ) Sub=02 Prot=01 MxPS= 9 #Cfgs=  1
P:  Vendor=1e2d ProdID=00f2 Rev=05.04
S:  Manufacturer=Cinterion
S:  Product=Cinterion PID 0x00F2 USB Mobile Broadband
S:  SerialNumber=cdd06a78
C:  #Ifs= 6 Cfg#= 1 Atr=a0 MxPwr=896mA
I:  If#=0x0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=0e Prot=00 Driver=cdc_mbim
I:  If#=0x1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
I:  If#=0x3 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=60 Driver=option
I:  If#=0x5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option

Interface 0&1: MBIM, 2:Modem, 3: GNSS, 4: NMEA, 5: Diag
GNSS port don't use serial driver.

Signed-off-by: Slark Xiao <slark_xiao@163.com>
Link: https://lore.kernel.org/r/20220414074434.5699-1-slark_xiao@163.com
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -432,6 +432,8 @@ static void option_instat_callback(struc
 #define CINTERION_PRODUCT_CLS8			0x00b0
 #define CINTERION_PRODUCT_MV31_MBIM		0x00b3
 #define CINTERION_PRODUCT_MV31_RMNET		0x00b7
+#define CINTERION_PRODUCT_MV32_WA		0x00f1
+#define CINTERION_PRODUCT_MV32_WB		0x00f2
 
 /* Olivetti products */
 #define OLIVETTI_VENDOR_ID			0x0b3c
@@ -1969,6 +1971,10 @@ static const struct usb_device_id option
 	  .driver_info = RSVD(3)},
 	{ USB_DEVICE_INTERFACE_CLASS(CINTERION_VENDOR_ID, CINTERION_PRODUCT_MV31_RMNET, 0xff),
 	  .driver_info = RSVD(0)},
+	{ USB_DEVICE_INTERFACE_CLASS(CINTERION_VENDOR_ID, CINTERION_PRODUCT_MV32_WA, 0xff),
+	  .driver_info = RSVD(3)},
+	{ USB_DEVICE_INTERFACE_CLASS(CINTERION_VENDOR_ID, CINTERION_PRODUCT_MV32_WB, 0xff),
+	  .driver_info = RSVD(3)},
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD100),
 	  .driver_info = RSVD(4) },
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD120),


