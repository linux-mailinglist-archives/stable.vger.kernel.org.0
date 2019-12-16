Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E58D1121608
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731632AbfLPSRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:17:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:40602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731630AbfLPSRI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:17:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BD602082E;
        Mon, 16 Dec 2019 18:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520227;
        bh=KQ68/+ysZd4CeG7YbMrfGDwM3dUSViBLfLgBfwl3HN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B40BB2Oswxg7tmzW9Wh5YCU4KGMq+iYqq05uhBvxoXGsbf0hcwin1YKbkAYJZEcVB
         emuTFZ7zhDbYjfMZGH3xLpjnih5K0rd5q/nnj/QXeLOhyfuhgb2BbZZwlQ3jTeek8o
         L3o7Twwp4tSKZL4n2mrPRBzPc6bDqXjAsDTB8PgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 068/177] btrfs: use refcount_inc_not_zero in kill_all_nodes
Date:   Mon, 16 Dec 2019 18:48:44 +0100
Message-Id: <20191216174834.568557217@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit baf320b9d531f1cfbf64c60dd155ff80a58b3796 upstream.

We hit the following warning while running down a different problem

[ 6197.175850] ------------[ cut here ]------------
[ 6197.185082] refcount_t: underflow; use-after-free.
[ 6197.194704] WARNING: CPU: 47 PID: 966 at lib/refcount.c:190 refcount_sub_and_test_checked+0x53/0x60
[ 6197.521792] Call Trace:
[ 6197.526687]  __btrfs_release_delayed_node+0x76/0x1c0
[ 6197.536615]  btrfs_kill_all_delayed_nodes+0xec/0x130
[ 6197.546532]  ? __btrfs_btree_balance_dirty+0x60/0x60
[ 6197.556482]  btrfs_clean_one_deleted_snapshot+0x71/0xd0
[ 6197.566910]  cleaner_kthread+0xfa/0x120
[ 6197.574573]  kthread+0x111/0x130
[ 6197.581022]  ? kthread_create_on_node+0x60/0x60
[ 6197.590086]  ret_from_fork+0x1f/0x30
[ 6197.597228] ---[ end trace 424bb7ae00509f56 ]---

This is because the free side drops the ref without the lock, and then
takes the lock if our refcount is 0.  So you can have nodes on the tree
that have a refcount of 0.  Fix this by zero'ing out that element in our
temporary array so we don't try to kill it again.

CC: stable@vger.kernel.org # 4.14+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ add comment ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/delayed-inode.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1949,12 +1949,19 @@ void btrfs_kill_all_delayed_nodes(struct
 		}
 
 		inode_id = delayed_nodes[n - 1]->inode_id + 1;
-
-		for (i = 0; i < n; i++)
-			refcount_inc(&delayed_nodes[i]->refs);
+		for (i = 0; i < n; i++) {
+			/*
+			 * Don't increase refs in case the node is dead and
+			 * about to be removed from the tree in the loop below
+			 */
+			if (!refcount_inc_not_zero(&delayed_nodes[i]->refs))
+				delayed_nodes[i] = NULL;
+		}
 		spin_unlock(&root->inode_lock);
 
 		for (i = 0; i < n; i++) {
+			if (!delayed_nodes[i])
+				continue;
 			__btrfs_kill_delayed_node(delayed_nodes[i]);
 			btrfs_release_delayed_node(delayed_nodes[i]);
 		}


