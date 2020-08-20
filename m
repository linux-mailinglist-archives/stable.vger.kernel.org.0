Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE4E324BC64
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbgHTMpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:45:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728847AbgHTJpl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:45:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 248DF22CAF;
        Thu, 20 Aug 2020 09:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916726;
        bh=L5/aIVK9OucMl9O80aIiHExcX4Jerz8nTzXEwXa3isY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=insirguK5CGs4V15m5K3DM99F9wUOgwPG6oE9qz6NJ/0Tej1vutaLL2Fi6yjADwrh
         isjmVy0CNCzFp8GYhuY4GvLwWNHmYYizbD7NpjVemHRQSrmRIm302OubeM4K4hMNjC
         ag/w1rynotnUwAWp8jwMSW9mhUmio1kB72s0Qb1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 025/152] btrfs: only search for left_info if there is no right_info in try_merge_free_space
Date:   Thu, 20 Aug 2020 11:19:52 +0200
Message-Id: <20200820091554.934269841@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit bf53d4687b8f3f6b752f091eb85f62369a515dfd upstream.

In try_to_merge_free_space we attempt to find entries to the left and
right of the entry we are adding to see if they can be merged.  We
search for an entry past our current info (saved into right_info), and
then if right_info exists and it has a rb_prev() we save the rb_prev()
into left_info.

However there's a slight problem in the case that we have a right_info,
but no entry previous to that entry.  At that point we will search for
an entry just before the info we're attempting to insert.  This will
simply find right_info again, and assign it to left_info, making them
both the same pointer.

Now if right_info _can_ be merged with the range we're inserting, we'll
add it to the info and free right_info.  However further down we'll
access left_info, which was right_info, and thus get a use-after-free.

Fix this by only searching for the left entry if we don't find a right
entry at all.

The CVE referenced had a specially crafted file system that could
trigger this use-after-free. However with the tree checker improvements
we no longer trigger the conditions for the UAF.  But the original
conditions still apply, hence this fix.

Reference: CVE-2019-19448
Fixes: 963030817060 ("Btrfs: use hybrid extents+bitmap rb tree for free space")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/free-space-cache.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2166,7 +2166,7 @@ out:
 static bool try_merge_free_space(struct btrfs_free_space_ctl *ctl,
 			  struct btrfs_free_space *info, bool update_stat)
 {
-	struct btrfs_free_space *left_info;
+	struct btrfs_free_space *left_info = NULL;
 	struct btrfs_free_space *right_info;
 	bool merged = false;
 	u64 offset = info->offset;
@@ -2181,7 +2181,7 @@ static bool try_merge_free_space(struct
 	if (right_info && rb_prev(&right_info->offset_index))
 		left_info = rb_entry(rb_prev(&right_info->offset_index),
 				     struct btrfs_free_space, offset_index);
-	else
+	else if (!right_info)
 		left_info = tree_search_offset(ctl, offset - 1, 0, 0);
 
 	if (right_info && !right_info->bitmap) {


