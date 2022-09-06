Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2EB25AEA42
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbiIFNju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240819AbiIFNip (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:38:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD082703;
        Tue,  6 Sep 2022 06:35:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73D8B6154E;
        Tue,  6 Sep 2022 13:34:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831A1C433C1;
        Tue,  6 Sep 2022 13:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471292;
        bh=qOPfv6rN3G08Au0xWngt92uuyIDREJjHLEVh3jzqV5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pUMHJY4J4Imi33CuPVbC4Ak1v+nAWgB5p+uRwwqz2joxtWLOGD6NPZm3DXBrmSsP2
         n8fXQGwY3rGYpudWhyXOcDa1YfyEKOflvGR1LZd4KyiOAb3XoJjnmxPhRmJnpsUjkJ
         VD07oAnd2E5KyDT8MYAuz/Yh9KfcnwT4l9BONMEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yan Xinyu <sdlyyxy@bupt.edu.cn>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 53/80] USB: serial: option: add support for OPPO R11 diag port
Date:   Tue,  6 Sep 2022 15:30:50 +0200
Message-Id: <20220906132819.257861371@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
References: <20220906132816.936069583@linuxfoundation.org>
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
@@ -573,6 +573,10 @@ static void option_instat_callback(struc
 #define WETELECOM_PRODUCT_6802			0x6802
 #define WETELECOM_PRODUCT_WMD300		0x6803
 
+/* OPPO products */
+#define OPPO_VENDOR_ID				0x22d9
+#define OPPO_PRODUCT_R11			0x276c
+
 
 /* Device flags */
 
@@ -2155,6 +2159,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE_INTERFACE_CLASS(0x305a, 0x1404, 0xff) },			/* GosunCn GM500 RNDIS */
 	{ USB_DEVICE_INTERFACE_CLASS(0x305a, 0x1405, 0xff) },			/* GosunCn GM500 MBIM */
 	{ USB_DEVICE_INTERFACE_CLASS(0x305a, 0x1406, 0xff) },			/* GosunCn GM500 ECM/NCM */
+	{ USB_DEVICE_AND_INTERFACE_INFO(OPPO_VENDOR_ID, OPPO_PRODUCT_R11, 0xff, 0xff, 0x30) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);


