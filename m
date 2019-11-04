Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E242EEED15
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389467AbfKDWDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:03:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:33534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387970AbfKDWDM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:03:12 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D93FC20650;
        Mon,  4 Nov 2019 22:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904991;
        bh=5OUj+QuqErTOEhAKlafSVLVLPLYZY2IQPv6CAeujRU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y4NNgWtYy/OTo+JlKp4DOVkiaAx5pAnBrhHX/O9yyXgf/OHhuLQC2dp9bx9b+BPE0
         4xkaV62chXvhO46s4oGbqLiiWQmGwTCRL9lE1RT6PFSo7NkC5rFLVWF245r2cN5Cvh
         fqebCgSgvnRfhZyNGjxH53IrMXZo07kyH5cLi6Ig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 4.19 142/149] bonding: fix potential NULL deref in bond_update_slave_arr
Date:   Mon,  4 Nov 2019 22:45:35 +0100
Message-Id: <20191104212146.666721949@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit a7137534b597b7c303203e6bc3ed87e87a273bb8 upstream.

syzbot got a NULL dereference in bond_update_slave_arr() [1],
happening after a failure to allocate bond->slave_arr

A workqueue (bond_slave_arr_handler) is supposed to retry
the allocation later, but if the slave is removed before
the workqueue had a chance to complete, bond->slave_arr
can still be NULL.

[1]

Failed to build slave-array.
kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] SMP KASAN PTI
Modules linked in:
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:bond_update_slave_arr.cold+0xc6/0x198 drivers/net/bonding/bond_main.c:4039
RSP: 0018:ffff88018fe33678 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc9000290b000
RDX: 0000000000000000 RSI: ffffffff82b63037 RDI: ffff88019745ea20
RBP: ffff88018fe33760 R08: ffff880170754280 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffff88019745ea00 R14: 0000000000000000 R15: ffff88018fe338b0
FS:  00007febd837d700(0000) GS:ffff8801dad00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004540a0 CR3: 00000001c242e005 CR4: 00000000001626f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 [<ffffffff82b5b45e>] __bond_release_one+0x43e/0x500 drivers/net/bonding/bond_main.c:1923
 [<ffffffff82b5b966>] bond_release drivers/net/bonding/bond_main.c:2039 [inline]
 [<ffffffff82b5b966>] bond_do_ioctl+0x416/0x870 drivers/net/bonding/bond_main.c:3562
 [<ffffffff83ae25f4>] dev_ifsioc+0x6f4/0x940 net/core/dev_ioctl.c:328
 [<ffffffff83ae2e58>] dev_ioctl+0x1b8/0xc70 net/core/dev_ioctl.c:495
 [<ffffffff83995ffd>] sock_do_ioctl+0x1bd/0x300 net/socket.c:1088
 [<ffffffff83996a80>] sock_ioctl+0x300/0x5d0 net/socket.c:1196
 [<ffffffff81b124db>] vfs_ioctl fs/ioctl.c:47 [inline]
 [<ffffffff81b124db>] file_ioctl fs/ioctl.c:501 [inline]
 [<ffffffff81b124db>] do_vfs_ioctl+0xacb/0x1300 fs/ioctl.c:688
 [<ffffffff81b12dc6>] SYSC_ioctl fs/ioctl.c:705 [inline]
 [<ffffffff81b12dc6>] SyS_ioctl+0xb6/0xe0 fs/ioctl.c:696
 [<ffffffff8101ccc8>] do_syscall_64+0x528/0x770 arch/x86/entry/common.c:305
 [<ffffffff84400091>] entry_SYSCALL_64_after_hwframe+0x42/0xb7

Fixes: ee6377147409 ("bonding: Simplify the xmit function for modes that use xmit_hash")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Mahesh Bandewar <maheshb@google.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/bonding/bond_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4033,7 +4033,7 @@ out:
 		 * this to-be-skipped slave to send a packet out.
 		 */
 		old_arr = rtnl_dereference(bond->slave_arr);
-		for (idx = 0; idx < old_arr->count; idx++) {
+		for (idx = 0; old_arr != NULL && idx < old_arr->count; idx++) {
 			if (skipslave == old_arr->arr[idx]) {
 				old_arr->arr[idx] =
 				    old_arr->arr[old_arr->count-1];


