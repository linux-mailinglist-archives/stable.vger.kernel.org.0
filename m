Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6329E116225
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 14:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbfLHN5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 08:57:52 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60076 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726667AbfLHNyl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 08:54:41 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1C-0007dy-DK; Sun, 08 Dec 2019 13:54:38 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1B-0002Mk-Ck; Sun, 08 Dec 2019 13:54:37 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David Sterba" <dsterba@suse.com>,
        "Johannes Thumshirn" <jthumshirn@suse.de>,
        "Nikolay Borisov" <nborisov@suse.com>
Date:   Sun, 08 Dec 2019 13:53:13 +0000
Message-ID: <lsq.1575813165.846189592@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 29/72] btrfs: Relinquish CPUs in btrfs_compare_trees
In-Reply-To: <lsq.1575813164.154362148@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.79-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Borisov <nborisov@suse.com>

commit 6af112b11a4bc1b560f60a618ac9c1dcefe9836e upstream.

When doing any form of incremental send the parent and the child trees
need to be compared via btrfs_compare_trees. This  can result in long
loop chains without ever relinquishing the CPU. This causes softlockup
detector to trigger when comparing trees with a lot of items. Example
report:

watchdog: BUG: soft lockup - CPU#0 stuck for 24s! [snapperd:16153]
CPU: 0 PID: 16153 Comm: snapperd Not tainted 5.2.9-1-default #1 openSUSE Tumbleweed (unreleased)
Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
pstate: 40000005 (nZcv daif -PAN -UAO)
pc : __ll_sc_arch_atomic_sub_return+0x14/0x20
lr : btrfs_release_extent_buffer_pages+0xe0/0x1e8 [btrfs]
sp : ffff00001273b7e0
Call trace:
 __ll_sc_arch_atomic_sub_return+0x14/0x20
 release_extent_buffer+0xdc/0x120 [btrfs]
 free_extent_buffer.part.0+0xb0/0x118 [btrfs]
 free_extent_buffer+0x24/0x30 [btrfs]
 btrfs_release_path+0x4c/0xa0 [btrfs]
 btrfs_free_path.part.0+0x20/0x40 [btrfs]
 btrfs_free_path+0x24/0x30 [btrfs]
 get_inode_info+0xa8/0xf8 [btrfs]
 finish_inode_if_needed+0xe0/0x6d8 [btrfs]
 changed_cb+0x9c/0x410 [btrfs]
 btrfs_compare_trees+0x284/0x648 [btrfs]
 send_subvol+0x33c/0x520 [btrfs]
 btrfs_ioctl_send+0x8a0/0xaf0 [btrfs]
 btrfs_ioctl+0x199c/0x2288 [btrfs]
 do_vfs_ioctl+0x4b0/0x820
 ksys_ioctl+0x84/0xb8
 __arm64_sys_ioctl+0x28/0x38
 el0_svc_common.constprop.0+0x7c/0x188
 el0_svc_handler+0x34/0x90
 el0_svc+0x8/0xc

Fix this by adding a call to cond_resched at the beginning of the main
loop in btrfs_compare_trees.

Fixes: 7069830a9e38 ("Btrfs: add btrfs_compare_trees function")
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[bwh: Backported to 3.16: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/ctree.c | 1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -5446,6 +5446,7 @@ int btrfs_compare_trees(struct btrfs_roo
 	advance_left = advance_right = 0;
 
 	while (1) {
+		cond_resched();
 		if (advance_left && !left_end_reached) {
 			ret = tree_advance(left_root, left_path, &left_level,
 					left_root_level,

