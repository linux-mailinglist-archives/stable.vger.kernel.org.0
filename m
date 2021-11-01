Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFAF9441899
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233613AbhKAJtg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:49:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:52158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234021AbhKAJqb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:46:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39071613BD;
        Mon,  1 Nov 2021 09:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759019;
        bh=+gNXVsX/M598wnh5q65Qgkc5hLjGX5+sZacANQINnBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXIf7RBb6r67PwF+qUCQFUoz9Kxh5fDIiTxIP4NPyFDpw8+pnRpjuAWhicujrPePA
         DM4ELMXJKpk5k+6KVZhmBPFSvaTVErscU9jdSBICi5DUbA+zI9S+i533hVZbaIbVYl
         1BZkNDNmk9eLG5Bqe13m9VJce7ybF1470TCkgkS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Zhang <markzhang@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.14 081/125] RDMA/sa_query: Use strscpy_pad instead of memcpy to copy a string
Date:   Mon,  1 Nov 2021 10:17:34 +0100
Message-Id: <20211101082548.599225057@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Zhang <markzhang@nvidia.com>

commit 64733956ebba7cc629856f4a6ee35a52bc9c023f upstream.

When copying the device name, the length of the data memcpy copied exceeds
the length of the source buffer, which cause the KASAN issue below.  Use
strscpy_pad() instead.

 BUG: KASAN: slab-out-of-bounds in ib_nl_set_path_rec_attrs+0x136/0x320 [ib_core]
 Read of size 64 at addr ffff88811a10f5e0 by task rping/140263
 CPU: 3 PID: 140263 Comm: rping Not tainted 5.15.0-rc1+ #1
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
 Call Trace:
  dump_stack_lvl+0x57/0x7d
  print_address_description.constprop.0+0x1d/0xa0
  kasan_report+0xcb/0x110
  kasan_check_range+0x13d/0x180
  memcpy+0x20/0x60
  ib_nl_set_path_rec_attrs+0x136/0x320 [ib_core]
  ib_nl_make_request+0x1c6/0x380 [ib_core]
  send_mad+0x20a/0x220 [ib_core]
  ib_sa_path_rec_get+0x3e3/0x800 [ib_core]
  cma_query_ib_route+0x29b/0x390 [rdma_cm]
  rdma_resolve_route+0x308/0x3e0 [rdma_cm]
  ucma_resolve_route+0xe1/0x150 [rdma_ucm]
  ucma_write+0x17b/0x1f0 [rdma_ucm]
  vfs_write+0x142/0x4d0
  ksys_write+0x133/0x160
  do_syscall_64+0x43/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7f26499aa90f
 Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 29 fd ff ff 48 8b 54 24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 44 24 08 e8 5c fd ff ff 48
 RSP: 002b:00007f26495f2dc0 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
 RAX: ffffffffffffffda RBX: 00000000000007d0 RCX: 00007f26499aa90f
 RDX: 0000000000000010 RSI: 00007f26495f2e00 RDI: 0000000000000003
 RBP: 00005632a8315440 R08: 0000000000000000 R09: 0000000000000001
 R10: 0000000000000000 R11: 0000000000000293 R12: 00007f26495f2e00
 R13: 00005632a83154e0 R14: 00005632a8315440 R15: 00005632a830a810

 Allocated by task 131419:
  kasan_save_stack+0x1b/0x40
  __kasan_kmalloc+0x7c/0x90
  proc_self_get_link+0x8b/0x100
  pick_link+0x4f1/0x5c0
  step_into+0x2eb/0x3d0
  walk_component+0xc8/0x2c0
  link_path_walk+0x3b8/0x580
  path_openat+0x101/0x230
  do_filp_open+0x12e/0x240
  do_sys_openat2+0x115/0x280
  __x64_sys_openat+0xce/0x140
  do_syscall_64+0x43/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: 2ca546b92a02 ("IB/sa: Route SA pathrecord query through netlink")
Link: https://lore.kernel.org/r/72ede0f6dab61f7f23df9ac7a70666e07ef314b0.1635055496.git.leonro@nvidia.com
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/sa_query.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -760,8 +760,9 @@ static void ib_nl_set_path_rec_attrs(str
 
 	/* Construct the family header first */
 	header = skb_put(skb, NLMSG_ALIGN(sizeof(*header)));
-	memcpy(header->device_name, dev_name(&query->port->agent->device->dev),
-	       LS_DEVICE_NAME_MAX);
+	strscpy_pad(header->device_name,
+		    dev_name(&query->port->agent->device->dev),
+		    LS_DEVICE_NAME_MAX);
 	header->port_num = query->port->port_num;
 
 	if ((comp_mask & IB_SA_PATH_REC_REVERSIBLE) &&


