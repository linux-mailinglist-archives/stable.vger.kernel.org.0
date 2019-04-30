Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0B6CF63A
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730252AbfD3Loq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:44:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729295AbfD3Lop (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:44:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64BDC217D6;
        Tue, 30 Apr 2019 11:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624684;
        bh=imL9mDrXO2IU4GhsA/xFI5+efFxUzAHmJGbxiNa3XXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1xFEG8oQ9xFcOfQENV6TQtsddmKCOjKOUr3hXHKB/yC2jYTxlVzdcOttWE9ixPV4q
         RQw16u46m+eFOdvWkAsEkmFIgwvxEpQtv43B+8Gtd22Ze4BERwVVdP+5zOVVhp9loG
         qXvBavvo0/C4IN6l3TrIrCopn3sq0W6zNsDbQIhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>,
        Haggai Eran <haggaie@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: [PATCH 4.19 033/100] RDMA/mlx5: Do not allow the user to write to the clock page
Date:   Tue, 30 Apr 2019 13:38:02 +0200
Message-Id: <20190430113610.355843314@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
References: <20190430113608.616903219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

commit c660133c339f9ab684fdf568c0d51b9ae5e86002 upstream.

The intent of this VMA was to be read-only from user space, but the
VM_MAYWRITE masking was missed, so mprotect could make it writable.

Cc: stable@vger.kernel.org
Fixes: 5c99eaecb1fc ("IB/mlx5: Mmap the HCA's clock info to user-space")
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Reviewed-by: Haggai Eran <haggaie@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx5/main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2014,6 +2014,7 @@ static int mlx5_ib_mmap_clock_info_page(
 
 	if (vma->vm_flags & VM_WRITE)
 		return -EPERM;
+	vma->vm_flags &= ~VM_MAYWRITE;
 
 	if (!dev->mdev->clock_info_page)
 		return -EOPNOTSUPP;
@@ -2197,6 +2198,7 @@ static int mlx5_ib_mmap(struct ib_uconte
 
 		if (vma->vm_flags & VM_WRITE)
 			return -EPERM;
+		vma->vm_flags &= ~VM_MAYWRITE;
 
 		/* Don't expose to user-space information it shouldn't have */
 		if (PAGE_SIZE > 4096)


