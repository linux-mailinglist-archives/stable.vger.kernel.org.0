Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157A637C55E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234486AbhELPjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:39:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233628AbhELPdz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:33:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8786E61C35;
        Wed, 12 May 2021 15:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832637;
        bh=xBnnw+oRUG0J5VV86b4KwUe+R5KtRj6Wdk0I7DAuAeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kbz4QBuQbflR0565sBWA9SRFqALWJ/wo4STxtWskXoiJoU1rx4Z8UmhdQLMSeRn7O
         D+aQ6Gbb9RPcGO+x4nOU6uVSvPk4C/cXo0abwPpdrxKAsnaRFRLpTRn48mpAJlcvWK
         kitF1HE9J1d/4wpjVQLW6SJZw0sMirkiyf7yQpTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 360/530] iommu/vt-d: Reject unsupported page request modes
Date:   Wed, 12 May 2021 16:47:50 +0200
Message-Id: <20210512144831.614905781@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

[ Upstream commit 78a523fe73b81b4447beb2d6c78c9fafae24eebb ]

When supervisor/privilige mode SVM is used, we bind init_mm.pgd with
a supervisor PASID. There should not be any page fault for init_mm.
Execution request with DMA read is also not supported.

This patch checks PRQ descriptor for both unsupported configurations,
reject them both with invalid responses.

Fixes: 1c4f88b7f1f92 ("iommu/vt-d: Shared virtual address in scalable mode")
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Link: https://lore.kernel.org/r/1614680040-1989-4-git-send-email-jacob.jun.pan@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/svm.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index b200a3acc6ed..5c95e9693bf5 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -959,7 +959,17 @@ static irqreturn_t prq_event_thread(int irq, void *d)
 			       ((unsigned long long *)req)[1]);
 			goto no_pasid;
 		}
-
+		/* We shall not receive page request for supervisor SVM */
+		if (req->pm_req && (req->rd_req | req->wr_req)) {
+			pr_err("Unexpected page request in Privilege Mode");
+			/* No need to find the matching sdev as for bad_req */
+			goto no_pasid;
+		}
+		/* DMA read with exec requeset is not supported. */
+		if (req->exe_req && req->rd_req) {
+			pr_err("Execution request not supported\n");
+			goto no_pasid;
+		}
 		if (!svm || svm->pasid != req->pasid) {
 			rcu_read_lock();
 			svm = ioasid_find(NULL, req->pasid, NULL);
-- 
2.30.2



