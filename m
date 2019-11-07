Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B525AF2CE3
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 11:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbfKGKzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 05:55:19 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:33594 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727528AbfKGKzT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Nov 2019 05:55:19 -0500
Received: by mail-lf1-f65.google.com with SMTP id d6so857101lfc.0
        for <stable@vger.kernel.org>; Thu, 07 Nov 2019 02:55:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aleksander-es.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TPK50GPjrQoXQ8hD0+RbkmFtGxi2/e2ftn5FMSSFPF4=;
        b=Wtsk0xn2xgXOzagZqoSEmpZnVaZEg5IExadkuK8+HDd0v+4R5t/CuNMGuqBgYPHYJS
         aEBhShPEtMrQgMoLzq4DKH39AfjjRNFzJu6lhVS4QWxLIPiT+Ug/glUW6b7S1rBgIThi
         /ogs8XLfJe5jFUZD/JLYicSccj7jYn533/EO3b597LpZgcNz6z6ZWBK1XeJzXMVixfkd
         kTkQlyFkaonP6HWXaD+xIa0cQLpLwuSA72nIPRizCFlVdkZs0cvTsP2vmE1j+ERUMsm+
         Z2J85G6iAPbWL9GP8wfJTgMZ7GzQ3C2Om8h3Zq6/tx/YgKqWPw6JQZMo4V/DCE/CFbBo
         Fj6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TPK50GPjrQoXQ8hD0+RbkmFtGxi2/e2ftn5FMSSFPF4=;
        b=ro/b326hFPWUpHVOMh/E7zQBBqZd1SJwacaMw2H09gS2hFJOT+qW4Jo7mWG3HJdKX3
         oAImgdCnemMMRjETJ9+Xh9WV1qkB5C+eIg++3SsrJUaJ5hzRKifYo69+HGAuPz10Jmaw
         fYMW1SRkuls9Pn0zQw01bxF+PCzmdZBRts+lrw249pTBxgx4L/im/EpnS90utK4vbU2d
         AOiB5sLP6gE3TgtSnKluSmuhvrTUGQT0/+ZOSDWCClsOju6qx73g8pjrRfDe7e5G9ZR2
         oTSgo2xdB6vsyg8S6WX+zUphVsMW5Mjuekb6pdcnGicz6Xk9ePDWJyEwxgqI12kqR6rK
         h3hg==
X-Gm-Message-State: APjAAAVh1wL4Kn/mO6jw6xAuEV03F+koXHGin+Mnyng9lfWcb+Z0fYE5
        3gyJ/fa4y5fEge9tKcDtvVMnkA==
X-Google-Smtp-Source: APXvYqwqxxuBDu1x4vmJeaTVQv1FJjdGVZBPz2iwz+kHyblfJ1Xq1+yLRg0w9FP51km/b0Wa2GzQEQ==
X-Received: by 2002:ac2:5f0a:: with SMTP id 10mr1928775lfq.57.1573124116279;
        Thu, 07 Nov 2019 02:55:16 -0800 (PST)
Received: from localhost.localdomain ([37.46.115.8])
        by smtp.gmail.com with ESMTPSA id s28sm904756lfp.92.2019.11.07.02.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 02:55:15 -0800 (PST)
From:   Aleksander Morgado <aleksander@aleksander.es>
To:     johan@kernel.org
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] USB: serial: option: add support for DW5821e with eSIM support
Date:   Thu,  7 Nov 2019 11:55:08 +0100
Message-Id: <20191107105508.1010716-1-aleksander@aleksander.es>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The device exposes AT, NMEA and DIAG ports in both USB configurations.
Exactly same layout as the default DW5821e module, just a different
vid/pid.

P:  Vendor=413c ProdID=81e0 Rev=03.18
S:  Manufacturer=Dell Inc.
S:  Product=DW5821e-eSIM Snapdragon X20 LTE
S:  SerialNumber=0123456789ABCDEF
C:  #Ifs= 6 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#=0x0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
I:  If#=0x1 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=00 Prot=00 Driver=usbhid
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option

P:  Vendor=413c ProdID=81e0 Rev=03.18
S:  Manufacturer=Dell Inc.
S:  Product=DW5821e-eSIM Snapdragon X20 LTE
S:  SerialNumber=0123456789ABCDEF
C:  #Ifs= 7 Cfg#= 2 Atr=a0 MxPwr=500mA
I:  If#=0x0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=0e Prot=00 Driver=cdc_mbim
I:  If#=0x1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
I:  If#=0x6 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)

Signed-off-by: Aleksander Morgado <aleksander@aleksander.es>
Cc: stable <stable@vger.kernel.org>
---
 drivers/usb/serial/option.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 06ab016be0b6..2023f1f4edaf 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -197,6 +197,7 @@ static void option_instat_callback(struct urb *urb);
 #define DELL_PRODUCT_5804_MINICARD_ATT		0x819b  /* Novatel E371 */
 
 #define DELL_PRODUCT_5821E			0x81d7
+#define DELL_PRODUCT_5821E_ESIM			0x81e0
 
 #define KYOCERA_VENDOR_ID			0x0c88
 #define KYOCERA_PRODUCT_KPC650			0x17da
@@ -1044,6 +1045,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(DELL_VENDOR_ID, DELL_PRODUCT_5804_MINICARD_ATT, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5821E),
 	  .driver_info = RSVD(0) | RSVD(1) | RSVD(6) },
+	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5821E_ESIM),
+	  .driver_info = RSVD(0) | RSVD(1) | RSVD(6) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_E100A) },	/* ADU-E100, ADU-310 */
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_500A) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_620UW) },
-- 
2.24.0

