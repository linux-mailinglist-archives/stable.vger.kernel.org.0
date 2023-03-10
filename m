Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66F726B40AD
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbjCJNo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:44:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCJNov (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:44:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0AFE78C93
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:44:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 448A4617AF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:44:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4E8C433EF;
        Fri, 10 Mar 2023 13:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678455888;
        bh=/RhQubbgjR3Nx7/cr7K0N2rhLKwZwhmgjCzlE592XvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GQXdGUSHuZjDRlWiVYTVay5gNQgnB4f0QtuO/POKPytt7YzhfOpiOswnpwWlpuxus
         NP4VmJ1gZvCfwJPI5btFmzkufn6ceXVDVVQ+6DaKxrCm95drZR1xVxM26aMaif2YU0
         fkCf6bha+bVBti8pFFbg7mHDJB7cLjglPMq9HRpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Florian Zumbiehl <florz@florz.de>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 010/193] USB: serial: option: add support for VW/Skoda "Carstick LTE"
Date:   Fri, 10 Mar 2023 14:36:32 +0100
Message-Id: <20230310133711.279139654@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Zumbiehl <florz@florz.de>

commit 617c331d91077f896111044628c096802551dc66 upstream.

Add support for VW/Skoda "Carstick LTE"

D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1c9e ProdID=7605 Rev=02.00
S:  Manufacturer=USB Modem
S:  Product=USB Modem
C:  #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=500mA
I:  If#=0x0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#=0x1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)

The stick has AT command interfaces on interfaces 1, 2, and 3, and does PPP
on interface 3.

Signed-off-by: Florian Zumbiehl <florz@florz.de>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -405,6 +405,8 @@ static void option_instat_callback(struc
 #define LONGCHEER_VENDOR_ID			0x1c9e
 
 /* 4G Systems products */
+/* This one was sold as the VW and Skoda "Carstick LTE" */
+#define FOUR_G_SYSTEMS_PRODUCT_CARSTICK_LTE	0x7605
 /* This is the 4G XS Stick W14 a.k.a. Mobilcom Debitel Surf-Stick *
  * It seems to contain a Qualcomm QSC6240/6290 chipset            */
 #define FOUR_G_SYSTEMS_PRODUCT_W14		0x9603
@@ -1979,6 +1981,8 @@ static const struct usb_device_id option
 	  .driver_info = RSVD(2) },
 	{ USB_DEVICE(AIRPLUS_VENDOR_ID, AIRPLUS_PRODUCT_MCD650) },
 	{ USB_DEVICE(TLAYTECH_VENDOR_ID, TLAYTECH_PRODUCT_TEU800) },
+	{ USB_DEVICE(LONGCHEER_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_CARSTICK_LTE),
+	  .driver_info = RSVD(0) },
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W14),
 	  .driver_info = NCTRL(0) | NCTRL(1) },
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W100),


