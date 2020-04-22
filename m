Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C78441B3D92
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbgDVKQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:16:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:50598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729653AbgDVKPU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:15:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFB902075A;
        Wed, 22 Apr 2020 10:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550519;
        bh=QeP+z2py5zehTf5cGkwbpGZ5Yi83zG6RPJpUo8i2+no=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kKb96tcpOcPEmPh1al3oOIgCVPbeuiZZZEw4szs7zCeckX/zNzsb+P37rx7QkEza1
         gE4UdcglqzbzryM/dLqtCpC8S+KQwVcT9du+tGI4rSvZge81uQJaX9gMKcbJLrVocV
         NLYh0P2eL72/V0lMSGoO6VcV2Kehf14dTGabxwXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 48/64] iommu/vt-d: Fix mm reference leak
Date:   Wed, 22 Apr 2020 11:57:32 +0200
Message-Id: <20200422095021.497253732@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095008.799686511@linuxfoundation.org>
References: <20200422095008.799686511@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

[ Upstream commit 902baf61adf6b187f0a6b789e70d788ea71ff5bc ]

Move canonical address check before mmget_not_zero() to avoid mm
reference leak.

Fixes: 9d8c3af31607 ("iommu/vt-d: IOMMU Page Request needs to check if address is canonical.")
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel-svm.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel-svm.c b/drivers/iommu/intel-svm.c
index 5944d3b4dca37..ef3aadec980ee 100644
--- a/drivers/iommu/intel-svm.c
+++ b/drivers/iommu/intel-svm.c
@@ -620,14 +620,15 @@ static irqreturn_t prq_event_thread(int irq, void *d)
 		 * any faults on kernel addresses. */
 		if (!svm->mm)
 			goto bad_req;
-		/* If the mm is already defunct, don't handle faults. */
-		if (!mmget_not_zero(svm->mm))
-			goto bad_req;
 
 		/* If address is not canonical, return invalid response */
 		if (!is_canonical_address(address))
 			goto bad_req;
 
+		/* If the mm is already defunct, don't handle faults. */
+		if (!mmget_not_zero(svm->mm))
+			goto bad_req;
+
 		down_read(&svm->mm->mmap_sem);
 		vma = find_extend_vma(svm->mm, address);
 		if (!vma || address < vma->vm_start)
-- 
2.20.1



