Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A55F29B4AD
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1789828AbgJ0PDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:03:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753874AbgJ0PDH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:03:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64E8021707;
        Tue, 27 Oct 2020 15:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810987;
        bh=00VfQAyHIhYkNU+oPuPIMFUTURpy2UggZAz4orAQ9dI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I8i4WKYF38GUGh+GA24OmvwXr5+yhuQfJY7fhzl/hS9ue9qVykRBlAe/wXn8D3I0W
         IaazXkQPGTwdrq/INXN8YnefcWhELShqnucTZknQC2S/Y1FguNX66V+o4dH9eNZva+
         IHSvH34eqjX2Cwa6XaRlpc9dPR/sMdeTcpq7AfKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gal Pressman <galpress@amazon.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 333/633] RDMA/umem: Fix signature of stub ib_umem_find_best_pgsz()
Date:   Tue, 27 Oct 2020 14:51:16 +0100
Message-Id: <20201027135538.304085260@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
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
index e3518fd6b95b1..9353910915d41 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -95,10 +95,11 @@ static inline int ib_umem_copy_from(void *dst, struct ib_umem *umem, size_t offs
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



