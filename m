Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B813924BE00
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgHTNRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:17:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728468AbgHTJfL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:35:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE43421775;
        Thu, 20 Aug 2020 09:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916110;
        bh=hXW5C5tg9bIADkGE/iPp51ZKHJBMTdAvYzZ8FvK89oc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GAnxio2RzbgvwL/CzWeq7cnayDrV5yFLOBiYbry7JP5lOdZedDWvz95aI4hg++5VA
         7i0Q5VxM72/aeiwntp88P2p5LvuKH7Mx8EYZhs0GFIi6Ov9FnHmiMMZTPcr/s8bYP/
         s17v9YBIBhXtnj9oXDabwSOqQnwWx95IcwvUvyho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.7 015/204] btrfs: stop incremening log_batch for the log root tree when syncing log
Date:   Thu, 20 Aug 2020 11:18:32 +0200
Message-Id: <20200820091606.978695084@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 28a9579561bcb9082715e720eac93012e708ab94 upstream.

We are incrementing the log_batch atomic counter of the root log tree but
we never use that counter, it's used only for the log trees of subvolume
roots. We started doing it when we moved the log_batch and log_write
counters from the global, per fs, btrfs_fs_info structure, into the
btrfs_root structure in commit 7237f1833601dc ("Btrfs: fix tree logs
parallel sync").

So just stop doing it for the log root tree and add a comment over the
field declaration so inform it's used only for log trees of subvolume
roots.

This patch is part of a series that has the following patches:

1/4 btrfs: only commit the delayed inode when doing a full fsync
2/4 btrfs: only commit delayed items at fsync if we are logging a directory
3/4 btrfs: stop incremening log_batch for the log root tree when syncing log
4/4 btrfs: remove no longer needed use of log_writers for the log root tree

After the entire patchset applied I saw about 12% decrease on max latency
reported by dbench. The test was done on a qemu vm, with 8 cores, 16Gb of
ram, using kvm and using a raw NVMe device directly (no intermediary fs on
the host). The test was invoked like the following:

  mkfs.btrfs -f /dev/sdk
  mount -o ssd -o nospace_cache /dev/sdk /mnt/sdk
  dbench -D /mnt/sdk -t 300 8
  umount /mnt/dsk

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ctree.h    |    1 +
 fs/btrfs/tree-log.c |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1040,6 +1040,7 @@ struct btrfs_root {
 	struct list_head log_ctxs[2];
 	atomic_t log_writers;
 	atomic_t log_commit[2];
+	/* Used only for log trees of subvolumes, not for the log root tree */
 	atomic_t log_batch;
 	int log_transid;
 	/* No matter the commit succeeds or not*/
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3125,7 +3125,6 @@ int btrfs_sync_log(struct btrfs_trans_ha
 	btrfs_init_log_ctx(&root_log_ctx, NULL);
 
 	mutex_lock(&log_root_tree->log_mutex);
-	atomic_inc(&log_root_tree->log_batch);
 	atomic_inc(&log_root_tree->log_writers);
 
 	index2 = log_root_tree->log_transid % 2;


