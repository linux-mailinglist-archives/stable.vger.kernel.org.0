Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946EC330DD6
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhCHMdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:33:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:42350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229965AbhCHMdX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:33:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21521651C9;
        Mon,  8 Mar 2021 12:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206802;
        bh=heEBG8itY4ZSEXCC+u/JqWQ5Vqd79AS4CIm2jrp1OXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y91ypQcZzJ5nmfM8DHTOFLraxCdcPfnlKoLSFXmoePxkzSn3NNcb+n5DLiciq1Kgk
         pbqg2yOnBgslq4Tm65N+cqKDWpOjh69ZfDwU6jC+aiZpbAG2+BuODkGSdSn1mnv/c3
         +SAECaXm8wKZGSdi0RbeWIvzvIigPRnaooqZHZcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 11/42] btrfs: fix race between extent freeing/allocation when using bitmaps
Date:   Mon,  8 Mar 2021 13:30:37 +0100
Message-Id: <20210308122718.681086694@linuxfoundation.org>
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

From: Nikolay Borisov <nborisov@suse.com>

commit 3c17916510428dbccdf657de050c34e208347089 upstream.

During allocation the allocator will try to allocate an extent using
cluster policy. Once the current cluster is exhausted it will remove the
entry under btrfs_free_cluster::lock and subsequently acquire
btrfs_free_space_ctl::tree_lock to dispose of the already-deleted entry
and adjust btrfs_free_space_ctl::total_bitmap. This poses a problem
because there exists a race condition between removing the entry under
one lock and doing the necessary accounting holding a different lock
since extent freeing only uses the 2nd lock. This can result in the
following situation:

T1:                                    T2:
btrfs_alloc_from_cluster               insert_into_bitmap <holds tree_lock>
 if (entry->bytes == 0)                   if (block_group && !list_empty(&block_group->cluster_list)) {
    rb_erase(entry)

 spin_unlock(&cluster->lock);
   (total_bitmaps is still 4)           spin_lock(&cluster->lock);
                                         <doesn't find entry in cluster->root>
 spin_lock(&ctl->tree_lock);             <goes to new_bitmap label, adds
<blocked since T2 holds tree_lock>       <a new entry and calls add_new_bitmap>
					    recalculate_thresholds  <crashes,
                                              due to total_bitmaps
					      becoming 5 and triggering
					      an ASSERT>

To fix this ensure that once depleted, the cluster entry is deleted when
both cluster lock and tree locks are held in the allocator (T1), this
ensures that even if there is a race with a concurrent
insert_into_bitmap call it will correctly find the entry in the cluster
and add the new space to it.

CC: <stable@vger.kernel.org> # 4.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/free-space-cache.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -3034,8 +3034,6 @@ u64 btrfs_alloc_from_cluster(struct btrf
 			entry->bytes -= bytes;
 		}
 
-		if (entry->bytes == 0)
-			rb_erase(&entry->offset_index, &cluster->root);
 		break;
 	}
 out:
@@ -3052,7 +3050,10 @@ out:
 	ctl->free_space -= bytes;
 	if (!entry->bitmap && !btrfs_free_space_trimmed(entry))
 		ctl->discardable_bytes[BTRFS_STAT_CURR] -= bytes;
+
+	spin_lock(&cluster->lock);
 	if (entry->bytes == 0) {
+		rb_erase(&entry->offset_index, &cluster->root);
 		ctl->free_extents--;
 		if (entry->bitmap) {
 			kmem_cache_free(btrfs_free_space_bitmap_cachep,
@@ -3065,6 +3066,7 @@ out:
 		kmem_cache_free(btrfs_free_space_cachep, entry);
 	}
 
+	spin_unlock(&cluster->lock);
 	spin_unlock(&ctl->tree_lock);
 
 	return ret;


