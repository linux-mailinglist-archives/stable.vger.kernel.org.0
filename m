Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAB434C9EA
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbhC2IeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:34:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234599AbhC2IdV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:33:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62435619B7;
        Mon, 29 Mar 2021 08:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006731;
        bh=4ZlL0hiTebv8fuSRjHJIYa0eZHyLJzoBSI9l82OeImo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1rwjzN029F8ObyPaGCNwXBbYTeNUFxvKxRLX2dCc8p8F3mHSvE4RBrGp1SKbplrNt
         jV/HKtU41trUbEu29JBVtP/meJZo7Zsii5nVYoAJUrZLRiqBADbfBuw541scBJu9Ch
         1PX7aXMS0VrNnoWkhfd2lMw5TA6zrGAe0t6byE5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stuart Shelton <srcshelton@gmail.com>,
        Qu Wenruo <wqu@suse.com>, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.11 071/254] btrfs: fix sleep while in non-sleep context during qgroup removal
Date:   Mon, 29 Mar 2021 09:56:27 +0200
Message-Id: <20210329075635.486737742@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 0bb788300990d3eb5582d3301a720f846c78925c upstream.

While removing a qgroup's sysfs entry we end up taking the kernfs_mutex,
through kobject_del(), while holding the fs_info->qgroup_lock spinlock,
producing the following trace:

  [821.843637] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:281
  [821.843641] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 28214, name: podman
  [821.843644] CPU: 3 PID: 28214 Comm: podman Tainted: G        W         5.11.6 #15
  [821.843646] Hardware name: Dell Inc. PowerEdge R330/084XW4, BIOS 2.11.0 12/08/2020
  [821.843647] Call Trace:
  [821.843650]  dump_stack+0xa1/0xfb
  [821.843656]  ___might_sleep+0x144/0x160
  [821.843659]  mutex_lock+0x17/0x40
  [821.843662]  kernfs_remove_by_name_ns+0x1f/0x80
  [821.843666]  sysfs_remove_group+0x7d/0xe0
  [821.843668]  sysfs_remove_groups+0x28/0x40
  [821.843670]  kobject_del+0x2a/0x80
  [821.843672]  btrfs_sysfs_del_one_qgroup+0x2b/0x40 [btrfs]
  [821.843685]  __del_qgroup_rb+0x12/0x150 [btrfs]
  [821.843696]  btrfs_remove_qgroup+0x288/0x2a0 [btrfs]
  [821.843707]  btrfs_ioctl+0x3129/0x36a0 [btrfs]
  [821.843717]  ? __mod_lruvec_page_state+0x5e/0xb0
  [821.843719]  ? page_add_new_anon_rmap+0xbc/0x150
  [821.843723]  ? kfree+0x1b4/0x300
  [821.843725]  ? mntput_no_expire+0x55/0x330
  [821.843728]  __x64_sys_ioctl+0x5a/0xa0
  [821.843731]  do_syscall_64+0x33/0x70
  [821.843733]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
  [821.843736] RIP: 0033:0x4cd3fb
  [821.843741] RSP: 002b:000000c000906b20 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
  [821.843744] RAX: ffffffffffffffda RBX: 000000c000050000 RCX: 00000000004cd3fb
  [821.843745] RDX: 000000c000906b98 RSI: 000000004010942a RDI: 000000000000000f
  [821.843747] RBP: 000000c000907cd0 R08: 000000c000622901 R09: 0000000000000000
  [821.843748] R10: 000000c000d992c0 R11: 0000000000000206 R12: 000000000000012d
  [821.843749] R13: 000000000000012c R14: 0000000000000200 R15: 0000000000000049

Fix this by removing the qgroup sysfs entry while not holding the spinlock,
since the spinlock is only meant for protection of the qgroup rbtree.

Reported-by: Stuart Shelton <srcshelton@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/7A5485BB-0628-419D-A4D3-27B1AF47E25A@gmail.com/
Fixes: 49e5fb46211de0 ("btrfs: qgroup: export qgroups in sysfs")
CC: stable@vger.kernel.org # 5.10+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/qgroup.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -226,7 +226,6 @@ static void __del_qgroup_rb(struct btrfs
 {
 	struct btrfs_qgroup_list *list;
 
-	btrfs_sysfs_del_one_qgroup(fs_info, qgroup);
 	list_del(&qgroup->dirty);
 	while (!list_empty(&qgroup->groups)) {
 		list = list_first_entry(&qgroup->groups,
@@ -243,7 +242,6 @@ static void __del_qgroup_rb(struct btrfs
 		list_del(&list->next_member);
 		kfree(list);
 	}
-	kfree(qgroup);
 }
 
 /* must be called with qgroup_lock held */
@@ -569,6 +567,8 @@ void btrfs_free_qgroup_config(struct btr
 		qgroup = rb_entry(n, struct btrfs_qgroup, node);
 		rb_erase(n, &fs_info->qgroup_tree);
 		__del_qgroup_rb(fs_info, qgroup);
+		btrfs_sysfs_del_one_qgroup(fs_info, qgroup);
+		kfree(qgroup);
 	}
 	/*
 	 * We call btrfs_free_qgroup_config() when unmounting
@@ -1578,6 +1578,14 @@ int btrfs_remove_qgroup(struct btrfs_tra
 	spin_lock(&fs_info->qgroup_lock);
 	del_qgroup_rb(fs_info, qgroupid);
 	spin_unlock(&fs_info->qgroup_lock);
+
+	/*
+	 * Remove the qgroup from sysfs now without holding the qgroup_lock
+	 * spinlock, since the sysfs_remove_group() function needs to take
+	 * the mutex kernfs_mutex through kernfs_remove_by_name_ns().
+	 */
+	btrfs_sysfs_del_one_qgroup(fs_info, qgroup);
+	kfree(qgroup);
 out:
 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 	return ret;


