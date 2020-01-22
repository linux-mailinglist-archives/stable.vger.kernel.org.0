Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A776714524D
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 11:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgAVKPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 05:15:53 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:45410 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729281AbgAVKPx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 05:15:53 -0500
Received: by mail-lf1-f66.google.com with SMTP id 203so4850219lfa.12;
        Wed, 22 Jan 2020 02:15:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nAGmP7/E0+dkjElTkN6jQ2jIYPfA3j8DC+gRpJkqbEM=;
        b=RR9APJA9q+P+rvlxm+E9R/AvatjJnDSjytvr7OMpj5tKI2MvPxuQETkiPOIYU22kUt
         f4ehalsXkf/+oHBO/LEW0Ce8r+wZR1I8/BIS47LX94L5xR0bxL5DGhVsI0SkehCCTrKz
         QxC1F1TwriIvWOobk58q+CuEaNtEyugimLkFiyYvuDjLANlv34QiZAxcpl7tv3GEeK0g
         pqI2tI7xh/p7iem9MCsPgBNeGmndqMp2n7NN0/cUYmbIuagN0l9WhGKQSQbzaup0OQZ3
         5u5iKuvN32cOpin9A2loRwgoT6JoTPf54ja5rm0cMfNV79vvLSBT4XVLff4wEk+Brfow
         kTfw==
X-Gm-Message-State: APjAAAVgKqmJpXfYW/ujtcO+yJ84IoJ8CxZs2QlRAXgjadFfnNcKkiTu
        28NGomJxaNn/CZsGgZ/Nx+w=
X-Google-Smtp-Source: APXvYqx1ZBBPf872QGty4fVC30qLUgko5wXFyT5uPwtOwckYEcWVbOSAkTvlTWqQkroYybLE+tCUfQ==
X-Received: by 2002:ac2:5e2e:: with SMTP id o14mr1399159lfg.198.1579688151084;
        Wed, 22 Jan 2020 02:15:51 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id r15sm19988772ljh.11.2020.01.22.02.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 02:15:50 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iuD34-0007bU-71; Wed, 22 Jan 2020 11:15:46 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: [PATCH 1/5] USB: serial: ir-usb: add missing endpoint sanity check
Date:   Wed, 22 Jan 2020 11:15:26 +0100
Message-Id: <20200122101530.29176-2-johan@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200122101530.29176-1-johan@kernel.org>
References: <20200122101530.29176-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add missing endpoint sanity check to avoid dereferencing a NULL-pointer
on open() in case a device lacks a bulk-out endpoint.

Note that prior to commit f4a4cbb2047e ("USB: ir-usb: reimplement using
generic framework") the oops would instead happen on open() if the
device lacked a bulk-in endpoint and on write() if it lacked a bulk-out
endpoint.

Fixes: f4a4cbb2047e ("USB: ir-usb: reimplement using generic framework")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/ir-usb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/serial/ir-usb.c b/drivers/usb/serial/ir-usb.c
index 302eb9530859..c3b06fc5a7f0 100644
--- a/drivers/usb/serial/ir-usb.c
+++ b/drivers/usb/serial/ir-usb.c
@@ -195,6 +195,9 @@ static int ir_startup(struct usb_serial *serial)
 	struct usb_irda_cs_descriptor *irda_desc;
 	int rates;
 
+	if (serial->num_bulk_in < 1 || serial->num_bulk_out < 1)
+		return -ENODEV;
+
 	irda_desc = irda_usb_find_class_desc(serial, 0);
 	if (!irda_desc) {
 		dev_err(&serial->dev->dev,
-- 
2.24.1

