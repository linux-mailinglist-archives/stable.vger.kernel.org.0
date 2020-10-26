Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5848F29883E
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 09:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728857AbgJZI0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 04:26:05 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:38147 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1771667AbgJZI0F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 04:26:05 -0400
Received: by mail-lf1-f67.google.com with SMTP id c141so10628910lfg.5;
        Mon, 26 Oct 2020 01:26:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V+jakLBrl9A0QRy0ACCLn+POIM4wvTqpKbwiPWwLh/Q=;
        b=Dfikz2Q0gQx/n0L8u50e80xHJ1DI4lfCNXsOAbOuz6yJ04Cf5zKJ/7CfGt+WX7XlMr
         gCuJtnywsCz9+kdI8u/ihdefmdl9nK2yRbMlqkD9hKAQN6S+mKaYtUO3AE5zSVGc1wEf
         /ddHLEQxzmtSKXoNz3pLBk6mZb71Bd0CgqYYomxOs/BSxlrLNBmJnBU2UY1NscWr8wO5
         Yx66TV3RotU+Gs1rH4TsC6yYDCGcbENydL8BZprAFonxHu4SynlKg7VMID/1xmpNN5nJ
         489fEo5PCpVFztYGEUNf/ukpLQol/xfxgt2TrCNkIXY+oRd6k4koXcJX63xluIff8wxp
         2Qpw==
X-Gm-Message-State: AOAM533ftT0m+FfrZiFQR222D71Ao9jsUxu8CzSlfvTSlW+FfzEcxgmZ
        O9j6Wi0jgn+vEFfVcqlwUrJmisY5Y8oXWg==
X-Google-Smtp-Source: ABdhPJyQ2uJccQ59KpQO+0fxZT6r2bgdyJeamwvsQXPtm53K89Gp7AGJVz29970BpKGYASjAYjZKuA==
X-Received: by 2002:a19:8884:: with SMTP id k126mr5009463lfd.63.1603700762566;
        Mon, 26 Oct 2020 01:26:02 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id w18sm967685lfc.5.2020.10.26.01.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 01:26:01 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@xi.terra>)
        id 1kWxpO-0004gc-Uf; Mon, 26 Oct 2020 09:26:07 +0100
From:   Johan Hovold <johan@kernel.org>
To:     linux-usb@vger.kernel.org
Cc:     Johan Hovold <johan@kernel.org>, stable <stable@vger.kernel.org>
Subject: [PATCH] USB: serial: cyberjack: fix write-URB completion race
Date:   Mon, 26 Oct 2020 09:25:48 +0100
Message-Id: <20201026082548.17970-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The write-URB busy flag was being cleared before the completion handler
was done with the URB, something which could lead to corrupt transfers
due to a racing write request if the URB is resubmitted.

Fixes: 507ca9bc0476 ("[PATCH] USB: add ability for usb-serial drivers to determine if their write urb is currently being used.")
Cc: stable <stable@vger.kernel.org>     # 2.6.13
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/cyberjack.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/cyberjack.c b/drivers/usb/serial/cyberjack.c
index 821970609695..2e40908963da 100644
--- a/drivers/usb/serial/cyberjack.c
+++ b/drivers/usb/serial/cyberjack.c
@@ -357,11 +357,12 @@ static void cyberjack_write_bulk_callback(struct urb *urb)
 	struct device *dev = &port->dev;
 	int status = urb->status;
 	unsigned long flags;
+	bool resubmitted = false;
 
-	set_bit(0, &port->write_urbs_free);
 	if (status) {
 		dev_dbg(dev, "%s - nonzero write bulk status received: %d\n",
 			__func__, status);
+		set_bit(0, &port->write_urbs_free);
 		return;
 	}
 
@@ -394,6 +395,8 @@ static void cyberjack_write_bulk_callback(struct urb *urb)
 			goto exit;
 		}
 
+		resubmitted = true;
+
 		dev_dbg(dev, "%s - priv->wrsent=%d\n", __func__, priv->wrsent);
 		dev_dbg(dev, "%s - priv->wrfilled=%d\n", __func__, priv->wrfilled);
 
@@ -410,6 +413,8 @@ static void cyberjack_write_bulk_callback(struct urb *urb)
 
 exit:
 	spin_unlock_irqrestore(&priv->lock, flags);
+	if (!resubmitted)
+		set_bit(0, &port->write_urbs_free);
 	usb_serial_port_softint(port);
 }
 
-- 
2.26.2

