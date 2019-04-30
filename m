Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 763A510366
	for <lists+stable@lfdr.de>; Wed,  1 May 2019 01:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfD3Xxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 19:53:37 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46130 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbfD3Xxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Apr 2019 19:53:37 -0400
Received: by mail-pg1-f196.google.com with SMTP id n2so7566830pgg.13
        for <stable@vger.kernel.org>; Tue, 30 Apr 2019 16:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uBpm5gYOe5W/bG3Rpue7pr4kHy6ULIihFpmVaIiYSuc=;
        b=AM1rxiWpPSzeBi0LVngerVt7H4ksulYZwnczMUdf6VY6SKjpqgEMHfQMNwnOAK7g+5
         cSF+dXusY4o+RgTaWA/4K7GBZNcGQk9qAjt83u3Jsxu3V0Eg1iO1YWCWmGFAc5cUmu+0
         3yejTGoLHJG9lQfKSp05jxTzfBsUzH6wTRFS5zaLbIrym0uUeaiFyuMZ76FXE3mpwp7o
         f+qtPnrQnnT3GxqRP3mwrHQZ1gl0wAvlWfPzVh9pE1fjDI1+o810kyNQ2Y7kTI4D4hM/
         Cat+t5h9cxudG7FNNbcOXTbLcZYG8ShWwvxSNfGZf7QZdTt4/CIhXoFtATBecBzxiGbx
         xYVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=uBpm5gYOe5W/bG3Rpue7pr4kHy6ULIihFpmVaIiYSuc=;
        b=n0e4be6c8VXWa2gJ3R0X/j2ekeSvROADl/r4avYc80Rxy3aLJ9X6SslO3Uiy6dZibw
         mcEHahUICAseb+QwbIIbGATjqOj7+tT4oQZwOkU/1MC3r2DsWdvNzB0AQEGkeD+Ti4Tl
         bC2nt0yQi4oGXkJTvOLKN/eN1YFGToUUyzm54d/JXgdRRxoWL/PQFj+TKQNYAAhjVZjt
         5V9fMhxZXq7i/JbdqL2m8l4hEcY7gcAHGYHkZ8OEy+BaKmeRhrl1K7OaDdyR6vl8297z
         Qq18QYR3jEsotveIUcUJpmOFRJDi45YBfJbrSODHoriKh8VagXENt5wMHA2+FcILIvX3
         5gtw==
X-Gm-Message-State: APjAAAXLqy5m+KbTegKxV+tbpMVly2aPPbdaWVUbsIuCbvVhFQUgyIOe
        8l1otQugfyrM3MEEh+UxRp8=
X-Google-Smtp-Source: APXvYqyzy50RmcLiFIEwiyBJEwaMi7S9RLVNRc4AAQ4OXRQ0P9+EuwPeKuCOfBcK1pgmbHVcdBJZaw==
X-Received: by 2002:a63:f64f:: with SMTP id u15mr62259364pgj.192.1556668416592;
        Tue, 30 Apr 2019 16:53:36 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s6sm6944570pfb.128.2019.04.30.16.53.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 16:53:36 -0700 (PDT)
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        "David S . Miller" <davem@davemloft.net>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v4.4,v4.9,v4.14 2/2] usbnet: ipheth: fix potential null pointer dereference in ipheth_carrier_set
Date:   Tue, 30 Apr 2019 16:53:30 -0700
Message-Id: <1556668410-31439-2-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556668410-31439-1-git-send-email-linux@roeck-us.net>
References: <1556668410-31439-1-git-send-email-linux@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>

commit 61c59355e0154a938b28710dfa6c1d8be2ddcefa upstream.

_dev_ is being dereferenced before it is null checked, hence there
is a potential null pointer dereference.

Fix this by moving the pointer dereference after _dev_ has been null
checked.

Addresses-Coverity-ID: 1462020
Fixes: bb1b40c7cb86 ("usbnet: ipheth: prevent TX queue timeouts when device not ready")
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/net/usb/ipheth.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index cefb75f8cc94..01f95d192d25 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -290,12 +290,15 @@ static void ipheth_sndbulk_callback(struct urb *urb)
 
 static int ipheth_carrier_set(struct ipheth_device *dev)
 {
-	struct usb_device *udev = dev->udev;
+	struct usb_device *udev;
 	int retval;
+
 	if (!dev)
 		return 0;
 	if (!dev->confirmed_pairing)
 		return 0;
+
+	udev = dev->udev;
 	retval = usb_control_msg(udev,
 			usb_rcvctrlpipe(udev, IPHETH_CTRL_ENDP),
 			IPHETH_CMD_CARRIER_CHECK, /* request */
-- 
2.7.4

