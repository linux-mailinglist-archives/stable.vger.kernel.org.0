Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE01ED1309
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 17:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731252AbfJIPiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 11:38:55 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34771 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729865AbfJIPiz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 11:38:55 -0400
Received: by mail-lj1-f194.google.com with SMTP id j19so3018024lja.1;
        Wed, 09 Oct 2019 08:38:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Br9ch3HUxePYMcVA5+eOqOIVq/1B20gFu8Zz9x8IFTI=;
        b=XBhXP7R1BvdDAaYId5Jh3TWjEho52qqGxmMcjim4BhCD8kC8EEDcNaS0rXzW5O9+fd
         YTIb5yIm9qJNlQAnGbfxY20hF42cgLyIdaxWc5aISncto+g3WVsBl5sa/i3eYZ6WBewW
         7q1UCCIsDCa2z0cY+/lEVaG746M/KZn99yV/JngpCyc6HNzaY+jlMXkYUgE3ZILc48IR
         g6H0RNbgJB2DNyGkpUSc/2GcTN5Si0rZKI+SiSre5XXamzbvyefPEUSQCJ5ONx38jhhA
         c3je9QIATDg8JMYllEYBzzDGbLap2MaD/CRby2qwqHsSu4++EkE9s9sSamsqR4eMobvz
         RoOg==
X-Gm-Message-State: APjAAAUIHfjNwqz13oX54YwZNF2VqJ8RDermSnaGNUNTiSIAJRyv8gZd
        hgybwJLV8aQe31cltyqxvY9ZCFgd
X-Google-Smtp-Source: APXvYqywcWUdHcZH20c3zwxA9S/BXw6GsWgph5TWDTvmOIYGVcG/uEb6zD2k0xkfN06b4ddhIpYjtw==
X-Received: by 2002:a2e:6101:: with SMTP id v1mr2827736ljb.122.1570635532802;
        Wed, 09 Oct 2019 08:38:52 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id q5sm582581lfm.93.2019.10.09.08.38.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Oct 2019 08:38:51 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iIE3J-0002Gw-DB; Wed, 09 Oct 2019 17:39:01 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, Keith Packard <keithp@keithp.com>,
        Juergen Stuber <starblue@users.sourceforge.net>,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 2/5] USB: chaoskey: fix use-after-free on release
Date:   Wed,  9 Oct 2019 17:38:45 +0200
Message-Id: <20191009153848.8664-3-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191009153848.8664-1-johan@kernel.org>
References: <20191009153848.8664-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver was accessing its struct usb_interface in its release()
callback without holding a reference. This would lead to a
use-after-free whenever the device was disconnected while the character
device was still open.

Fixes: 66e3e591891d ("usb: Add driver for Altus Metrum ChaosKey device (v2)")
Cc: stable <stable@vger.kernel.org>     # 4.1
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/misc/chaoskey.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/misc/chaoskey.c b/drivers/usb/misc/chaoskey.c
index cf5828ce927a..34e6cd6f40d3 100644
--- a/drivers/usb/misc/chaoskey.c
+++ b/drivers/usb/misc/chaoskey.c
@@ -98,6 +98,7 @@ static void chaoskey_free(struct chaoskey *dev)
 		usb_free_urb(dev->urb);
 		kfree(dev->name);
 		kfree(dev->buf);
+		usb_put_intf(dev->interface);
 		kfree(dev);
 	}
 }
@@ -145,6 +146,8 @@ static int chaoskey_probe(struct usb_interface *interface,
 	if (dev == NULL)
 		goto out;
 
+	dev->interface = usb_get_intf(interface);
+
 	dev->buf = kmalloc(size, GFP_KERNEL);
 
 	if (dev->buf == NULL)
@@ -174,8 +177,6 @@ static int chaoskey_probe(struct usb_interface *interface,
 			goto out;
 	}
 
-	dev->interface = interface;
-
 	dev->in_ep = in_ep;
 
 	if (le16_to_cpu(udev->descriptor.idVendor) != ALEA_VENDOR_ID)
-- 
2.23.0

