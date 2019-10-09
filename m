Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3215AD1310
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 17:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731340AbfJIPi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 11:38:57 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40882 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731168AbfJIPi5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 11:38:57 -0400
Received: by mail-lj1-f193.google.com with SMTP id 7so2968360ljw.7;
        Wed, 09 Oct 2019 08:38:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/zQJrcNnJxUcOVRPJjyZL/u2APizudcIOcg9KosTJuI=;
        b=KTUDPaAUejV1guU8qJi4jlzzDedgHv635yvRLw6KzD+ExNg+atfiSdjJ+ugGHYJk5h
         FJtJiORFkp1b9JiLhgcTuXbo8fQ8Ri143WaFU1WJGo6JMe2MvmFuHL5pFu3BNCs5Kdey
         Xuh64pQngLHIuABtmLOtb6X10gpIiGzG6nZmCxEcZVDdMiFEkBtAcBazOsPI7AsYmLGv
         uiWgC0u8c9JYRfoyj/JYTLNGWM9DT47VNaaQKHNdtuaojRyb9fm63iY45Ldzy4Yv+Aef
         fkVU9cCH0B4Hvlwv9sFVGKZ/MJGWe1JUW3UuMflEIB++CpRWs1tOZ6kIly7HKTkh9wGD
         7ePQ==
X-Gm-Message-State: APjAAAUEoyaRqB7rjyGSbxuyiosdKx2eAPbhwKSzwjrbq48iXwdR2B4C
        m6tzrXG8wg9ZTIu3dxz3Q0CJ85os
X-Google-Smtp-Source: APXvYqxabR1MXt0AgYV0VZq8D6na/8L7mjbB4TOHMZxWwdDNpo6z9gIUTQN55CNZ0fM+mMiWzWxK5g==
X-Received: by 2002:a2e:420a:: with SMTP id p10mr2881448lja.16.1570635534570;
        Wed, 09 Oct 2019 08:38:54 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id b7sm529841lfp.23.2019.10.09.08.38.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Oct 2019 08:38:53 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iIE3J-0002H6-IG; Wed, 09 Oct 2019 17:39:01 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, Keith Packard <keithp@keithp.com>,
        Juergen Stuber <starblue@users.sourceforge.net>,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 4/5] USB: legousbtower: fix use-after-free on release
Date:   Wed,  9 Oct 2019 17:38:47 +0200
Message-Id: <20191009153848.8664-5-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191009153848.8664-1-johan@kernel.org>
References: <20191009153848.8664-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver was accessing its struct usb_device in its release()
callback without holding a reference. This would lead to a
use-after-free whenever the device was disconnected while the character
device was still open.

Fixes: fef526cae700 ("USB: legousbtower: remove custom debug macro")
Cc: stable <stable@vger.kernel.org>     # 3.12
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/misc/legousbtower.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/misc/legousbtower.c b/drivers/usb/misc/legousbtower.c
index 44d6a3381804..9d4c52a7ebe0 100644
--- a/drivers/usb/misc/legousbtower.c
+++ b/drivers/usb/misc/legousbtower.c
@@ -296,6 +296,7 @@ static inline void tower_delete (struct lego_usb_tower *dev)
 	kfree (dev->read_buffer);
 	kfree (dev->interrupt_in_buffer);
 	kfree (dev->interrupt_out_buffer);
+	usb_put_dev(dev->udev);
 	kfree (dev);
 }
 
@@ -810,7 +811,7 @@ static int tower_probe (struct usb_interface *interface, const struct usb_device
 
 	mutex_init(&dev->lock);
 
-	dev->udev = udev;
+	dev->udev = usb_get_dev(udev);
 	dev->open_count = 0;
 	dev->disconnected = 0;
 
-- 
2.23.0

