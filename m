Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F013CD8E6
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243753AbhGSOZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:25:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243871AbhGSOYd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:24:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C43B661287;
        Mon, 19 Jul 2021 15:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707058;
        bh=2cj57QhkvUfRxKbwrHmZUz2KpRz8mxUdCYhyEkAQwMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QX3uaSYboy4VwQ0Kv+Gc1PzMaPTKp60pK9IPL4gxSReoftX2IWeEEvrHdH2iyH89u
         WIuhOOINRBk+BIOYJ24CYUfdtTIKauM8g/gOEVg5mzGLkWDZX7tt3DEkuvp8dQl2Kw
         YaMAYRrD7Z/1JR3YVqx08ttjHSsyLBM+eX08gloI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Pan Dong <pandong.peter@bytedance.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.9 015/245] ext4: fix avefreec in find_group_orlov
Date:   Mon, 19 Jul 2021 16:49:17 +0200
Message-Id: <20210719144940.881726332@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Dong <pandong.peter@bytedance.com>

commit c89849cc0259f3d33624cc3bd127685c3c0fa25d upstream.

The avefreec should be average free clusters instead
of average free blocks, otherwize Orlov's allocator
will not work properly when bigalloc enabled.

Cc: stable@kernel.org
Signed-off-by: Pan Dong <pandong.peter@bytedance.com>
Link: https://lore.kernel.org/r/20210525073656.31594-1-pandong.peter@bytedance.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ialloc.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -405,7 +405,7 @@ static void get_orlov_stats(struct super
  *
  * We always try to spread first-level directories.
  *
- * If there are blockgroups with both free inodes and free blocks counts
+ * If there are blockgroups with both free inodes and free clusters counts
  * not worse than average we return one with smallest directory count.
  * Otherwise we simply return a random group.
  *
@@ -414,7 +414,7 @@ static void get_orlov_stats(struct super
  * It's OK to put directory into a group unless
  * it has too many directories already (max_dirs) or
  * it has too few free inodes left (min_inodes) or
- * it has too few free blocks left (min_blocks) or
+ * it has too few free clusters left (min_clusters) or
  * Parent's group is preferred, if it doesn't satisfy these
  * conditions we search cyclically through the rest. If none
  * of the groups look good we just look for a group with more
@@ -430,7 +430,7 @@ static int find_group_orlov(struct super
 	ext4_group_t real_ngroups = ext4_get_groups_count(sb);
 	int inodes_per_group = EXT4_INODES_PER_GROUP(sb);
 	unsigned int freei, avefreei, grp_free;
-	ext4_fsblk_t freeb, avefreec;
+	ext4_fsblk_t freec, avefreec;
 	unsigned int ndirs;
 	int max_dirs, min_inodes;
 	ext4_grpblk_t min_clusters;
@@ -449,9 +449,8 @@ static int find_group_orlov(struct super
 
 	freei = percpu_counter_read_positive(&sbi->s_freeinodes_counter);
 	avefreei = freei / ngroups;
-	freeb = EXT4_C2B(sbi,
-		percpu_counter_read_positive(&sbi->s_freeclusters_counter));
-	avefreec = freeb;
+	freec = percpu_counter_read_positive(&sbi->s_freeclusters_counter);
+	avefreec = freec;
 	do_div(avefreec, ngroups);
 	ndirs = percpu_counter_read_positive(&sbi->s_dirs_counter);
 


