Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 649F534DDA3
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 03:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhC3BhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 21:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbhC3Bgz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 21:36:55 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3BFC061762
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 18:36:55 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id v26so14739250iox.11
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 18:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tV/mEj+Wz4XIbwCNkB/GFkd/M8Q2H4CM2ibkXqRlrls=;
        b=NtT7wCrRnSAGUWpVWKDKbK87e+lZ68sIxKoEKYx5eXkr5uEYVxvOjCIkhvJ4OCxPJY
         CSuLHcvo0Rbopiyg+cjMgmc57WZkpouFLjROnkzowqYimckIUyBixLhQ+hfb+ipkRiaU
         81DTjLGUAvlitj+31mL4GA01UAuPMIKeZ1Bds=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tV/mEj+Wz4XIbwCNkB/GFkd/M8Q2H4CM2ibkXqRlrls=;
        b=VJmwhru0xGxyBsoozoqiGxy02gVx7bNNxTX/Qc/mHk2MUqrg3gBQdMwXt8vK2xhsUH
         0WfX5mFgncZZJP482tNEmZkNZ3auMctZiNbgDc3eiVPKLB2CvtGJjjZQEjoxb5PBa1lH
         MZ5e3+m8jpQoO3Vf8YiBBlXlT8KEj+GgsEtQwZUDP8iUqO8fjsf7hsVBVkOylq9aoo3m
         jzJmCDyJMPqXkPGWhIrR0+QqefMxoYcs2Vn75j/jYa+t7kKWP4wubr/rjrdOXSvoqVOZ
         d0n00lTeF2ThqZ3mgzA4ACCBQSCe417llQ//PB/cawRMVY36n7IDfRHI21gRbYmx4zt6
         3Y4A==
X-Gm-Message-State: AOAM533qLDFiBSrVs2pxNM9wCIyUpm9Q+I/Mrtos54ai4A/hHsXjAp6q
        aynci2K7uFSFTNvZK28H4sHWvw==
X-Google-Smtp-Source: ABdhPJymWFQgtGt2nvRet++FbCKoktEKtDhEaZuC66r7VTdIM7c0tSZNfwldgR6bWs9qvYTEQLquSg==
X-Received: by 2002:a6b:5905:: with SMTP id n5mr22385286iob.90.1617068214937;
        Mon, 29 Mar 2021 18:36:54 -0700 (PDT)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id i13sm10551696ilm.86.2021.03.29.18.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 18:36:54 -0700 (PDT)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     valentina.manea.m@gmail.com, shuah@kernel.org,
        gregkh@linuxfoundation.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: [PATCH 3/4] usbip: vudc synchronize sysfs code paths
Date:   Mon, 29 Mar 2021 19:36:50 -0600
Message-Id: <caabcf3fc87bdae970509b5ff32d05bb7ce2fb15.1616807117.git.skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1616807117.git.skhan@linuxfoundation.org>
References: <cover.1616807117.git.skhan@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fuzzing uncovered race condition between sysfs code paths in usbip
drivers. Device connect/disconnect code paths initiated through
sysfs interface are prone to races if disconnect happens during
connect and vice versa.

Use sysfs_lock to protect sysfs paths in vudc.

Reported-and-tested-by: syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 drivers/usb/usbip/vudc_dev.c   | 1 +
 drivers/usb/usbip/vudc_sysfs.c | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/usb/usbip/vudc_dev.c b/drivers/usb/usbip/vudc_dev.c
index c8eeabdd9b56..2bc428f2e261 100644
--- a/drivers/usb/usbip/vudc_dev.c
+++ b/drivers/usb/usbip/vudc_dev.c
@@ -572,6 +572,7 @@ static int init_vudc_hw(struct vudc *udc)
 	init_waitqueue_head(&udc->tx_waitq);
 
 	spin_lock_init(&ud->lock);
+	mutex_init(&ud->sysfs_lock);
 	ud->status = SDEV_ST_AVAILABLE;
 	ud->side = USBIP_VUDC;
 
diff --git a/drivers/usb/usbip/vudc_sysfs.c b/drivers/usb/usbip/vudc_sysfs.c
index 7383a543c6d1..f7633ee655a1 100644
--- a/drivers/usb/usbip/vudc_sysfs.c
+++ b/drivers/usb/usbip/vudc_sysfs.c
@@ -112,6 +112,7 @@ static ssize_t usbip_sockfd_store(struct device *dev,
 		dev_err(dev, "no device");
 		return -ENODEV;
 	}
+	mutex_lock(&udc->ud.sysfs_lock);
 	spin_lock_irqsave(&udc->lock, flags);
 	/* Don't export what we don't have */
 	if (!udc->driver || !udc->pullup) {
@@ -187,6 +188,8 @@ static ssize_t usbip_sockfd_store(struct device *dev,
 
 		wake_up_process(udc->ud.tcp_rx);
 		wake_up_process(udc->ud.tcp_tx);
+
+		mutex_unlock(&udc->ud.sysfs_lock);
 		return count;
 
 	} else {
@@ -207,6 +210,7 @@ static ssize_t usbip_sockfd_store(struct device *dev,
 	}
 
 	spin_unlock_irqrestore(&udc->lock, flags);
+	mutex_unlock(&udc->ud.sysfs_lock);
 
 	return count;
 
@@ -216,6 +220,7 @@ static ssize_t usbip_sockfd_store(struct device *dev,
 	spin_unlock_irq(&udc->ud.lock);
 unlock:
 	spin_unlock_irqrestore(&udc->lock, flags);
+	mutex_unlock(&udc->ud.sysfs_lock);
 
 	return ret;
 }
-- 
2.27.0

