Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A73E2126B45
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbfLSSzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:55:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:51256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730655AbfLSSzT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:55:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 498DD206EC;
        Thu, 19 Dec 2019 18:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781718;
        bh=ZDWjkucWnuNDUFia2/GxQNQEtlT4iZWmBPaU8zSh7vg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hg1aRa7I6YhjV0MTHG7gzMNeP3inDofHYyCWvVbKiJKTTpazH/bJ5QCzo1PbVwOZd
         590zdgEDghzXWG1LDoWqPX/Ydf6OuEUalSdNNRCdxkdYs6lpTb16qoiPuUGIooRRUW
         BhcIsHwOAMKYNmaL4uVrI6+EZ/25ZPRYtAj0eqpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.4 52/80] dm btree: increase rebalance threshold in __rebalance2()
Date:   Thu, 19 Dec 2019 19:34:44 +0100
Message-Id: <20191219183122.909187724@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: stable@vger.kernel.org
Signed-off-by: Hou Tao <houtao1@huawei.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/persistent-data/dm-btree-remove.c |    8 +++++++-
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


