Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2F923A5FD
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbgHCM3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:29:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728309AbgHCM3X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:29:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 102BB2083B;
        Mon,  3 Aug 2020 12:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457761;
        bh=UrYifyq0Pf/TA6VM3AVSRA9hu+2XFb3N7zmCd1lYJQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GuH8gfB2QjKIpJvA9JAy7anQ4OWz9lcADIub8U+/lsxExuttXlkSec1wQI/Y6HMmZ
         2HOPbe4C/TWIG2RVTpQ6IsR5Ntu/TdiKHFr7AbgW7RBbNAtjuB9ljZ91YEpM/FSx40
         6k6TK5jK8Kp6w2exIcAIFS6cKOumbfDL8eiEzh/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+6db548b615e5aeefdce2@syzkaller.appspotmail.com,
        YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 34/90] net/x25: Fix null-ptr-deref in x25_disconnect
Date:   Mon,  3 Aug 2020 14:18:56 +0200
Message-Id: <20200803121859.263966529@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

commit 8999dc89497ab1c80d0718828e838c7cd5f6bffe upstream.

We should check null before do x25_neigh_put in x25_disconnect,
otherwise may cause null-ptr-deref like this:

 #include <sys/socket.h>
 #include <linux/x25.h>

 int main() {
    int sck_x25;
    sck_x25 = socket(AF_X25, SOCK_SEQPACKET, 0);
    close(sck_x25);
    return 0;
 }

BUG: kernel NULL pointer dereference, address: 00000000000000d8
CPU: 0 PID: 4817 Comm: t2 Not tainted 5.7.0-rc3+ #159
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.9.3-
RIP: 0010:x25_disconnect+0x91/0xe0
Call Trace:
 x25_release+0x18a/0x1b0
 __sock_release+0x3d/0xc0
 sock_close+0x13/0x20
 __fput+0x107/0x270
 ____fput+0x9/0x10
 task_work_run+0x6d/0xb0
 exit_to_usermode_loop+0x102/0x110
 do_syscall_64+0x23c/0x260
 entry_SYSCALL_64_after_hwframe+0x49/0xb3

Reported-by: syzbot+6db548b615e5aeefdce2@syzkaller.appspotmail.com
Fixes: 4becb7ee5b3d ("net/x25: Fix x25_neigh refcnt leak when x25 disconnect")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/x25/x25_subr.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/net/x25/x25_subr.c
+++ b/net/x25/x25_subr.c
@@ -357,10 +357,12 @@ void x25_disconnect(struct sock *sk, int
 		sk->sk_state_change(sk);
 		sock_set_flag(sk, SOCK_DEAD);
 	}
-	read_lock_bh(&x25_list_lock);
-	x25_neigh_put(x25->neighbour);
-	x25->neighbour = NULL;
-	read_unlock_bh(&x25_list_lock);
+	if (x25->neighbour) {
+		read_lock_bh(&x25_list_lock);
+		x25_neigh_put(x25->neighbour);
+		x25->neighbour = NULL;
+		read_unlock_bh(&x25_list_lock);
+	}
 }
 
 /*


