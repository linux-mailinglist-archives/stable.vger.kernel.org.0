Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10EE26B5B6
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbgIOXtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:49:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727101AbgIOOcm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:32:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AA7323BCF;
        Tue, 15 Sep 2020 14:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179866;
        bh=VuRyrZCpxs7LnotuOGP1p05L9b/lWfxDQDDHXSxiBnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hm9HvUyxVCm0YrvwTaAHa879b+ZUlI72NiuAoiJcESq/tIIydzhS4KtYayr7TdSqo
         QUkGfk5wPRFe+G47AxJrHj8uVdoxQycqnK1+S+SwwrGvbQx1KJAlHa4rFcp4IxQmRC
         lugJYL2iAlZX6MPbCrMaAuLwgKjtEdJa+Va2i+NY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 017/177] RDMA/rxe: Fix panic when calling kmem_cache_create()
Date:   Tue, 15 Sep 2020 16:11:28 +0200
Message-Id: <20200915140654.469715444@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Heib <kamalheib1@gmail.com>

[ Upstream commit d862060a4b43479887ae8e2c0b74a58c4e27e5f3 ]

To avoid the following kernel panic when calling kmem_cache_create() with
a NULL pointer from pool_cache(), Block the rxe_param_set_add() from
running if the rdma_rxe module is not initialized.

 BUG: unable to handle kernel NULL pointer dereference at 000000000000000b
 PGD 0 P4D 0
 Oops: 0000 [#1] SMP NOPTI
 CPU: 4 PID: 8512 Comm: modprobe Kdump: loaded Not tainted 4.18.0-231.el8.x86_64 #1
 Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 10/02/2018
 RIP: 0010:kmem_cache_alloc+0xd1/0x1b0
 Code: 8b 57 18 45 8b 77 1c 48 8b 5c 24 30 0f 1f 44 00 00 5b 48 89 e8 5d 41 5c 41 5d 41 5e 41 5f c3 81 e3 00 00 10 00 75 0e 4d 89 fe <41> f6 47 0b 04 0f 84 6c ff ff ff 4c 89 ff e8 cc da 01 00 49 89 c6
 RSP: 0018:ffffa2b8c773f9d0 EFLAGS: 00010246
 RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000005
 RDX: 0000000000000004 RSI: 00000000006080c0 RDI: 0000000000000000
 RBP: ffff8ea0a8634fd0 R08: ffffa2b8c773f988 R09: 00000000006000c0
 R10: 0000000000000000 R11: 0000000000000230 R12: 00000000006080c0
 R13: ffffffffc0a97fc8 R14: 0000000000000000 R15: 0000000000000000
 FS:  00007f9138ed9740(0000) GS:ffff8ea4ae800000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000000000000000b CR3: 000000046d59a000 CR4: 00000000003406e0
 Call Trace:
  rxe_alloc+0xc8/0x160 [rdma_rxe]
  rxe_get_dma_mr+0x25/0xb0 [rdma_rxe]
  __ib_alloc_pd+0xcb/0x160 [ib_core]
  ib_mad_init_device+0x296/0x8b0 [ib_core]
  add_client_context+0x11a/0x160 [ib_core]
  enable_device_and_get+0xdc/0x1d0 [ib_core]
  ib_register_device+0x572/0x6b0 [ib_core]
  ? crypto_create_tfm+0x32/0xe0
  ? crypto_create_tfm+0x7a/0xe0
  ? crypto_alloc_tfm+0x58/0xf0
  rxe_register_device+0x19d/0x1c0 [rdma_rxe]
  rxe_net_add+0x3d/0x70 [rdma_rxe]
  ? dev_get_by_name_rcu+0x73/0x90
  rxe_param_set_add+0xaf/0xc0 [rdma_rxe]
  parse_args+0x179/0x370
  ? ref_module+0x1b0/0x1b0
  load_module+0x135e/0x17e0
  ? ref_module+0x1b0/0x1b0
  ? __do_sys_init_module+0x13b/0x180
  __do_sys_init_module+0x13b/0x180
  do_syscall_64+0x5b/0x1a0
  entry_SYSCALL_64_after_hwframe+0x65/0xca
 RIP: 0033:0x7f9137ed296e

This can be triggered if a user tries to use the 'module option' which is
not actually a real module option but some idiotic (and thankfully no
obsolete) sysfs interface.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/r/20200825151725.254046-1-kamalheib1@gmail.com
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe.c       | 4 ++++
 drivers/infiniband/sw/rxe/rxe.h       | 2 ++
 drivers/infiniband/sw/rxe/rxe_sysfs.c | 5 +++++
 3 files changed, 11 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
index c7191b5e04a5a..d6b1236b114ab 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -48,6 +48,8 @@ static void rxe_cleanup_ports(struct rxe_dev *rxe)
 
 }
 
+bool rxe_initialized;
+
 /* free resources for a rxe device all objects created for this device must
  * have been destroyed
  */
@@ -345,6 +347,7 @@ static int __init rxe_module_init(void)
 		return err;
 
 	rdma_link_register(&rxe_link_ops);
+	rxe_initialized = true;
 	pr_info("loaded\n");
 	return 0;
 }
@@ -356,6 +359,7 @@ static void __exit rxe_module_exit(void)
 	rxe_net_exit();
 	rxe_cache_exit();
 
+	rxe_initialized = false;
 	pr_info("unloaded\n");
 }
 
diff --git a/drivers/infiniband/sw/rxe/rxe.h b/drivers/infiniband/sw/rxe/rxe.h
index fb07eed9e4028..cae1b0a24c850 100644
--- a/drivers/infiniband/sw/rxe/rxe.h
+++ b/drivers/infiniband/sw/rxe/rxe.h
@@ -67,6 +67,8 @@
 
 #define RXE_ROCE_V2_SPORT		(0xc000)
 
+extern bool rxe_initialized;
+
 static inline u32 rxe_crc32(struct rxe_dev *rxe,
 			    u32 crc, void *next, size_t len)
 {
diff --git a/drivers/infiniband/sw/rxe/rxe_sysfs.c b/drivers/infiniband/sw/rxe/rxe_sysfs.c
index ccda5f5a3bc0a..2af31d421bfc3 100644
--- a/drivers/infiniband/sw/rxe/rxe_sysfs.c
+++ b/drivers/infiniband/sw/rxe/rxe_sysfs.c
@@ -61,6 +61,11 @@ static int rxe_param_set_add(const char *val, const struct kernel_param *kp)
 	struct net_device *ndev;
 	struct rxe_dev *exists;
 
+	if (!rxe_initialized) {
+		pr_err("Module parameters are not supported, use rdma link add or rxe_cfg\n");
+		return -EAGAIN;
+	}
+
 	len = sanitize_arg(val, intf, sizeof(intf));
 	if (!len) {
 		pr_err("add: invalid interface name\n");
-- 
2.25.1



