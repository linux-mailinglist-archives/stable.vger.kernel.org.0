Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A50F5140C9D
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 15:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbgAQOfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 09:35:42 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36725 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728816AbgAQOfm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 09:35:42 -0500
Received: by mail-lj1-f195.google.com with SMTP id r19so26701382ljg.3;
        Fri, 17 Jan 2020 06:35:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kdJveTlmi2+Fpg8OnkLnEuQpdQrxVQF3RU2697aMjxo=;
        b=Oqr7NJVoCRMs4KMHs8JC0ikQLmo0gELNQopujeJJRfIa8zVRxUgQreBAdkvbtyKFyX
         4OPs48qwZr5sGJ6ymBFbpNGl7/gS+eIl66jwWti9Nk59NxDN17zWifXgxldvp9MzCB2o
         jAY7tr4EV7jt36oA8EhjNU35zFd8JHf9ZKIfefmSvjkse04Wd40ycWeAhxCh3ZVuPJ0I
         NsDRPTW65DV6wfe5HBDYNVMWVZ38xyywYSE8Q8eV7whvHgNrZhPoC2h9BbHObPX/NEEE
         7rN6LgNgDzbssoB6a/RXN1eJtsP+Y2zKZxgqlAFNZ4J+0sLxGsLSnwkAB32M6dZ4TY/L
         6KAw==
X-Gm-Message-State: APjAAAU2Ov9I8/IMEf+dVCMMKbJtCcQKM6EMbQVwI6E09+Oy1pz8k/VU
        tK+D2CxLs7ENnunxCKyC7Pc=
X-Google-Smtp-Source: APXvYqwoTzojqUdGcCb/ABR1sXLBRqqwyw3Xaz4jZ2M3ht6px5aqaBJLokFtVSX1d24D+BMnoTLR8A==
X-Received: by 2002:a05:651c:232:: with SMTP id z18mr5817879ljn.85.1579271740280;
        Fri, 17 Jan 2020 06:35:40 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id a14sm11801355lfh.50.2020.01.17.06.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 06:35:39 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1isSip-0001K9-Ka; Fri, 17 Jan 2020 15:35:39 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: [PATCH v2] USB: serial: quatech2: handle unbound ports
Date:   Fri, 17 Jan 2020 15:35:26 +0100
Message-Id: <20200117143526.5048-1-johan@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Check for NULL port data in the modem- and line-status handlers to avoid
dereferencing a NULL pointer in the unlikely case where a port device
isn't bound to a driver (e.g. after an allocation failure on port
probe).

Note that the other (stubbed) event handlers qt2_process_xmit_empty()
and qt2_process_flush() would need similar sanity checks in case they
are ever implemented.

Fixes: f7a33e608d9a ("USB: serial: add quatech2 usb to serial driver")
Cc: stable <stable@vger.kernel.org>     # 3.5
Signed-off-by: Johan Hovold <johan@kernel.org>
---

v2
 - move sanity checks to where the actual dereferences take place
 - drop sanity checks from the stubbed event handlers


 drivers/usb/serial/quatech2.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/serial/quatech2.c b/drivers/usb/serial/quatech2.c
index a62981ca7a73..f93b81a297d6 100644
--- a/drivers/usb/serial/quatech2.c
+++ b/drivers/usb/serial/quatech2.c
@@ -841,7 +841,10 @@ static void qt2_update_msr(struct usb_serial_port *port, unsigned char *ch)
 	u8 newMSR = (u8) *ch;
 	unsigned long flags;
 
+	/* May be called from qt2_process_read_urb() for an unbound port. */
 	port_priv = usb_get_serial_port_data(port);
+	if (!port_priv)
+		return;
 
 	spin_lock_irqsave(&port_priv->lock, flags);
 	port_priv->shadowMSR = newMSR;
@@ -869,7 +872,10 @@ static void qt2_update_lsr(struct usb_serial_port *port, unsigned char *ch)
 	unsigned long flags;
 	u8 newLSR = (u8) *ch;
 
+	/* May be called from qt2_process_read_urb() for an unbound port. */
 	port_priv = usb_get_serial_port_data(port);
+	if (!port_priv)
+		return;
 
 	if (newLSR & UART_LSR_BI)
 		newLSR &= (u8) (UART_LSR_OE | UART_LSR_BI);
-- 
2.24.1

