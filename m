Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4378F27CBC9
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732938AbgI2Maq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:30:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729294AbgI2L3J (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:29:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8548B206A5;
        Tue, 29 Sep 2020 11:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378594;
        bh=AZ8ZANYn2ayZhfHdgsNtX6pMLu7dDv5koNz1Gu18hNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d+KyULDQ1yh8UjJqc+f63Dp2t15HWrNGk3byIY4IuKKhhRdWQhqEHIu4BF0g2EFp0
         5cwRh+0ILatEd04HgEbATFqVADB+Ek1/N3dMrijrMrR9KIB7Yw9Cz2cws8w3FeWxEB
         iVPuRoJju6VPr3GaKuDWCy8KYx7mWrbMSmd2q9sA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+c3c5bdea7863886115dc@syzkaller.appspotmail.com,
        Manish Mandlik <mmandlik@google.com>,
        Hillf Danton <hdanton@sina.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 069/245] Bluetooth: prefetch channel before killing sock
Date:   Tue, 29 Sep 2020 12:58:40 +0200
Message-Id: <20200929105950.351532974@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hillf Danton <hdanton@sina.com>

[ Upstream commit 2a154903cec20fb64ff4d7d617ca53c16f8fd53a ]

Prefetch channel before killing sock in order to fix UAF like

 BUG: KASAN: use-after-free in l2cap_sock_release+0x24c/0x290 net/bluetooth/l2cap_sock.c:1212
 Read of size 8 at addr ffff8880944904a0 by task syz-fuzzer/9751

Reported-by: syzbot+c3c5bdea7863886115dc@syzkaller.appspotmail.com
Fixes: 6c08fc896b60 ("Bluetooth: Fix refcount use-after-free issue")
Cc: Manish Mandlik <mmandlik@google.com>
Signed-off-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_sock.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index d128750e47305..5572042f04531 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1190,6 +1190,7 @@ static int l2cap_sock_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
 	int err;
+	struct l2cap_chan *chan;
 
 	BT_DBG("sock %p, sk %p", sock, sk);
 
@@ -1199,15 +1200,16 @@ static int l2cap_sock_release(struct socket *sock)
 	bt_sock_unlink(&l2cap_sk_list, sk);
 
 	err = l2cap_sock_shutdown(sock, 2);
+	chan = l2cap_pi(sk)->chan;
 
-	l2cap_chan_hold(l2cap_pi(sk)->chan);
-	l2cap_chan_lock(l2cap_pi(sk)->chan);
+	l2cap_chan_hold(chan);
+	l2cap_chan_lock(chan);
 
 	sock_orphan(sk);
 	l2cap_sock_kill(sk);
 
-	l2cap_chan_unlock(l2cap_pi(sk)->chan);
-	l2cap_chan_put(l2cap_pi(sk)->chan);
+	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 	return err;
 }
-- 
2.25.1



