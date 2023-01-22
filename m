Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13778676F9A
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbjAVPXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbjAVPXQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:23:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61272C655
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:23:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C149B80B1B
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:23:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE06C433D2;
        Sun, 22 Jan 2023 15:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400991;
        bh=pq/3UXdHZ11wrPonijGtD89M6ShkAWO1bA1sNxMSCWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W2VCns3jA5C88HQtDgfVrUbbA9UUnzgd4CP30qsRZwpQj3EajnU875L/c8JFbzdsN
         zxRp6AWcw0kVwrXJKxZxDB5HuHM31N6P44h70rHo5qpuiBwauKMvvkfZkK6GmWa+IB
         h5kP/5FyrS5lsPoXQHrX/pZunRFqrZnX0ycYDn+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yu Zhao <yuzhao@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 039/193] nommu: fix split_vma() map_count error
Date:   Sun, 22 Jan 2023 16:02:48 +0100
Message-Id: <20230122150248.194589222@linuxfoundation.org>
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

commit fd9edbdbdcde6b489ce59f326755ef16a2ffadd7 upstream.

During the maple tree conversion of nommu, an error in counting the VMAs
was introduced by counting the existing VMA again.  The counting used to
be decremented by one and incremented by two, but now it only increments
by two.  Fix the counting error by moving the increment outside the
setup_vma_to_mm() function to the callers.

Link: https://lkml.kernel.org/r/20230109205809.956325-1-Liam.Howlett@oracle.com
Fixes: 8220543df148 ("nommu: remove uses of VMA linked list")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/nommu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 844af5be7640..5b83938ecb67 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -559,7 +559,6 @@ void vma_mas_remove(struct vm_area_struct *vma, struct ma_state *mas)
 
 static void setup_vma_to_mm(struct vm_area_struct *vma, struct mm_struct *mm)
 {
-	mm->map_count++;
 	vma->vm_mm = mm;
 
 	/* add the VMA to the mapping */
@@ -587,6 +586,7 @@ static void mas_add_vma_to_mm(struct ma_state *mas, struct mm_struct *mm,
 	BUG_ON(!vma->vm_region);
 
 	setup_vma_to_mm(vma, mm);
+	mm->map_count++;
 
 	/* add the VMA to the tree */
 	vma_mas_store(vma, mas);
@@ -1347,6 +1347,7 @@ int split_vma(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (vma->vm_file)
 		return -ENOMEM;
 
+	mm = vma->vm_mm;
 	if (mm->map_count >= sysctl_max_map_count)
 		return -ENOMEM;
 
@@ -1398,6 +1399,7 @@ int split_vma(struct mm_struct *mm, struct vm_area_struct *vma,
 	mas_set_range(&mas, vma->vm_start, vma->vm_end - 1);
 	mas_store(&mas, vma);
 	vma_mas_store(new, &mas);
+	mm->map_count++;
 	return 0;
 
 err_mas_preallocate:
-- 
2.39.1



