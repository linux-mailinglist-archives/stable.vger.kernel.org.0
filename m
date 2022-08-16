Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01AE0596064
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 18:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236525AbiHPQhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 12:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236501AbiHPQhj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 12:37:39 -0400
Received: from mail-ed1-x549.google.com (mail-ed1-x549.google.com [IPv6:2a00:1450:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF0CF80B48
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 09:37:37 -0700 (PDT)
Received: by mail-ed1-x549.google.com with SMTP id b6-20020a056402278600b0043e686058feso6973671ede.10
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 09:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=Bt86ycU5TqIe5DWAivAOKuWY2/WSOfZm/1Ale3yOGtg=;
        b=qLBFcuLAhlDwJfDACSf2gt/J+hZ5HtnFVGcb/nrGUjJCkIsoRyLc6pgG87MjjR8KIQ
         5Iz1bYpH9D6l6+a2yXEoF1qmbqsfO3LSbDkEQeRvX5ucEx2BqTk5HTxQmnGstdvJ2/Z2
         YzWpn4+XRNNACYVTttlB2gPuTIQYUoVVf38GfoZerRGl9jB1RxdEpsDA2NaNBgqtb4Vj
         BnblFZJWuEkSo0udCHh6tFwqzcPKu6LI4BbFd2cQnQWmcEuRRgSoT6yiJLCOQU55+jP9
         aiutqycGzt4DBlwwmbrM9c1zKuDLUCGppvkHPVvSSLp/Pgkw/eKflRRZhpcxWOYy3qMo
         fFBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=Bt86ycU5TqIe5DWAivAOKuWY2/WSOfZm/1Ale3yOGtg=;
        b=rx/5AYd87qv6eSzViRdwED7NfYqCQXAuQ5XTchzM98V2GG6zKMTtUFfQfArXUqt/tt
         xQn37ayq3VzGCde29SxaE32Rz2chdm1cwt1UmFVtIeNiBv//5pdfIilgL8Lrm/ZotBHs
         +a+FiKdyR96lERVgLh/FQ04pA2f7qUggcUdPVoMd09LwVG7RAICScbqVDyvoOZXSreRK
         qE68+yRlM4UQdI9oEY+sd5MxgCnJxbBOWDT/x53oPkv9aYD6xakRccWuiKSO5ufsUiQs
         VrHQzaCQreoJA5LZyw6Rii31W3M24rvnMrHpLs0jUovlKRr4Hq9Yp9Zh1QY0WIkgUoJK
         SAbQ==
X-Gm-Message-State: ACgBeo0a99bM38WcrutG5mo4snAy9Snu2OLTPx677QEA9OX6vhp/Q0W7
        asj40T5x7PArVTNfxQTJkIT5garWDQ==
X-Google-Smtp-Source: AA6agR7puhx9qSi+R3MTquY9NGN8yzzazt4EdG1n9Sdj8HxHiF3+944McfTa/YkTSASAVUo0d2GXJFjQsg==
X-Received: from elver.muc.corp.google.com ([2a00:79e0:9c:201:b8f6:52b8:6a74:6073])
 (user=elver job=sendgmr) by 2002:a05:6402:4282:b0:43e:612c:fcf7 with SMTP id
 g2-20020a056402428200b0043e612cfcf7mr18989740edc.242.1660667856291; Tue, 16
 Aug 2022 09:37:36 -0700 (PDT)
Date:   Tue, 16 Aug 2022 18:36:41 +0200
Message-Id: <20220816163641.2359996-1-elver@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 5.19.y] Revert "mm: kfence: apply kmemleak_ignore_phys on
 early allocated pool"
From:   Marco Elver <elver@google.com>
To:     elver@google.com, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        kasan-dev@googlegroups.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Yee Lee <yee.lee@mediatek.com>,
        Max Schulze <max.schulze@online.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 07313a2b29ed1079eaa7722624544b97b3ead84b.

Commit 0c24e061196c21d5 ("mm: kmemleak: add rbtree and store physical
address for objects allocated with PA") is not yet in 5.19 (but appears
in 6.0). Without 0c24e061196c21d5, kmemleak still stores phys objects
and non-phys objects in the same tree, and ignoring (instead of freeing)
will cause insertions into the kmemleak object tree by the slab
post-alloc hook to conflict with the pool object (see comment).

Reports such as the following would appear on boot, and effectively
disable kmemleak:

 | kmemleak: Cannot insert 0xffffff806e24f000 into the object search tree (overlaps existing)
 | CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.19.0-v8-0815+ #5
 | Hardware name: Raspberry Pi Compute Module 4 Rev 1.0 (DT)
 | Call trace:
 |  dump_backtrace.part.0+0x1dc/0x1ec
 |  show_stack+0x24/0x80
 |  dump_stack_lvl+0x8c/0xb8
 |  dump_stack+0x1c/0x38
 |  create_object.isra.0+0x490/0x4b0
 |  kmemleak_alloc+0x3c/0x50
 |  kmem_cache_alloc+0x2f8/0x450
 |  __proc_create+0x18c/0x400
 |  proc_create_reg+0x54/0xd0
 |  proc_create_seq_private+0x94/0x120
 |  init_mm_internals+0x1d8/0x248
 |  kernel_init_freeable+0x188/0x388
 |  kernel_init+0x30/0x150
 |  ret_from_fork+0x10/0x20
 | kmemleak: Kernel memory leak detector disabled
 | kmemleak: Object 0xffffff806e24d000 (size 2097152):
 | kmemleak:   comm "swapper", pid 0, jiffies 4294892296
 | kmemleak:   min_count = -1
 | kmemleak:   count = 0
 | kmemleak:   flags = 0x5
 | kmemleak:   checksum = 0
 | kmemleak:   backtrace:
 |      kmemleak_alloc_phys+0x94/0xb0
 |      memblock_alloc_range_nid+0x1c0/0x20c
 |      memblock_alloc_internal+0x88/0x100
 |      memblock_alloc_try_nid+0x148/0x1ac
 |      kfence_alloc_pool+0x44/0x6c
 |      mm_init+0x28/0x98
 |      start_kernel+0x178/0x3e8
 |      __primary_switched+0xc4/0xcc

Reported-by: Max Schulze <max.schulze@online.de>
Signed-off-by: Marco Elver <elver@google.com>
---
 mm/kfence/core.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 6aff49f6b79e..4b5e5a3d3a63 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -603,6 +603,14 @@ static unsigned long kfence_init_pool(void)
 		addr += 2 * PAGE_SIZE;
 	}
 
+	/*
+	 * The pool is live and will never be deallocated from this point on.
+	 * Remove the pool object from the kmemleak object tree, as it would
+	 * otherwise overlap with allocations returned by kfence_alloc(), which
+	 * are registered with kmemleak through the slab post-alloc hook.
+	 */
+	kmemleak_free(__kfence_pool);
+
 	return 0;
 }
 
@@ -615,16 +623,8 @@ static bool __init kfence_init_pool_early(void)
 
 	addr = kfence_init_pool();
 
-	if (!addr) {
-		/*
-		 * The pool is live and will never be deallocated from this point on.
-		 * Ignore the pool object from the kmemleak phys object tree, as it would
-		 * otherwise overlap with allocations returned by kfence_alloc(), which
-		 * are registered with kmemleak through the slab post-alloc hook.
-		 */
-		kmemleak_ignore_phys(__pa(__kfence_pool));
+	if (!addr)
 		return true;
-	}
 
 	/*
 	 * Only release unprotected pages, and do not try to go back and change
-- 
2.37.1.595.g718a3a8f04-goog

