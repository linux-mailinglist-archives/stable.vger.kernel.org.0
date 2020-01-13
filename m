Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 124AA139770
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 18:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgAMRW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 12:22:29 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:41056 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727331AbgAMRW3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jan 2020 12:22:29 -0500
Received: by mail-lf1-f65.google.com with SMTP id m30so7447583lfp.8;
        Mon, 13 Jan 2020 09:22:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5zVt0sRFRdUX8z6vKZQ0/vfkRSe85i7P2h2dcN4rYpE=;
        b=EV4aS1Q8dRF0j7DibbCEL0gw9HNtAKvE9WFZ4nsPOmMJsUqWMnZ6BEicjUP/ImW451
         N++8Cxq/mg7x8hCZVCeDsYobpxCXTp3mHFPl7lX2O9uPAdJ3/OzdXtECn3M9I/S+8Awl
         05TTFfvarChOgP4KGaArnnZEZxs71glH58hTHvUu5FSbo8Hp96Q5ObzmY3582MU6sfX5
         H5GzoxHpQJ3+24c2gccnD/czMNDCivYp8UbiKPibBCZ8WwyiTbnFXSixgro4cdatIyjt
         3j9vJhalGd2nU/+pnxp8382FXRv2xH/C2SGIv2Qxh7eaGdCzkZd8lFEHsprBoyhQSmo/
         20gg==
X-Gm-Message-State: APjAAAX1zaTmaf0qfcG3zGA+ziDvdVK/I3PeeXmvKIMc81vXE2wYDP4e
        1x9F48zoiE6r2JpFngMsgpQ=
X-Google-Smtp-Source: APXvYqzk5Ev0WmtdV66O19LVc+hQg/udQ4dagQdxMNaWaUXOHFci9mTchJqUzGcwZylCMVN8e4BjnA==
X-Received: by 2002:a19:cc49:: with SMTP id c70mr10453747lfg.73.1578936146650;
        Mon, 13 Jan 2020 09:22:26 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id n1sm5936296lfq.16.2020.01.13.09.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 09:22:26 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1ir3Q2-00082e-3j; Mon, 13 Jan 2020 18:22:26 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>,
        Martin Jansen <martin.jansen@opticon.com>
Subject: [PATCH] USB: serial: opticon: fix control-message timeouts
Date:   Mon, 13 Jan 2020 18:22:13 +0100
Message-Id: <20200113172213.30869-1-johan@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver was issuing synchronous uninterruptible control requests
without using a timeout. This could lead to the driver hanging
on open() or tiocmset() due to a malfunctioning (or malicious) device
until the device is physically disconnected.

The USB upper limit of five seconds per request should be more than
enough.

Fixes: 309a057932ab ("USB: opticon: add rts and cts support")
Cc: stable <stable@vger.kernel.org>     # 2.6.39
Cc: Martin Jansen <martin.jansen@opticon.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---

This was reported to me off-list to be an issue with some opticon
devices. Let's address the obvious bug while waiting for a bug report
to be sent to the list.

Johan


 drivers/usb/serial/opticon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
index cb7aac9cd9e7..ed2b4e6dca38 100644
--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -113,7 +113,7 @@ static int send_control_msg(struct usb_serial_port *port, u8 requesttype,
 	retval = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
 				requesttype,
 				USB_DIR_OUT|USB_TYPE_VENDOR|USB_RECIP_INTERFACE,
-				0, 0, buffer, 1, 0);
+				0, 0, buffer, 1, USB_CTRL_SET_TIMEOUT);
 	kfree(buffer);
 
 	if (retval < 0)
-- 
2.24.1

