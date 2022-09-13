Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C76F5B7550
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236695AbiIMPkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236911AbiIMPjW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:39:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABEA56B67B;
        Tue, 13 Sep 2022 07:45:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EB24614D8;
        Tue, 13 Sep 2022 14:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B91CC433C1;
        Tue, 13 Sep 2022 14:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079648;
        bh=TCIma7NPREKAXuZtFQo3nopI/p7CcBG1rtrR+ZyVvq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O1loZK9+GrXtqY8l3sjXFCe1cI6L4WkjP+SDgPSkxEyGfLUJ+tVNLkSFupwzwVV3z
         UMWgeEruGACxQdGTqsj4jB07dNh8UeLuFYXTqdML5XxQyqUdMvgbO58RxRSPMeCWmR
         rh2Me5KbmXYfRUF6rRjsexKy6rCXtUICweBFP1rY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yan Xinyu <sdlyyxy@bupt.edu.cn>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 20/61] USB: serial: option: add support for OPPO R11 diag port
Date:   Tue, 13 Sep 2022 16:07:22 +0200
Message-Id: <20220913140347.523762859@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140346.422813036@linuxfoundation.org>
References: <20220913140346.422813036@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Yan Xinyu <sdlyyxy@bupt.edu.cn>

commit 8d5fc280392735e4441b35de14f2f4860fa8d83c upstream.

Add support for OPPO R11 USB diag serial port to option driver. This
phone uses Qualcomm Snapdragon 660 SoC.

usb-devices output:
T:  Bus=03 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#= 10 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=22d9 ProdID=276c Rev=04.04
S:  Manufacturer=OPPO
S:  Product=SDM660-MTP _SN:09C6BCA7
S:  SerialNumber=beb2c403
C:  #Ifs= 2 Cfg#= 1 Atr=80 MxPwr=500mA
I:  If#=0x0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
I:  If#=0x1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=usbfs

Signed-off-by: Yan Xinyu <sdlyyxy@bupt.edu.cn>
Link: https://lore.kernel.org/r/20220714102037.4113889-1-sdlyyxy@bupt.edu.cn
Link: https://lore.kernel.org/r/Yt1WfSZk03Plpnan@hovoldconsulting.com
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -576,6 +576,10 @@ static void option_instat_callback(struc
 #define WETELECOM_PRODUCT_6802			0x6802
 #define WETELECOM_PRODUCT_WMD300		0x6803
 
+/* OPPO products */
+#define OPPO_VENDOR_ID				0x22d9
+#define OPPO_PRODUCT_R11			0x276c
+
 
 /* Device flags */
 
@@ -2157,6 +2161,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE_INTERFACE_CLASS(0x305a, 0x1404, 0xff) },			/* GosunCn GM500 RNDIS */
 	{ USB_DEVICE_INTERFACE_CLASS(0x305a, 0x1405, 0xff) },			/* GosunCn GM500 MBIM */
 	{ USB_DEVICE_INTERFACE_CLASS(0x305a, 0x1406, 0xff) },			/* GosunCn GM500 ECM/NCM */
+	{ USB_DEVICE_AND_INTERFACE_INFO(OPPO_VENDOR_ID, OPPO_PRODUCT_R11, 0xff, 0xff, 0x30) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);


