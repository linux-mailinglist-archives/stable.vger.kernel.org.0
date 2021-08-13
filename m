Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 798B43EB7CA
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241388AbhHMPJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:09:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241343AbhHMPJT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:09:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 212D26109D;
        Fri, 13 Aug 2021 15:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867332;
        bh=hwbr9amKacF2CFaujbyovablgzoJATRYJBgr8N02J5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f6JYLM4q/Q5e8XnfuQEs6WMdMYN/GVkpT/EpOxAq5cVp5BEWhjY8HmngVT/Wb4mvq
         LxbiAklPLgf1iSp3GGodurIV8DyCTIVw9JdeUlvPX3dD8nZ+cbNBddC7JLtban3yOz
         J1CI3gNvzc3tHjxlBroNx0WoI53k/xr0u1+6N5n8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+a5df189917e79d5e59c9@syzkaller.appspotmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 09/25] Bluetooth: defer cleanup of resources in hci_unregister_dev()
Date:   Fri, 13 Aug 2021 17:06:33 +0200
Message-Id: <20210813150521.027222164@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150520.718161915@linuxfoundation.org>
References: <20210813150520.718161915@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

[ Upstream commit e04480920d1eec9c061841399aa6f35b6f987d8b ]

syzbot is hitting might_sleep() warning at hci_sock_dev_event() due to
calling lock_sock() with rw spinlock held [1].

It seems that history of this locking problem is a trial and error.

Commit b40df5743ee8 ("[PATCH] bluetooth: fix socket locking in
hci_sock_dev_event()") in 2.6.21-rc4 changed bh_lock_sock() to
lock_sock() as an attempt to fix lockdep warning.

Then, commit 4ce61d1c7a8e ("[BLUETOOTH]: Fix locking in
hci_sock_dev_event().") in 2.6.22-rc2 changed lock_sock() to
local_bh_disable() + bh_lock_sock_nested() as an attempt to fix the
sleep in atomic context warning.

Then, commit 4b5dd696f81b ("Bluetooth: Remove local_bh_disable() from
hci_sock.c") in 3.3-rc1 removed local_bh_disable().

Then, commit e305509e678b ("Bluetooth: use correct lock to prevent UAF
of hdev object") in 5.13-rc5 again changed bh_lock_sock_nested() to
lock_sock() as an attempt to fix CVE-2021-3573.

This difficulty comes from current implementation that
hci_sock_dev_event(HCI_DEV_UNREG) is responsible for dropping all
references from sockets because hci_unregister_dev() immediately
reclaims resources as soon as returning from
hci_sock_dev_event(HCI_DEV_UNREG).

But the history suggests that hci_sock_dev_event(HCI_DEV_UNREG) was not
doing what it should do.

Therefore, instead of trying to detach sockets from device, let's accept
not detaching sockets from device at hci_sock_dev_event(HCI_DEV_UNREG),
by moving actual cleanup of resources from hci_unregister_dev() to
hci_cleanup_dev() which is called by bt_host_release() when all
references to this unregistered device (which is a kobject) are gone.

Since hci_sock_dev_event(HCI_DEV_UNREG) no longer resets
hci_pi(sk)->hdev, we need to check whether this device was unregistered
and return an error based on HCI_UNREGISTER flag.  There might be subtle
behavioral difference in "monitor the hdev" functionality; please report
if you found something went wrong due to this patch.

Link: https://syzkaller.appspot.com/bug?extid=a5df189917e79d5e59c9 [1]
Reported-by: syzbot <syzbot+a5df189917e79d5e59c9@syzkaller.appspotmail.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: e305509e678b ("Bluetooth: use correct lock to prevent UAF of hdev object")
Acked-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h |    1 
 net/bluetooth/hci_core.c         |   16 ++++++------
 net/bluetooth/hci_sock.c         |   49 ++++++++++++++++++++++++++-------------
 net/bluetooth/hci_sysfs.c        |    3 ++
 4 files changed, 45 insertions(+), 24 deletions(-)

--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1013,6 +1013,7 @@ struct hci_dev *hci_alloc_dev(void);
 void hci_free_dev(struct hci_dev *hdev);
 int hci_register_dev(struct hci_dev *hdev);
 void hci_unregister_dev(struct hci_dev *hdev);
+void hci_cleanup_dev(struct hci_dev *hdev);
 int hci_suspend_dev(struct hci_dev *hdev);
 int hci_resume_dev(struct hci_dev *hdev);
 int hci_reset_dev(struct hci_dev *hdev);
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3457,14 +3457,10 @@ EXPORT_SYMBOL(hci_register_dev);
 /* Unregister HCI device */
 void hci_unregister_dev(struct hci_dev *hdev)
 {
-	int id;
-
 	BT_DBG("%p name %s bus %d", hdev, hdev->name, hdev->bus);
 
 	hci_dev_set_flag(hdev, HCI_UNREGISTER);
 
-	id = hdev->id;
-
 	write_lock(&hci_dev_list_lock);
 	list_del(&hdev->list);
 	write_unlock(&hci_dev_list_lock);
@@ -3493,7 +3489,14 @@ void hci_unregister_dev(struct hci_dev *
 	}
 
 	device_del(&hdev->dev);
+	/* Actual cleanup is deferred until hci_cleanup_dev(). */
+	hci_dev_put(hdev);
+}
+EXPORT_SYMBOL(hci_unregister_dev);
 
+/* Cleanup HCI device */
+void hci_cleanup_dev(struct hci_dev *hdev)
+{
 	debugfs_remove_recursive(hdev->debugfs);
 
 	destroy_workqueue(hdev->workqueue);
@@ -3513,11 +3516,8 @@ void hci_unregister_dev(struct hci_dev *
 	hci_discovery_filter_clear(hdev);
 	hci_dev_unlock(hdev);
 
-	hci_dev_put(hdev);
-
-	ida_simple_remove(&hci_index_ida, id);
+	ida_simple_remove(&hci_index_ida, hdev->id);
 }
-EXPORT_SYMBOL(hci_unregister_dev);
 
 /* Suspend HCI device */
 int hci_suspend_dev(struct hci_dev *hdev)
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -53,6 +53,17 @@ struct hci_pinfo {
 	unsigned long     flags;
 };
 
+static struct hci_dev *hci_hdev_from_sock(struct sock *sk)
+{
+	struct hci_dev *hdev = hci_pi(sk)->hdev;
+
+	if (!hdev)
+		return ERR_PTR(-EBADFD);
+	if (hci_dev_test_flag(hdev, HCI_UNREGISTER))
+		return ERR_PTR(-EPIPE);
+	return hdev;
+}
+
 void hci_sock_set_flag(struct sock *sk, int nr)
 {
 	set_bit(nr, &hci_pi(sk)->flags);
@@ -480,19 +491,13 @@ void hci_sock_dev_event(struct hci_dev *
 	if (event == HCI_DEV_UNREG) {
 		struct sock *sk;
 
-		/* Detach sockets from device */
+		/* Wake up sockets using this dead device */
 		read_lock(&hci_sk_list.lock);
 		sk_for_each(sk, &hci_sk_list.head) {
-			lock_sock(sk);
 			if (hci_pi(sk)->hdev == hdev) {
-				hci_pi(sk)->hdev = NULL;
 				sk->sk_err = EPIPE;
-				sk->sk_state = BT_OPEN;
 				sk->sk_state_change(sk);
-
-				hci_dev_put(hdev);
 			}
-			release_sock(sk);
 		}
 		read_unlock(&hci_sk_list.lock);
 	}
@@ -631,10 +636,10 @@ static int hci_sock_blacklist_del(struct
 static int hci_sock_bound_ioctl(struct sock *sk, unsigned int cmd,
 				unsigned long arg)
 {
-	struct hci_dev *hdev = hci_pi(sk)->hdev;
+	struct hci_dev *hdev = hci_hdev_from_sock(sk);
 
-	if (!hdev)
-		return -EBADFD;
+	if (IS_ERR(hdev))
+		return PTR_ERR(hdev);
 
 	if (hci_dev_test_flag(hdev, HCI_USER_CHANNEL))
 		return -EBUSY;
@@ -766,6 +771,18 @@ static int hci_sock_bind(struct socket *
 
 	lock_sock(sk);
 
+	/* Allow detaching from dead device and attaching to alive device, if
+	 * the caller wants to re-bind (instead of close) this socket in
+	 * response to hci_sock_dev_event(HCI_DEV_UNREG) notification.
+	 */
+	hdev = hci_pi(sk)->hdev;
+	if (hdev && hci_dev_test_flag(hdev, HCI_UNREGISTER)) {
+		hci_pi(sk)->hdev = NULL;
+		sk->sk_state = BT_OPEN;
+		hci_dev_put(hdev);
+	}
+	hdev = NULL;
+
 	if (sk->sk_state == BT_BOUND) {
 		err = -EALREADY;
 		goto done;
@@ -937,9 +954,9 @@ static int hci_sock_getname(struct socke
 
 	lock_sock(sk);
 
-	hdev = hci_pi(sk)->hdev;
-	if (!hdev) {
-		err = -EBADFD;
+	hdev = hci_hdev_from_sock(sk);
+	if (IS_ERR(hdev)) {
+		err = PTR_ERR(hdev);
 		goto done;
 	}
 
@@ -1191,9 +1208,9 @@ static int hci_sock_sendmsg(struct socke
 		goto done;
 	}
 
-	hdev = hci_pi(sk)->hdev;
-	if (!hdev) {
-		err = -EBADFD;
+	hdev = hci_hdev_from_sock(sk);
+	if (IS_ERR(hdev)) {
+		err = PTR_ERR(hdev);
 		goto done;
 	}
 
--- a/net/bluetooth/hci_sysfs.c
+++ b/net/bluetooth/hci_sysfs.c
@@ -180,6 +180,9 @@ ATTRIBUTE_GROUPS(bt_host);
 static void bt_host_release(struct device *dev)
 {
 	struct hci_dev *hdev = to_hci_dev(dev);
+
+	if (hci_dev_test_flag(hdev, HCI_UNREGISTER))
+		hci_cleanup_dev(hdev);
 	kfree(hdev);
 	module_put(THIS_MODULE);
 }


