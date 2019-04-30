Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8CA4F6E5
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731242AbfD3Luu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:50:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731261AbfD3Lus (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:50:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1C28217D8;
        Tue, 30 Apr 2019 11:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556625048;
        bh=CRfhy5PxTCVL9VXkS5Q8VufIPIH86Z5u52uJc2DmXaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hg4QBK3Y0hM4e2OR6Vz4l8oxZUpJ8S++txx7kDDkU+T/m5nU3RItHaFsOTFAmH3RH
         sYtvNbjylKjC1SoTTuikflPT/z+7Zazi2WDs+RnVoOontvVk6itlsut2WU3fa6niK/
         D4T9zkS0WPTwHYQtLWObjMcm/QI0abZ9MuQKXXf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.0 71/89] rdma: fix build errors on s390 and MIPS due to bad ZERO_PAGE use
Date:   Tue, 30 Apr 2019 13:39:02 +0200
Message-Id: <20190430113613.074939505@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 6a5c5d26c4c6c3cc486fef0bf04ff9551132611b upstream.

The parameter to ZERO_PAGE() was wrong, but since all architectures
except for MIPS and s390 ignore it, it wasn't noticed until 0-day
reported the build error.

Fixes: 67f269b37f9b ("RDMA/ucontext: Fix regression with disassociate")
Cc: stable@vger.kernel.org
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Leon Romanovsky <leonro@mellanox.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/uverbs_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -894,7 +894,7 @@ static vm_fault_t rdma_umap_fault(struct
 
 	/* Read only pages can just use the system zero page. */
 	if (!(vmf->vma->vm_flags & (VM_WRITE | VM_MAYWRITE))) {
-		vmf->page = ZERO_PAGE(vmf->vm_start);
+		vmf->page = ZERO_PAGE(vmf->address);
 		get_page(vmf->page);
 		return 0;
 	}


