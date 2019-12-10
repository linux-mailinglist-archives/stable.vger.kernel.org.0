Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0C0D11868F
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 12:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbfLJLhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 06:37:51 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:39901 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727131AbfLJLhv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 06:37:51 -0500
Received: by mail-lf1-f66.google.com with SMTP id y1so2112150lfb.6;
        Tue, 10 Dec 2019 03:37:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZY93hUXgP9MdjxnR094b5yMFKUy+YydKGknr6vwPzSM=;
        b=ss7kiSP711gFTqT3iMckKzXWfkAlF1673Dcdou2O2mtfrZuvYxjTdzVQsHnwaAOBE2
         1XteH/vRG8FgqbVHGMkc59Eff18IF6Aa9vO7toaySTYu0eBmZrWIoZixXRUhmP4ehaI+
         K5YkfDSKYy/gyo0bzXeGuwwCluynVEtYverCYT/cHPAaX8zRDv71av4EjoADPWPI257B
         WhRfgBhoXf//i3Vbu0hzQIK8nV46hGkSR5vaGW9/U94lMTVhKYQTULLVU9XRg15bkNp4
         jOTvcJsX+qMXA5NuZLtLoXcKORC2K1El87MwuxVpCEM7f6kr98y8o1ZC3GU62axh1YJo
         KUeQ==
X-Gm-Message-State: APjAAAUILQC8W5G6lHq5zPsNxw6OM587jQqL0U2KKSDFAwCFLJj6Sf+c
        zkcy3iB39BS/XF7PRxO536M=
X-Google-Smtp-Source: APXvYqzqUPnasg7TcmqZwZCL73CR6bdEW7PtC489KLUT5hWmCeetgNTRr1cvB2nHk0JBXWWB5Qq1tg==
X-Received: by 2002:a19:6a06:: with SMTP id u6mr14684526lfu.187.1575977868601;
        Tue, 10 Dec 2019 03:37:48 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id f24sm1615955ljm.12.2019.12.10.03.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 03:37:47 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iedpt-00013j-QS; Tue, 10 Dec 2019 12:37:49 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCH 1/7] Input: pegasus_notetaker: fix endpoint sanity check
Date:   Tue, 10 Dec 2019 12:37:31 +0100
Message-Id: <20191210113737.4016-2-johan@kernel.org>
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
setting instead of the current one, something which could be used by a
malicious device (or USB descriptor fuzzer) to trigger a NULL-pointer
dereference.

Fixes: 1afca2b66aac ("Input: add Pegasus Notetaker tablet driver")
Cc: stable <stable@vger.kernel.org>     # 4.8
Cc: Martin Kepplinger <martink@posteo.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/input/tablet/pegasus_notetaker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/tablet/pegasus_notetaker.c b/drivers/input/tablet/pegasus_notetaker.c
index a1f3a0cb197e..38f087404f7a 100644
--- a/drivers/input/tablet/pegasus_notetaker.c
+++ b/drivers/input/tablet/pegasus_notetaker.c
@@ -275,7 +275,7 @@ static int pegasus_probe(struct usb_interface *intf,
 		return -ENODEV;
 
 	/* Sanity check that the device has an endpoint */
-	if (intf->altsetting[0].desc.bNumEndpoints < 1) {
+	if (intf->cur_altsetting->desc.bNumEndpoints < 1) {
 		dev_err(&intf->dev, "Invalid number of endpoints\n");
 		return -EINVAL;
 	}
-- 
2.24.0

