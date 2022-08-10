Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF59158EE05
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 16:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbiHJOQC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 10:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbiHJOQC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 10:16:02 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20EDF6051B;
        Wed, 10 Aug 2022 07:16:01 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id z12so17906662wrs.9;
        Wed, 10 Aug 2022 07:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=kKLVpIdsRy5TMWtiB5ZaP6V18ibVcn9e+fK2DzTcFxQ=;
        b=BumslBWwvg8KyrxOsGDuztgkN0YS1dRH2Ws55oBlCsYv2+TALUbzNcPDSy3V8T/guu
         q4rW8VMt18R0Sb/KLAQwUid2iYmERAH0iHF9MGpK9lKdF5CHuFGnInXUXCIXfoOrHtP0
         k/2vD6KixV/4ppOTp1YqX8MDgGttg0PkD3T6xfH1W1/Rgxazj2Tv2/oD6WnQpNnCDe9V
         dSWz8Yd4WgY2nUEExuUYPHa4IUQOHmL57SXiInol+sv3u1hRn6Hhhv9/Y0qpSxsXe8PL
         1+KbML1VLM6yABhpujvPTOOv7HEU/AiQ+5cIjYpEs1tuT2YCEzzzFxL2BRkcbDvq37M5
         mHSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=kKLVpIdsRy5TMWtiB5ZaP6V18ibVcn9e+fK2DzTcFxQ=;
        b=3eNXd8iADt84DdvSj/4J0eC5xagU/ku638QU7WG/lTFJzlShKqawRtoYPCvUeBHoxH
         eTTxPPxePqtEGAvEzAEd72O77YSbG3oQHGu/AL39jsRn2MlCe6fPIyEac2gKv+LtP5we
         kDg/sV9JvAnywD4LsiSs/MbrdVnU0RWJAJQxwLFOrWmxF9QS1G5U87Mz0lI2EDxFrLGE
         1QaBEEPhW2Qyp3by+N+XEw/+SffGvB58DcrB/qtIy4S2o/Hqm57AZl0Uw9eLIkj/wt+m
         FSrGVLdDfUelZD46glyMZlJxEfUAJn0//defgSTc7BlZ4LGuNlVReBD3edYAvKAybZXd
         pQRg==
X-Gm-Message-State: ACgBeo32tFc8dFEBuIu5jrf58FKsxBRm5w7wZzZnq19wON2F6htZupBh
        KTExYhN/QzptY8tdjoZAm5Q=
X-Google-Smtp-Source: AA6agR5hf/oTVvHUucj+RCk7YZHXvUuLwiZT2QduyqHxZLniT6vUN7gvf9tUPuTU5FGLXVJRW1BzLA==
X-Received: by 2002:adf:ecc7:0:b0:220:5fef:6d40 with SMTP id s7-20020adfecc7000000b002205fef6d40mr17500256wro.5.1660140959670;
        Wed, 10 Aug 2022 07:15:59 -0700 (PDT)
Received: from localhost.localdomain ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id x13-20020adfdccd000000b0021d65675583sm16902969wrm.52.2022.08.10.07.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 07:15:59 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Mel Gorman <mgorman@techsingularity.net>
Subject: [PATCH 5.10 v2 1/3] mm: Add kvrealloc()
Date:   Wed, 10 Aug 2022 16:15:50 +0200
Message-Id: <20220810141552.168763-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220810141552.168763-1-amir73il@gmail.com>
References: <20220810141552.168763-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit de2860f4636256836450c6543be744a50118fc66 upstream.

During log recovery of an XFS filesystem with 64kB directory
buffers, rebuilding a buffer split across two log records results
in a memory allocation warning from krealloc like this:

xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
XFS (dm-0): Unmounting Filesystem
XFS (dm-0): Mounting V5 Filesystem
XFS (dm-0): Starting recovery (logdev: internal)
------------[ cut here ]------------
WARNING: CPU: 5 PID: 3435170 at mm/page_alloc.c:3539 get_page_from_freelist+0xdee/0xe40
.....
RIP: 0010:get_page_from_freelist+0xdee/0xe40
Call Trace:
 ? complete+0x3f/0x50
 __alloc_pages+0x16f/0x300
 alloc_pages+0x87/0x110
 kmalloc_order+0x2c/0x90
 kmalloc_order_trace+0x1d/0x90
 __kmalloc_track_caller+0x215/0x270
 ? xlog_recover_add_to_cont_trans+0x63/0x1f0
 krealloc+0x54/0xb0
 xlog_recover_add_to_cont_trans+0x63/0x1f0
 xlog_recovery_process_trans+0xc1/0xd0
 xlog_recover_process_ophdr+0x86/0x130
 xlog_recover_process_data+0x9f/0x160
 xlog_recover_process+0xa2/0x120
 xlog_do_recovery_pass+0x40b/0x7d0
 ? __irq_work_queue_local+0x4f/0x60
 ? irq_work_queue+0x3a/0x50
 xlog_do_log_recovery+0x70/0x150
 xlog_do_recover+0x38/0x1d0
 xlog_recover+0xd8/0x170
 xfs_log_mount+0x181/0x300
 xfs_mountfs+0x4a1/0x9b0
 xfs_fs_fill_super+0x3c0/0x7b0
 get_tree_bdev+0x171/0x270
 ? suffix_kstrtoint.constprop.0+0xf0/0xf0
 xfs_fs_get_tree+0x15/0x20
 vfs_get_tree+0x24/0xc0
 path_mount+0x2f5/0xaf0
 __x64_sys_mount+0x108/0x140
 do_syscall_64+0x3a/0x70
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Essentially, we are taking a multi-order allocation from kmem_alloc()
(which has an open coded no fail, no warn loop) and then
reallocating it out to 64kB using krealloc(__GFP_NOFAIL) and that is
then triggering the above warning.

This is a regression caused by converting this code from an open
coded no fail/no warn reallocation loop to using __GFP_NOFAIL.

What we actually need here is kvrealloc(), so that if contiguous
page allocation fails we fall back to vmalloc() and we don't
get nasty warnings happening in XFS.

Fixes: 771915c4f688 ("xfs: remove kmem_realloc()")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log_recover.c |  4 +++-
 include/linux/mm.h       |  2 ++
 mm/util.c                | 15 +++++++++++++++
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 69408782019e..e61f28ce3e44 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2061,7 +2061,9 @@ xlog_recover_add_to_cont_trans(
 	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
 	old_len = item->ri_buf[item->ri_cnt-1].i_len;
 
-	ptr = krealloc(old_ptr, len + old_len, GFP_KERNEL | __GFP_NOFAIL);
+	ptr = kvrealloc(old_ptr, old_len, len + old_len, GFP_KERNEL);
+	if (!ptr)
+		return -ENOMEM;
 	memcpy(&ptr[old_len], dp, len);
 	item->ri_buf[item->ri_cnt-1].i_len += len;
 	item->ri_buf[item->ri_cnt-1].i_addr = ptr;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5b4d88faf114..b8b677f47a8d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -788,6 +788,8 @@ static inline void *kvcalloc(size_t n, size_t size, gfp_t flags)
 	return kvmalloc_array(n, size, flags | __GFP_ZERO);
 }
 
+extern void *kvrealloc(const void *p, size_t oldsize, size_t newsize,
+		gfp_t flags);
 extern void kvfree(const void *addr);
 extern void kvfree_sensitive(const void *addr, size_t len);
 
diff --git a/mm/util.c b/mm/util.c
index ba9643de689e..25bfda774f6f 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -661,6 +661,21 @@ void kvfree_sensitive(const void *addr, size_t len)
 }
 EXPORT_SYMBOL(kvfree_sensitive);
 
+void *kvrealloc(const void *p, size_t oldsize, size_t newsize, gfp_t flags)
+{
+	void *newp;
+
+	if (oldsize >= newsize)
+		return (void *)p;
+	newp = kvmalloc(newsize, flags);
+	if (!newp)
+		return NULL;
+	memcpy(newp, p, oldsize);
+	kvfree(p);
+	return newp;
+}
+EXPORT_SYMBOL(kvrealloc);
+
 static inline void *__page_rmapping(struct page *page)
 {
 	unsigned long mapping;
-- 
2.25.1

