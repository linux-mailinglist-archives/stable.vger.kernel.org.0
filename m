Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2716C5C28
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 02:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbjCWBeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 21:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbjCWBdl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 21:33:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE7BFF04;
        Wed, 22 Mar 2023 18:33:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD8C6B81EBB;
        Thu, 23 Mar 2023 01:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48436C433D2;
        Thu, 23 Mar 2023 01:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679535145;
        bh=h7SVAz2wUS05Wd/uxfbyuvOZis+Rfw8L8vNQnofQeTg=;
        h=Date:To:From:Subject:From;
        b=TQ454LUIZ+rq0uHE/W5COXCOcRZKXTEjO88y/otGzlcIN6nK/t+2OR/ghMh8uzoeY
         MB6ZFqO6GzVm5IpKv1SivNZ70E/9nQIec+dIEk8isza/g5XSf98lm8rxFVJpq34Iwr
         55SFSe7tiDnFLxzXjOxNlnbXRI5PQ4tNnnfmQOmQ=
Date:   Wed, 22 Mar 2023 18:32:24 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        sjpark@amazon.de, jannh@google.com, glider@google.com,
        elver@google.com, dvyukov@google.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-kfence-fix-using-kfence_metadata-without-initialization-in-show_object.patch removed from -mm tree
Message-Id: <20230323013225.48436C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm: kfence: fix using kfence_metadata without initialization in show_object()
has been removed from the -mm tree.  Its filename was
     mm-kfence-fix-using-kfence_metadata-without-initialization-in-show_object.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: kfence: fix using kfence_metadata without initialization in show_object()
Date: Wed, 15 Mar 2023 11:44:41 +0800

The variable kfence_metadata is initialized in kfence_init_pool(), then,
it is not initialized if kfence is disabled after booting.  In this case,
kfence_metadata will be used (e.g.  ->lock and ->state fields) without
initialization when reading /sys/kernel/debug/kfence/objects.  There will
be a warning if you enable CONFIG_DEBUG_SPINLOCK.  Fix it by creating
debugfs files when necessary.

Link: https://lkml.kernel.org/r/20230315034441.44321-1-songmuchun@bytedance.com
Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Tested-by: Marco Elver <elver@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: SeongJae Park <sjpark@amazon.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/kfence/core.c~mm-kfence-fix-using-kfence_metadata-without-initialization-in-show_object
+++ a/mm/kfence/core.c
@@ -726,10 +726,14 @@ static const struct seq_operations objec
 };
 DEFINE_SEQ_ATTRIBUTE(objects);
 
-static int __init kfence_debugfs_init(void)
+static int kfence_debugfs_init(void)
 {
-	struct dentry *kfence_dir = debugfs_create_dir("kfence", NULL);
+	struct dentry *kfence_dir;
 
+	if (!READ_ONCE(kfence_enabled))
+		return 0;
+
+	kfence_dir = debugfs_create_dir("kfence", NULL);
 	debugfs_create_file("stats", 0444, kfence_dir, NULL, &stats_fops);
 	debugfs_create_file("objects", 0400, kfence_dir, NULL, &objects_fops);
 	return 0;
@@ -883,6 +887,8 @@ static int kfence_init_late(void)
 	}
 
 	kfence_init_enable();
+	kfence_debugfs_init();
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-kfence-fix-pg_slab-and-memcg_data-clearing.patch
mm-hugetlb_vmemmap-simplify-hugetlb_vmemmap_init-a-bit.patch

