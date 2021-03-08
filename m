Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D12330DE6
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbhCHMeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:34:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:42604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231195AbhCHMdn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:33:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9691064EBC;
        Mon,  8 Mar 2021 12:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206823;
        bh=McBes+rk6Ag/RBx+10Y6ij8K1VSk8jk+U/BI5de1v50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v1TwlBG4mzrP/0sNti+6tL0h3bB5s0nzGCcuw2MzYHn6jXtfa3bmQ3wtFvf4mZKiv
         fHDbxLE7odrAAG3NAwuUL2uLg3+OYHryYoisyjbAE9PFc3L4kjeDB7tij1dlJ4+hTo
         guNybJQ/1rzFiBTcv5p0WxuyQkhO8Uxf+NdK5TiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 06/42] btrfs: avoid double put of block group when emptying cluster
Date:   Mon,  8 Mar 2021 13:30:32 +0100
Message-Id: <20210308122718.442849402@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.120213856@linuxfoundation.org>
References: <20210308122718.120213856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 95c85fba1f64c3249c67f0078a29f8a125078189 upstream.

It's wrong calling btrfs_put_block_group in
__btrfs_return_cluster_to_free_space if the block group passed is
different than the block group the cluster represents. As this means the
cluster doesn't have a reference to the passed block group. This results
in double put and a use-after-free bug.

Fix this by simply bailing if the block group we passed in does not
match the block group on the cluster.

Fixes: fa9c0d795f7b ("Btrfs: rework allocation clustering")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ update changelog ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/free-space-cache.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2714,8 +2714,10 @@ static void __btrfs_return_cluster_to_fr
 	struct rb_node *node;
 
 	spin_lock(&cluster->lock);
-	if (cluster->block_group != block_group)
-		goto out;
+	if (cluster->block_group != block_group) {
+		spin_unlock(&cluster->lock);
+		return;
+	}
 
 	cluster->block_group = NULL;
 	cluster->window_start = 0;
@@ -2753,8 +2755,6 @@ static void __btrfs_return_cluster_to_fr
 				   entry->offset, &entry->offset_index, bitmap);
 	}
 	cluster->root = RB_ROOT;
-
-out:
 	spin_unlock(&cluster->lock);
 	btrfs_put_block_group(block_group);
 }


