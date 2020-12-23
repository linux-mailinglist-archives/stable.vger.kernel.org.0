Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEAE2E1DF8
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 16:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgLWPdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 10:33:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:43850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbgLWPdX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 10:33:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 669D323341;
        Wed, 23 Dec 2020 15:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608737562;
        bh=kQyEGOfHq1dy9PlOkGpBQWr4nr1nvX/atM2YHNOdTcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kidNEHh6Iyk2a/+hGOPMUXH2qBrQKLB99nDneY0TlZUvnoCCGE/AvvM2AgyDfMRm+
         NmfeDfa82CYtQIbjVjsbw6o6JAQ2cMSdo4B1vZSPz7tnvwLHXvwsHxnYznc3DvEGwW
         6k5tt171FiZ5QxaMOusRO7AFQLYjVjavevydZsSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Artem Labazov <123321artyom@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 5.10 03/40] exfat: Avoid allocating upcase table using kcalloc()
Date:   Wed, 23 Dec 2020 16:33:04 +0100
Message-Id: <20201223150515.734584720@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223150515.553836647@linuxfoundation.org>
References: <20201223150515.553836647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Artem Labazov <123321artyom@gmail.com>

commit 9eb78c25327548b905598975aa3ded4ef244b94a upstream.

The table for Unicode upcase conversion requires an order-5 allocation,
which may fail on a highly-fragmented system:

 pool-udisksd: page allocation failure: order:5,
 mode:0x40dc0(GFP_KERNEL|__GFP_COMP|__GFP_ZERO), nodemask=(null),
 cpuset=/,mems_allowed=0
 CPU: 4 PID: 3756880 Comm: pool-udisksd Tainted: G U
 5.8.10-200.fc32.x86_64 #1
 Hardware name: Dell Inc. XPS 13 9360/0PVG6D, BIOS 2.13.0 11/14/2019
 Call Trace:
  dump_stack+0x6b/0x88
  warn_alloc.cold+0x75/0xd9
  ? _cond_resched+0x16/0x40
  ? __alloc_pages_direct_compact+0x144/0x150
  __alloc_pages_slowpath.constprop.0+0xcfa/0xd30
  ? __schedule+0x28a/0x840
  ? __wait_on_bit_lock+0x92/0xa0
  __alloc_pages_nodemask+0x2df/0x320
  kmalloc_order+0x1b/0x80
  kmalloc_order_trace+0x1d/0xa0
  exfat_create_upcase_table+0x115/0x390 [exfat]
  exfat_fill_super+0x3ef/0x7f0 [exfat]
  ? sget_fc+0x1d0/0x240
  ? exfat_init_fs_context+0x120/0x120 [exfat]
  get_tree_bdev+0x15c/0x250
  vfs_get_tree+0x25/0xb0
  do_mount+0x7c3/0xaf0
  ? copy_mount_options+0xab/0x180
  __x64_sys_mount+0x8e/0xd0
  do_syscall_64+0x4d/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Make the driver use kvcalloc() to eliminate the issue.

Fixes: 370e812b3ec1 ("exfat: add nls operations")
Cc: stable@vger.kernel.org #v5.7+
Signed-off-by: Artem Labazov <123321artyom@gmail.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/exfat/nls.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/exfat/nls.c
+++ b/fs/exfat/nls.c
@@ -659,7 +659,7 @@ static int exfat_load_upcase_table(struc
 	unsigned char skip = false;
 	unsigned short *upcase_table;
 
-	upcase_table = kcalloc(UTBL_COUNT, sizeof(unsigned short), GFP_KERNEL);
+	upcase_table = kvcalloc(UTBL_COUNT, sizeof(unsigned short), GFP_KERNEL);
 	if (!upcase_table)
 		return -ENOMEM;
 
@@ -715,7 +715,7 @@ static int exfat_load_default_upcase_tab
 	unsigned short uni = 0, *upcase_table;
 	unsigned int index = 0;
 
-	upcase_table = kcalloc(UTBL_COUNT, sizeof(unsigned short), GFP_KERNEL);
+	upcase_table = kvcalloc(UTBL_COUNT, sizeof(unsigned short), GFP_KERNEL);
 	if (!upcase_table)
 		return -ENOMEM;
 
@@ -803,5 +803,5 @@ load_default:
 
 void exfat_free_upcase_table(struct exfat_sb_info *sbi)
 {
-	kfree(sbi->vol_utbl);
+	kvfree(sbi->vol_utbl);
 }


