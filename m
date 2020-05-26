Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAE7719918C
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730574AbgCaJPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:15:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731249AbgCaJPE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:15:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DA1C20772;
        Tue, 31 Mar 2020 09:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646103;
        bh=FicCXVrC/nCMsgbkC5DjAjRJKwvdTxrQwIoRiKc+enc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A3UOyjnXola1bF/ooFsYeppPW3Zej2xhTBKe1XL2Ol78RIK6aDzVbt1uU/HAorxA/
         vwlej9Jo3ipsIkwH2EO5sEehT+4NlvAPO4i/C/3LWuJyqXwAA+ZlO5KrI14udtuAmH
         207zavivfbWmkuMu45OeKF3sZdUCzbyvBk2MubCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        syzbot+46fe08363dbba223dec5@syzkaller.appspotmail.com,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 085/155] RDMA/mad: Do not crash if the rdma device does not have a umad interface
Date:   Tue, 31 Mar 2020 10:58:45 +0200
Message-Id: <20200331085427.797159123@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

commit 5bdfa854013ce4193de0d097931fd841382c76a7 upstream.

Non-IB devices do not have a umad interface and the client_data will be
left set to NULL. In this case calling get_nl_info() will try to kref a
NULL cdev causing a crash:

  general protection fault, probably for non-canonical address 0xdffffc00000000ba: 0000 [#1] PREEMPT SMP KASAN
  KASAN: null-ptr-deref in range [0x00000000000005d0-0x00000000000005d7]
  CPU: 0 PID: 20851 Comm: syz-executor.0 Not tainted 5.6.0-rc2-syzkaller #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  RIP: 0010:kobject_get+0x35/0x150 lib/kobject.c:640
  Code: 53 e8 3f b0 8b f9 4d 85 e4 0f 84 a2 00 00 00 e8 31 b0 8b f9 49 8d 7c 24 3c 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f  b6 04 02 48 89 fa
+83 e2 07 38 d0 7f 08 84 c0 0f 85 eb 00 00 00
  RSP: 0018:ffffc9000946f1a0 EFLAGS: 00010203
  RAX: dffffc0000000000 RBX: ffffffff85bdbbb0 RCX: ffffc9000bf22000
  RDX: 00000000000000ba RSI: ffffffff87e9d78f RDI: 00000000000005d4
  RBP: ffffc9000946f1b8 R08: ffff8880581a6440 R09: ffff8880581a6cd0
  R10: fffffbfff154b838 R11: ffffffff8aa5c1c7 R12: 0000000000000598
  R13: 0000000000000000 R14: ffffc9000946f278 R15: ffff88805cb0c4d0
  FS:  00007faa9e8af700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000001b30121000 CR3: 000000004515d000 CR4: 00000000001406f0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   get_device+0x25/0x40 drivers/base/core.c:2574
   __ib_get_client_nl_info+0x205/0x2e0 drivers/infiniband/core/device.c:1861
   ib_get_client_nl_info+0x35/0x180 drivers/infiniband/core/device.c:1881
   nldev_get_chardev+0x575/0xac0 drivers/infiniband/core/nldev.c:1621
   rdma_nl_rcv_msg drivers/infiniband/core/netlink.c:195 [inline]
   rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
   rdma_nl_rcv+0x5d9/0x980 drivers/infiniband/core/netlink.c:259
   netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
   netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1329
   netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1918
   sock_sendmsg_nosec net/socket.c:652 [inline]
   sock_sendmsg+0xd7/0x130 net/socket.c:672
   ____sys_sendmsg+0x753/0x880 net/socket.c:2343
   ___sys_sendmsg+0x100/0x170 net/socket.c:2397
   __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
   __do_sys_sendmsg net/socket.c:2439 [inline]
   __se_sys_sendmsg net/socket.c:2437 [inline]
   __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
   do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
   entry_SYSCALL_64_after_hwframe+0x49/0xbe

Cc: stable@kernel.org
Fixes: 8f71bb0030b8 ("RDMA: Report available cdevs through RDMA_NLDEV_CMD_GET_CHARDEV")
Link: https://lore.kernel.org/r/20200310075339.238090-1-leon@kernel.org
Reported-by: syzbot+46fe08363dbba223dec5@syzkaller.appspotmail.com
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/user_mad.c |   33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -1129,17 +1129,30 @@ static const struct file_operations umad
 	.llseek	 = no_llseek,
 };
 
+static struct ib_umad_port *get_port(struct ib_device *ibdev,
+				     struct ib_umad_device *umad_dev,
+				     unsigned int port)
+{
+	if (!umad_dev)
+		return ERR_PTR(-EOPNOTSUPP);
+	if (!rdma_is_port_valid(ibdev, port))
+		return ERR_PTR(-EINVAL);
+	if (!rdma_cap_ib_mad(ibdev, port))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	return &umad_dev->ports[port - rdma_start_port(ibdev)];
+}
+
 static int ib_umad_get_nl_info(struct ib_device *ibdev, void *client_data,
 			       struct ib_client_nl_info *res)
 {
-	struct ib_umad_device *umad_dev = client_data;
+	struct ib_umad_port *port = get_port(ibdev, client_data, res->port);
 
-	if (!rdma_is_port_valid(ibdev, res->port))
-		return -EINVAL;
+	if (IS_ERR(port))
+		return PTR_ERR(port);
 
 	res->abi = IB_USER_MAD_ABI_VERSION;
-	res->cdev = &umad_dev->ports[res->port - rdma_start_port(ibdev)].dev;
-
+	res->cdev = &port->dev;
 	return 0;
 }
 
@@ -1154,15 +1167,13 @@ MODULE_ALIAS_RDMA_CLIENT("umad");
 static int ib_issm_get_nl_info(struct ib_device *ibdev, void *client_data,
 			       struct ib_client_nl_info *res)
 {
-	struct ib_umad_device *umad_dev =
-		ib_get_client_data(ibdev, &umad_client);
+	struct ib_umad_port *port = get_port(ibdev, client_data, res->port);
 
-	if (!rdma_is_port_valid(ibdev, res->port))
-		return -EINVAL;
+	if (IS_ERR(port))
+		return PTR_ERR(port);
 
 	res->abi = IB_USER_MAD_ABI_VERSION;
-	res->cdev = &umad_dev->ports[res->port - rdma_start_port(ibdev)].sm_dev;
-
+	res->cdev = &port->sm_dev;
 	return 0;
 }
 


