Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777213629A9
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 22:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236559AbhDPUyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 16:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234312AbhDPUyF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 16:54:05 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CE0C061574
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 13:53:40 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id v6so1353705oiv.3
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 13:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gClhNBz2PctsHGx1upM7EkuvRPvL47X9XJbsIPsu8zU=;
        b=d962BjDIdQlUnkkEJnbTsh90LjvOQ262ToC5vEnPgm+jJ35BJi5rDUeuR727ZF36A1
         WlCFpT3u4YvxRh9LBW6FuDoZVR1VINYf66JRQDogK3YZiA2s9bA6bv6VEbddRV0Iif/A
         d2XV6lfTuMvCKVy+vSt25bCSQMDYmm8KteHmTiEbYK6NO/ACrBOXfK5lODLEd/PuGExD
         cI3/9hhD9Jx0T4Z3jbwJausA1wQCO9EFDUkN64Fo4jkblR4vSC/NFNXI23ZFPaNI/47W
         5BjmnGx+CJPWu3QkG6iecfTSjrDk7dfBUVehfQioNDFvHaNVNzJaFBqYbcczLKe53si0
         uYIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gClhNBz2PctsHGx1upM7EkuvRPvL47X9XJbsIPsu8zU=;
        b=NgR+5RFjUc4jaba65AAQOzLHgWSuDSveLAmxCv/GtRLnWZFK5MKAUpYPOrlkVc1kY+
         5CjtEb8gadP2ah7hp9XTjLxOyahLYw+KMuUm4EaJWKdbzRsVeEh5Iz3QmenUdv3eba6i
         YkECIw6huporm6815WtiTcAzuNEJwVECFkfmHXGMS9P0xX5yFMiFLdL6GV7O8y+f4zot
         gDnS+P7iCIdFUqbxh1epf5SN5kKJND88PBSknwZbc57osPWG7z2BuNWcUbfBkagmagg1
         y7tfXLQ7FFcieJQoXbBzFo0+uPo9B1yTXprf1beMhXWc+0VbYxGWc1CUSDmTxfnpXgG3
         S/1g==
X-Gm-Message-State: AOAM530viJ+gTmAmbhPtPP5gsJTfv8sfyecxPaiNHHXcKFaWm2zbU7hh
        AtFqgL599fK5nIzrs6IMDaHfzNczUrBUTFAS
X-Google-Smtp-Source: ABdhPJz4ET1JTITlFX36a1ra9NWgfkkhLHbznI52L+2Hnex5/D94x1yx+Hb4uawcy3pZfp5CAXwTlQ==
X-Received: by 2002:a54:4005:: with SMTP id x5mr7912634oie.66.1618606419447;
        Fri, 16 Apr 2021 13:53:39 -0700 (PDT)
Received: from proxmox.local.lan (2603-80a0-0e01-cc2f-0226-b9ff-fe41-ba6b.res6.spectrum.com. [2603:80a0:e01:cc2f:226:b9ff:fe41:ba6b])
        by smtp.googlemail.com with ESMTPSA id c21sm1440847ooa.48.2021.04.16.13.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 13:53:39 -0700 (PDT)
From:   Tom Seewald <tseewald@gmail.com>
To:     stable@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tom Seewald <tseewald@gmail.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>
Subject: [PATCH 3/4] usbip: vudc synchronize sysfs code paths
Date:   Fri, 16 Apr 2021 15:53:18 -0500
Message-Id: <20210416205319.14075-3-tseewald@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210416205319.14075-1-tseewald@gmail.com>
References: <20210416205319.14075-1-tseewald@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

commit bd8b82042269a95db48074b8bb400678dbac1815 upstream.

Fuzzing uncovered race condition between sysfs code paths in usbip
drivers. Device connect/disconnect code paths initiated through
sysfs interface are prone to races if disconnect happens during
connect and vice versa.

Use sysfs_lock to protect sysfs paths in vudc.

Cc: stable@vger.kernel.org # 4.9.x # 4.14.x
Reported-and-tested-by: syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/caabcf3fc87bdae970509b5ff32d05bb7ce2fb15.1616807117.git.skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Tom Seewald <tseewald@gmail.com>
---
 drivers/usb/usbip/vudc_dev.c   | 1 +
 drivers/usb/usbip/vudc_sysfs.c | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/usb/usbip/vudc_dev.c b/drivers/usb/usbip/vudc_dev.c
index 7091848df6c8..d61b22bb1d8b 100644
--- a/drivers/usb/usbip/vudc_dev.c
+++ b/drivers/usb/usbip/vudc_dev.c
@@ -582,6 +582,7 @@ static int init_vudc_hw(struct vudc *udc)
 	init_waitqueue_head(&udc->tx_waitq);
 
 	spin_lock_init(&ud->lock);
+	mutex_init(&ud->sysfs_lock);
 	ud->status = SDEV_ST_AVAILABLE;
 	ud->side = USBIP_VUDC;
 
diff --git a/drivers/usb/usbip/vudc_sysfs.c b/drivers/usb/usbip/vudc_sysfs.c
index f44d98eeb36a..e9d8dbd4e5a4 100644
--- a/drivers/usb/usbip/vudc_sysfs.c
+++ b/drivers/usb/usbip/vudc_sysfs.c
@@ -125,6 +125,7 @@ static ssize_t store_sockfd(struct device *dev,
 		dev_err(dev, "no device");
 		return -ENODEV;
 	}
+	mutex_lock(&udc->ud.sysfs_lock);
 	spin_lock_irqsave(&udc->lock, flags);
 	/* Don't export what we don't have */
 	if (!udc->driver || !udc->pullup) {
@@ -200,6 +201,8 @@ static ssize_t store_sockfd(struct device *dev,
 
 		wake_up_process(udc->ud.tcp_rx);
 		wake_up_process(udc->ud.tcp_tx);
+
+		mutex_unlock(&udc->ud.sysfs_lock);
 		return count;
 
 	} else {
@@ -220,6 +223,7 @@ static ssize_t store_sockfd(struct device *dev,
 	}
 
 	spin_unlock_irqrestore(&udc->lock, flags);
+	mutex_unlock(&udc->ud.sysfs_lock);
 
 	return count;
 
@@ -229,6 +233,7 @@ static ssize_t store_sockfd(struct device *dev,
 	spin_unlock_irq(&udc->ud.lock);
 unlock:
 	spin_unlock_irqrestore(&udc->lock, flags);
+	mutex_unlock(&udc->ud.sysfs_lock);
 
 	return ret;
 }
-- 
2.20.1

