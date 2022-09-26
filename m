Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9994E5E9FC8
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235577AbiIZK3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235711AbiIZK24 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:28:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C2D4E611;
        Mon, 26 Sep 2022 03:19:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E531DB80924;
        Mon, 26 Sep 2022 10:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA07C433C1;
        Mon, 26 Sep 2022 10:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187494;
        bh=4dbwDwZ0eBnfjVz2XPlQVhmi10ewahaSZNSGTnSir1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wcIuVbyX12DA6ARl8Ozde+Vbf5C8+oFdNZ44HxhgOGmHF57Pjv5Ehw3Vt5M9fUTeu
         395PMaAfCb6K0puV8iUhQs0UjTdZ+sM4OYqYu+ntSBhCx5mrca117iICWiWfIK4LTn
         SHppCcDuSPdIh7pxf+O0AZZef/lyFglfLZS1SDUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carl Yin <carl.yin@quectel.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 26/58] USB: serial: option: add Quectel BG95 0x0203 composition
Date:   Mon, 26 Sep 2022 12:11:45 +0200
Message-Id: <20220926100742.407107628@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100741.430882406@linuxfoundation.org>
References: <20220926100741.430882406@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Carl Yin(殷张成) <carl.yin@quectel.com>

commit f8f67eff6847f9b8d753fa029723bcc54296055a upstream.

Add support for the following Quectel BG95 composition:

0x0203: Diag + GNSS + Modem + ECM

usb-devices output:
T:  Bus=01 Lev=01 Prnt=01 Port=03 Cnt=01 Dev#=  2 Spd=480  MxCh= 0
D:  Ver= 2.00 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=2c7c ProdID=0203 Rev= 0.00
S:  Manufacturer=Quectel, Incorporated
S:  Product=Quectel LPWA Module
S:  SerialNumber=71d3a21b
C:* #Ifs= 5 Cfg#= 1 Atr=e0 MxPwr=500mA
A:  FirstIf#= 3 IfCount= 2 Cls=02(comm.) Sub=00 Prot=00
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=60 Driver=option
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
E:  Ad=83(I) Atr=03(Int.) MxPS=  64 Ivl=2ms
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 1 Cls=02(comm.) Sub=06 Prot=00 Driver=cdc_ether
E:  Ad=85(I) Atr=03(Int.) MxPS=  64 Ivl=2ms
I:  If#= 4 Alt= 0 #EPs= 0 Cls=0a(data ) Sub=00 Prot=00 Driver=cdc_ether
I:* If#= 4 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=cdc_ether
E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Signed-off-by: Carl Yin <carl.yin@quectel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1138,6 +1138,8 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EG95, 0xff, 0xff, 0xff),
 	  .driver_info = NUMEP2 },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EG95, 0xff, 0, 0) },
+	{ USB_DEVICE_INTERFACE_CLASS(QUECTEL_VENDOR_ID, 0x0203, 0xff), /* BG95-M3 */
+	  .driver_info = ZLP },
 	{ USB_DEVICE(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_BG96),
 	  .driver_info = RSVD(4) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EP06, 0xff, 0xff, 0xff),


