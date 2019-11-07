Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF01F2F0D
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 14:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfKGNVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 08:21:30 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36421 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbfKGNVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Nov 2019 08:21:30 -0500
Received: by mail-lf1-f65.google.com with SMTP id m6so1596274lfl.3;
        Thu, 07 Nov 2019 05:21:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vfuYrbtvtgA5KR2MZecxBHYYg6/uOilfHzXfpqpwQPM=;
        b=aVtOYy3wq5ZBF9f66/XdHN2MTkSuI85wpnc7UqUcTH/UiNrkAHc6cYtY6BvKpXRtQB
         D+Y4KX0GHlHzFAZuWaSjNb7i0KgQce1gt4CAnnSaYsDOX1Jfepe99lyjQU/5XJWBOnNg
         IF/SWOYXbtIW/yQlsSWqUf6Gj8ZuwLWmc5dd5d6e5AKtqdF1aaqK9BSoUN/UwGYSY+7W
         JNtl8SpPvqN5UV9tqkBimv8l6yiKsGcvz1oE/H7In9ddI401noTrS4cRC90ondWSOJ4r
         CIfybtLiCSpUAOT6B3mXCQuXVBgLOnqN/C/VPCIHdqrKUD7UGXGn3h5iAhT0MY5IuV1W
         AghQ==
X-Gm-Message-State: APjAAAXq/vT9HoKtInHVq4tfTDxJ8jjPRAIb/YOG1byuAo9dfxW/ZyGp
        1D7J1nZTG8w/BalCEFKy/4mRHPUw
X-Google-Smtp-Source: APXvYqwH59e9I72472nIdJJORSCXNyrkK2OVDRIionfAx/7vep/m+AA73BqRhv2u4PL22ANOVMe4qA==
X-Received: by 2002:ac2:4248:: with SMTP id m8mr2420028lfl.94.1573132887989;
        Thu, 07 Nov 2019 05:21:27 -0800 (PST)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id l82sm1460676lfd.81.2019.11.07.05.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 05:21:27 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iShj6-0000Zb-9x; Thu, 07 Nov 2019 14:21:28 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: [PATCH 1/2] USB: serial: mos7720: fix remote wakeup
Date:   Thu,  7 Nov 2019 14:21:18 +0100
Message-Id: <20191107132119.2159-1-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver was setting the device remote-wakeup feature during probe in
violation of the USB specification (which says it should only be set
just prior to suspending the device). This could potentially waste
power during suspend as well as lead to spurious wakeups.

Note that USB core would clear the remote-wakeup feature at first
resume.

Fixes: 0f64478cbc7a ("USB: add USB serial mos7720 driver")
Cc: stable <stable@vger.kernel.org>     # 2.6.19
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/mos7720.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index 18110225d506..2ec4eeacebc7 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -1833,10 +1833,6 @@ static int mos7720_startup(struct usb_serial *serial)
 	product = le16_to_cpu(serial->dev->descriptor.idProduct);
 	dev = serial->dev;
 
-	/* setting configuration feature to one */
-	usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-			(__u8)0x03, 0x00, 0x01, 0x00, NULL, 0x00, 5000);
-
 	if (product == MOSCHIP_DEVICE_ID_7715) {
 		struct urb *urb = serial->port[0]->interrupt_in_urb;
 
-- 
2.23.0

