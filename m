Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEF6F171FDD
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731680AbgB0Nza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:55:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:55742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731198AbgB0Nz3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:55:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D6BA2084E;
        Thu, 27 Feb 2020 13:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811728;
        bh=ryOnP8ucTIYwFVmX7tPoXN5bUSKlEErdFqgLlvtWFRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CZ95Zi9/Y5KNz96QdE+bt8OJmSyv1ebDX1Sb030CLfQUcyhTNoOfqB9+kwJjl8IYE
         8TSl8pieNKq0vops3iWtFhBK8SMcXhpXUJzsPgUzlQDQq47pHeFrPoVQeY4f5FwhpM
         LHf0EkzMx+2bPcDI3+l9505Bx1JrhnNIE90bXZ7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: [PATCH 4.14 029/237] RDMA/core: Fix protection fault in get_pkey_idx_qp_list
Date:   Thu, 27 Feb 2020 14:34:03 +0100
Message-Id: <20200227132258.663284698@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

commit 1dd017882e01d2fcd9c5dbbf1eb376211111c393 upstream.

We don't need to set pkey as valid in case that user set only one of pkey
index or port number, otherwise it will be resulted in NULL pointer
dereference while accessing to uninitialized pkey list.  The following
crash from Syzkaller revealed it.

  kasan: CONFIG_KASAN_INLINE enabled
  kasan: GPF could be caused by NULL-ptr deref or user memory access
  general protection fault: 0000 [#1] SMP KASAN PTI
  CPU: 1 PID: 14753 Comm: syz-executor.2 Not tainted 5.5.0-rc5 #2
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
  rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
  RIP: 0010:get_pkey_idx_qp_list+0x161/0x2d0
  Code: 01 00 00 49 8b 5e 20 4c 39 e3 0f 84 b9 00 00 00 e8 e4 42 6e fe 48
  8d 7b 10 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04
  02 84 c0 74 08 3c 01 0f 8e d0 00 00 00 48 8d 7d 04 48 b8
  RSP: 0018:ffffc9000bc6f950 EFLAGS: 00010202
  RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff82c8bdec
  RDX: 0000000000000002 RSI: ffffc900030a8000 RDI: 0000000000000010
  RBP: ffff888112c8ce80 R08: 0000000000000004 R09: fffff5200178df1f
  R10: 0000000000000001 R11: fffff5200178df1f R12: ffff888115dc4430
  R13: ffff888115da8498 R14: ffff888115dc4410 R15: ffff888115da8000
  FS:  00007f20777de700(0000) GS:ffff88811b100000(0000)
  knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000001b2f721000 CR3: 00000001173ca002 CR4: 0000000000360ee0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   port_pkey_list_insert+0xd7/0x7c0
   ib_security_modify_qp+0x6fa/0xfc0
   _ib_modify_qp+0x8c4/0xbf0
   modify_qp+0x10da/0x16d0
   ib_uverbs_modify_qp+0x9a/0x100
   ib_uverbs_write+0xaa5/0xdf0
   __vfs_write+0x7c/0x100
   vfs_write+0x168/0x4a0
   ksys_write+0xc8/0x200
   do_syscall_64+0x9c/0x390
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: d291f1a65232 ("IB/core: Enforce PKey security on QPs")
Link: https://lore.kernel.org/r/20200212080651.GB679970@unreal
Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Message-Id: <20200212080651.GB679970@unreal>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/security.c |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

--- a/drivers/infiniband/core/security.c
+++ b/drivers/infiniband/core/security.c
@@ -338,22 +338,16 @@ static struct ib_ports_pkeys *get_new_pp
 	if (!new_pps)
 		return NULL;
 
-	if (qp_attr_mask & (IB_QP_PKEY_INDEX | IB_QP_PORT)) {
-		if (!qp_pps) {
-			new_pps->main.port_num = qp_attr->port_num;
-			new_pps->main.pkey_index = qp_attr->pkey_index;
-		} else {
-			new_pps->main.port_num = (qp_attr_mask & IB_QP_PORT) ?
-						  qp_attr->port_num :
-						  qp_pps->main.port_num;
-
-			new_pps->main.pkey_index =
-					(qp_attr_mask & IB_QP_PKEY_INDEX) ?
-					 qp_attr->pkey_index :
-					 qp_pps->main.pkey_index;
-		}
+	if (qp_attr_mask & IB_QP_PORT)
+		new_pps->main.port_num =
+			(qp_pps) ? qp_pps->main.port_num : qp_attr->port_num;
+	if (qp_attr_mask & IB_QP_PKEY_INDEX)
+		new_pps->main.pkey_index = (qp_pps) ? qp_pps->main.pkey_index :
+						      qp_attr->pkey_index;
+	if ((qp_attr_mask & IB_QP_PKEY_INDEX) && (qp_attr_mask & IB_QP_PORT))
 		new_pps->main.state = IB_PORT_PKEY_VALID;
-	} else if (qp_pps) {
+
+	if (!(qp_attr_mask & (IB_QP_PKEY_INDEX || IB_QP_PORT)) && qp_pps) {
 		new_pps->main.port_num = qp_pps->main.port_num;
 		new_pps->main.pkey_index = qp_pps->main.pkey_index;
 		if (qp_pps->main.state != IB_PORT_PKEY_NOT_VALID)


