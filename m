Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A88F3B6283
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236384AbhF1OsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:48:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:51690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235030AbhF1OoG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:44:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7358D61CF4;
        Mon, 28 Jun 2021 14:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890832;
        bh=UzTEwpoQtfEBrdsI/qYr0yA9V1QLcf86tCxcXt6DDiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pQyGamWbthw0kwi7ee9Yogr7YNae8GvJmauqZz1dCgIUz++hvLh3vW5giz5A/brB8
         umSOgCAdaG3JjXy5hThb0m9Vs1Bx21K8eA+ic8Rrx+ihKrjXFD5HGRdByM74hkISbi
         fR5gUe6y0A1Eo5LzfaloIMVwDUnDP/WQpYHdjHPjxn8ymDgWsZztBRUkaJl4YJeqcY
         BsPUZcASU90VAOcDlZGl7hyc2UQ7RXKE6CtekrtZZbq1LHI7lTw+Alyj0hm5VDQiP6
         Fw67G9Lmi/GPGy+TUXt2ZIvDJPWV1/exXa8zRsZGlQAwRj19+KOlyjOtsqpvwACwom
         jb/eaX8+jhNUg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 050/109] net: hamradio: fix memory leak in mkiss_close
Date:   Mon, 28 Jun 2021 10:32:06 -0400
Message-Id: <20210628143305.32978-51-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 7edcc682301492380fbdd604b4516af5ae667a13 ]

My local syzbot instance hit memory leak in
mkiss_open()[1]. The problem was in missing
free_netdev() in mkiss_close().

In mkiss_open() netdevice is allocated and then
registered, but in mkiss_close() netdevice was
only unregistered, but not freed.

Fail log:

BUG: memory leak
unreferenced object 0xffff8880281ba000 (size 4096):
  comm "syz-executor.1", pid 11443, jiffies 4295046091 (age 17.660s)
  hex dump (first 32 bytes):
    61 78 30 00 00 00 00 00 00 00 00 00 00 00 00 00  ax0.............
    00 27 fa 2a 80 88 ff ff 00 00 00 00 00 00 00 00  .'.*............
  backtrace:
    [<ffffffff81a27201>] kvmalloc_node+0x61/0xf0
    [<ffffffff8706e7e8>] alloc_netdev_mqs+0x98/0xe80
    [<ffffffff84e64192>] mkiss_open+0xb2/0x6f0 [1]
    [<ffffffff842355db>] tty_ldisc_open+0x9b/0x110
    [<ffffffff84236488>] tty_set_ldisc+0x2e8/0x670
    [<ffffffff8421f7f3>] tty_ioctl+0xda3/0x1440
    [<ffffffff81c9f273>] __x64_sys_ioctl+0x193/0x200
    [<ffffffff8911263a>] do_syscall_64+0x3a/0xb0
    [<ffffffff89200068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff8880141a9a00 (size 96):
  comm "syz-executor.1", pid 11443, jiffies 4295046091 (age 17.660s)
  hex dump (first 32 bytes):
    e8 a2 1b 28 80 88 ff ff e8 a2 1b 28 80 88 ff ff  ...(.......(....
    98 92 9c aa b0 40 02 00 00 00 00 00 00 00 00 00  .....@..........
  backtrace:
    [<ffffffff8709f68b>] __hw_addr_create_ex+0x5b/0x310
    [<ffffffff8709fb38>] __hw_addr_add_ex+0x1f8/0x2b0
    [<ffffffff870a0c7b>] dev_addr_init+0x10b/0x1f0
    [<ffffffff8706e88b>] alloc_netdev_mqs+0x13b/0xe80
    [<ffffffff84e64192>] mkiss_open+0xb2/0x6f0 [1]
    [<ffffffff842355db>] tty_ldisc_open+0x9b/0x110
    [<ffffffff84236488>] tty_set_ldisc+0x2e8/0x670
    [<ffffffff8421f7f3>] tty_ioctl+0xda3/0x1440
    [<ffffffff81c9f273>] __x64_sys_ioctl+0x193/0x200
    [<ffffffff8911263a>] do_syscall_64+0x3a/0xb0
    [<ffffffff89200068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff8880219bfc00 (size 512):
  comm "syz-executor.1", pid 11443, jiffies 4295046091 (age 17.660s)
  hex dump (first 32 bytes):
    00 a0 1b 28 80 88 ff ff 80 8f b1 8d ff ff ff ff  ...(............
    80 8f b1 8d ff ff ff ff 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81a27201>] kvmalloc_node+0x61/0xf0
    [<ffffffff8706eec7>] alloc_netdev_mqs+0x777/0xe80
    [<ffffffff84e64192>] mkiss_open+0xb2/0x6f0 [1]
    [<ffffffff842355db>] tty_ldisc_open+0x9b/0x110
    [<ffffffff84236488>] tty_set_ldisc+0x2e8/0x670
    [<ffffffff8421f7f3>] tty_ioctl+0xda3/0x1440
    [<ffffffff81c9f273>] __x64_sys_ioctl+0x193/0x200
    [<ffffffff8911263a>] do_syscall_64+0x3a/0xb0
    [<ffffffff89200068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff888029b2b200 (size 256):
  comm "syz-executor.1", pid 11443, jiffies 4295046091 (age 17.660s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81a27201>] kvmalloc_node+0x61/0xf0
    [<ffffffff8706f062>] alloc_netdev_mqs+0x912/0xe80
    [<ffffffff84e64192>] mkiss_open+0xb2/0x6f0 [1]
    [<ffffffff842355db>] tty_ldisc_open+0x9b/0x110
    [<ffffffff84236488>] tty_set_ldisc+0x2e8/0x670
    [<ffffffff8421f7f3>] tty_ioctl+0xda3/0x1440
    [<ffffffff81c9f273>] __x64_sys_ioctl+0x193/0x200
    [<ffffffff8911263a>] do_syscall_64+0x3a/0xb0
    [<ffffffff89200068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: 815f62bf7427 ("[PATCH] SMP rewrite of mkiss")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/mkiss.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/hamradio/mkiss.c b/drivers/net/hamradio/mkiss.c
index 3b14e6e281d4..940aa7a19f50 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -810,6 +810,7 @@ static void mkiss_close(struct tty_struct *tty)
 	ax->tty = NULL;
 
 	unregister_netdev(ax->dev);
+	free_netdev(ax->dev);
 }
 
 /* Perform I/O control on an active ax25 channel. */
-- 
2.30.2

