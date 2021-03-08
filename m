Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E25C330699
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 04:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234023AbhCHDx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 22:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234019AbhCHDxi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 22:53:38 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392A8C061765
        for <stable@vger.kernel.org>; Sun,  7 Mar 2021 19:53:38 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id f20so8500504ioo.10
        for <stable@vger.kernel.org>; Sun, 07 Mar 2021 19:53:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1Yz6kpCfZnD1C4GegUTdokHbPqK7j0RwCOVETYPwpHA=;
        b=XLm+NYdzS/kL+Jrto4VdbEhzzx4U6J01oArZPg4P8I1h9LfVhRioAxoL7+jcoSevrj
         RDHs2OxyCuwau8OYFxz3VcSL0wnjZ4ImyQYB84RMQGRtCPHhGHbzEVvAOsYHkzlE6PaU
         tQuMWOTY96mI+3j9Cp95lDmVkEO3yMVeQJQac=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1Yz6kpCfZnD1C4GegUTdokHbPqK7j0RwCOVETYPwpHA=;
        b=T8E/CguJ4hXhuiWGmIA6tUndL9x825bTii9pQYyTMtt+mZROKoodCzaF3RouqVKphT
         aAwSXYa3wTLR0nf3QLNVzbjGnerX7eKMv3F+YbZoASC61/5hTSawyfuwSWQJ//0+2wQ6
         mGJ6nnRD1+CytQOT4wWhjvYioPgtbfbjLSEPjs2oLN/NkdJpzm/x6YfqfML7DqFZiSXc
         SgWL9McEtvOOUBCKOJcfBqVl5yVeYefT7BQXPIUq0ERy5iILp4Jh4AZR0SR1F/xyR6/0
         6UTBzGo5TTXmsC1R2OPS7WkJhwN1YGW2EPYVxdvuylPvQsqBKCJvOEAf4Tpux21u5xoU
         rOZA==
X-Gm-Message-State: AOAM533HmB8Gd1lBDcqyuxNdGVgmxTpOVX9x7Qy8+h/xKBpxzkYvghEu
        i8Zpv6mAmarwTun/Me5ggexLxw==
X-Google-Smtp-Source: ABdhPJwrraUVRWqDEE3wi8nY43hAijv+snYj4bMlMqJSiSqaIbqDi/spYiRIJOm9snDh/B7Vvb28nw==
X-Received: by 2002:a02:8545:: with SMTP id g63mr21457064jai.79.1615175617756;
        Sun, 07 Mar 2021 19:53:37 -0800 (PST)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id g6sm5605242ilj.28.2021.03.07.19.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 19:53:37 -0800 (PST)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     shuah@kernel.org, valentina.manea.m@gmail.com,
        gregkh@linuxfoundation.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp,
        syzbot <syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com>,
        syzbot <syzbot+bf1a360e305ee719e364@syzkaller.appspotmail.com>,
        syzbot <syzbot+95ce4b142579611ef0a9@syzkaller.appspotmail.com>,
        stable@vger.kernel.org
Subject: [PATCH 5/6] usbip: fix vhci_hcd attach_store() races leading to gpf
Date:   Sun,  7 Mar 2021 20:53:30 -0700
Message-Id: <bb434bd5d7a64fbec38b5ecfb838a6baef6eb12b.1615171203.git.skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1615171203.git.skhan@linuxfoundation.org>
References: <cover.1615171203.git.skhan@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

attach_store() is invoked when user requests import (attach) a device
from usbip host.

Attach and detach are governed by local state and shared state
- Shared state (usbip device status) - Device status is used to manage
  the attach and detach operations on import-able devices.
- Local state (tcp_socket, rx and tx thread task_struct ptrs)
  A valid tcp_socket controls rx and tx thread operations while the
  device is in exported state.
- Device has to be in the right state to be attached and detached.

Attach sequence includes validating the socket and creating receive (rx)
and transmit (tx) threads to talk to the host to get access to the
imported device. rx and tx threads depends on local and shared state to
be correct and in sync.

Detach sequence shuts the socket down and stops the rx and tx threads.
Detach sequence relies on local and shared states to be in sync.

There are races in updating the local and shared status in the current
attach sequence resulting in crashes. These stem from starting rx and
tx threads before local and global state is updated correctly to be in
sync.

1. Doesn't handle kthread_create() error and saves invalid ptr in local
   state that drives rx and tx threads.
2. Updates tcp_socket and sockfd,  starts stub_rx and stub_tx threads
   before updating usbip_device status to VDEV_ST_NOTASSIGNED. This opens
   up a race condition between the threads, port connect, and detach
   handling.

Fix the above problems:
- Stop using kthread_get_run() macro to create/start threads.
- Create threads and get task struct reference.
- Add kthread_create() failure handling and bail out.
- Hold vhci and usbip_device locks to update local and shared states after
  creating rx and tx threads.
- Update usbip_device status to VDEV_ST_NOTASSIGNED.
- Update usbip_device tcp_socket, sockfd, tcp_rx, and tcp_tx
- Start threads after usbip_device (tcp_socket, sockfd, tcp_rx, tcp_tx,
  and status) is complete.

Credit goes to syzbot and Tetsuo Handa for finding and root-causing the
kthread_get_run() improper error handling problem and others. This is
hard problem to find and debug since the races aren't seen in a normal
case. Fuzzing forces the race window to be small enough for the
kthread_get_run() error path bug and starting threads before updating the
local and shared state bug in the attach sequence.
- Update usbip_device tcp_rx and tcp_tx pointers holding vhci and
  usbip_device locks.

Tested with syzbot reproducer:
- https://syzkaller.appspot.com/text?tag=ReproC&x=14801034d00000

Reported-by: syzbot <syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com>
Reported-by: syzbot <syzbot+bf1a360e305ee719e364@syzkaller.appspotmail.com>
Reported-by: syzbot <syzbot+95ce4b142579611ef0a9@syzkaller.appspotmail.com>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: 9720b4bc76a83807 ("staging/usbip: convert to kthread")
Cc: stable@vger.kernel.org
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 drivers/usb/usbip/vhci_sysfs.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/usbip/vhci_sysfs.c b/drivers/usb/usbip/vhci_sysfs.c
index 1e1ae9bd06ab..c4b4256e5dad 100644
--- a/drivers/usb/usbip/vhci_sysfs.c
+++ b/drivers/usb/usbip/vhci_sysfs.c
@@ -312,6 +312,8 @@ static ssize_t attach_store(struct device *dev, struct device_attribute *attr,
 	struct vhci *vhci;
 	int err;
 	unsigned long flags;
+	struct task_struct *tcp_rx = NULL;
+	struct task_struct *tcp_tx = NULL;
 
 	/*
 	 * @rhport: port number of vhci_hcd
@@ -360,9 +362,24 @@ static ssize_t attach_store(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 	}
 
-	/* now need lock until setting vdev status as used */
+	/* create threads before locking */
+	tcp_rx = kthread_create(vhci_rx_loop, &vdev->ud, "vhci_rx");
+	if (IS_ERR(tcp_rx)) {
+		sockfd_put(socket);
+		return -EINVAL;
+	}
+	tcp_tx = kthread_create(vhci_tx_loop, &vdev->ud, "vhci_tx");
+	if (IS_ERR(tcp_tx)) {
+		kthread_stop(tcp_rx);
+		sockfd_put(socket);
+		return -EINVAL;
+	}
+
+	/* get task structs now */
+	get_task_struct(tcp_rx);
+	get_task_struct(tcp_tx);
 
-	/* begin a lock */
+	/* now begin lock until setting vdev status set */
 	spin_lock_irqsave(&vhci->lock, flags);
 	spin_lock(&vdev->ud.lock);
 
@@ -372,6 +389,8 @@ static ssize_t attach_store(struct device *dev, struct device_attribute *attr,
 		spin_unlock_irqrestore(&vhci->lock, flags);
 
 		sockfd_put(socket);
+		kthread_stop_put(tcp_rx);
+		kthread_stop_put(tcp_tx);
 
 		dev_err(dev, "port %d already used\n", rhport);
 		/*
@@ -390,6 +409,8 @@ static ssize_t attach_store(struct device *dev, struct device_attribute *attr,
 	vdev->speed         = speed;
 	vdev->ud.sockfd     = sockfd;
 	vdev->ud.tcp_socket = socket;
+	vdev->ud.tcp_rx     = tcp_rx;
+	vdev->ud.tcp_tx     = tcp_tx;
 	vdev->ud.status     = VDEV_ST_NOTASSIGNED;
 	usbip_kcov_handle_init(&vdev->ud);
 
@@ -397,8 +418,8 @@ static ssize_t attach_store(struct device *dev, struct device_attribute *attr,
 	spin_unlock_irqrestore(&vhci->lock, flags);
 	/* end the lock */
 
-	vdev->ud.tcp_rx = kthread_get_run(vhci_rx_loop, &vdev->ud, "vhci_rx");
-	vdev->ud.tcp_tx = kthread_get_run(vhci_tx_loop, &vdev->ud, "vhci_tx");
+	wake_up_process(vdev->ud.tcp_rx);
+	wake_up_process(vdev->ud.tcp_tx);
 
 	rh_port_connect(vdev, speed);
 
-- 
2.27.0

