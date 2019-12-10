Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75DFA11868C
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 12:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbfLJLhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 06:37:53 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37665 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbfLJLhw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 06:37:52 -0500
Received: by mail-lf1-f65.google.com with SMTP id b15so13422351lfc.4;
        Tue, 10 Dec 2019 03:37:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EqNpTSkza+eQj8K2xj20PlaT6wotGOHkK97zIiEKJAQ=;
        b=KzN0d8GZAC4erZ09TcavQa5ecG7zuCLKWzEsHufEPKzXWEpD7o7OvLVHQNe7kLHzLL
         TBhcXmxr6P6Uxj5Q8ZycE8uLfFx36xHj3ifYV1OFu7xhbitEi3ojQM0809wA25Jwh0QQ
         qm7eqUBevtU3etyWPLJgTkVM9VgOjiLRyAvTWu46WFsRr/aNQkjKTQ2KEvzy7+kyypPp
         Xmf6tCeYQQlDKGr1VZ3qEc2oA4w+RZT2IWsXDoq9tiRupRxg2la4TMVrVJquOXXfAVzB
         YTgMgqdTwe0lEMplzCmxp29hrfjY3i54mQitDc0kzwLHQzCgsj87AE3WRYOuqaV6CNJw
         U2fg==
X-Gm-Message-State: APjAAAU0tx4GejOBDrFzK3stZCy3VQ0sEj+8gcaZjNAhdC6K4eZeuqGN
        raxKkmIPmv85sVbq/nWY2g/ed4vH
X-Google-Smtp-Source: APXvYqz3AlE6wPReZrV2ucIUecMHpCKtz7S6dDKY5ME3aa+t3OyIfslalKBvUVIPeddGQ3/bulIcZQ==
X-Received: by 2002:a19:cc49:: with SMTP id c70mr11667364lfg.73.1575977869953;
        Tue, 10 Dec 2019 03:37:49 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id u24sm1569296ljo.77.2019.12.10.03.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 03:37:47 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iedpt-00013n-Tc; Tue, 10 Dec 2019 12:37:49 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        Vladis Dronov <vdronov@redhat.com>
Subject: [PATCH 2/7] Input: aiptek: fix endpoint sanity check
Date:   Tue, 10 Dec 2019 12:37:32 +0100
Message-Id: <20191210113737.4016-3-johan@kernel.org>
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

Fixes: 8e20cf2bce12 ("Input: aiptek - fix crash on detecting device without endpoints")
Cc: stable <stable@vger.kernel.org>     # 4.4
Cc: Vladis Dronov <vdronov@redhat.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/input/tablet/aiptek.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/input/tablet/aiptek.c b/drivers/input/tablet/aiptek.c
index 2ca586fb914f..06d0ffef4a17 100644
--- a/drivers/input/tablet/aiptek.c
+++ b/drivers/input/tablet/aiptek.c
@@ -1802,14 +1802,14 @@ aiptek_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	input_set_abs_params(inputdev, ABS_WHEEL, AIPTEK_WHEEL_MIN, AIPTEK_WHEEL_MAX - 1, 0, 0);
 
 	/* Verify that a device really has an endpoint */
-	if (intf->altsetting[0].desc.bNumEndpoints < 1) {
+	if (intf->cur_altsetting->desc.bNumEndpoints < 1) {
 		dev_err(&intf->dev,
 			"interface has %d endpoints, but must have minimum 1\n",
-			intf->altsetting[0].desc.bNumEndpoints);
+			intf->cur_altsetting->desc.bNumEndpoints);
 		err = -EINVAL;
 		goto fail3;
 	}
-	endpoint = &intf->altsetting[0].endpoint[0].desc;
+	endpoint = &intf->cur_altsetting->endpoint[0].desc;
 
 	/* Go set up our URB, which is called when the tablet receives
 	 * input.
-- 
2.24.0

