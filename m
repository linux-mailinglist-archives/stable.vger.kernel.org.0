Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 293DD118636
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 12:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbfLJL0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 06:26:23 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:46963 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbfLJL0W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 06:26:22 -0500
Received: by mail-lj1-f194.google.com with SMTP id z17so19383488ljk.13;
        Tue, 10 Dec 2019 03:26:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5OsDhYumquwD8URBJRA6LU7R9HQWBfpM9E2aQ/J5j10=;
        b=kCfCcmIz7O3FHcYNk9dcq0gVZPOB5qtqEUynUeFOBy5AlGxyXWBTOCStMbPwoDE6LN
         WOILKu5ET0QCz78gCRLxAbcapWK9vJn/zGCk8ZMfRqg/BAKXGrLaOM4+tJ3HS5qva4wT
         Lguw5hV2FTyz2y16OYlAGp0IcNP/ma3sNcZPHYU8zphGSGznBVLARZmpyu+19G7lOwna
         j5uhxQ3IlfDVDPJK+mXbTbyy4ba/i+QwvLLmABkG++4Bu64nBOa1m9ZN+cJ/9IgXsTT/
         5L8VIExGVJlnt3i1OgcK7+HkjUZQGzmzncjIRK5OYJWqupUWwBGG/8kAZaY4SxNho9og
         4+xw==
X-Gm-Message-State: APjAAAWqggWRFrWJZCLJFyZs0+WvVT5/gX3qOvy3ejsyMCPDL50Xgkdj
        DTBB/HXgRSamKXk4HA3Xk2c=
X-Google-Smtp-Source: APXvYqx0/P79/eyW7tmUaqkenv3wqIuiPmwLIEY5+OlcYaubkM/Q36layzZZQRRxI3MNq/Lxad+Iuw==
X-Received: by 2002:a2e:9f52:: with SMTP id v18mr17566281ljk.30.1575977180545;
        Tue, 10 Dec 2019 03:26:20 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id t6sm1568848ljj.62.2019.12.10.03.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 03:26:18 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iedem-0000wa-PR; Tue, 10 Dec 2019 12:26:20 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 3/4] USB: idmouse: fix interface sanity checks
Date:   Tue, 10 Dec 2019 12:26:00 +0100
Message-Id: <20191210112601.3561-4-johan@kernel.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191210112601.3561-1-johan@kernel.org>
References: <20191210112601.3561-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure to use the current alternate setting when verifying the
interface descriptors to avoid binding to an invalid interface.

Failing to do so could cause the driver to misbehave or trigger a WARN()
in usb_submit_urb() that kernels with panic_on_warn set would choke on.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/misc/idmouse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/misc/idmouse.c b/drivers/usb/misc/idmouse.c
index 4afb5ddfd361..e9437a176518 100644
--- a/drivers/usb/misc/idmouse.c
+++ b/drivers/usb/misc/idmouse.c
@@ -322,7 +322,7 @@ static int idmouse_probe(struct usb_interface *interface,
 	int result;
 
 	/* check if we have gotten the data or the hid interface */
-	iface_desc = &interface->altsetting[0];
+	iface_desc = interface->cur_altsetting;
 	if (iface_desc->desc.bInterfaceClass != 0x0A)
 		return -ENODEV;
 
-- 
2.24.0

