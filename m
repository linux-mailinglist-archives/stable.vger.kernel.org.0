Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5573135A9B1
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 02:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235249AbhDJAts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 20:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235215AbhDJAtr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 20:49:47 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC8FC061762
        for <stable@vger.kernel.org>; Fri,  9 Apr 2021 17:49:33 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id x2so7590610oiv.2
        for <stable@vger.kernel.org>; Fri, 09 Apr 2021 17:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:reply-to:mime-version
         :content-transfer-encoding;
        bh=CVbQmHyA4ZzeHvRyveW1iGtt9QNh9Rt8u8Y4WsqNvSY=;
        b=lO7kl5ieHDsoHLI/arB7f4WMon8h9iHgk+RqWUlEnOKKK7ccIOkGjzQuWaCYRHxirv
         V+6HvaejNbzM3L3r/Npc1xJJBgb1qvHH1fqLosI4HSiInRNp/f/RougP1D7mviY7Nk1/
         kdL/6JmSEE1rCTSk+Rtn9mqC5KjKKWAD/iXiD9qCr1Dzc24Qh1OVVsxRc4b4Ba+oprNl
         FgNoGjPqq7XBXB7YbQQCJjkAgQanL5reqXYxU+gRhgtmpuRvmF54Zsp5K+AfEYLJH8O/
         ubXooWFK6D939EtUI6o7APhghQsvNhLagL4uparX1lqK7vxu2wCcju+TMpFwOkyqweRx
         Sx0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :mime-version:content-transfer-encoding;
        bh=CVbQmHyA4ZzeHvRyveW1iGtt9QNh9Rt8u8Y4WsqNvSY=;
        b=h6kFX/aim9LN1v5P+8J0yiQEjiMj0iaYZkdew3irK1peh3msFTdjpgkWWD7XDaXdHc
         4W62gD7k+nMzsEwX2r93NVHNDrmDKGFDZQwAGvKdpdZFW9OIW6lWoSVhOCu3KhzF3dFi
         +l2qXSHGDshhfh0pIpendA12WJXutMOQSisA8IWD+Cvj29qBhdmaztucbz6jJFhAUeqO
         7YEqqzZlEXlfJtJcMh4/Pd3MaxLOvyNkYkI/eJ1CMDfeN2CQYWyOca3LLpwVoMd6PSRm
         nQRShenePeZCxfezf6zDu5xLhBD2Aj79LT8Pvi9uOgFClr4Awla8ZemhvjNCiL/auYpK
         /2Hg==
X-Gm-Message-State: AOAM530CT66r7ABL3SZo+ZUrTeKZa+0iYGwjGSwn2kByfR2RTcnEJCKi
        pXwD8UeLc9Xwi0++wbP7rss=
X-Google-Smtp-Source: ABdhPJxuyuBpQ8tHmZwwJZjfHVVQxPx4WU7Jc+kDrCGouqqnbl0JCai9nkx1LPrE3qyF2xCw+LBy7A==
X-Received: by 2002:aca:d884:: with SMTP id p126mr12092919oig.118.1618015772875;
        Fri, 09 Apr 2021 17:49:32 -0700 (PDT)
Received: from proxmox.local.lan (2603-80a0-0e01-cc2f-0226-b9ff-fe41-ba6b.res6.spectrum.com. [2603:80a0:e01:cc2f:226:b9ff:fe41:ba6b])
        by smtp.googlemail.com with ESMTPSA id y13sm928927oti.79.2021.04.09.17.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 17:49:32 -0700 (PDT)
From:   Tom Seewald <tseewald@gmail.com>
To:     skhan@linuxfoundation.org
Cc:     tseewald@gmail.com,
        syzbot <syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com>,
        syzbot <syzbot+bf1a360e305ee719e364@syzkaller.appspotmail.com>,
        syzbot <syzbot+95ce4b142579611ef0a9@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        stable@vger.kernel.org
Subject: [PATCH] usbip: fix vudc usbip_sockfd_store races leading to gpf
Date:   Fri,  9 Apr 2021 19:49:30 -0500
Message-Id: <20210410004930.17411-1-tseewald@gmail.com>
X-Mailer: git-send-email 2.20.1
Reply-To: 6f17ac98-5b23-3068-b6ec-4911273fe093@linuxfoundation.org
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[backport of mainline commit 46613c9dfa96 ("usbip: fix vudc
usbip_sockfd_store races leading to gpf") to 4.9 and 4.14]

usbip_sockfd_store() is invoked when user requests attach (import)
detach (unimport) usb gadget device from usbip host. vhci_hcd sends
import request and usbip_sockfd_store() exports the device if it is
free for export.

Export and unexport are governed by local state and shared state
- Shared state (usbip device status, sockfd) - sockfd and Device
  status are used to determine if stub should be brought up or shut
  down. Device status is shared between host and client.
- Local state (tcp_socket, rx and tx thread task_struct ptrs)
  A valid tcp_socket controls rx and tx thread operations while the
  device is in exported state.
- While the device is exported, device status is marked used and socket,
  sockfd, and thread pointers are valid.

Export sequence (stub-up) includes validating the socket and creating
receive (rx) and transmit (tx) threads to talk to the client to provide
access to the exported device. rx and tx threads depends on local and
shared state to be correct and in sync.

Unexport (stub-down) sequence shuts the socket down and stops the rx and
tx threads. Stub-down sequence relies on local and shared states to be
in sync.

There are races in updating the local and shared status in the current
stub-up sequence resulting in crashes. These stem from starting rx and
tx threads before local and global state is updated correctly to be in
sync.

1. Doesn't handle kthread_create() error and saves invalid ptr in local
   state that drives rx and tx threads.
2. Updates tcp_socket and sockfd,  starts stub_rx and stub_tx threads
   before updating usbip_device status to SDEV_ST_USED. This opens up a
   race condition between the threads and usbip_sockfd_store() stub up
   and down handling.

Fix the above problems:
- Stop using kthread_get_run() macro to create/start threads.
- Create threads and get task struct reference.
- Add kthread_create() failure handling and bail out.
- Hold usbip_device lock to update local and shared states after
  creating rx and tx threads.
- Update usbip_device status to SDEV_ST_USED.
- Update usbip_device tcp_socket, sockfd, tcp_rx, and tcp_tx
- Start threads after usbip_device (tcp_socket, sockfd, tcp_rx, tcp_tx,
  and status) is complete.

Credit goes to syzbot and Tetsuo Handa for finding and root-causing the
kthread_get_run() improper error handling problem and others. This is a
hard problem to find and debug since the races aren't seen in a normal
case. Fuzzing forces the race window to be small enough for the
kthread_get_run() error path bug and starting threads before updating the
local and shared state bug in the stub-up sequence.

Reported-by: syzbot <syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com>
Reported-by: syzbot <syzbot+bf1a360e305ee719e364@syzkaller.appspotmail.com>
Reported-by: syzbot <syzbot+95ce4b142579611ef0a9@syzkaller.appspotmail.com>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: 9720b4bc76a83807 ("staging/usbip: convert to kthread")
Cc: stable@vger.kernel.org
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Tom Seewald <tseewald@gmail.com>
---
 drivers/usb/usbip/vudc_sysfs.c | 42 +++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/usbip/vudc_sysfs.c b/drivers/usb/usbip/vudc_sysfs.c
index e3f7c76d1956..f44d98eeb36a 100644
--- a/drivers/usb/usbip/vudc_sysfs.c
+++ b/drivers/usb/usbip/vudc_sysfs.c
@@ -103,8 +103,9 @@ static ssize_t dev_desc_read(struct file *file, struct kobject *kobj,
 }
 static BIN_ATTR_RO(dev_desc, sizeof(struct usb_device_descriptor));
 
-static ssize_t store_sockfd(struct device *dev, struct device_attribute *attr,
-		     const char *in, size_t count)
+static ssize_t store_sockfd(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *in, size_t count)
 {
 	struct vudc *udc = (struct vudc *) dev_get_drvdata(dev);
 	int rv;
@@ -113,6 +114,8 @@ static ssize_t store_sockfd(struct device *dev, struct device_attribute *attr,
 	struct socket *socket;
 	unsigned long flags;
 	int ret;
+	struct task_struct *tcp_rx = NULL;
+	struct task_struct *tcp_tx = NULL;
 
 	rv = kstrtoint(in, 0, &sockfd);
 	if (rv != 0)
@@ -158,24 +161,47 @@ static ssize_t store_sockfd(struct device *dev, struct device_attribute *attr,
 			goto sock_err;
 		}
 
-		udc->ud.tcp_socket = socket;
-
+		/* unlock and create threads and get tasks */
 		spin_unlock_irq(&udc->ud.lock);
 		spin_unlock_irqrestore(&udc->lock, flags);
 
-		udc->ud.tcp_rx = kthread_get_run(&v_rx_loop,
-						    &udc->ud, "vudc_rx");
-		udc->ud.tcp_tx = kthread_get_run(&v_tx_loop,
-						    &udc->ud, "vudc_tx");
+		tcp_rx = kthread_create(&v_rx_loop, &udc->ud, "vudc_rx");
+		if (IS_ERR(tcp_rx)) {
+			sockfd_put(socket);
+			return -EINVAL;
+		}
+		tcp_tx = kthread_create(&v_tx_loop, &udc->ud, "vudc_tx");
+		if (IS_ERR(tcp_tx)) {
+			kthread_stop(tcp_rx);
+			sockfd_put(socket);
+			return -EINVAL;
+		}
+
+		/* get task structs now */
+		get_task_struct(tcp_rx);
+		get_task_struct(tcp_tx);
 
+		/* lock and update udc->ud state */
 		spin_lock_irqsave(&udc->lock, flags);
 		spin_lock_irq(&udc->ud.lock);
+
+		udc->ud.tcp_socket = socket;
+		udc->ud.tcp_rx = tcp_rx;
+		udc->ud.tcp_rx = tcp_tx;
 		udc->ud.status = SDEV_ST_USED;
+
 		spin_unlock_irq(&udc->ud.lock);
 
 		do_gettimeofday(&udc->start_time);
 		v_start_timer(udc);
 		udc->connected = 1;
+
+		spin_unlock_irqrestore(&udc->lock, flags);
+
+		wake_up_process(udc->ud.tcp_rx);
+		wake_up_process(udc->ud.tcp_tx);
+		return count;
+
 	} else {
 		if (!udc->connected) {
 			dev_err(dev, "Device not connected");
-- 
2.20.1

