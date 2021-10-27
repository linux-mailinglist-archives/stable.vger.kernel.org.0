Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A956C43D1E6
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 21:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235520AbhJ0Tyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 15:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbhJ0Tyu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 15:54:50 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B139DC061570;
        Wed, 27 Oct 2021 12:52:24 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id u6-20020a17090a3fc600b001a00250584aso5998839pjm.4;
        Wed, 27 Oct 2021 12:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5sUNlB/oeM7v7Lajc1viu0P4O/wTbw1CkB2X041cqCg=;
        b=kN+rFpi6Xvrq4I1a0elUch1TmP+0VipuO4agksFf6bPJaJ44eZ7R8sLkFRm1/jEuht
         EB/9egA/hDHzDWAP9vIdLzBgs/TwmiPpnhSO9DgIStJ8eupi2EGvHzIu5MDpYTcJz4/D
         jIOVplfvUDIZFXG7UhrrIhFo5lCHm8YJF35wKGev+i+ldz6sY3qOPtufj9Pf53IRNIyV
         OFNFY9VcHXYBJoMZh9Z0J9IRP1zl5LULq6GpkjFajonSfmIN4gg59HqEVT6yOCoq3b0u
         m9jadSPrK+pYgArBn4D0PrBCDoUDJL3zt+U6YZgJqtv/EQ3d+P7pSHa1uN4RAVxSy4IM
         gOuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5sUNlB/oeM7v7Lajc1viu0P4O/wTbw1CkB2X041cqCg=;
        b=yt/6lsOkXnw1m0QwbfLlsJMOG05JaaGRPck3Xly3nqdVRZFwyrGdzOsZ85ZnaFeKdD
         k3T2iOFVrW4IuSMqpU0reKnA+FsM1rhyiLJPwdlR9sEB9D2+VIUpPnW+s/VI8B84mVwX
         hJb493GlDFJvMJqBxWtL15yyVFbaSJilgKgImvUatr9ZcA0cgpsloRdqUvOQw3NnCu/4
         x4ks7bZH6d4VYzZ7Af6fTzY19yw+21qAZZ3dB81uFwBa1Cl6Y2jRtRBz5HhPbSAP6Df4
         j4We178mddDjqJCzDczxjxc0/YJFp9zIBD23YKzmbDl7rwZgkUeb9oer+FW2D3iun7bu
         LGRg==
X-Gm-Message-State: AOAM530flJbrz/MfCipNdf4Y1FOlIAer/jnL9UwAyaCPGEPGeJmI4bD1
        ymDanWg5l6z8GgDMjs7Vkng=
X-Google-Smtp-Source: ABdhPJxnhGGhyOcAl898TGV06elPp3eS65A6ugFkxNlpR9hmUWsA3aFLPh0FJumtdnL263vo43m+6Q==
X-Received: by 2002:a17:903:1cd:b0:140:43f0:353c with SMTP id e13-20020a17090301cd00b0014043f0353cmr23652935plh.81.1635364344086;
        Wed, 27 Oct 2021 12:52:24 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-239-127.hsd1.ca.comcast.net. [73.93.239.127])
        by smtp.gmail.com with ESMTPSA id nr14sm509433pjb.24.2021.10.27.12.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 12:52:23 -0700 (PDT)
From:   Yang Shi <shy828301@gmail.com>
To:     hughd@google.com, sunhao.th@gmail.com, willy@infradead.org,
        kirill.shutemov@linux.intel.com, songliubraving@fb.com,
        andrea.righi@canonical.com, akpm@linux-foundation.org
Cc:     shy828301@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] mm: khugepaged: skip huge page collapse for special files
Date:   Wed, 27 Oct 2021 12:52:21 -0700
Message-Id: <20211027195221.3825-1-shy828301@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The read-only THP for filesystems would collapse THP for file opened
readonly and mapped with VM_EXEC, the intended usecase is to avoid TLB
miss for large text segment.  But it doesn't restrict the file types so
THP could be collapsed for non-regular file, for example, block device,
if it is opened readonly and mapped with EXEC permission.  This may
cause bugs, like [1] and [2].

This is definitely not intended usecase, so just collapsing THP for regular
file in order to close the attack surface.

[1] https://lore.kernel.org/lkml/CACkBjsYwLYLRmX8GpsDpMthagWOjWWrNxqY6ZLNQVr6yx+f5vA@mail.gmail.com/
[2] https://lore.kernel.org/linux-mm/000000000000c6a82505ce284e4c@google.com/

Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Reported-by: Hao Sun <sunhao.th@gmail.com>
Reported-by: syzbot+aae069be1de40fb11825@syzkaller.appspotmail.com
Cc: Hao Sun <sunhao.th@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Andrea Righi <andrea.righi@canonical.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Yang Shi <shy828301@gmail.com>
---
The patch is basically based off the proposal from Hugh
(https://lore.kernel.org/linux-mm/a07564a3-b2fc-9ffe-3ace-3f276075ea5c@google.com/).
It seems Hugh is too busy to prepare the patch for formal submission (I
didn't hear from him by pinging him a couple of times on mailing list),
so I prepared the patch and added his SOB.

 mm/khugepaged.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 045cc579f724..e91b7271275e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -445,22 +445,25 @@ static bool hugepage_vma_check(struct vm_area_struct *vma,
 	if (!transhuge_vma_enabled(vma, vm_flags))
 		return false;
 
-	/* Enabled via shmem mount options or sysfs settings. */
-	if (shmem_file(vma->vm_file) && shmem_huge_enabled(vma)) {
+	if (vma->vm_file)
 		return IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
 				HPAGE_PMD_NR);
-	}
+
+	/* Enabled via shmem mount options or sysfs settings. */
+	if (shmem_file(vma->vm_file))
+		return shmem_huge_enabled(vma);
 
 	/* THP settings require madvise. */
 	if (!(vm_flags & VM_HUGEPAGE) && !khugepaged_always())
 		return false;
 
-	/* Read-only file mappings need to be aligned for THP to work. */
+	/* Only regular file is valid */
 	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && vma->vm_file &&
-	    !inode_is_open_for_write(vma->vm_file->f_inode) &&
 	    (vm_flags & VM_EXEC)) {
-		return IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
-				HPAGE_PMD_NR);
+		struct inode *inode = vma->vm_file->f_inode;
+
+		return !inode_is_open_for_write(inode) &&
+			S_ISREG(inode->i_mode);
 	}
 
 	if (!vma->anon_vma || vma->vm_ops)
-- 
2.26.2

