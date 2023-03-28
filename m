Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 127B76CBE54
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 14:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbjC1MB5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 08:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232598AbjC1MB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 08:01:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B937199
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 05:01:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E5AC616DF
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 12:01:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7FEC433D2;
        Tue, 28 Mar 2023 12:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680004914;
        bh=/uYr58Ti2bothrwgGQa8DTx9cwzFBbUjKPmLGjJr+Cw=;
        h=Subject:To:Cc:From:Date:From;
        b=bLfJQZmY0oiQlHE/eXJV03bz0TB3xboIY+GNaOdjksmShlj/6pXpSBIzxEnYU6Jww
         lrgx+V/BMPNqN6cJoPoVg2Sitb9ccJagFTzM6J/LBRRzw6Hr3P546a+QLcFO0xcVyF
         ymx3GSQnaMboBMeqUwuGi+Z49Edkqd1guf1UqU3c=
Subject: FAILED: patch "[PATCH] mm: kfence: fix using kfence_metadata without initialization" failed to apply to 5.15-stable tree
To:     muchun.song@linux.dev, akpm@linux-foundation.org,
        dvyukov@google.com, elver@google.com, glider@google.com,
        jannh@google.com, sjpark@amazon.de, songmuchun@bytedance.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Mar 2023 14:01:51 +0200
Message-ID: <16800049118459@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x 1c86a188e03156223a34d09ce290b49bd4dd0403
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '16800049118459@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

1c86a188e031 ("mm: kfence: fix using kfence_metadata without initialization in show_object()")
b33f778bba5e ("kfence: alloc kfence_pool after system startup")
698361bca2d5 ("kfence: allow re-enabling KFENCE after system startup")
07e8481d3c38 ("kfence: always use static branches to guard kfence_alloc()")
08f6b10630f2 ("kfence: limit currently covered allocations when pool nearly full")
a9ab52bbcb52 ("kfence: move saving stack trace of allocations into __kfence_alloc()")
9a19aeb56650 ("kfence: count unexpectedly skipped allocations")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1c86a188e03156223a34d09ce290b49bd4dd0403 Mon Sep 17 00:00:00 2001
From: Muchun Song <muchun.song@linux.dev>
Date: Wed, 15 Mar 2023 11:44:41 +0800
Subject: [PATCH] mm: kfence: fix using kfence_metadata without initialization
 in show_object()

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

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 5349c37a5dac..79c94ee55f97 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -726,10 +726,14 @@ static const struct seq_operations objects_sops = {
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
 

