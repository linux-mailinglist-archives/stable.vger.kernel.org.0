Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C61620E4DF
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729429AbgF2V3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:29:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728905AbgF2SlY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:41:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DDEE2415A;
        Mon, 29 Jun 2020 15:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443940;
        bh=b+BmPJ7PdB/ndOAReTGuooxydxFLBS0jg9jSpDW8ObI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ho6UkY9iPtwZWHcPI1veQvtelIW0DjppfqHEEkyzvwWCLaxN3Hntcl/fTXNty2LUy
         75CYmBQligkp/q06AYDy0Hyio4mZYlhqwdMVPdFQK+VuHFTeiSEZlHtd+N6Ol109CP
         wgLdjGlvuazkjKyYW7le7FPo6Iya7KL0mkvIoIIc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 042/265] mptcp: fix memory leak in mptcp_subflow_create_socket()
Date:   Mon, 29 Jun 2020 11:14:35 -0400
Message-Id: <20200629151818.2493727-43-sashal@kernel.org>
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

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit b8ad540dd4e40566c520dff491fc06c71ae6b989 ]

socket malloced  by sock_create_kern() should be release before return
in the error handling, otherwise it cause memory leak.

unreferenced object 0xffff88810910c000 (size 1216):
  comm "00000003_test_m", pid 12238, jiffies 4295050289 (age 54.237s)
  hex dump (first 32 bytes):
    01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 2f 30 0a 81 88 ff ff  ........./0.....
  backtrace:
    [<00000000e877f89f>] sock_alloc_inode+0x18/0x1c0
    [<0000000093d1dd51>] alloc_inode+0x63/0x1d0
    [<000000005673fec6>] new_inode_pseudo+0x14/0xe0
    [<00000000b5db6be8>] sock_alloc+0x3c/0x260
    [<00000000e7e3cbb2>] __sock_create+0x89/0x620
    [<0000000023e48593>] mptcp_subflow_create_socket+0xc0/0x5e0
    [<00000000419795e4>] __mptcp_socket_create+0x1ad/0x3f0
    [<00000000b2f942e8>] mptcp_stream_connect+0x281/0x4f0
    [<00000000c80cd5cc>] __sys_connect_file+0x14d/0x190
    [<00000000dc761f11>] __sys_connect+0x128/0x160
    [<000000008b14e764>] __x64_sys_connect+0x6f/0xb0
    [<000000007b4f93bd>] do_syscall_64+0xa1/0x530
    [<00000000d3e770b6>] entry_SYSCALL_64_after_hwframe+0x49/0xb3

Fixes: 2303f994b3e1 ("mptcp: Associate MPTCP context with TCP socket")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index e6feb05a93dc3..db3e4e74e7857 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1015,8 +1015,10 @@ int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
 	err = tcp_set_ulp(sf->sk, "mptcp");
 	release_sock(sf->sk);
 
-	if (err)
+	if (err) {
+		sock_release(sf);
 		return err;
+	}
 
 	/* the newly created socket really belongs to the owning MPTCP master
 	 * socket, even if for additional subflows the allocation is performed
-- 
2.25.1

