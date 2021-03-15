Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37BE33B8D5
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbhCOOEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:04:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233004AbhCOOAd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1145464F2C;
        Mon, 15 Mar 2021 14:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816809;
        bh=YKPmQxAjCwsSf4fehiyvc04XjXrWyNvQpt/yLlSn600=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f/nln7XHeDkdOzILySnpJvjxXzfc5BtfaQC8ZPopMUbZR8V8uDRbhRHQ2q4bZ9uJ3
         /28xRiUo0/wver7czV7r1Yq54gb8Opsq+JWbMxgGQTlOftLPaTgZYMyb9z9kMc2R2P
         YQBBq9w68hweGPnwDbTRwEZDisD/0DAY4uheYoeM=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com>,
        syzbot <syzbot+bf1a360e305ee719e364@syzkaller.appspotmail.com>,
        syzbot <syzbot+95ce4b142579611ef0a9@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.4 124/168] usbip: fix vudc usbip_sockfd_store races leading to gpf
Date:   Mon, 15 Mar 2021 14:55:56 +0100
Message-Id: <20210315135554.427838916@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Shuah Khan <skhan@linuxfoundation.org>

commit 46613c9dfa964c0c60b5385dbdf5aaa18be52a9c upstream.

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

Fixes: 9720b4bc76a83807 ("staging/usbip: convert to kthread")
Cc: stable@vger.kernel.org
Reported-by: syzbot <syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com>
Reported-by: syzbot <syzbot+bf1a360e305ee719e364@syzkaller.appspotmail.com>
Reported-by: syzbot <syzbot+95ce4b142579611ef0a9@syzkaller.appspotmail.com>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/b1c08b983ffa185449c9f0f7d1021dc8c8454b60.1615171203.git.skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/usbip/vudc_sysfs.c |   42 +++++++++++++++++++++++++++++++++--------
 1 file changed, 34 insertions(+), 8 deletions(-)

--- a/drivers/usb/usbip/vudc_sysfs.c
+++ b/drivers/usb/usbip/vudc_sysfs.c
@@ -90,8 +90,9 @@ unlock:
 }
 static BIN_ATTR_RO(dev_desc, sizeof(struct usb_device_descriptor));
 
-static ssize_t usbip_sockfd_store(struct device *dev, struct device_attribute *attr,
-		     const char *in, size_t count)
+static ssize_t usbip_sockfd_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *in, size_t count)
 {
 	struct vudc *udc = (struct vudc *) dev_get_drvdata(dev);
 	int rv;
@@ -100,6 +101,8 @@ static ssize_t usbip_sockfd_store(struct
 	struct socket *socket;
 	unsigned long flags;
 	int ret;
+	struct task_struct *tcp_rx = NULL;
+	struct task_struct *tcp_tx = NULL;
 
 	rv = kstrtoint(in, 0, &sockfd);
 	if (rv != 0)
@@ -145,24 +148,47 @@ static ssize_t usbip_sockfd_store(struct
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
 
 		ktime_get_ts64(&udc->start_time);
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


