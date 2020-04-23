Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C64B1B6910
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729319AbgDWXUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:20:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48652 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728226AbgDWXGe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:34 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvM-0004c4-1k; Fri, 24 Apr 2020 00:06:28 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvK-00E6jG-EQ; Fri, 24 Apr 2020 00:06:26 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Joe Thornber" <ejt@redhat.com>,
        "Mike Snitzer" <snitzer@redhat.com>, "Hou Tao" <houtao1@huawei.com>
Date:   Fri, 24 Apr 2020 00:04:51 +0100
Message-ID: <lsq.1587683028.323647383@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 064/245] dm btree: increase rebalance threshold in
 __rebalance2()
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Tao <houtao1@huawei.com>

commit 474e559567fa631dea8fb8407ab1b6090c903755 upstream.

We got the following warnings from thin_check during thin-pool setup:

  $ thin_check /dev/vdb
  examining superblock
  examining devices tree
    missing devices: [1, 84]
      too few entries in btree_node: 41, expected at least 42 (block 138, max_entries = 126)
  examining mapping tree

The phenomenon is the number of entries in one node of details_info tree is
less than (max_entries / 3). And it can be easily reproduced by the following
procedures:

  $ new a thin pool
  $ presume the max entries of details_info tree is 126
  $ new 127 thin devices (e.g. 1~127) to make the root node being full
    and then split
  $ remove the first 43 (e.g. 1~43) thin devices to make the children
    reblance repeatedly
  $ stop the thin pool
  $ thin_check

The root cause is that the B-tree removal procedure in __rebalance2()
doesn't guarantee the invariance: the minimal number of entries in
non-root node should be >= (max_entries / 3).

Simply fix the problem by increasing the rebalance threshold to
make sure the number of entries in each child will be greater
than or equal to (max_entries / 3 + 1), so no matter which
child is used for removal, the number will still be valid.

Signed-off-by: Hou Tao <houtao1@huawei.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/persistent-data/dm-btree-remove.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/md/persistent-data/dm-btree-remove.c
+++ b/drivers/md/persistent-data/dm-btree-remove.c
@@ -203,7 +203,13 @@ static void __rebalance2(struct dm_btree
 	struct btree_node *right = r->n;
 	uint32_t nr_left = le32_to_cpu(left->header.nr_entries);
 	uint32_t nr_right = le32_to_cpu(right->header.nr_entries);
-	unsigned threshold = 2 * merge_threshold(left) + 1;
+	/*
+	 * Ensure the number of entries in each child will be greater
+	 * than or equal to (max_entries / 3 + 1), so no matter which
+	 * child is used for removal, the number will still be not
+	 * less than (max_entries / 3).
+	 */
+	unsigned int threshold = 2 * (merge_threshold(left) + 1);
 
 	if (nr_left + nr_right < threshold) {
 		/*

