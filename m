Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74ED836B816
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 19:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235654AbhDZRbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 13:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235550AbhDZRbU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 13:31:20 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60926C061574
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 10:30:37 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id u80so23572519oia.0
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 10:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wyyhcHvvxF52Sd3fLoAibHOh3vzTBM6XwtNGmvVGbpQ=;
        b=PYw98oAlti0/8OXYfvE8xI4BhSqgC0tz/aPPvVjVVQBr03iT0ocpcf66XmaHwOsv+2
         tjPf7TUEZA+mySnJrjC27aysT86r0V8dzfnmrEVdwZI/saXN+xD+4/MMC+ho4czxD4RM
         PIBuD36szw2/up4I+Mjtw3MkXBkCKQjL+SVzEqzD9Q38QYvEKr2L9M42AYh7aQBM9Pek
         hnRTU341ZBDCtKROhPPpxuUPXQT+jqmPnLFnBo0rH+T0J9TwSzjbC4b/ADNNELOWAMh4
         IXPY8kdGcXVbuelbaAycq/ceRSjeB0jA5sM4NgpTRIouNaO7IgI81apQry4t7l4PFf7N
         zY3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wyyhcHvvxF52Sd3fLoAibHOh3vzTBM6XwtNGmvVGbpQ=;
        b=FD7bQ8MkTF8KVHAVchQYryJImHJwcRNP/fLEO5HwUYN52Y0MnzM/j1rxRH22PCpk/4
         6NDxl9jNhP5l/hzHxlW3l75c1/IWP5ImZ4hkfS2tjMBCh3e1Hu2l2C+1i1qhQ2CkXa9V
         GceJ03srya3HRE9K3MvyG21JFG9/d1HKpU0Df7rrcSYhjNRFniGborrNGMlqe7yT/z3+
         69caJd9uhPrZ1+hyW1qUz8/f5qYPM/gF682FDCll8sG8Kzqh4k7cz8hmyltVEtP6gWEm
         NtuZp1vJCUnPv3EErEGRlqfa1Cm5ZCGgVL8+0h/z/7dsZYCfGWYkFs0WorZyHBaMZT45
         z64w==
X-Gm-Message-State: AOAM531JTrkI57MzfG1wZfaqz/RHiJnczHDK4THOP0tzS5Azro+Qq+P/
        Zmv1RdjCzvHYfAmGZk6WekHh8IrEdisyPonM
X-Google-Smtp-Source: ABdhPJyJ+2y5qAiMMTfmOsBfmHPOlA+fJGCI098wyUZ5vmMBKjckHXdq+FFVQ+FVFRec3rFRR9jgHA==
X-Received: by 2002:aca:4b90:: with SMTP id y138mr12940905oia.169.1619458236280;
        Mon, 26 Apr 2021 10:30:36 -0700 (PDT)
Received: from proxmox.local.lan (2603-80a0-0e01-cc2f-0226-b9ff-fe41-ba6b.res6.spectrum.com. [2603:80a0:e01:cc2f:226:b9ff:fe41:ba6b])
        by smtp.googlemail.com with ESMTPSA id j8sm3745957otj.49.2021.04.26.10.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 10:30:35 -0700 (PDT)
From:   Tom Seewald <tseewald@gmail.com>
To:     stable@vger.kernel.org
Cc:     tseewald@gmail.com, Shuah Khan <skhan@linuxfoundation.org>,
        syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>
Subject: [PATCH] usbip: vudc synchronize sysfs code paths
Date:   Mon, 26 Apr 2021 12:28:31 -0500
Message-Id: <20210426172831.24030-1-tseewald@gmail.com>
X-Mailer: git-send-email 2.20.1
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

Cc: stable@vger.kernel.org # 4.14.x
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

