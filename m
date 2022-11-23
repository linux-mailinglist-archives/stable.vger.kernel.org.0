Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 659F66354A8
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237120AbiKWJJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237132AbiKWJJV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:09:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40AD21055A4
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:09:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E71E1B81EEB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:09:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D15C433C1;
        Wed, 23 Nov 2022 09:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194557;
        bh=XLhMLZb6XiLLtPgxe/0OyAMI6SvnqSR49NwowbBrBYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LkjfFnDe4sOJhvJSGgdA3VU0Aw1oreA60PWyktaZr5ICahxRQ8iAV7Ps6xQNqsXPq
         GpktRCoLPVB4O24XmlLYSlxJ1hYfCx/Ph0PCpTYVPxYJtikwc75eh1Nc5NKa+BK5id
         kkXJv9ILf/ZdIDK5nUW4ayNi/cCax1sugNFJzT2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Beno=C3=AEt=20Monin?= <benoit.monin@gmx.fr>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 082/114] USB: serial: option: add Sierra Wireless EM9191
Date:   Wed, 23 Nov 2022 09:51:09 +0100
Message-Id: <20221123084555.135761368@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
References: <20221123084551.864610302@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benoît Monin <benoit.monin@gmx.fr>

commit df3414b0a245f43476061fddd78cee7d6cff797f upstream.

Add support for the AT and diag ports, similar to other qualcomm SDX55
modems. In QDL mode, the modem uses a different device ID and support
is provided by qcserial in commit 11c52d250b34 ("USB: serial: qcserial:
add EM9191 QDL support").

T:  Bus=08 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  3 Spd=5000 MxCh= 0
D:  Ver= 3.20 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 9 #Cfgs=  1
P:  Vendor=1199 ProdID=90d3 Rev=00.06
S:  Manufacturer=Sierra Wireless, Incorporated
S:  Product=Sierra Wireless EM9191
S:  SerialNumber=xxxxxxxxxxxxxxxx
C:  #Ifs= 4 Cfg#= 1 Atr=a0 MxPwr=896mA
I:  If#=0x0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=0e Prot=00 Driver=cdc_mbim
I:  If#=0x1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
I:  If#=0x4 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=(none)

Signed-off-by: Benoît Monin <benoit.monin@gmx.fr>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -581,6 +581,9 @@ static void option_instat_callback(struc
 #define OPPO_VENDOR_ID				0x22d9
 #define OPPO_PRODUCT_R11			0x276c
 
+/* Sierra Wireless products */
+#define SIERRA_VENDOR_ID			0x1199
+#define SIERRA_PRODUCT_EM9191			0x90d3
 
 /* Device flags */
 
@@ -2176,6 +2179,8 @@ static const struct usb_device_id option
 	{ USB_DEVICE_INTERFACE_CLASS(0x305a, 0x1405, 0xff) },			/* GosunCn GM500 MBIM */
 	{ USB_DEVICE_INTERFACE_CLASS(0x305a, 0x1406, 0xff) },			/* GosunCn GM500 ECM/NCM */
 	{ USB_DEVICE_AND_INTERFACE_INFO(OPPO_VENDOR_ID, OPPO_PRODUCT_R11, 0xff, 0xff, 0x30) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(SIERRA_VENDOR_ID, SIERRA_PRODUCT_EM9191, 0xff, 0xff, 0x30) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(SIERRA_VENDOR_ID, SIERRA_PRODUCT_EM9191, 0xff, 0, 0) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);


