Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E19D420FB1
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237429AbhJDNhJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:37:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237479AbhJDNfQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:35:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D32D961BA7;
        Mon,  4 Oct 2021 13:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353356;
        bh=bpu1ckal/4m+hGMfx5xAtXUdPJDSYvzVAWrIWpxoXBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=16YVeMeIb9bCzew2QbX8ZnMvLn2L+5VU7pPhBFbS7C/q6vS2PfNSO/KvDngmweEl6
         s0E26+IHNJDuruIa9OOKsi02iwKvayjGeUDShJVd2E/bT2JowoiCMHCmfipp35s94k
         HrOMzuVJ/x2AyDytU1jf2yHWaAmObmRCwZ63W+T8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+6bb0528b13611047209c@syzkaller.appspotmail.com,
        Hao Sun <sunhao.th@gmail.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.14 064/172] RDMA/cma: Do not change route.addr.src_addr.ss_family
Date:   Mon,  4 Oct 2021 14:51:54 +0200
Message-Id: <20211004125047.055660686@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

commit bc0bdc5afaa740d782fbf936aaeebd65e5c2921d upstream.

If the state is not idle then rdma_bind_addr() will immediately fail and
no change to global state should happen.

For instance if the state is already RDMA_CM_LISTEN then this will corrupt
the src_addr and would cause the test in cma_cancel_operation():

		if (cma_any_addr(cma_src_addr(id_priv)) && !id_priv->cma_dev)

To view a mangled src_addr, eg with a IPv6 loopback address but an IPv4
family, failing the test.

This would manifest as this trace from syzkaller:

  BUG: KASAN: use-after-free in __list_add_valid+0x93/0xa0 lib/list_debug.c:26
  Read of size 8 at addr ffff8881546491e0 by task syz-executor.1/32204

  CPU: 1 PID: 32204 Comm: syz-executor.1 Not tainted 5.12.0-rc8-syzkaller #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  Call Trace:
   __dump_stack lib/dump_stack.c:79 [inline]
   dump_stack+0x141/0x1d7 lib/dump_stack.c:120
   print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:232
   __kasan_report mm/kasan/report.c:399 [inline]
   kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:416
   __list_add_valid+0x93/0xa0 lib/list_debug.c:26
   __list_add include/linux/list.h:67 [inline]
   list_add_tail include/linux/list.h:100 [inline]
   cma_listen_on_all drivers/infiniband/core/cma.c:2557 [inline]
   rdma_listen+0x787/0xe00 drivers/infiniband/core/cma.c:3751
   ucma_listen+0x16a/0x210 drivers/infiniband/core/ucma.c:1102
   ucma_write+0x259/0x350 drivers/infiniband/core/ucma.c:1732
   vfs_write+0x28e/0xa30 fs/read_write.c:603
   ksys_write+0x1ee/0x250 fs/read_write.c:658
   do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
   entry_SYSCALL_64_after_hwframe+0x44/0xae

Which is indicating that an rdma_id_private was destroyed without doing
cma_cancel_listens().

Instead of trying to re-use the src_addr memory to indirectly create an
any address build one explicitly on the stack and bind to that as any
other normal flow would do.

Link: https://lore.kernel.org/r/0-v1-9fbb33f5e201+2a-cma_listen_jgg@nvidia.com
Cc: stable@vger.kernel.org
Fixes: 732d41c545bb ("RDMA/cma: Make the locking for automatic state transition more clear")
Reported-by: syzbot+6bb0528b13611047209c@syzkaller.appspotmail.com
Tested-by: Hao Sun <sunhao.th@gmail.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/cma.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -3768,9 +3768,13 @@ int rdma_listen(struct rdma_cm_id *id, i
 	int ret;
 
 	if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND, RDMA_CM_LISTEN)) {
+		struct sockaddr_in any_in = {
+			.sin_family = AF_INET,
+			.sin_addr.s_addr = htonl(INADDR_ANY),
+		};
+
 		/* For a well behaved ULP state will be RDMA_CM_IDLE */
-		id->route.addr.src_addr.ss_family = AF_INET;
-		ret = rdma_bind_addr(id, cma_src_addr(id_priv));
+		ret = rdma_bind_addr(id, (struct sockaddr *)&any_in);
 		if (ret)
 			return ret;
 		if (WARN_ON(!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND,


