Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C0F33B8EF
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234722AbhCOOE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:04:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232953AbhCOOAV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13EED64F5F;
        Mon, 15 Mar 2021 14:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816805;
        bh=y9MWJwAHKI1yTKJrTrQ3s9kibterPfHI/FArkPmAavI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ssl27O8mMTkDoCTF9PDVfHT/vflimG6oy5KXYnJFc7Z9qW7ivyn8IM9Mk9KabShK4
         8rQ/SigR+zeexh4nalZF9PVNjccWnHp9VEc4zv6gLMk31pVUl++09fR0RdL6GB6Oth
         AZ8UQDvOX+o+SjJTD+eMvePJlQ4Jwl1Gl4MNR5qQ=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com>,
        syzbot <syzbot+bf1a360e305ee719e364@syzkaller.appspotmail.com>,
        syzbot <syzbot+95ce4b142579611ef0a9@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.4 122/168] usbip: fix stub_dev usbip_sockfd_store() races leading to gpf
Date:   Mon, 15 Mar 2021 14:55:54 +0100
Message-Id: <20210315135554.366271344@linuxfoundation.org>
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

commit 9380afd6df70e24eacbdbde33afc6a3950965d22 upstream.

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

Fixes: 9720b4bc76a83807 ("staging/usbip: convert to kthread")
Cc: stable@vger.kernel.org
Reported-by: syzbot <syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com>
Reported-by: syzbot <syzbot+bf1a360e305ee719e364@syzkaller.appspotmail.com>
Reported-by: syzbot <syzbot+95ce4b142579611ef0a9@syzkaller.appspotmail.com>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/268a0668144d5ff36ec7d87fdfa90faf583b7ccc.1615171203.git.skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/usbip/stub_dev.c |   32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

--- a/drivers/usb/usbip/stub_dev.c
+++ b/drivers/usb/usbip/stub_dev.c
@@ -46,6 +46,8 @@ static ssize_t usbip_sockfd_store(struct
 	int sockfd = 0;
 	struct socket *socket;
 	int rv;
+	struct task_struct *tcp_rx = NULL;
+	struct task_struct *tcp_tx = NULL;
 
 	if (!sdev) {
 		dev_err(dev, "sdev is null\n");
@@ -80,20 +82,36 @@ static ssize_t usbip_sockfd_store(struct
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
 


