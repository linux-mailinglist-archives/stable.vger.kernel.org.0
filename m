Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC8C1118711
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 12:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbfLJLsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 06:48:30 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:44717 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727411AbfLJLsB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 06:48:01 -0500
Received: by mail-lf1-f67.google.com with SMTP id v201so13420924lfa.11;
        Tue, 10 Dec 2019 03:48:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5C4SF4dYqrrVgr3TXUeoZ9GHkn69qJJjE9pwXzPrJrg=;
        b=Si+8ZLYo0AA6ktzMy5qnifeF6iHPmhrrKQGZFW+MWFY6p3HBdRO6AKtVTNG0zHD5dg
         bcZLhSRdbuzF4Rv3BepQJd4sdJJqGofcdq9wlfhwfJutBsa63y0/3F2EvyZKGJ4fczM4
         BkCEPKFxvHSDX18Q1Z14EZKyBosjGND3taU4OYOa9bqNQKKPYL2tW7cdTHPxNnqT1EJP
         nFv9srB69i88zdPrUN7hfgjqCBdXfxbcQC6NN4y21C9dWl6qVDvQnUO5xPn4HUwXH/7I
         LRmQiczx04H1jWpczSBm5EAqIJcOeLGdnpcj0reRCvAMQn3OWKkk/lNSGHZCEHA5NoPJ
         v8zw==
X-Gm-Message-State: APjAAAXnB9NGsgq0Exur1ctRlVzJAkeWNpsTniEYVHC6KW9LB9J/ntCC
        7/pVcZ0aja8WVHBmlB7W5tZVhGf7
X-Google-Smtp-Source: APXvYqxzDhvpXC8Gs8pOUopECbJJEaJy4ZsNQJ3HROeJjafJrIC0HjKI+nYfNFhmf3ZJhA1OTxsboA==
X-Received: by 2002:ac2:4476:: with SMTP id y22mr18829851lfl.169.1575978479262;
        Tue, 10 Dec 2019 03:47:59 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id i1sm1640753lji.71.2019.12.10.03.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 03:47:58 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iedzk-0001LQ-Ej; Tue, 10 Dec 2019 12:48:00 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        devel@driverdev.osuosl.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 1/2] staging: rtl8188eu: fix interface sanity check
Date:   Tue, 10 Dec 2019 12:47:50 +0100
Message-Id: <20191210114751.5119-2-johan@kernel.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191210114751.5119-1-johan@kernel.org>
References: <20191210114751.5119-1-johan@kernel.org>
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

Fixes: c2478d39076b ("staging: r8188eu: Add files for new driver - part 20")
Cc: stable <stable@vger.kernel.org>     # 3.12
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 4fac9dca798e..a7cac0719b8b 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -70,7 +70,7 @@ static struct dvobj_priv *usb_dvobj_init(struct usb_interface *usb_intf)
 	phost_conf = pusbd->actconfig;
 	pconf_desc = &phost_conf->desc;
 
-	phost_iface = &usb_intf->altsetting[0];
+	phost_iface = usb_intf->cur_altsetting;
 	piface_desc = &phost_iface->desc;
 
 	pdvobjpriv->NumInterfaces = pconf_desc->bNumInterfaces;
-- 
2.24.0

