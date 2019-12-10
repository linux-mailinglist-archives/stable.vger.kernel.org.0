Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 387E111867A
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 12:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbfLJLiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 06:38:05 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43633 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727434AbfLJLhz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 06:37:55 -0500
Received: by mail-lj1-f194.google.com with SMTP id a13so19475094ljm.10;
        Tue, 10 Dec 2019 03:37:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H0ckkvmbuP0M6RAigoxMjD95QOpCoqkmvi2yCF+Kpfg=;
        b=e42vnHZIyrMoektAOGrEsvrUExgS0TMQ2gcqPtSlYy7ewXzHgHt1EnmtU11AstA8MV
         puQMdinf9AITU5xLn95JLvrEw7fHdkOozkhbUAbrgHdlJ3YMNUm0ZAhChgzeE3IHNWfV
         xG69zfOn3L5PP4mqFhHyLRJcjAEOjUPpLrv7OJl3JEeWPAfgBGW/Cy3vuTHYhRmyq8su
         RRAxgQLiW3ru6Iw0AuneqB/JVzWYAeQ73LnKNkbzGU8UKkjezduX5eRYj0m7X+OJEUXN
         V3JYVbgNmJGLDVOqaJKUU6XSx9fiIPLFRpPrzb/WghXhegQMD9m3/Nx02CZWzYHeNN2z
         +sDg==
X-Gm-Message-State: APjAAAVptLHmiql00aVeZWurIfnr9X6EQyDUfJOsFJEYkzvr3fGKZM0J
        2BZvvTJ9gtHwA73v0jI4eeNhgyrS
X-Google-Smtp-Source: APXvYqwi1wEz7XIEpXMu/kzhK6QPZO1dEJNS67w1U/4kgV9xrjSipawTKdJ28IEhBXu5NGupE2kU3A==
X-Received: by 2002:a2e:9987:: with SMTP id w7mr14897151lji.107.1575977872858;
        Tue, 10 Dec 2019 03:37:52 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id e21sm1736363lfc.63.2019.12.10.03.37.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 03:37:51 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iedpu-00013x-3X; Tue, 10 Dec 2019 12:37:50 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        Vladis Dronov <vdronov@redhat.com>
Subject: [PATCH 4/7] Input: gtco: fix endpoint sanity check
Date:   Tue, 10 Dec 2019 12:37:34 +0100
Message-Id: <20191210113737.4016-5-johan@kernel.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191210113737.4016-1-johan@kernel.org>
References: <20191210113737.4016-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver was checking the number of endpoints of the first alternate
setting instead of the current one, something which could lead to the
driver binding to an invalid interface.

This in turn could cause the driver to misbehave or trigger a WARN() in
usb_submit_urb() that kernels with panic_on_warn set would choke on.

Fixes: 162f98dea487 ("Input: gtco - fix crash on detecting device without endpoints")
Cc: stable <stable@vger.kernel.org>     # 4.6
Cc: Vladis Dronov <vdronov@redhat.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/input/tablet/gtco.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/input/tablet/gtco.c b/drivers/input/tablet/gtco.c
index 35031228a6d0..799c94dda651 100644
--- a/drivers/input/tablet/gtco.c
+++ b/drivers/input/tablet/gtco.c
@@ -875,18 +875,14 @@ static int gtco_probe(struct usb_interface *usbinterface,
 	}
 
 	/* Sanity check that a device has an endpoint */
-	if (usbinterface->altsetting[0].desc.bNumEndpoints < 1) {
+	if (usbinterface->cur_altsetting->desc.bNumEndpoints < 1) {
 		dev_err(&usbinterface->dev,
 			"Invalid number of endpoints\n");
 		error = -EINVAL;
 		goto err_free_urb;
 	}
 
-	/*
-	 * The endpoint is always altsetting 0, we know this since we know
-	 * this device only has one interrupt endpoint
-	 */
-	endpoint = &usbinterface->altsetting[0].endpoint[0].desc;
+	endpoint = &usbinterface->cur_altsetting->endpoint[0].desc;
 
 	/* Some debug */
 	dev_dbg(&usbinterface->dev, "gtco # interfaces: %d\n", usbinterface->num_altsetting);
@@ -973,7 +969,7 @@ static int gtco_probe(struct usb_interface *usbinterface,
 	input_dev->dev.parent = &usbinterface->dev;
 
 	/* Setup the URB, it will be posted later on open of input device */
-	endpoint = &usbinterface->altsetting[0].endpoint[0].desc;
+	endpoint = &usbinterface->cur_altsetting->endpoint[0].desc;
 
 	usb_fill_int_urb(gtco->urbinfo,
 			 udev,
-- 
2.24.0

