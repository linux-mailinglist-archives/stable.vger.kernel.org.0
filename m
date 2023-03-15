Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC0C6BBDDF
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 21:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjCOUVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 16:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232588AbjCOUU6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 16:20:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B44364210;
        Wed, 15 Mar 2023 13:20:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E29AB619D9;
        Wed, 15 Mar 2023 20:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E20C433D2;
        Wed, 15 Mar 2023 20:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678911656;
        bh=9MIBd6oFAf5X5n4MBH1P+Eha/o/tKZ5nxKTODl6HJmc=;
        h=Date:To:From:Subject:From;
        b=FhDHZKorabAWb7XECPsrpOKl+YSKaFiqlnKXMYvh+XEH+zpFDS5dy+dDSdeqPwPKw
         mbOhHbXjru7hZ8bZRSl7eEqe89hjpEJku9625nqtFsDpObVYPXRjSMg1/SAEka8cEA
         amOmwivpnI8mDxqB8h1zOirpMxIDJz2wMkBl+ij0=
Date:   Wed, 15 Mar 2023 13:20:55 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        sjpark@amazon.de, jannh@google.com, glider@google.com,
        elver@google.com, dvyukov@google.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kfence-fix-using-kfence_metadata-without-initialization-in-show_object.patch added to mm-hotfixes-unstable branch
Message-Id: <20230315202056.44E20C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: kfence: fix using kfence_metadata without initialization in show_object()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-kfence-fix-using-kfence_metadata-without-initialization-in-show_object.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kfence-fix-using-kfence_metadata-without-initialization-in-show_object.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

 mm/kfence/core.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

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

mm-kfence-fix-using-kfence_metadata-without-initialization-in-show_object.patch
mm-hugetlb_vmemmap-simplify-hugetlb_vmemmap_init-a-bit.patch

