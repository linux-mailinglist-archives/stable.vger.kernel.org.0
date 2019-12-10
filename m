Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2E59118632
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 12:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbfLJL0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 06:26:22 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36262 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727196AbfLJL0W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 06:26:22 -0500
Received: by mail-lj1-f194.google.com with SMTP id r19so19474444ljg.3;
        Tue, 10 Dec 2019 03:26:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WucoAdQqWyBkNs0JJK7CZWsBgKNZr9bbzVbrw8HFiTo=;
        b=FKzRcbnT9u3OQvLftwa2lflSjWPCqrSn0zVmZOWtfP7JM+TZ4NEEvX7Qv35WB8R6tN
         XlrBBQtWlmPH3JtL/9zJUmdEYzUlcGU6+34NXNYIvM6r17zT8/DxcFP5yffi9e8CHBZe
         zs/SyGJhQStRrcyNJSssTJvHZ+Cg0+/UH/niefSHjB4bHAQ3Jyg4ei7CrkmUt5qkn6t+
         btp5Wmcubmmt7M2TGFxAB22i4mdsIV9qDHURtjuAD0TohnoNpJIxxpP3+9jSr6iHG8W6
         QU6g2A2loe7e2tUAMaetE5RUM0105YtU+1ZKmkYdZHNS2Bp0ocwekpvh86/Psa4zS8E/
         uXzA==
X-Gm-Message-State: APjAAAU++HLgbvtnMdQCfy2BHxidpThgK5wofK1ReFtmDa6mTRJEHpsn
        Yz0iZrhwNrydIKu50Quspxg=
X-Google-Smtp-Source: APXvYqws6nRYSYz0R6XHyWlg+BYv6iqXM+SVEVrSsINEOjmeHi1LZwCuiGLtZKcURnf6Ix9nKqJLhg==
X-Received: by 2002:a2e:9a51:: with SMTP id k17mr19128887ljj.206.1575977180051;
        Tue, 10 Dec 2019 03:26:20 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id e20sm1555481ljl.59.2019.12.10.03.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 03:26:18 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iedem-0000wM-Ms; Tue, 10 Dec 2019 12:26:20 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 2/4] USB: adutux: fix interface sanity check
Date:   Tue, 10 Dec 2019 12:25:59 +0100
Message-Id: <20191210112601.3561-3-johan@kernel.org>
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

Fixes: 03270634e242 ("USB: Add ADU support for Ontrak ADU devices")
Cc: stable <stable@vger.kernel.org>     # 2.6.19
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/misc/adutux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/misc/adutux.c b/drivers/usb/misc/adutux.c
index 6f5edb9fc61e..d8d157c4c271 100644
--- a/drivers/usb/misc/adutux.c
+++ b/drivers/usb/misc/adutux.c
@@ -669,7 +669,7 @@ static int adu_probe(struct usb_interface *interface,
 	init_waitqueue_head(&dev->read_wait);
 	init_waitqueue_head(&dev->write_wait);
 
-	res = usb_find_common_endpoints_reverse(&interface->altsetting[0],
+	res = usb_find_common_endpoints_reverse(interface->cur_altsetting,
 			NULL, NULL,
 			&dev->interrupt_in_endpoint,
 			&dev->interrupt_out_endpoint);
-- 
2.24.0

