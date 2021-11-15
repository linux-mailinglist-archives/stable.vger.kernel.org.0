Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF6214527AD
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242289AbhKPCaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:30:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:50536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235145AbhKORQx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:16:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA12D63256;
        Mon, 15 Nov 2021 17:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996371;
        bh=wFMUeH1FDA87z3CGgGJ9U3yq3OQ7CrXInZWnOAy9wXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VHDmnGZQS5/5pfbaeWF7BlNBByry146KowPY1wLzdjp2kyeS5Yvp11URpg4uRga9Y
         GNjOjv4xeQMMjMrmRPNbeAQoYks2OqHwkyOV2nW4z0O4MN8KT8uW8+F3Uk81stATuT
         5zfo/35kXIXYt05gu+rFyLW9ChuHFl00ZXdaUvwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 116/355] Bluetooth: sco: Fix lock_sock() blockage by memcpy_from_msg()
Date:   Mon, 15 Nov 2021 18:00:40 +0100
Message-Id: <20211115165317.561104921@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 99c23da0eed4fd20cae8243f2b51e10e66aa0951 ]

The sco_send_frame() also takes lock_sock() during memcpy_from_msg()
call that may be endlessly blocked by a task with userfaultd
technique, and this will result in a hung task watchdog trigger.

Just like the similar fix for hci_sock_sendmsg() in commit
92c685dc5de0 ("Bluetooth: reorganize functions..."), this patch moves
the  memcpy_from_msg() out of lock_sock() for addressing the hang.

This should be the last piece for fixing CVE-2021-3640 after a few
already queued fixes.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/sco.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 1915943bb646a..cc5a1d2545679 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -280,7 +280,8 @@ static int sco_connect(struct hci_dev *hdev, struct sock *sk)
 	return err;
 }
 
-static int sco_send_frame(struct sock *sk, struct msghdr *msg, int len)
+static int sco_send_frame(struct sock *sk, void *buf, int len,
+			  unsigned int msg_flags)
 {
 	struct sco_conn *conn = sco_pi(sk)->conn;
 	struct sk_buff *skb;
@@ -292,15 +293,11 @@ static int sco_send_frame(struct sock *sk, struct msghdr *msg, int len)
 
 	BT_DBG("sk %p len %d", sk, len);
 
-	skb = bt_skb_send_alloc(sk, len, msg->msg_flags & MSG_DONTWAIT, &err);
+	skb = bt_skb_send_alloc(sk, len, msg_flags & MSG_DONTWAIT, &err);
 	if (!skb)
 		return err;
 
-	if (memcpy_from_msg(skb_put(skb, len), msg, len)) {
-		kfree_skb(skb);
-		return -EFAULT;
-	}
-
+	memcpy(skb_put(skb, len), buf, len);
 	hci_send_sco(conn->hcon, skb);
 
 	return len;
@@ -714,6 +711,7 @@ static int sco_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 			    size_t len)
 {
 	struct sock *sk = sock->sk;
+	void *buf;
 	int err;
 
 	BT_DBG("sock %p, sk %p", sock, sk);
@@ -725,14 +723,24 @@ static int sco_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 	if (msg->msg_flags & MSG_OOB)
 		return -EOPNOTSUPP;
 
+	buf = kmalloc(len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	if (memcpy_from_msg(buf, msg, len)) {
+		kfree(buf);
+		return -EFAULT;
+	}
+
 	lock_sock(sk);
 
 	if (sk->sk_state == BT_CONNECTED)
-		err = sco_send_frame(sk, msg, len);
+		err = sco_send_frame(sk, buf, len, msg->msg_flags);
 	else
 		err = -ENOTCONN;
 
 	release_sock(sk);
+	kfree(buf);
 	return err;
 }
 
-- 
2.33.0



