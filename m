Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5DA118681
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 12:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbfLJLiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 06:38:14 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:39907 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727407AbfLJLhy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 06:37:54 -0500
Received: by mail-lf1-f66.google.com with SMTP id y1so2112276lfb.6;
        Tue, 10 Dec 2019 03:37:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gizESJPdbXxmJNJeGwhGZnMnlbvzjtAzhsJxIVT6qdY=;
        b=mwNvFNSxoM7/7S0054957ZfHrptP32CUtj0SL5MQ2LCqMZpWqhaTub7ZBuQVNoWAc5
         T+fJZx/duFNzSvLbW3klt1nae6s7wLMscazySjVkSb7UuvTx+F20g/94fiPUCEzpEMTH
         7xleGnqBqX1GDDzoQduPZUqwuMY42azI46xTLfAXBIGvkNGCDlf7XVCwVy+ugBar1cIM
         u3rMWmfVhafIcLnLxU7pU5ZMsdAbZqSCeoGoIhq6TYDmyurJwMyjAQKYSeu0LU9qKP71
         3ODcNSJgKaNuZ96edUzvWFZI+DeKkfYIjh6Z/T3dJ5Hi0UZ7d7ADXMrmrzgegoi3dwDj
         bn4w==
X-Gm-Message-State: APjAAAXKGCKnTwa/WY4hRf4ycaQvUTyGkSXfDLcCPqArF58HrvGkFS8P
        wQL5+bO2SNTXXH55Yl+MtXCr1fQA
X-Google-Smtp-Source: APXvYqy6D+qpHF61I1Tn+xu/XYGTKK0i1vpyVAhneBoDXI+DraQ+/PosTwlLTDMvhQC2Yk4jQocOGw==
X-Received: by 2002:a19:2389:: with SMTP id j131mr17056148lfj.86.1575977871489;
        Tue, 10 Dec 2019 03:37:51 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id 207sm1941884ljj.72.2019.12.10.03.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 03:37:49 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iedpu-00014F-Cx; Tue, 10 Dec 2019 12:37:50 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        Florian Echtler <floe@butterbrot.org>
Subject: [PATCH 7/7] Input: sur40: fix interface sanity checks
Date:   Tue, 10 Dec 2019 12:37:37 +0100
Message-Id: <20191210113737.4016-8-johan@kernel.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191210113737.4016-1-johan@kernel.org>
References: <20191210113737.4016-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure to use the current alternate setting when verifying the
interface descriptors to avoid binding to an invalid interface.

This in turn could cause the driver to misbehave or trigger a WARN() in
usb_submit_urb() that kernels with panic_on_warn set would choke on.

Fixes: bdb5c57f209c ("Input: add sur40 driver for Samsung SUR40 (aka MS Surface 2.0/Pixelsense)")
Cc: stable <stable@vger.kernel.org>     # 3.13
Cc: Florian Echtler <floe@butterbrot.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/input/touchscreen/sur40.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index 1dd47dda71cd..34d31c7ec8ba 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -661,7 +661,7 @@ static int sur40_probe(struct usb_interface *interface,
 	int error;
 
 	/* Check if we really have the right interface. */
-	iface_desc = &interface->altsetting[0];
+	iface_desc = interface->cur_altsetting;
 	if (iface_desc->desc.bInterfaceClass != 0xFF)
 		return -ENODEV;
 
-- 
2.24.0

