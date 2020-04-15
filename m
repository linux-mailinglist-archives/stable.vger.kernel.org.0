Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6571A9FA5
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409270AbgDOLqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:46:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:40832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409259AbgDOLqG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:46:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F5762078A;
        Wed, 15 Apr 2020 11:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951165;
        bh=oInKObr4lNnwZetiYJiXWFagFaAcWKQY3usP8woXmFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cVF54EiJgJKFW0meUv9FozxWLisUNHZ/N9CPYZH6Z2EJAPY8riyih4mgt7mjFrzk7
         aliS1nNNd1DoNmxDbXiN8SzhR4Ysx1SF2wVT/CBCL813YUGGopK/wp1g38VtvsrJzt
         kEDts+OhS8u85fXOOGBgXHQ4JoJ7TZPvj9weWvSg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.4 70/84] iommu/vt-d: Fix mm reference leak
Date:   Wed, 15 Apr 2020 07:44:27 -0400
Message-Id: <20200415114442.14166-70-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114442.14166-1-sashal@kernel.org>
References: <20200415114442.14166-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 518d0b2d12afd..3020506180c10 100644
--- a/drivers/iommu/intel-svm.c
+++ b/drivers/iommu/intel-svm.c
@@ -583,14 +583,15 @@ static irqreturn_t prq_event_thread(int irq, void *d)
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

