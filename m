Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08AA44497B
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 21:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhKCUZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 16:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbhKCUZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 16:25:37 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E08CC061714;
        Wed,  3 Nov 2021 13:23:01 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id v20so3455184plo.7;
        Wed, 03 Nov 2021 13:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FB36Sz9xaSOuhojZsirNmM4Fac3UYkPFaEPW7F3xjy0=;
        b=TZkCoymatDNmz9fAPGOcwzksGrRgFeWlQYuDhjzk8lxhd/kNQmNVOL0RNVRGMWT7mG
         XvXqVuYU60JDX1hFW0B4QDb/LHBWMDpnkQEJY6Ik5KlirqzbCNgGIWfhiav7qYFF7Di+
         FZvw78XGU4YEKCxUz9u/CMuTi3iX5CUsbVrfaRs0woE4qhAdxGWvNaRAJ8jonS3Kn2kG
         qxWj7PcY75IyKCfcht/miCltXuw6ILWvoaBudd/3JVFRLruI3ETt0pBJKhEmzi9kl+w8
         +Bu8eyEfnKdogYbcBNk7hxtPDsVhSJiaoIZl0ntOAOBM88s5F8NbZnZAMnsfqK8Vo4Xi
         dRpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FB36Sz9xaSOuhojZsirNmM4Fac3UYkPFaEPW7F3xjy0=;
        b=8BPnqHsMl/1Tyjeo4K30nAX3h0HE+3CF4ohwA/AA2P7ra3R6kT2hE+wl9tkRvH/U+J
         k5zfrQ1VgSvMEisGLRqCRFEk07bzVzq78qUzXzZ8/7rUCTTlIJ2tLCCawvDgeo9Zr873
         FLWvkR6HDN/lOKqxiYl84f63cKlysHBeZ7kUG1Scuye/nFdHpMddmWd3BrI88b3Uf8tR
         Wwtvq5efK2HPkgi0qq1s9rqRKk2zW+s9xdmJosxNw1+VJ0oelnMVc0BJH4D3V28nzG28
         KcVQdRkvE3ed2GS273wXUcALuCtIMU6IFjDK9M0DEjQltYyfai9XKTpGEJVTML9vx65L
         64tQ==
X-Gm-Message-State: AOAM531tHdmcPHKFMLV8pqXfqAeZB/7fiCZ7okS0vJk4aLbl0D7NTL5N
        8q/rtEfws53t5e4b/gCeq5s=
X-Google-Smtp-Source: ABdhPJw4b9b2Drq+EVQJDZJtNyQ4qeqLw/lhvtJts7NUJVQ3adQsl1+oAH7ZTp2v+ekJw5iw9Gxhww==
X-Received: by 2002:a17:90b:1e0c:: with SMTP id pg12mr11786165pjb.135.1635970980723;
        Wed, 03 Nov 2021 13:23:00 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-239-127.hsd1.ca.comcast.net. [73.93.239.127])
        by smtp.gmail.com with ESMTPSA id t12sm5839863pjo.44.2021.11.03.13.22.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 13:22:59 -0700 (PDT)
From:   Yang Shi <shy828301@gmail.com>
To:     gregkh@linuxfoundation.org, hughd@google.com, sunhao.th@gmail.com,
        willy@infradead.org, kirill.shutemov@linux.intel.com,
        songliubraving@fb.com, andrea.righi@canonical.com,
        akpm@linux-foundation.org
Cc:     shy828301@gmail.com, stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [stable 5.10 PATCH] mm: khugepaged: skip huge page collapse for special files
Date:   Wed,  3 Nov 2021 13:22:58 -0700
Message-Id: <20211103202258.3564-1-shy828301@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit a4aeaa06d45e90f9b279f0b09de84bd00006e733 upstream.

The read-only THP for filesystems will collapse THP for files opened
readonly and mapped with VM_EXEC.  The intended usecase is to avoid TLB
misses for large text segments.  But it doesn't restrict the file types
so a THP could be collapsed for a non-regular file, for example, block
device, if it is opened readonly and mapped with EXEC permission.  This
may cause bugs, like [1] and [2].

This is definitely not the intended usecase, so just collapse THP for
regular files in order to close the attack surface.

[shy828301@gmail.com: fix vm_file check [3]]

Link: https://lore.kernel.org/lkml/CACkBjsYwLYLRmX8GpsDpMthagWOjWWrNxqY6ZLNQVr6yx+f5vA@mail.gmail.com/ [1]
Link: https://lore.kernel.org/linux-mm/000000000000c6a82505ce284e4c@google.com/ [2]
Link: https://lkml.kernel.org/r/CAHbLzkqTW9U3VvTu1Ki5v_cLRC9gHW+znBukg_ycergE0JWj-A@mail.gmail.com [3]
Link: https://lkml.kernel.org/r/20211027195221.3825-1-shy828301@gmail.com
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reported-by: Hao Sun <sunhao.th@gmail.com>
Reported-by: syzbot+aae069be1de40fb11825@syzkaller.appspotmail.com
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Andrea Righi <andrea.righi@canonical.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/khugepaged.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index ee8812578563..5c36848022de 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -443,21 +443,24 @@ static bool hugepage_vma_check(struct vm_area_struct *vma,
 	if (!transhuge_vma_enabled(vma, vm_flags))
 		return false;
 
+	if (vma->vm_file && !IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) -
+				vma->vm_pgoff, HPAGE_PMD_NR))
+		return false;
+
 	/* Enabled via shmem mount options or sysfs settings. */
-	if (shmem_file(vma->vm_file) && shmem_huge_enabled(vma)) {
-		return IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
-				HPAGE_PMD_NR);
-	}
+	if (shmem_file(vma->vm_file))
+		return shmem_huge_enabled(vma);
 
 	/* THP settings require madvise. */
 	if (!(vm_flags & VM_HUGEPAGE) && !khugepaged_always())
 		return false;
 
-	/* Read-only file mappings need to be aligned for THP to work. */
+	/* Only regular file is valid */
 	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && vma->vm_file &&
 	    (vm_flags & VM_DENYWRITE)) {
-		return IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
-				HPAGE_PMD_NR);
+		struct inode *inode = vma->vm_file->f_inode;
+
+		return S_ISREG(inode->i_mode);
 	}
 
 	if (!vma->anon_vma || vma->vm_ops)
-- 
2.26.2

