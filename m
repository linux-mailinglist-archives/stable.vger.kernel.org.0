Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8024420E4EC
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbgF2Vaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:30:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728849AbgF2SlV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:41:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD86923EF3;
        Mon, 29 Jun 2020 15:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443907;
        bh=9K5dZmUCZ09b907mtuBrQymjYkfsXL2A+ZFWg/PT65I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j7PoIfcVL4IDNCIiAO0PQxKjYC7iRj6j/jzNBkYc28/cVJ7CaTQvu1eryqkVLPnO7
         z7HJUh1o8/L6qhSeCWpQ+Bj7Iy7xdK0aIoMBTEcqKDoYn4kctHe+0QhBMhv3VXp5k8
         VYH4jWS3Eog2hYdIxGdEyMK2kae8SV4bQWcXAuGo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Hai <wanghai38@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 007/265] mld: fix memory leak in ipv6_mc_destroy_dev()
Date:   Mon, 29 Jun 2020 11:14:00 -0400
Message-Id: <20200629151818.2493727-8-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit ea2fce88d2fd678ed9d45354ff49b73f1d5615dd ]

Commit a84d01647989 ("mld: fix memory leak in mld_del_delrec()") fixed
the memory leak of MLD, but missing the ipv6_mc_destroy_dev() path, in
which mca_sources are leaked after ma_put().

Using ip6_mc_clear_src() to take care of the missing free.

BUG: memory leak
unreferenced object 0xffff8881113d3180 (size 64):
  comm "syz-executor071", pid 389, jiffies 4294887985 (age 17.943s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 ff 02 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000002cbc483c>] kmalloc include/linux/slab.h:555 [inline]
    [<000000002cbc483c>] kzalloc include/linux/slab.h:669 [inline]
    [<000000002cbc483c>] ip6_mc_add1_src net/ipv6/mcast.c:2237 [inline]
    [<000000002cbc483c>] ip6_mc_add_src+0x7f5/0xbb0 net/ipv6/mcast.c:2357
    [<0000000058b8b1ff>] ip6_mc_source+0xe0c/0x1530 net/ipv6/mcast.c:449
    [<000000000bfc4fb5>] do_ipv6_setsockopt.isra.12+0x1b2c/0x3b30 net/ipv6/ipv6_sockglue.c:754
    [<00000000e4e7a722>] ipv6_setsockopt+0xda/0x150 net/ipv6/ipv6_sockglue.c:950
    [<0000000029260d9a>] rawv6_setsockopt+0x45/0x100 net/ipv6/raw.c:1081
    [<000000005c1b46f9>] __sys_setsockopt+0x131/0x210 net/socket.c:2132
    [<000000008491f7db>] __do_sys_setsockopt net/socket.c:2148 [inline]
    [<000000008491f7db>] __se_sys_setsockopt net/socket.c:2145 [inline]
    [<000000008491f7db>] __x64_sys_setsockopt+0xba/0x150 net/socket.c:2145
    [<00000000c7bc11c5>] do_syscall_64+0xa1/0x530 arch/x86/entry/common.c:295
    [<000000005fb7a3f3>] entry_SYSCALL_64_after_hwframe+0x49/0xb3

Fixes: 1666d49e1d41 ("mld: do not remove mld souce list info when set link down")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Acked-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/mcast.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index eaa4c2cc2fbb2..c875c9b6edbe9 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -2618,6 +2618,7 @@ void ipv6_mc_destroy_dev(struct inet6_dev *idev)
 		idev->mc_list = i->next;
 
 		write_unlock_bh(&idev->lock);
+		ip6_mc_clear_src(i);
 		ma_put(i);
 		write_lock_bh(&idev->lock);
 	}
-- 
2.25.1

