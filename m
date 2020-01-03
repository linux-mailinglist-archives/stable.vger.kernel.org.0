Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 567A512FA87
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 17:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgACQff (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 11:35:35 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36873 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727980AbgACQfe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 11:35:34 -0500
Received: by mail-lf1-f65.google.com with SMTP id b15so32230161lfc.4;
        Fri, 03 Jan 2020 08:35:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t2rl7ZcqsXYCGxJFsJJzURnWZhFxN2ZAlltA2Ev3mU0=;
        b=AmWBVvo5Xq/2tBHD+L2G9q7NB990zlGpdF0heX3OEKuI6aiLDMh2z2JVI/L0nEMVK3
         KkrK/6ySm9rfgvHtkwERWvbJ7bztIXXVYG7mkv6mTiS7Up4BYptrAzAdkCefsF9I3q8Y
         to+5oQDwJKSYBimKztPlEFR7pKz6qcas6gpqtnw013FHeTptkMOvCQNjUhQ5v3T2YM69
         85i0pPBoVoOK7Bt8BXCty33Ue9Rp1GihxumDiGaAsdpGkN3sAZQnDjaLIJGPcp8gA61q
         VIWw8bdaqs5w4L9szqA+lzq4k6dMhjLtbK/yA1TCYflM0BOFvC/nYjF9GXjNpSbkpqL6
         p0ZA==
X-Gm-Message-State: APjAAAUZ5uCbLx/Uu2lNKU8jLWQli+AFzCHEtn28xTZkvc0enyV2Zuoo
        zwwo2NVH0sgOv1qSkuqC4CXCxYPA
X-Google-Smtp-Source: APXvYqwfQMiwtQBYqyr/l2m2RgF1Ki6vgIfhw+bV7PYO3ca3nP4scEMNOH8ETfGDb0vV1FuNaILXpw==
X-Received: by 2002:ac2:5147:: with SMTP id q7mr50425117lfd.87.1578069332135;
        Fri, 03 Jan 2020 08:35:32 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id d20sm24857445lfm.32.2020.01.03.08.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 08:35:30 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1inPvB-0000Kj-3W; Fri, 03 Jan 2020 17:35:33 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Sean Young <sean@mess.org>, Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 1/6] media: flexcop-usb: fix endpoint sanity check
Date:   Fri,  3 Jan 2020 17:35:08 +0100
Message-Id: <20200103163513.1229-2-johan@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200103163513.1229-1-johan@kernel.org>
References: <20200103163513.1229-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A recent commit added an endpoint sanity check to address a NULL-pointer
dereference on probe. Unfortunately the check was done on the current
altsetting which was later changed.

Fix this by moving the sanity check to after the altsetting is changed.

Fixes: 1b976fc6d684 ("media: b2c2-flexcop-usb: add sanity checking")
Cc: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/usb/b2c2/flexcop-usb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/b2c2/flexcop-usb.c b/drivers/media/usb/b2c2/flexcop-usb.c
index 039963a7765b..198ddfb8d2b1 100644
--- a/drivers/media/usb/b2c2/flexcop-usb.c
+++ b/drivers/media/usb/b2c2/flexcop-usb.c
@@ -511,6 +511,9 @@ static int flexcop_usb_init(struct flexcop_usb *fc_usb)
 		return ret;
 	}
 
+	if (fc_usb->uintf->cur_altsetting->desc.bNumEndpoints < 1)
+		return -ENODEV;
+
 	switch (fc_usb->udev->speed) {
 	case USB_SPEED_LOW:
 		err("cannot handle USB speed because it is too slow.");
@@ -544,9 +547,6 @@ static int flexcop_usb_probe(struct usb_interface *intf,
 	struct flexcop_device *fc = NULL;
 	int ret;
 
-	if (intf->cur_altsetting->desc.bNumEndpoints < 1)
-		return -ENODEV;
-
 	if ((fc = flexcop_device_kmalloc(sizeof(struct flexcop_usb))) == NULL) {
 		err("out of memory\n");
 		return -ENOMEM;
-- 
2.24.1

