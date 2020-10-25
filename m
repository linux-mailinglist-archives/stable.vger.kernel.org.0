Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE2142982EA
	for <lists+stable@lfdr.de>; Sun, 25 Oct 2020 18:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1417852AbgJYRrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Oct 2020 13:47:52 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:44306 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1417714AbgJYRqk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Oct 2020 13:46:40 -0400
Received: by mail-lf1-f67.google.com with SMTP id b1so8902342lfp.11;
        Sun, 25 Oct 2020 10:46:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mLH2jEE7RKRcoLwhkzgaqRtvr7bnr4NSOoTQehYo+/Y=;
        b=Xjxtzz1LK6LO3HD8pQsXTS/iV5qEUHxTR5bytGUfmHoF8eBnUMAiH7orhn63C+NJ8F
         gWi9oxbpP2XcugGYtZngexfeeUWYCSr1EjUUlSmZrQoeqvopAH8DjbXMrHP6LI/8V1lL
         OZELH7DMyJLcaiw403lRxTDPPBWl1krq0enjnw4Fy5ghApqxIcjPA6qIZJ90Tm8ubipA
         bHlSr0AfVZdihzhVZJOVYPKXKN3GyYhFJVFKi2/1lkWoeETiyPXa2Gqw5ceSN3jyVqG6
         BAnS/GFPkWUUgNEDEf4zCDVWfnAjDSEQNZbaUMNbjsqnd8Pe7fWcJeFKce/T3MMv+p5N
         0DgQ==
X-Gm-Message-State: AOAM5312DOIdYYyBQbyDeaEuN8M4n47LabFdFiRGlwfCSKONv4YDPgJd
        iKZjhzHAHUy7RLF/MTdMbl25HdCoSjPswQ==
X-Google-Smtp-Source: ABdhPJwIu5JxZA5EikW7OmQwczCYOMug3Pz2X03kVWfXjycmiVx42exfzXnPBhNcDMbR5/FXYpDbzg==
X-Received: by 2002:ac2:5a03:: with SMTP id q3mr4135228lfn.527.1603647997449;
        Sun, 25 Oct 2020 10:46:37 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id l6sm799335lfk.267.2020.10.25.10.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2020 10:46:34 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@xi.terra>)
        id 1kWk6I-0007HP-P6; Sun, 25 Oct 2020 18:46:38 +0100
From:   Johan Hovold <johan@kernel.org>
To:     linux-usb@vger.kernel.org
Cc:     "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 04/14] USB: serial: keyspan_pda: fix write-wakeup use-after-free
Date:   Sun, 25 Oct 2020 18:45:50 +0100
Message-Id: <20201025174600.27896-5-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201025174600.27896-1-johan@kernel.org>
References: <20201025174600.27896-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver's deferred write wakeup was never flushed on disconnect,
something which could lead to the driver port data being freed while the
wakeup work is still scheduled.

Fix this by using the usb-serial write wakeup which gets cancelled
properly on disconnect.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/keyspan_pda.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index d6ebde779e85..d91180ab5f3b 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -43,8 +43,7 @@
 struct keyspan_pda_private {
 	int			tx_room;
 	int			tx_throttled;
-	struct work_struct			wakeup_work;
-	struct work_struct			unthrottle_work;
+	struct work_struct	unthrottle_work;
 	struct usb_serial	*serial;
 	struct usb_serial_port	*port;
 };
@@ -97,15 +96,6 @@ static const struct usb_device_id id_table_fake_xircom[] = {
 };
 #endif
 
-static void keyspan_pda_wakeup_write(struct work_struct *work)
-{
-	struct keyspan_pda_private *priv =
-		container_of(work, struct keyspan_pda_private, wakeup_work);
-	struct usb_serial_port *port = priv->port;
-
-	tty_port_tty_wakeup(&port->port);
-}
-
 static void keyspan_pda_request_unthrottle(struct work_struct *work)
 {
 	struct keyspan_pda_private *priv =
@@ -183,7 +173,7 @@ static void keyspan_pda_rx_interrupt(struct urb *urb)
 		case 2: /* tx unthrottle interrupt */
 			priv->tx_throttled = 0;
 			/* queue up a wakeup at scheduler time */
-			schedule_work(&priv->wakeup_work);
+			usb_serial_port_softint(port);
 			break;
 		default:
 			break;
@@ -563,7 +553,7 @@ static void keyspan_pda_write_bulk_callback(struct urb *urb)
 	priv = usb_get_serial_port_data(port);
 
 	/* queue up a wakeup at scheduler time */
-	schedule_work(&priv->wakeup_work);
+	usb_serial_port_softint(port);
 }
 
 
@@ -715,7 +705,6 @@ static int keyspan_pda_port_probe(struct usb_serial_port *port)
 	if (!priv)
 		return -ENOMEM;
 
-	INIT_WORK(&priv->wakeup_work, keyspan_pda_wakeup_write);
 	INIT_WORK(&priv->unthrottle_work, keyspan_pda_request_unthrottle);
 	priv->serial = port->serial;
 	priv->port = port;
-- 
2.26.2

