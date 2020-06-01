Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D64F1E9C01
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 05:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgFADWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 May 2020 23:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbgFADWJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 May 2020 23:22:09 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53387C061A0E
        for <stable@vger.kernel.org>; Sun, 31 May 2020 20:22:08 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id u186so2593169ybf.1
        for <stable@vger.kernel.org>; Sun, 31 May 2020 20:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=cAL9AzTlR3/rckuz0QiBMeDp6G7+Z3C8GGU0gCN+rUE=;
        b=O2UdUjD8EOczgn/SjK0fKFL0Zv4xhbEPuhxmDtj5bVx0uGLy+65C/pgAov0drvlu5M
         fdLUJ/cY4PDDSlFxpcj4jNB3caWX6tsvWf6ngrtryjT9djpEPqg+03CSUjtgoEO0EN/T
         NqGNPho1JQhBF4XnSu8EP9J3RQyUAq9KXt5g2A58syxbm05Ic99xDyeHy0TdH3uQIWqO
         rCA8ga3goyC1hhi5tJkkkTLdlamubwNf+kBTaNZD0XWCYwLIjGRu4BxaY70vwQs9+Tk8
         0WQnOERJvOdvExMPdmRHUF409YX3M5mCiIR27/VEip1u3T74GRPX7zWl1jCUCsco2iTt
         n70Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=cAL9AzTlR3/rckuz0QiBMeDp6G7+Z3C8GGU0gCN+rUE=;
        b=HTe2kvDURAjSdcLN1Bx3L33U8KHOGKY6X7e7XIeb5iCwyI3Wh2/v8EdMxru1UixVT+
         pTeth4NqjhS3XlMSFpE7i54Ci48yUCn3RXqRUN0UdVLIWswhMPKQP3IOfyLsWpkNXG//
         AaY/BYfjvHctVMXgp5KFF5EN/soib+T74v/wDgq0UJeqKuhsbJU76WhQ65s+eqgpavgu
         L9Qsrat2ExtW7ib4HS9fSVe71JRIR5847z8Ve9pSC9JyKEOA/2OXYqGT9KgIbX3cpAie
         Nv334AkjpAKxpBMQNCronS9n8P7W/TcQrmKcJcGfo/eiMRMAOWZdYCwIr9UAEIymUhwq
         5BPw==
X-Gm-Message-State: AOAM5314lcBreI62DKTZ1HGfHQpmsZKoJ6VuyfYdSPTHY6QQcugWC+f7
        2LQFhCcU31M3uRXkZzGal5JBBZFmykdg
X-Google-Smtp-Source: ABdhPJyiQN0OxMj6OkJD/8I4N+N1aiQSXh9A8vYaaHWG0D4IYmq0xioXXLwVDT7cexpNePzq0XmE9Oq4X5qi
X-Received: by 2002:a25:3203:: with SMTP id y3mr20025143yby.77.1590981727300;
 Sun, 31 May 2020 20:22:07 -0700 (PDT)
Date:   Sun, 31 May 2020 20:22:04 -0700
Message-Id: <20200601032204.124624-1-gthelen@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH] shmem, memcg: enable memcg aware shrinker
From:   Greg Thelen <gthelen@google.com>
To:     Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Greg Thelen <gthelen@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since v4.19 commit b0dedc49a2da ("mm/vmscan.c: iterate only over charged
shrinkers during memcg shrink_slab()") a memcg aware shrinker is only
called when the per-memcg per-node shrinker_map indicates that the
shrinker may have objects to release to the memcg and node.

shmem_unused_huge_count and shmem_unused_huge_scan support the per-tmpfs
shrinker which advertises per memcg and numa awareness.  The shmem
shrinker releases memory by splitting hugepages that extend beyond
i_size.

Shmem does not currently set bits in shrinker_map.  So, starting with
b0dedc49a2da, memcg reclaim avoids calling the shmem shrinker under
pressure.  This leads to undeserved memcg OOM kills.
Example that reliably sees memcg OOM kill in unpatched kernel:
  FS=/tmp/fs
  CONTAINER=/cgroup/memory/tmpfs_shrinker
  mkdir -p $FS
  mount -t tmpfs -o huge=always nodev $FS
  # Create 1000 MB container, which shouldn't suffer OOM.
  mkdir $CONTAINER
  echo 1000M > $CONTAINER/memory.limit_in_bytes
  echo $BASHPID >> $CONTAINER/cgroup.procs
  # Create 4000 files.  Ideally each file uses 4k data page + a little
  # metadata.  Assume 8k total per-file, 32MB (4000*8k) should easily
  # fit within container's 1000 MB.  But if data pages use 2MB
  # hugepages (due to aggressive huge=always) then files consume 8GB,
  # which hits memcg 1000 MB limit.
  for i in {1..4000}; do
    echo . > $FS/$i
  done

v5.4 commit 87eaceb3faa5 ("mm: thp: make deferred split shrinker memcg
aware") maintains the per-node per-memcg shrinker bitmap for THP
shrinker.  But there's no such logic in shmem.  Make shmem set the
per-memcg per-node shrinker bits when it modifies inodes to have
shrinkable pages.

Fixes: b0dedc49a2da ("mm/vmscan.c: iterate only over charged shrinkers during memcg shrink_slab()")
Cc: <stable@vger.kernel.org> # 4.19+
Signed-off-by: Greg Thelen <gthelen@google.com>
---
 mm/shmem.c | 61 +++++++++++++++++++++++++++++++-----------------------
 1 file changed, 35 insertions(+), 26 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index bd8840082c94..e11090f78cb5 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1002,6 +1002,33 @@ static int shmem_getattr(const struct path *path, struct kstat *stat,
 	return 0;
 }
 
+/*
+ * Expose inode and optional page to shrinker as having a possibly splittable
+ * hugepage that reaches beyond i_size.
+ */
+static void shmem_shrinker_add(struct shmem_sb_info *sbinfo,
+			       struct inode *inode, struct page *page)
+{
+	struct shmem_inode_info *info = SHMEM_I(inode);
+
+	spin_lock(&sbinfo->shrinklist_lock);
+	/*
+	 * _careful to defend against unlocked access to ->shrink_list in
+	 * shmem_unused_huge_shrink()
+	 */
+	if (list_empty_careful(&info->shrinklist)) {
+		list_add_tail(&info->shrinklist, &sbinfo->shrinklist);
+		sbinfo->shrinklist_len++;
+	}
+	spin_unlock(&sbinfo->shrinklist_lock);
+
+#ifdef CONFIG_MEMCG
+	if (page && PageTransHuge(page))
+		memcg_set_shrinker_bit(page->mem_cgroup, page_to_nid(page),
+				       inode->i_sb->s_shrink.id);
+#endif
+}
+
 static int shmem_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = d_inode(dentry);
@@ -1048,17 +1075,13 @@ static int shmem_setattr(struct dentry *dentry, struct iattr *attr)
 			 * to shrink under memory pressure.
 			 */
 			if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
-				spin_lock(&sbinfo->shrinklist_lock);
-				/*
-				 * _careful to defend against unlocked access to
-				 * ->shrink_list in shmem_unused_huge_shrink()
-				 */
-				if (list_empty_careful(&info->shrinklist)) {
-					list_add_tail(&info->shrinklist,
-							&sbinfo->shrinklist);
-					sbinfo->shrinklist_len++;
-				}
-				spin_unlock(&sbinfo->shrinklist_lock);
+				struct page *page;
+
+				page = find_get_page(inode->i_mapping,
+					(newsize & HPAGE_PMD_MASK) >> PAGE_SHIFT);
+				shmem_shrinker_add(sbinfo, inode, page);
+				if (page)
+					put_page(page);
 			}
 		}
 	}
@@ -1889,21 +1912,7 @@ static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
 	if (PageTransHuge(page) &&
 	    DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE) <
 			hindex + HPAGE_PMD_NR - 1) {
-		/*
-		 * Part of the huge page is beyond i_size: subject
-		 * to shrink under memory pressure.
-		 */
-		spin_lock(&sbinfo->shrinklist_lock);
-		/*
-		 * _careful to defend against unlocked access to
-		 * ->shrink_list in shmem_unused_huge_shrink()
-		 */
-		if (list_empty_careful(&info->shrinklist)) {
-			list_add_tail(&info->shrinklist,
-				      &sbinfo->shrinklist);
-			sbinfo->shrinklist_len++;
-		}
-		spin_unlock(&sbinfo->shrinklist_lock);
+		shmem_shrinker_add(sbinfo, inode, page);
 	}
 
 	/*
-- 
2.27.0.rc0.183.gde8f92d652-goog

