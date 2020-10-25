Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCD42982ED
	for <lists+stable@lfdr.de>; Sun, 25 Oct 2020 18:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1416482AbgJYRsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Oct 2020 13:48:00 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37198 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1417706AbgJYRqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Oct 2020 13:46:39 -0400
Received: by mail-lj1-f196.google.com with SMTP id i2so7286354ljg.4;
        Sun, 25 Oct 2020 10:46:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8F5bIaxdX0w1ouDNYj2bcxzTc3dOdSXKUtWoL55jsSs=;
        b=GjnRw5jyGUquqq7ClfTNt2lJah8pcLnv+/Wu7+cuEP26L8MKrr/d0IZKVdkG0b06A1
         HV0SElbUagF5e4X1YY7VU69OaeP0AOyOLZixD1RBa3muvKmHXugig7a9iTOJ4Jf+wZ83
         /ZTkkk5SK99f5DE0AJg1s51uOwN6bqiTwwNtIWIlP/Cvhu/qD7pC491ynINh32oJBQdT
         B1mak+Q+gAUG8KrigIqk+4wm5DaXxO3vUsktg+FWS5dFeSRt8PhaiN4JKgy+hwOQs4fy
         X2gPLn8HYC2iTjyhMtQYQAB6lkfu0FuhbhvLZRpDSIBQacOEMn9bTYL8rNxevcBu+xrF
         uGnQ==
X-Gm-Message-State: AOAM531Zk0tzBIi6ejsNwlWGKNOCbJAeSVXRIHc3bmMTF1E9Ri2a/cOf
        lEZo+AWAeKuEO63xwr/1qGk5lYVZUBau4A==
X-Google-Smtp-Source: ABdhPJyAZnlLiVQGH9JpmXnwbzpxeBbCOjWEjNVHAbx8vvb0U0Z4GJNV1tjTZaMnjdyEx6NQx+6X/A==
X-Received: by 2002:a2e:8e6c:: with SMTP id t12mr4059103ljk.432.1603647996931;
        Sun, 25 Oct 2020 10:46:36 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id m18sm795963lfb.35.2020.10.25.10.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2020 10:46:34 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@xi.terra>)
        id 1kWk6I-0007HF-JL; Sun, 25 Oct 2020 18:46:38 +0100
From:   Johan Hovold <johan@kernel.org>
To:     linux-usb@vger.kernel.org
Cc:     "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 02/14] USB: serial: keyspan_pda: fix write deadlock
Date:   Sun, 25 Oct 2020 18:45:48 +0100
Message-Id: <20201025174600.27896-3-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201025174600.27896-1-johan@kernel.org>
References: <20201025174600.27896-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The write() callback can be called in interrupt context (e.g. when used
as a console) so interrupts must be disabled while holding the port lock
to prevent a possible deadlock.

Fixes: e81ee637e4ae ("usb-serial: possible irq lock inversion (PPP vs. usb/serial)")
Fixes: 507ca9bc0476 ("[PATCH] USB: add ability for usb-serial drivers to determine if their write urb is currently being used.")
Cc: stable <stable@vger.kernel.org>     # 2.6.19
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/keyspan_pda.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index 2d5ad579475a..17b60e5a9f1f 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -443,6 +443,7 @@ static int keyspan_pda_write(struct tty_struct *tty,
 	int request_unthrottle = 0;
 	int rc = 0;
 	struct keyspan_pda_private *priv;
+	unsigned long flags;
 
 	priv = usb_get_serial_port_data(port);
 	/* guess how much room is left in the device's ring buffer, and if we
@@ -462,13 +463,13 @@ static int keyspan_pda_write(struct tty_struct *tty,
 	   the TX urb is in-flight (wait until it completes)
 	   the device is full (wait until it says there is room)
 	*/
-	spin_lock_bh(&port->lock);
+	spin_lock_irqsave(&port->lock, flags);
 	if (!test_bit(0, &port->write_urbs_free) || priv->tx_throttled) {
-		spin_unlock_bh(&port->lock);
+		spin_unlock_irqrestore(&port->lock, flags);
 		return 0;
 	}
 	clear_bit(0, &port->write_urbs_free);
-	spin_unlock_bh(&port->lock);
+	spin_unlock_irqrestore(&port->lock, flags);
 
 	/* At this point the URB is in our control, nobody else can submit it
 	   again (the only sudden transition was the one from EINPROGRESS to
-- 
2.26.2

