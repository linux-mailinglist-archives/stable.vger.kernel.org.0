Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC85633069B
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 04:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234015AbhCHDx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 22:53:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234018AbhCHDxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 22:53:37 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA53C061765
        for <stable@vger.kernel.org>; Sun,  7 Mar 2021 19:53:37 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id g27so8534323iox.2
        for <stable@vger.kernel.org>; Sun, 07 Mar 2021 19:53:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9Mtf+/GMHQQaVl5Wo2noId5jc+1UjqdNt79wf1IcZT4=;
        b=L6nbQIbf2Dxc8FQu0/EAxtQ4yCqggl7xgYvWHss3oW40kV6hIv41eQrrZxFVTS74fV
         5t9w17VGluac/kPCURGyDirUVyMgQSCInvyj+bxt6FhJoL3SePELqlgg+E3bdx95qycC
         3sj1u5QdnE4XreGwL1k/K49oKZlEHjvgxyz14=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9Mtf+/GMHQQaVl5Wo2noId5jc+1UjqdNt79wf1IcZT4=;
        b=jc2Gf5u8KuCy2l6EJl1QlT0v4fBf0C5qmE3gYdpIT7I8GhrQY4A+dIYAHVVNQcZsUR
         g/h7gPcYfsDD8XX0XFKtejo4n9/IH+E3OVFC4jYI5VA0Xf/mMyav5zwgQtJT4K1XUmbM
         c1vYQaNvK3yuBiZ5Go56+j3YnTJFPRiCW8oQEGzgmVElz4OoMXP1Y7+7BiZ75rJFb6xW
         U9G9VG4gsBxHDkKWhbRnUS1a5BN+f12YDxQCMywDfNTd2AF8ZfPg2nNGnoXKplYAtKf4
         lJccTI9KgwNfbPoEyvJ5G0FOls+eMl7G95J7yWDCIvxqnScotzGVhYjRi8huu0dIAfI1
         SHSA==
X-Gm-Message-State: AOAM530Oh7nnJNkeROe1aPqo+xXM5p6SsXM9cwhH4M/CwbAb2OgZMgIk
        Of1/VvGEKNFyr1juTq13wVYOTw==
X-Google-Smtp-Source: ABdhPJyD8eSfduXsrnjkASYs7XzbCFP4vzrCgT6uFawrG2mg1kn2S5KhvL6xmDzb5VHRQ+TRizKzMA==
X-Received: by 2002:a05:6638:1390:: with SMTP id w16mr21494082jad.83.1615175617045;
        Sun, 07 Mar 2021 19:53:37 -0800 (PST)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id g6sm5605242ilj.28.2021.03.07.19.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 19:53:36 -0800 (PST)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     shuah@kernel.org, valentina.manea.m@gmail.com,
        gregkh@linuxfoundation.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp,
        syzbot <syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com>,
        syzbot <syzbot+bf1a360e305ee719e364@syzkaller.appspotmail.com>,
        syzbot <syzbot+95ce4b142579611ef0a9@syzkaller.appspotmail.com>,
        stable@vger.kernel.org
Subject: [PATCH 4/6] usbip: fix stub_dev usbip_sockfd_store() races leading to gpf
Date:   Sun,  7 Mar 2021 20:53:29 -0700
Message-Id: <268a0668144d5ff36ec7d87fdfa90faf583b7ccc.1615171203.git.skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1615171203.git.skhan@linuxfoundation.org>
References: <cover.1615171203.git.skhan@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

usbip_sockfd_store() is invoked when user requests attach (import)
detach (unimport) usb device from usbip host. vhci_hcd sends import
request and usbip_sockfd_store() exports the device if it is free
for export.

Export and unexport are governed by local state and shared state
- Shared state (usbip device status, sockfd) - sockfd and Device
  status are used to determine if stub should be brought up or shut
  down.
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
 drivers/usb/usbip/stub_dev.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/usbip/stub_dev.c b/drivers/usb/usbip/stub_dev.c
index 90c105469a07..8f1de1fbbeed 100644
--- a/drivers/usb/usbip/stub_dev.c
+++ b/drivers/usb/usbip/stub_dev.c
@@ -46,6 +46,8 @@ static ssize_t usbip_sockfd_store(struct device *dev, struct device_attribute *a
 	int sockfd = 0;
 	struct socket *socket;
 	int rv;
+	struct task_struct *tcp_rx = NULL;
+	struct task_struct *tcp_tx = NULL;
 
 	if (!sdev) {
 		dev_err(dev, "sdev is null\n");
@@ -80,20 +82,36 @@ static ssize_t usbip_sockfd_store(struct device *dev, struct device_attribute *a
 			goto sock_err;
 		}
 
-		sdev->ud.tcp_socket = socket;
-		sdev->ud.sockfd = sockfd;
-
+		/* unlock and create threads and get tasks */
 		spin_unlock_irq(&sdev->ud.lock);
+		tcp_rx = kthread_create(stub_rx_loop, &sdev->ud, "stub_rx");
+		if (IS_ERR(tcp_rx)) {
+			sockfd_put(socket);
+			return -EINVAL;
+		}
+		tcp_tx = kthread_create(stub_tx_loop, &sdev->ud, "stub_tx");
+		if (IS_ERR(tcp_tx)) {
+			kthread_stop(tcp_rx);
+			sockfd_put(socket);
+			return -EINVAL;
+		}
 
-		sdev->ud.tcp_rx = kthread_get_run(stub_rx_loop, &sdev->ud,
-						  "stub_rx");
-		sdev->ud.tcp_tx = kthread_get_run(stub_tx_loop, &sdev->ud,
-						  "stub_tx");
+		/* get task structs now */
+		get_task_struct(tcp_rx);
+		get_task_struct(tcp_tx);
 
+		/* lock and update sdev->ud state */
 		spin_lock_irq(&sdev->ud.lock);
+		sdev->ud.tcp_socket = socket;
+		sdev->ud.sockfd = sockfd;
+		sdev->ud.tcp_rx = tcp_rx;
+		sdev->ud.tcp_tx = tcp_tx;
 		sdev->ud.status = SDEV_ST_USED;
 		spin_unlock_irq(&sdev->ud.lock);
 
+		wake_up_process(sdev->ud.tcp_rx);
+		wake_up_process(sdev->ud.tcp_tx);
+
 	} else {
 		dev_info(dev, "stub down\n");
 
-- 
2.27.0

