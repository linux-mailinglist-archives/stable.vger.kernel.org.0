Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61AEC1406E4
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 10:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbgAQJvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 04:51:08 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:42925 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbgAQJvH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 04:51:07 -0500
Received: by mail-lf1-f66.google.com with SMTP id y19so17859926lfl.9;
        Fri, 17 Jan 2020 01:51:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WWRBcoPU/m+0XaWultvQ07QvHcKAXmUxIDJo5eqommk=;
        b=H5DQbh4XuLzTa9WojmbJK+AwDFEyrgLskyIwKG2lc+10h7VVG9DEUoVx4NVbfaRUlk
         Zau0l9W5ntaSbWxLPax4wpqPRg3NA12xxcI1TrZzq8wFoYaIhBjeBCrO6yb+7nEbzcNe
         qBDWytWjYIwVTb/xSV/cxQfYYQ88z0oaTVzsFR7ReIeU763oLTkce1wHJ9XrHuDMpUQG
         r9fFWhwgKQZLqGDAAp1wAUgP5MOjOZZ3RNt9n9O+telIvVklImA12GMGCDLSy825Ere3
         tRexyq8auL0wyfOwr+RyjBsv+AR/FRbtHDh60AKpZ6n1ZZU4ijVTzXA1VFb6z2PdsNHT
         H7yw==
X-Gm-Message-State: APjAAAUN061Xk8g002HOv55uH0dg8Ld1rfsFsaW5xD6GAGvJ4HGJkQV8
        1NCjneGjTCD431adVEURx3c=
X-Google-Smtp-Source: APXvYqynKW/PNFLWTOw0LQJFVZgqN2uYrZXoh/DJ6cN/NFm7y/WAwXN6BVLGOvZLzOwt6s7fhxlkSw==
X-Received: by 2002:ac2:599c:: with SMTP id w28mr4921754lfn.78.1579254665397;
        Fri, 17 Jan 2020 01:51:05 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id b20sm11995092ljp.20.2020.01.17.01.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 01:51:04 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1isOHQ-0007DC-8o; Fri, 17 Jan 2020 10:51:04 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: [PATCH 1/5] USB: ch341: handle unbound port at reset_resume
Date:   Fri, 17 Jan 2020 10:50:22 +0100
Message-Id: <20200117095026.27655-2-johan@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200117095026.27655-1-johan@kernel.org>
References: <20200117095026.27655-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Check for NULL port data in reset_resume() to avoid dereferencing a NULL
pointer in case the port device isn't bound to a driver (e.g. after a
failed control request at port probe).

Fixes: 1ded7ea47b88 ("USB: ch341 serial: fix port number changed after resume")
Cc: stable <stable@vger.kernel.org>     # 2.6.30
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/ch341.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index df582fe855f0..d3f420f3a083 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -642,9 +642,13 @@ static int ch341_tiocmget(struct tty_struct *tty)
 static int ch341_reset_resume(struct usb_serial *serial)
 {
 	struct usb_serial_port *port = serial->port[0];
-	struct ch341_private *priv = usb_get_serial_port_data(port);
+	struct ch341_private *priv;
 	int ret;
 
+	priv = usb_get_serial_port_data(port);
+	if (!priv)
+		return 0;
+
 	/* reconfigure ch341 serial port after bus-reset */
 	ch341_configure(serial->dev, priv);
 
-- 
2.24.1

