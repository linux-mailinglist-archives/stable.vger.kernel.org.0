Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65B27F2F0F
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 14:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbfKGNVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 08:21:31 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40384 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbfKGNVb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Nov 2019 08:21:31 -0500
Received: by mail-lj1-f195.google.com with SMTP id q2so2238791ljg.7;
        Thu, 07 Nov 2019 05:21:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CXOwm3JVTioKPeIjIaF7xUdT+yoBDfy1Z2LEgU+q66I=;
        b=YUDU4l/9fD8yrwiVeZz/CilInEbQaaUVhMx/IFyRo8+Ra9xAhRcUQcd85aEETDqG2S
         3J8AgLnHQ/ecpS/Jt++nXaXE3eOzxwsWk4adxEsQGW2M/xLdWAsendHfT4OA43/Vs6Fv
         75CuRJUY+cTsAxoY0Xul+82mCQooeZuZQxDPtCuplIuR7CjL9Bs3PrSdLtUjelPNUaqU
         VJhxnRErGYHMh1edU8Q0wzsBbGIMcmSAUIgTjltqB2OPMuInmFtJUCVDxHvQy5w199ma
         kJncvwbQawywVb3ed+WuGGLQ7FfcevOo3C2nunQGueOowCL69O1zoYn436rcN83Ryanr
         cDMw==
X-Gm-Message-State: APjAAAV1X57Eo0Fpymz80YW5Denvur+I8OOTntqGLnW4kIbCtc54BzXQ
        +fcQE+TroTV7bdXZbB11cPTwXkPh
X-Google-Smtp-Source: APXvYqz/1qlrA9iBqGCLR1DGiLg+y3R/jCSVFYDbH77pyRJ26XWJwe5a1DQJMic/QB7gaAn1m122qw==
X-Received: by 2002:a05:651c:1a1:: with SMTP id c1mr2572823ljn.23.1573132887574;
        Thu, 07 Nov 2019 05:21:27 -0800 (PST)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id d17sm1168864lja.27.2019.11.07.05.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 05:21:26 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iShj6-0000Ze-EB; Thu, 07 Nov 2019 14:21:28 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: [PATCH 2/2] USB: serial: mos7840: fix remote wakeup
Date:   Thu,  7 Nov 2019 14:21:19 +0100
Message-Id: <20191107132119.2159-2-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191107132119.2159-1-johan@kernel.org>
References: <20191107132119.2159-1-johan@kernel.org>
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

Fixes: 3f5429746d91 ("USB: Moschip 7840 USB-Serial Driver")
Cc: stable <stable@vger.kernel.org>     # 2.6.19
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/mos7840.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 3eeeee38debc..ab4bf8d6d7df 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2290,11 +2290,6 @@ static int mos7840_port_probe(struct usb_serial_port *port)
 			goto error;
 		} else
 			dev_dbg(&port->dev, "ZLP_REG5 Writing success status%d\n", status);
-
-		/* setting configuration feature to one */
-		usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-				0x03, 0x00, 0x01, 0x00, NULL, 0x00,
-				MOS_WDR_TIMEOUT);
 	}
 	return 0;
 error:
-- 
2.23.0

