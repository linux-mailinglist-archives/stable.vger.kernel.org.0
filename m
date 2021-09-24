Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40A3416E8A
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 11:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244402AbhIXJKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 05:10:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244396AbhIXJKb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 05:10:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 517F960F39;
        Fri, 24 Sep 2021 09:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632474538;
        bh=Dlr35G//MFY9qIJea2+4IpWN5RKWscOwI/Xr0Mfdz3U=;
        h=Subject:To:Cc:From:Date:From;
        b=mXkgMwV6t8JNfZxmZVVe46C8/JsKcyawj1Mr1mnTl1YHuy0a7zHjrcD6VgZ7fCzFs
         R9HSn3zw7aNn592Tety3aAbLk58crAjuGm+isnV7mUkzBdHYmbTiwe6iqQ6xq9luJk
         Ok4jsb6FSBH+s31JoUCpgVgknGZZsPnIpx00Gi7s=
Subject: FAILED: patch "[PATCH] Bluetooth: defer cleanup of resources in hci_unregister_dev()" failed to apply to 4.19-stable tree
To:     penguin-kernel@I-love.SAKURA.ne.jp, luiz.von.dentz@intel.com,
        syzbot+a5df189917e79d5e59c9@syzkaller.appspotmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 24 Sep 2021 11:08:51 +0200
Message-ID: <163247453120048@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 58ce6d5b271ab25fb2056f84a8e5546945eb5fc9 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Tue, 27 Jul 2021 06:12:04 +0900
Subject: [PATCH] Bluetooth: defer cleanup of resources in hci_unregister_dev()

syzbot is hitting might_sleep() warning at hci_sock_dev_event()
due to calling lock_sock() with rw spinlock held [1].

It seems that history of this locking problem is a trial and error.

Commit b40df5743ee8aed8 ("[PATCH] bluetooth: fix socket locking in
hci_sock_dev_event()") in 2.6.21-rc4 changed bh_lock_sock() to lock_sock()
as an attempt to fix lockdep warning.

Then, commit 4ce61d1c7a8ef4c1 ("[BLUETOOTH]: Fix locking in
hci_sock_dev_event().") in 2.6.22-rc2 changed lock_sock() to
local_bh_disable() + bh_lock_sock_nested() as an attempt to fix
sleep in atomic context warning.

Then, commit 4b5dd696f81b210c ("Bluetooth: Remove local_bh_disable() from
hci_sock.c") in 3.3-rc1 removed local_bh_disable().

Then, commit e305509e678b3a4a ("Bluetooth: use correct lock to prevent UAF
of hdev object") in 5.13-rc5 again changed bh_lock_sock_nested() to
lock_sock() as an attempt to fix CVE-2021-3573.

This difficulty comes from current implementation that
hci_sock_dev_event(HCI_DEV_UNREG) is responsible for dropping all
references from sockets because hci_unregister_dev() immediately reclaims
resources as soon as returning from hci_sock_dev_event(HCI_DEV_UNREG).
But the history suggests that hci_sock_dev_event(HCI_DEV_UNREG) was not
doing what it should do.

Therefore, instead of trying to detach sockets from device, let's accept
not detaching sockets from device at hci_sock_dev_event(HCI_DEV_UNREG),
by moving actual cleanup of resources from hci_unregister_dev() to
hci_release_dev() which is called by bt_host_release when all references
to this unregistered device (which is a kobject) are gone.

Link: https://syzkaller.appspot.com/bug?extid=a5df189917e79d5e59c9 [1]
Reported-by: syzbot <syzbot+a5df189917e79d5e59c9@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: syzbot <syzbot+a5df189917e79d5e59c9@syzkaller.appspotmail.com>
Fixes: e305509e678b3a4a ("Bluetooth: use correct lock to prevent UAF of hdev object")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index a53e94459ecd..4abe3c494002 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1230,6 +1230,7 @@ struct hci_dev *hci_alloc_dev(void);
 void hci_free_dev(struct hci_dev *hdev);
 int hci_register_dev(struct hci_dev *hdev);
 void hci_unregister_dev(struct hci_dev *hdev);
+void hci_release_dev(struct hci_dev *hdev);
 int hci_suspend_dev(struct hci_dev *hdev);
 int hci_resume_dev(struct hci_dev *hdev);
 int hci_reset_dev(struct hci_dev *hdev);
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 2560ed2f144d..2b78e1336c53 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3996,14 +3996,10 @@ EXPORT_SYMBOL(hci_register_dev);
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
@@ -4038,7 +4034,13 @@ void hci_unregister_dev(struct hci_dev *hdev)
 	}
 
 	device_del(&hdev->dev);
+	hci_dev_put(hdev);
+}
+EXPORT_SYMBOL(hci_unregister_dev);
 
+/* Release HCI device */
+void hci_release_dev(struct hci_dev *hdev)
+{
 	debugfs_remove_recursive(hdev->debugfs);
 	kfree_const(hdev->hw_info);
 	kfree_const(hdev->fw_info);
@@ -4063,11 +4065,10 @@ void hci_unregister_dev(struct hci_dev *hdev)
 	hci_blocked_keys_clear(hdev);
 	hci_dev_unlock(hdev);
 
-	hci_dev_put(hdev);
-
-	ida_simple_remove(&hci_index_ida, id);
+	ida_simple_remove(&hci_index_ida, hdev->id);
+	kfree(hdev);
 }
-EXPORT_SYMBOL(hci_unregister_dev);
+EXPORT_SYMBOL(hci_release_dev);
 
 /* Suspend HCI device */
 int hci_suspend_dev(struct hci_dev *hdev)
diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index b04a5a02ecf3..d810a5adf064 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -759,19 +759,13 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
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
@@ -1103,6 +1097,18 @@ static int hci_sock_bind(struct socket *sock, struct sockaddr *addr,
 
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
diff --git a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
index 9874844a95a9..ebf282d1eb2b 100644
--- a/net/bluetooth/hci_sysfs.c
+++ b/net/bluetooth/hci_sysfs.c
@@ -83,7 +83,7 @@ void hci_conn_del_sysfs(struct hci_conn *conn)
 static void bt_host_release(struct device *dev)
 {
 	struct hci_dev *hdev = to_hci_dev(dev);
-	kfree(hdev);
+	hci_release_dev(hdev);
 	module_put(THIS_MODULE);
 }
 

