Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885A329B8ED
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802105AbgJ0Pph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801067AbgJ0Pia (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:38:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 116B5207C4;
        Tue, 27 Oct 2020 15:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813109;
        bh=A+/aA+MZyoGPQHC8Mb8YDO++Qm9rhcBdY03BqUVE5bc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EKa1N0BYC2JaY+xlERJzcDGki6yF+z8kwihP4uEoZVgmHxLdkUF4a04jas/y+jfFD
         pEmgkNEt6altWq8hrseuoaCv/f4PjUSA6STsW3BkTTD42JB1ybOrHXm1U5gvtU6dZ4
         e3fJa6riNMet851VLYEjUDWfBQPVxETjLFC2QDSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gal Pressman <galpress@amazon.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 410/757] RDMA/umem: Fix signature of stub ib_umem_find_best_pgsz()
Date:   Tue, 27 Oct 2020 14:51:00 +0100
Message-Id: <20201027135509.801610703@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 61690d01db32eb1f94adc9ac2b8bb741d34e4671 ]

The original function returns unsigned long and 0 on failure.

Fixes: 4a35339958f1 ("RDMA/umem: Add API to find best driver supported page size in an MR")
Link: https://lore.kernel.org/r/0-v1-982a13cc5c6d+501ae-fix_best_pgsz_stub_jgg@nvidia.com
Reviewed-by: Gal Pressman <galpress@amazon.com>
Acked-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/rdma/ib_umem.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 71f573a418bf0..07a764eb692ee 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -68,10 +68,11 @@ static inline int ib_umem_copy_from(void *dst, struct ib_umem *umem, size_t offs
 		      		    size_t length) {
 	return -EINVAL;
 }
-static inline int ib_umem_find_best_pgsz(struct ib_umem *umem,
-					 unsigned long pgsz_bitmap,
-					 unsigned long virt) {
-	return -EINVAL;
+static inline unsigned long ib_umem_find_best_pgsz(struct ib_umem *umem,
+						   unsigned long pgsz_bitmap,
+						   unsigned long virt)
+{
+	return 0;
 }
 
 #endif /* CONFIG_INFINIBAND_USER_MEM */
-- 
2.25.1



