Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0104F11870D
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 12:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727667AbfLJLsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 06:48:24 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38385 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727426AbfLJLsC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 06:48:02 -0500
Received: by mail-lj1-f193.google.com with SMTP id k8so19479933ljh.5;
        Tue, 10 Dec 2019 03:48:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SomisIKYrhnGM9uPCjPrNcYhFDkrQCYHEW6V1huhmgY=;
        b=qn5jd9tvsiOoC2AVcE9GGC8YV8C749WT8BQmBs5YCcvAWZU5idSrHjXmjoo5x08UkC
         zGMt9CYuHflcd2ZYTwbzoMI8ZeKU78OQO6wsG5MHGbuY6DygKs0mO/W/Im955lsPgJJl
         Xo0mkm7/X9Ye/6FxGbdNcrkWwEBbCl4XUPGAS7iDfPljhcPUTsQPmaQqHiwOdO477+6H
         DXEHNiSK/n97xIT9jBhxNL/xoXJkHXF+PVdOZXNb07zV4C7AtdwT06lIPQzSItUtkrQ8
         cUVQmSPUlhBzFTdtqWYUkrDn+Q0avIYfppvSfJD82+HxfWddUeuMRSgutlrq9z8oSHq9
         JCSA==
X-Gm-Message-State: APjAAAVAdjaZBb5k4h7K6MmlfLfKicf0kOs6gH5KRzY2MWZDOTglj5OL
        r23g5Xi8Iv11qw8DB41moi0=
X-Google-Smtp-Source: APXvYqzhnW9ewIEAdaW6Atd0gX1aWXfA2az8JTi5RDAus4VEAcywwZw8M/TtqqPMRQXyUn67c8Vs2g==
X-Received: by 2002:a05:651c:112d:: with SMTP id e13mr17386635ljo.99.1575978479806;
        Tue, 10 Dec 2019 03:47:59 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id a9sm1441410lfk.23.2019.12.10.03.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 03:47:58 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iedzk-0001LV-HT; Tue, 10 Dec 2019 12:48:00 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        devel@driverdev.osuosl.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 2/2] staging: rtl8712: fix interface sanity check
Date:   Tue, 10 Dec 2019 12:47:51 +0100
Message-Id: <20191210114751.5119-3-johan@kernel.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191210114751.5119-1-johan@kernel.org>
References: <20191210114751.5119-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure to use the current alternate setting when verifying the
interface descriptors to avoid binding to an invalid interface.

Failing to do so could cause the driver to misbehave or trigger a WARN()
in usb_submit_urb() that kernels with panic_on_warn set would choke on.

Fixes: 2865d42c78a9 ("staging: r8712u: Add the new driver to the mainline kernel")
Cc: stable <stable@vger.kernel.org>     # 2.6.37
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/staging/rtl8712/usb_intf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index ba1288297ee4..a87562f632a7 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -247,7 +247,7 @@ static uint r8712_usb_dvobj_init(struct _adapter *padapter)
 
 	pdvobjpriv->padapter = padapter;
 	padapter->eeprom_address_size = 6;
-	phost_iface = &pintf->altsetting[0];
+	phost_iface = pintf->cur_altsetting;
 	piface_desc = &phost_iface->desc;
 	pdvobjpriv->nr_endpoint = piface_desc->bNumEndpoints;
 	if (pusbd->speed == USB_SPEED_HIGH) {
-- 
2.24.0

