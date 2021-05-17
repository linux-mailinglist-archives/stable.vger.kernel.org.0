Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F278382E7F
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237963AbhEQOH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:07:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237968AbhEQOG7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:06:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F29DF61244;
        Mon, 17 May 2021 14:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260339;
        bh=1Tj8L1ZaYES/mLH5ILY14A6ccbafPhdoBV0lV+yee9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Co5RW+U/YnEDiNiJYjkaHq242uHZsi30oHWzapxiR/HRIolWZIQiCAM8d0uU0CZS1
         171FDKjxSxHh0dQn0csSASz8KyNYupYZr69v3SpUrnwFj+8MZgMhErac3JousPawLY
         8DMra+fPt0iXnJbHBgpae7TYug0NAmmMyQ6gDCpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Archie Pusaka <apusaka@chromium.org>,
        syzbot+abfc0f5e668d4099af73@syzkaller.appspotmail.com,
        Alain Michaud <alainm@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 037/363] Bluetooth: check for zapped sk before connecting
Date:   Mon, 17 May 2021 15:58:23 +0200
Message-Id: <20210517140303.846735793@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Archie Pusaka <apusaka@chromium.org>

[ Upstream commit 3af70b39fa2d415dc86c370e5b24ddb9fdacbd6f ]

There is a possibility of receiving a zapped sock on
l2cap_sock_connect(). This could lead to interesting crashes, one
such case is tearing down an already tore l2cap_sock as is happened
with this call trace:

__dump_stack lib/dump_stack.c:15 [inline]
dump_stack+0xc4/0x118 lib/dump_stack.c:56
register_lock_class kernel/locking/lockdep.c:792 [inline]
register_lock_class+0x239/0x6f6 kernel/locking/lockdep.c:742
__lock_acquire+0x209/0x1e27 kernel/locking/lockdep.c:3105
lock_acquire+0x29c/0x2fb kernel/locking/lockdep.c:3599
__raw_spin_lock_bh include/linux/spinlock_api_smp.h:137 [inline]
_raw_spin_lock_bh+0x38/0x47 kernel/locking/spinlock.c:175
spin_lock_bh include/linux/spinlock.h:307 [inline]
lock_sock_nested+0x44/0xfa net/core/sock.c:2518
l2cap_sock_teardown_cb+0x88/0x2fb net/bluetooth/l2cap_sock.c:1345
l2cap_chan_del+0xa3/0x383 net/bluetooth/l2cap_core.c:598
l2cap_chan_close+0x537/0x5dd net/bluetooth/l2cap_core.c:756
l2cap_chan_timeout+0x104/0x17e net/bluetooth/l2cap_core.c:429
process_one_work+0x7e3/0xcb0 kernel/workqueue.c:2064
worker_thread+0x5a5/0x773 kernel/workqueue.c:2196
kthread+0x291/0x2a6 kernel/kthread.c:211
ret_from_fork+0x4e/0x80 arch/x86/entry/entry_64.S:604

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reported-by: syzbot+abfc0f5e668d4099af73@syzkaller.appspotmail.com
Reviewed-by: Alain Michaud <alainm@chromium.org>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_sock.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index f1b1edd0b697..c99d65ef13b1 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -179,9 +179,17 @@ static int l2cap_sock_connect(struct socket *sock, struct sockaddr *addr,
 	struct l2cap_chan *chan = l2cap_pi(sk)->chan;
 	struct sockaddr_l2 la;
 	int len, err = 0;
+	bool zapped;
 
 	BT_DBG("sk %p", sk);
 
+	lock_sock(sk);
+	zapped = sock_flag(sk, SOCK_ZAPPED);
+	release_sock(sk);
+
+	if (zapped)
+		return -EINVAL;
+
 	if (!addr || alen < offsetofend(struct sockaddr, sa_family) ||
 	    addr->sa_family != AF_BLUETOOTH)
 		return -EINVAL;
-- 
2.30.2



