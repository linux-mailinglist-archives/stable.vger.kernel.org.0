Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6BC220DEF1
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733029AbgF2Ua6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:30:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732481AbgF2TZT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C063D25429;
        Mon, 29 Jun 2020 15:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445378;
        bh=qIdhd1f6eHOYapZmovH72ShT5h0sRK0Uxj8J0WuHwpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UQYCFGiHJP4fA9y3C3/zERlyMvqd+GDxBWxsUWw2aLT6S+0p+F1oFXm2UJEFcgMFt
         56OgAIAIa5tqmY9Sh+4AwWb8LL3R14A69WIm6oVbKQ1sheRxEI02iwj+mE01HBLIHi
         Dxdw5KMHMlArI8DMIf6zcqaUtDKqUU6hWthUN7+I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 133/191] net: fix memleak in register_netdevice()
Date:   Mon, 29 Jun 2020 11:39:09 -0400
Message-Id: <20200629154007.2495120-134-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 814152a89ed52c722ab92e9fbabcac3cb8a39245 ]

I got a memleak report when doing some fuzz test:

unreferenced object 0xffff888112584000 (size 13599):
  comm "ip", pid 3048, jiffies 4294911734 (age 343.491s)
  hex dump (first 32 bytes):
    74 61 70 30 00 00 00 00 00 00 00 00 00 00 00 00  tap0............
    00 ee d9 19 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000002f60ba65>] __kmalloc_node+0x309/0x3a0
    [<0000000075b211ec>] kvmalloc_node+0x7f/0xc0
    [<00000000d3a97396>] alloc_netdev_mqs+0x76/0xfc0
    [<00000000609c3655>] __tun_chr_ioctl+0x1456/0x3d70
    [<000000001127ca24>] ksys_ioctl+0xe5/0x130
    [<00000000b7d5e66a>] __x64_sys_ioctl+0x6f/0xb0
    [<00000000e1023498>] do_syscall_64+0x56/0xa0
    [<000000009ec0eb12>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
unreferenced object 0xffff888111845cc0 (size 8):
  comm "ip", pid 3048, jiffies 4294911734 (age 343.491s)
  hex dump (first 8 bytes):
    74 61 70 30 00 88 ff ff                          tap0....
  backtrace:
    [<000000004c159777>] kstrdup+0x35/0x70
    [<00000000d8b496ad>] kstrdup_const+0x3d/0x50
    [<00000000494e884a>] kvasprintf_const+0xf1/0x180
    [<0000000097880a2b>] kobject_set_name_vargs+0x56/0x140
    [<000000008fbdfc7b>] dev_set_name+0xab/0xe0
    [<000000005b99e3b4>] netdev_register_kobject+0xc0/0x390
    [<00000000602704fe>] register_netdevice+0xb61/0x1250
    [<000000002b7ca244>] __tun_chr_ioctl+0x1cd1/0x3d70
    [<000000001127ca24>] ksys_ioctl+0xe5/0x130
    [<00000000b7d5e66a>] __x64_sys_ioctl+0x6f/0xb0
    [<00000000e1023498>] do_syscall_64+0x56/0xa0
    [<000000009ec0eb12>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
unreferenced object 0xffff88811886d800 (size 512):
  comm "ip", pid 3048, jiffies 4294911734 (age 343.491s)
  hex dump (first 32 bytes):
    00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
    ff ff ff ff ff ff ff ff c0 66 3d a3 ff ff ff ff  .........f=.....
  backtrace:
    [<0000000050315800>] device_add+0x61e/0x1950
    [<0000000021008dfb>] netdev_register_kobject+0x17e/0x390
    [<00000000602704fe>] register_netdevice+0xb61/0x1250
    [<000000002b7ca244>] __tun_chr_ioctl+0x1cd1/0x3d70
    [<000000001127ca24>] ksys_ioctl+0xe5/0x130
    [<00000000b7d5e66a>] __x64_sys_ioctl+0x6f/0xb0
    [<00000000e1023498>] do_syscall_64+0x56/0xa0
    [<000000009ec0eb12>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

If call_netdevice_notifiers() failed, then rollback_registered()
calls netdev_unregister_kobject() which holds the kobject. The
reference cannot be put because the netdev won't be add to todo
list, so it will leads a memleak, we need put the reference to
avoid memleak.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index edb2ddbbed9a1..267b648a0645e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7355,6 +7355,13 @@ int register_netdevice(struct net_device *dev)
 		rcu_barrier();
 
 		dev->reg_state = NETREG_UNREGISTERED;
+		/* We should put the kobject that hold in
+		 * netdev_unregister_kobject(), otherwise
+		 * the net device cannot be freed when
+		 * driver calls free_netdev(), because the
+		 * kobject is being hold.
+		 */
+		kobject_put(&dev->dev.kobj);
 	}
 	/*
 	 *	Prevent userspace races by waiting until the network
-- 
2.25.1

