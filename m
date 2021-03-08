Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C90F8330E38
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbhCHMfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:35:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:45048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232229AbhCHMfq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:35:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BED8A65203;
        Mon,  8 Mar 2021 12:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206946;
        bh=CLI+iUaX3tjjRVmmq6EFBRlz5u5mN2rHWfngL0ydgKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y+LRWuwImtN3zG8g6/JcUbWo9/09rBl2gnIBVD58P3s9iBGDnpP2Kc3OtVoa4Z5RG
         WVJ6Jachb7Lt/9HwJn89g1Fyy/CMVqxwh6kpgPkPz7Qh6t9j+YwrpEICoBGMMNhBtK
         6V4jAVv6eT1FJg+TsA53jMV1rXTdCU0y/nD+lBZE=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.11 08/44] btrfs: avoid double put of block group when emptying cluster
Date:   Mon,  8 Mar 2021 13:34:46 +0100
Message-Id: <20210308122718.984889439@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.586629218@linuxfoundation.org>
References: <20210308122718.586629218@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
@@ -2708,8 +2708,10 @@ static void __btrfs_return_cluster_to_fr
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
@@ -2747,8 +2749,6 @@ static void __btrfs_return_cluster_to_fr
 				   entry->offset, &entry->offset_index, bitmap);
 	}
 	cluster->root = RB_ROOT;
-
-out:
 	spin_unlock(&cluster->lock);
 	btrfs_put_block_group(block_group);
 }


