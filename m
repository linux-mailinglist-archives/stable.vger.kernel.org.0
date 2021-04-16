Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1EF3629A8
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 22:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236387AbhDPUyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 16:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234312AbhDPUyC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 16:54:02 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E3BC061574
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 13:53:36 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id a21so16088988oib.10
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 13:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o2I1ugYhrAul2FqAdFz18RQe+MGL/+zQfL0tzztH0bQ=;
        b=OQfT/E2ZqchZoXoQQAw5uwIoaibNLFesoYDlEgtdXtxXqmn9wcA5NVeTv/n7uRX0zr
         OQrykjtAOD2lOcuSdeRrhRMoZPB6hNh/AtQTEDErP/Uppq9QOjpZaosvt114nlXoe0+/
         r+FqmNxsHUIZc6vsqBVtynrVVFT7WxJfDbZSfkjNeaOdh5i6ko2L9XBrC5LRxLwvw4Oc
         72diQ4ST0dhEI/jkzRBr9SRhv/ty4wvokAVaIb7ZyiHCSaL54qJJPQj5rsi18Gn5kz8f
         Bg6OReK95J59JgGPIxE8rJ7Vr0xYIgGFFYfNarjCs8Dfwca1GvWnkXE2sF3Y5USNMcjL
         B/mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o2I1ugYhrAul2FqAdFz18RQe+MGL/+zQfL0tzztH0bQ=;
        b=A8NbBE1DaImgLBLGgId3/t03wvZgAlI/ge9xhL4XasxDfhvI0rp2r4K9c++PLzUd3U
         JY2HYc5g1KOYDOKJ8NvqIEf5PTLmYRynira/yeArD7iOkMCtB3idcA/lZQE2Nm1sbl61
         9sJp1v9RtxKOC2RB5fB31oqcuCqqBuvs2FxK1hiMVOWpQAZA3jHjkOFsjHVKjS4+2yDD
         KCt/WhWaE01udJ9RihktNu3kyXgWv0BTkyvBPSCrwPXZjyuzv9wSCrYePaT62BDG2isO
         BWwXBaNlmcmye3roZ/avPvPsA9qFMuFYBkz+kjMHMFYZfrMFglhIYdbtoa0hX2tyVTph
         UhqA==
X-Gm-Message-State: AOAM532bsGAa+2GxpMdB1gp3S6u7+r2fw5uW1DHMLcF4BNij2hGiT7q5
        zcrSDPblse/wFJOMDSb6YC88SG4HPaCTiVo4
X-Google-Smtp-Source: ABdhPJwgCpTxJLENCAWo4NQwJ1xV/7DQ7hya9BSOT6AMbqV1nJUlWxsaItb+CMdilQ+GhVqykAjF6g==
X-Received: by 2002:a05:6808:d4c:: with SMTP id w12mr5188851oik.60.1618606415342;
        Fri, 16 Apr 2021 13:53:35 -0700 (PDT)
Received: from proxmox.local.lan (2603-80a0-0e01-cc2f-0226-b9ff-fe41-ba6b.res6.spectrum.com. [2603:80a0:e01:cc2f:226:b9ff:fe41:ba6b])
        by smtp.googlemail.com with ESMTPSA id c21sm1440847ooa.48.2021.04.16.13.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 13:53:34 -0700 (PDT)
From:   Tom Seewald <tseewald@gmail.com>
To:     stable@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tom Seewald <tseewald@gmail.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>
Subject: [PATCH 2/4] usbip: stub-dev synchronize sysfs code paths
Date:   Fri, 16 Apr 2021 15:53:17 -0500
Message-Id: <20210416205319.14075-2-tseewald@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210416205319.14075-1-tseewald@gmail.com>
References: <20210416205319.14075-1-tseewald@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

commit 9dbf34a834563dada91366c2ac266f32ff34641a upstream.

Fuzzing uncovered race condition between sysfs code paths in usbip
drivers. Device connect/disconnect code paths initiated through
sysfs interface are prone to races if disconnect happens during
connect and vice versa.

Use sysfs_lock to protect sysfs paths in stub-dev.

Cc: stable@vger.kernel.org # 4.9.x
Reported-and-tested-by: syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/2b182f3561b4a065bf3bf6dce3b0e9944ba17b3f.1616807117.git.skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Tom Seewald <tseewald@gmail.com>
---
 drivers/usb/usbip/stub_dev.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/usbip/stub_dev.c b/drivers/usb/usbip/stub_dev.c
index 6b643e6c8f0b..cec5805feb25 100644
--- a/drivers/usb/usbip/stub_dev.c
+++ b/drivers/usb/usbip/stub_dev.c
@@ -77,6 +77,7 @@ static ssize_t store_sockfd(struct device *dev, struct device_attribute *attr,
 
 		dev_info(dev, "stub up\n");
 
+		mutex_lock(&sdev->ud.sysfs_lock);
 		spin_lock_irq(&sdev->ud.lock);
 
 		if (sdev->ud.status != SDEV_ST_AVAILABLE) {
@@ -101,13 +102,13 @@ static ssize_t store_sockfd(struct device *dev, struct device_attribute *attr,
 		tcp_rx = kthread_create(stub_rx_loop, &sdev->ud, "stub_rx");
 		if (IS_ERR(tcp_rx)) {
 			sockfd_put(socket);
-			return -EINVAL;
+			goto unlock_mutex;
 		}
 		tcp_tx = kthread_create(stub_tx_loop, &sdev->ud, "stub_tx");
 		if (IS_ERR(tcp_tx)) {
 			kthread_stop(tcp_rx);
 			sockfd_put(socket);
-			return -EINVAL;
+			goto unlock_mutex;
 		}
 
 		/* get task structs now */
@@ -126,6 +127,8 @@ static ssize_t store_sockfd(struct device *dev, struct device_attribute *attr,
 		wake_up_process(sdev->ud.tcp_rx);
 		wake_up_process(sdev->ud.tcp_tx);
 
+		mutex_unlock(&sdev->ud.sysfs_lock);
+
 	} else {
 		dev_info(dev, "stub down\n");
 
@@ -136,6 +139,7 @@ static ssize_t store_sockfd(struct device *dev, struct device_attribute *attr,
 		spin_unlock_irq(&sdev->ud.lock);
 
 		usbip_event_add(&sdev->ud, SDEV_EVENT_DOWN);
+		mutex_unlock(&sdev->ud.sysfs_lock);
 	}
 
 	return count;
@@ -144,6 +148,8 @@ static ssize_t store_sockfd(struct device *dev, struct device_attribute *attr,
 	sockfd_put(socket);
 err:
 	spin_unlock_irq(&sdev->ud.lock);
+unlock_mutex:
+	mutex_unlock(&sdev->ud.sysfs_lock);
 	return -EINVAL;
 }
 static DEVICE_ATTR(usbip_sockfd, S_IWUSR, NULL, store_sockfd);
@@ -309,6 +315,7 @@ static struct stub_device *stub_device_alloc(struct usb_device *udev)
 	sdev->ud.side		= USBIP_STUB;
 	sdev->ud.status		= SDEV_ST_AVAILABLE;
 	spin_lock_init(&sdev->ud.lock);
+	mutex_init(&sdev->ud.sysfs_lock);
 	sdev->ud.tcp_socket	= NULL;
 	sdev->ud.sockfd		= -1;
 
-- 
2.20.1

