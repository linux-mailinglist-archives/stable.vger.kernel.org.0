Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F5145BEB7
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344515AbhKXMuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:50:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:56074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244627AbhKXMsH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:48:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8707A61352;
        Wed, 24 Nov 2021 12:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756877;
        bh=sTK+5Vqde1OdfOU/XWFM6OGFf6/EGUAiKkUPGUNtyPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MH+6um3AVptL3981r0j8i9JrwhHZMP++LpsRbg9OAiMbN66dx2w/e9dwfHU6QWvNe
         8HjvHPFVju8RT0bfXZQoETA74dHV8X9HCXwAT0SyRDW3grm9lO6+7381CXtDV/R23f
         GSinPQ1zXmM9DaOS07gfp3ulCWmJAkee1czEFD00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Murphy <lists@colorremedies.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Chris Murphy <chris@colorremedies.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.14 237/251] btrfs: fix memory ordering between normal and ordered work functions
Date:   Wed, 24 Nov 2021 12:57:59 +0100
Message-Id: <20211124115718.565281346@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Borisov <nborisov@suse.com>

commit 45da9c1767ac31857df572f0a909fbe88fd5a7e9 upstream.

Ordered work functions aren't guaranteed to be handled by the same thread
which executed the normal work functions. The only way execution between
normal/ordered functions is synchronized is via the WORK_DONE_BIT,
unfortunately the used bitops don't guarantee any ordering whatsoever.

This manifested as seemingly inexplicable crashes on ARM64, where
async_chunk::inode is seen as non-null in async_cow_submit which causes
submit_compressed_extents to be called and crash occurs because
async_chunk::inode suddenly became NULL. The call trace was similar to:

    pc : submit_compressed_extents+0x38/0x3d0
    lr : async_cow_submit+0x50/0xd0
    sp : ffff800015d4bc20

    <registers omitted for brevity>

    Call trace:
     submit_compressed_extents+0x38/0x3d0
     async_cow_submit+0x50/0xd0
     run_ordered_work+0xc8/0x280
     btrfs_work_helper+0x98/0x250
     process_one_work+0x1f0/0x4ac
     worker_thread+0x188/0x504
     kthread+0x110/0x114
     ret_from_fork+0x10/0x18

Fix this by adding respective barrier calls which ensure that all
accesses preceding setting of WORK_DONE_BIT are strictly ordered before
setting the flag. At the same time add a read barrier after reading of
WORK_DONE_BIT in run_ordered_work which ensures all subsequent loads
would be strictly ordered after reading the bit. This in turn ensures
are all accesses before WORK_DONE_BIT are going to be strictly ordered
before any access that can occur in ordered_func.

Reported-by: Chris Murphy <lists@colorremedies.com>
Fixes: 08a9ff326418 ("btrfs: Added btrfs_workqueue_struct implemented ordered execution based on kernel workqueue")
CC: stable@vger.kernel.org # 4.4+
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2011928
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Tested-by: Chris Murphy <chris@colorremedies.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/async-thread.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -283,6 +283,13 @@ static void run_ordered_work(struct __bt
 				  ordered_list);
 		if (!test_bit(WORK_DONE_BIT, &work->flags))
 			break;
+		/*
+		 * Orders all subsequent loads after reading WORK_DONE_BIT,
+		 * paired with the smp_mb__before_atomic in btrfs_work_helper
+		 * this guarantees that the ordered function will see all
+		 * updates from ordinary work function.
+		 */
+		smp_rmb();
 
 		/*
 		 * we are going to call the ordered done function, but
@@ -368,6 +375,13 @@ static void normal_work_helper(struct bt
 	thresh_exec_hook(wq);
 	work->func(work);
 	if (need_order) {
+		/*
+		 * Ensures all memory accesses done in the work function are
+		 * ordered before setting the WORK_DONE_BIT. Ensuring the thread
+		 * which is going to executed the ordered work sees them.
+		 * Pairs with the smp_rmb in run_ordered_work.
+		 */
+		smp_mb__before_atomic();
 		set_bit(WORK_DONE_BIT, &work->flags);
 		run_ordered_work(wq, work);
 	}


