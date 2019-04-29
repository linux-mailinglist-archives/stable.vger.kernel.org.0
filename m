Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54AD3DFF8
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 12:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbfD2KAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 06:00:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727217AbfD2KAd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Apr 2019 06:00:33 -0400
Received: from localhost (unknown [77.138.135.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5337220449;
        Mon, 29 Apr 2019 10:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556532033;
        bh=8+KrS3MN83LrdK/gcPTXlmQoU7AtaGEuBQj0pJa47Og=;
        h=From:To:Cc:Subject:Date:From;
        b=X2B+iNL9WYce0XZEHnruNMdxpXFiIkTAgYSsjEYnCLht4mjPrYwZEuBz6dzrNemby
         EHDo7HUFC/5btVec1nfoFI1zVFmEtUO48UddjRJ8tOb9U1niDm0zqehFQUe/V4T6ph
         Y/g/d0C515pk3jB9d9Nc8ELE/Bj7JyYrAqUWLG54=
From:   Leon Romanovsky <leon@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        stable@vger.kernel.org
Subject: [PATCH] RDMA/uverbs: Fix compilation error on s390 and mips platforms
Date:   Mon, 29 Apr 2019 13:00:14 +0300
Message-Id: <20190429100014.5820-1-leon@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Most platforms ignore parameter provided to ZERO_PAGE macro,
hence wrong parameter was used and missed. This caused to compilation
error like presented below.

drivers/infiniband/core/uverbs_main.c: In function 'rdma_umap_fault':
drivers/infiniband/core/uverbs_main.c:898:28: error: 'struct vm_fault' has no member named 'vm_start'
   vmf->page = ZERO_PAGE(vmf->vm_start);
                            ^~
Cc: stable@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Fixes: 67f269b37f9b ("RDMA/ucontext: Fix regression with disassociate")
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/uverbs_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 7843e89235c3..65fe89b3fa2d 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -895,7 +895,7 @@ static vm_fault_t rdma_umap_fault(struct vm_fault *vmf)

 	/* Read only pages can just use the system zero page. */
 	if (!(vmf->vma->vm_flags & (VM_WRITE | VM_MAYWRITE))) {
-		vmf->page = ZERO_PAGE(vmf->vm_start);
+		vmf->page = ZERO_PAGE(vmf->vma->vm_start);
 		get_page(vmf->page);
 		return 0;
 	}
--
2.20.1

