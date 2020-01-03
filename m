Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFC5512FA9B
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 17:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgACQgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 11:36:02 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37003 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728040AbgACQff (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 11:35:35 -0500
Received: by mail-lj1-f196.google.com with SMTP id o13so33001084ljg.4;
        Fri, 03 Jan 2020 08:35:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+tlqOZeymQPSzMRwJcWO6YbRSpeG6g0qeksDnmBdU10=;
        b=BazQZLFwOzVOPB0VwBVnhNRyeWeWGjqREEXs3llMKwYOeEXpkM3tVqZyT0/uoRPAXZ
         AMKQAoSCJaN5P7pF+VaGE5PA/tWv4ANx04bkrQpYbF1c6aTzKZlsLxrgzJEfQKOg/F0H
         eavjvabmBdBXR9fltugjvoGyBbeMLFcsbTxcxQJaTvot5eVWGlrme8gjLbUNfOqTGBCl
         adtFem8UAThZY+omHYBSNzO8PIYYegf16Ql35sHIRKoGU7oUHIP2rYskl0y2zgKJO5Wu
         THVkyagqzSeeeu2b9vXJMKK3D9RMigj61CUMNgh3X9gtryIFQXwb7rTnxvafTVMjgWWJ
         PyJw==
X-Gm-Message-State: APjAAAVI9PuztnpjnsrbfR24A4Y3/oJIVvAps4dxNRKoAuU0yy4Lszqu
        Q+oVPYti98UzCGkzfwD6HWg=
X-Google-Smtp-Source: APXvYqwYSsLJyZGoPLjR6puxlsXnmFozkkoUW6uBboL+dGzIHZp3/IWNSbX0v5RXpEQ36TA9fZ4bOg==
X-Received: by 2002:a2e:8603:: with SMTP id a3mr43840365lji.210.1578069333597;
        Fri, 03 Jan 2020 08:35:33 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id l5sm23959515lje.1.2020.01.03.08.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 08:35:32 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1inPvB-0000L3-FV; Fri, 03 Jan 2020 17:35:33 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Sean Young <sean@mess.org>, Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 5/6] media: dib0700: fix rc endpoint lookup
Date:   Fri,  3 Jan 2020 17:35:12 +0100
Message-Id: <20200103163513.1229-6-johan@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200103163513.1229-1-johan@kernel.org>
References: <20200103163513.1229-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure to use the current alternate setting when verifying the
interface descriptors to avoid submitting an URB to an invalid endpoint.

Failing to do so could cause the driver to misbehave or trigger a WARN()
in usb_submit_urb() that kernels with panic_on_warn set would choke on.

Fixes: c4018fa2e4c0 ("[media] dib0700: fix RC support on Hauppauge Nova-TD")
Cc: stable <stable@vger.kernel.org>     # 3.16
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/usb/dvb-usb/dib0700_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index e53c58ab6488..ef62dd6c5ae4 100644
--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -818,7 +818,7 @@ int dib0700_rc_setup(struct dvb_usb_device *d, struct usb_interface *intf)
 
 	/* Starting in firmware 1.20, the RC info is provided on a bulk pipe */
 
-	if (intf->altsetting[0].desc.bNumEndpoints < rc_ep + 1)
+	if (intf->cur_altsetting->desc.bNumEndpoints < rc_ep + 1)
 		return -ENODEV;
 
 	purb = usb_alloc_urb(0, GFP_KERNEL);
@@ -838,7 +838,7 @@ int dib0700_rc_setup(struct dvb_usb_device *d, struct usb_interface *intf)
 	 * Some devices like the Hauppauge NovaTD model 52009 use an interrupt
 	 * endpoint, while others use a bulk one.
 	 */
-	e = &intf->altsetting[0].endpoint[rc_ep].desc;
+	e = &intf->cur_altsetting->endpoint[rc_ep].desc;
 	if (usb_endpoint_dir_in(e)) {
 		if (usb_endpoint_xfer_bulk(e)) {
 			pipe = usb_rcvbulkpipe(d->udev, rc_ep);
-- 
2.24.1

