Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF675676F98
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbjAVPXW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:23:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbjAVPXI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:23:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70359B772
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:23:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B9D860C44
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B94C433EF;
        Sun, 22 Jan 2023 15:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400986;
        bh=L2jQWnhzQQn9RHurNCiKJ6+JRt32wE4vfjreIhG/pxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yLRfEumwbBJYfpE5lL3PLeJEjmIQ62GgyUH8q7t9p5ghq3+sN8i416xSqujV6XWhP
         qtH3KukwxUh9LL9YAEwP4SGnD9SIZCfBdjZmcy3zLzeAksbpJlR2GmTm30JTsz2+Ap
         yA51cb4KbW8N4g8i3E2/MQJnIvzHRD6PbsgFqqAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yu Zhao <yuzhao@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 037/193] nommu: fix memory leak in do_mmap() error path
Date:   Sun, 22 Jan 2023 16:02:46 +0100
Message-Id: <20230122150248.104168923@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liam Howlett <liam.howlett@oracle.com>

commit 7f31cced5724e6d414fe750aa1cd7e7b578ec22f upstream.

The preallocation of the maple tree nodes may leak if the error path to
"error_just_free" is taken.  Fix this by moving the freeing of the maple
tree nodes to a shared location for all error paths.

Link: https://lkml.kernel.org/r/20230109205507.955577-1-Liam.Howlett@oracle.com
Fixes: 8220543df148 ("nommu: remove uses of VMA linked list")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/nommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 214c70e1d059..c8252f01d5db 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1240,6 +1240,7 @@ unsigned long do_mmap(struct file *file,
 error_just_free:
 	up_write(&nommu_region_sem);
 error:
+	mas_destroy(&mas);
 	if (region->vm_file)
 		fput(region->vm_file);
 	kmem_cache_free(vm_region_jar, region);
@@ -1250,7 +1251,6 @@ unsigned long do_mmap(struct file *file,
 
 sharing_violation:
 	up_write(&nommu_region_sem);
-	mas_destroy(&mas);
 	pr_warn("Attempt to share mismatched mappings\n");
 	ret = -EINVAL;
 	goto error;
-- 
2.39.1



