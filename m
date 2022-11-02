Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE0F6157F9
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbiKBCmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbiKBCmd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:42:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCF820BCE
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:42:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFD8B601C6
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:42:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4F1C433B5;
        Wed,  2 Nov 2022 02:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356952;
        bh=/iXs2srnTOyDSuY7FjChpG6R2Oi3MpSbidZRChKxAww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ktUWgcLBazOKY01PpKv0EOiQm/gVuAoj6Fw3dSYFatc/ICBIzd+E4xkmXy/zrBZIS
         2x0qHohELbNihGU13og/eZyeK1l94UQLHh/JcOrDiQlFjGCkXZaFlrVS5Y1ZE0capU
         iKBsjpJFgVKGVrpmAroa2DHQnAMLUIoxhMAano+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Xu <peterx@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.0 087/240] mm/uffd: fix vma check on userfault for wp
Date:   Wed,  2 Nov 2022 03:31:02 +0100
Message-Id: <20221102022113.366299064@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

commit 67eae54bc227b30dedcce9db68b063ba1adb7838 upstream.

We used to have a report that pte-marker code can be reached even when
uffd-wp is not compiled in for file memories, here:

https://lore.kernel.org/all/YzeR+R6b4bwBlBHh@x1n/T/#u

I just got time to revisit this and found that the root cause is we simply
messed up with the vma check, so that for !PTE_MARKER_UFFD_WP system, we
will allow UFFDIO_REGISTER of MINOR & WP upon shmem as the check was
wrong:

    if (vm_flags & VM_UFFD_MINOR)
        return is_vm_hugetlb_page(vma) || vma_is_shmem(vma);

Where we'll allow anything to pass on shmem as long as minor mode is
requested.

Axel did it right when introducing minor mode but I messed it up in
b1f9e876862d when moving code around.  Fix it.

Link: https://lkml.kernel.org/r/20221024193336.1233616-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20221024193336.1233616-2-peterx@redhat.com
Fixes: b1f9e876862d ("mm/uffd: enable write protection for shmem & hugetlbfs")
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/userfaultfd_k.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index f07e6998bb68..9df0b9a762cc 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -146,9 +146,9 @@ static inline bool userfaultfd_armed(struct vm_area_struct *vma)
 static inline bool vma_can_userfault(struct vm_area_struct *vma,
 				     unsigned long vm_flags)
 {
-	if (vm_flags & VM_UFFD_MINOR)
-		return is_vm_hugetlb_page(vma) || vma_is_shmem(vma);
-
+	if ((vm_flags & VM_UFFD_MINOR) &&
+	    (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma)))
+		return false;
 #ifndef CONFIG_PTE_MARKER_UFFD_WP
 	/*
 	 * If user requested uffd-wp but not enabled pte markers for
-- 
2.38.1



