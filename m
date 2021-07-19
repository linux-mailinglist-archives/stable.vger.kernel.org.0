Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC773CDBD6
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238815AbhGSOuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:50:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344380AbhGSOsr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:48:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D8096141C;
        Mon, 19 Jul 2021 15:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708520;
        bh=NpbK2gd7O74c8e51R28pZrumdvAjjr2RCxASaj3J8QM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VqZMoN7+T1R7fq1Rvp3myEbfAINlgqcBbfHL+e+sdQl4408K73kcpZ0UYCY8hKkMd
         i9S0iZ3v4ckhV519j15LTDCavzlotDbWCF7iomoT+x+PX+OjN3TN1RHEJsXxmW+v1l
         fs0WN9tLMP7kJ2klcBW9WM0rXugHy0Mss9dKL4Cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Pan Dong <pandong.peter@bytedance.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.19 024/421] ext4: fix avefreec in find_group_orlov
Date:   Mon, 19 Jul 2021 16:47:15 +0200
Message-Id: <20210719144947.098226478@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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
@@ -399,7 +399,7 @@ static void get_orlov_stats(struct super
  *
  * We always try to spread first-level directories.
  *
- * If there are blockgroups with both free inodes and free blocks counts
+ * If there are blockgroups with both free inodes and free clusters counts
  * not worse than average we return one with smallest directory count.
  * Otherwise we simply return a random group.
  *
@@ -408,7 +408,7 @@ static void get_orlov_stats(struct super
  * It's OK to put directory into a group unless
  * it has too many directories already (max_dirs) or
  * it has too few free inodes left (min_inodes) or
- * it has too few free blocks left (min_blocks) or
+ * it has too few free clusters left (min_clusters) or
  * Parent's group is preferred, if it doesn't satisfy these
  * conditions we search cyclically through the rest. If none
  * of the groups look good we just look for a group with more
@@ -424,7 +424,7 @@ static int find_group_orlov(struct super
 	ext4_group_t real_ngroups = ext4_get_groups_count(sb);
 	int inodes_per_group = EXT4_INODES_PER_GROUP(sb);
 	unsigned int freei, avefreei, grp_free;
-	ext4_fsblk_t freeb, avefreec;
+	ext4_fsblk_t freec, avefreec;
 	unsigned int ndirs;
 	int max_dirs, min_inodes;
 	ext4_grpblk_t min_clusters;
@@ -443,9 +443,8 @@ static int find_group_orlov(struct super
 
 	freei = percpu_counter_read_positive(&sbi->s_freeinodes_counter);
 	avefreei = freei / ngroups;
-	freeb = EXT4_C2B(sbi,
-		percpu_counter_read_positive(&sbi->s_freeclusters_counter));
-	avefreec = freeb;
+	freec = percpu_counter_read_positive(&sbi->s_freeclusters_counter);
+	avefreec = freec;
 	do_div(avefreec, ngroups);
 	ndirs = percpu_counter_read_positive(&sbi->s_dirs_counter);
 


