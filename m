Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E64B1406EE
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 10:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbgAQJvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 04:51:12 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42458 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728733AbgAQJvK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 04:51:10 -0500
Received: by mail-lj1-f196.google.com with SMTP id y4so25806701ljj.9;
        Fri, 17 Jan 2020 01:51:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=40JSScTYyOWPofT3nlZNpI9vXYe97j1JnSkOaEKoYOo=;
        b=IcH3jEwiTz8EjUV82Ni3vQbgHgvGlPleQPVNNPrOyWH/8Kux8m8wk35Yq9qixSeYOn
         6TXyexiWAgCv5tMUxp8CrNWEl9A6JrjWepdvaAunxUlAs0FN53QznzIx5e7TiFKa6bz7
         9oP+3tGg9762C/R0bDsWD5o2SZXgjFURLQgg4qdMpsIHxQNKlzSzSWM+pwHnFd8V/YUt
         2WlgdSJEPSKfkZTdp/VNaxmoWLVOtTmEbaOgiMAKObho2hvygWOQRFrql2Kiw2rTM/xB
         v5g+hp032qECNNQ6JipnciCZvuks/HwJd113T4vjjAEM+0y2YmsezTDSiZq0Devg8DA/
         7b1g==
X-Gm-Message-State: APjAAAUzJEzHjsyMksQHuYd7xO2NoficxwCLjfZcRc9s/2vORfMO8I2n
        XNTvMCuejDfMwjCfm5R8d6g=
X-Google-Smtp-Source: APXvYqwjbimfxL+ouk5jb1yXFuN5jRAjSxk677pM16ltU2pIWlmSmTQAOx3qvjwZlNopkCXf20uKBA==
X-Received: by 2002:a05:651c:1129:: with SMTP id e9mr4943525ljo.239.1579254667686;
        Fri, 17 Jan 2020 01:51:07 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id y29sm11974808ljd.88.2020.01.17.01.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 01:51:06 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1isOHQ-0007DX-Kz; Fri, 17 Jan 2020 10:51:04 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: [PATCH 5/5] USB: serial: quatech2: handle unbound ports
Date:   Fri, 17 Jan 2020 10:50:26 +0100
Message-Id: <20200117095026.27655-6-johan@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200117095026.27655-1-johan@kernel.org>
References: <20200117095026.27655-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Check for NULL port data in the event handlers to avoid dereferencing a
NULL pointer in the unlikely case where a port device isn't bound to a
driver (e.g. after an allocation failure on port probe).

Fixes: f7a33e608d9a ("USB: serial: add quatech2 usb to serial driver")
Cc: stable <stable@vger.kernel.org>     # 3.5
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/quatech2.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/usb/serial/quatech2.c b/drivers/usb/serial/quatech2.c
index a62981ca7a73..c76a2c0c32ff 100644
--- a/drivers/usb/serial/quatech2.c
+++ b/drivers/usb/serial/quatech2.c
@@ -470,6 +470,13 @@ static int get_serial_info(struct tty_struct *tty,
 
 static void qt2_process_status(struct usb_serial_port *port, unsigned char *ch)
 {
+	struct qt2_port_private *port_priv;
+
+	/* May be called from qt2_process_read_urb() for an unbound port. */
+	port_priv = usb_get_serial_port_data(port);
+	if (!port_priv)
+		return;
+
 	switch (*ch) {
 	case QT2_LINE_STATUS:
 		qt2_update_lsr(port, ch + 1);
@@ -484,14 +491,27 @@ static void qt2_process_status(struct usb_serial_port *port, unsigned char *ch)
 static void qt2_process_xmit_empty(struct usb_serial_port *port,
 				   unsigned char *ch)
 {
+	struct qt2_port_private *port_priv;
 	int bytes_written;
 
+	/* May be called from qt2_process_read_urb() for an unbound port. */
+	port_priv = usb_get_serial_port_data(port);
+	if (!port_priv)
+		return;
+
 	bytes_written = (int)(*ch) + (int)(*(ch + 1) << 4);
 }
 
 /* not needed, kept to document functionality */
 static void qt2_process_flush(struct usb_serial_port *port, unsigned char *ch)
 {
+	struct qt2_port_private *port_priv;
+
+	/* May be called from qt2_process_read_urb() for an unbound port. */
+	port_priv = usb_get_serial_port_data(port);
+	if (!port_priv)
+		return;
+
 	return;
 }
 
-- 
2.24.1

