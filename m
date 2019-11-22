Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDBAF1062C4
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbfKVGGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:06:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:41000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729710AbfKVGCY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 01:02:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1029820714;
        Fri, 22 Nov 2019 06:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402543;
        bh=SIJ+2AtMRSVhyjKuNp+YgzLxZeDID8jWrYk0fqKMcMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rfHjXdBjPuM1JUh9N6/bXmC85/t0yq1zAhVC+iAAhv8xOO4I41SPbhtoeSoQKpaF9
         bzd0o99TDUaNsp8VnNquRgPR26tgeZod2FjVbyBfutNNotVfckGEl9EckB9LM5djRn
         X2YO6cw4KrgcK3EMGpNVetBcn7yOnwBXxi/rvKEk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 50/91] vfio/spapr_tce: Get rid of possible infinite loop
Date:   Fri, 22 Nov 2019 01:00:48 -0500
Message-Id: <20191122060129.4239-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122060129.4239-1-sashal@kernel.org>
References: <20191122060129.4239-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

[ Upstream commit 517ad4ae8aa93dccdb9a88c27257ecb421c9e848 ]

As a part of cleanup, the SPAPR TCE IOMMU subdriver releases preregistered
memory. If there is a bug in memory release, the loop in
tce_iommu_release() becomes infinite; this actually happened to me.

This makes the loop finite and prints a warning on every failure to make
the code more bug prone.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Reviewed-by: David Gibson <david@gibson.dropbear.id.au>
Acked-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio_iommu_spapr_tce.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index 70c748a5fbcc2..a8e25f9409fa5 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -406,6 +406,7 @@ static void tce_iommu_release(void *iommu_data)
 {
 	struct tce_container *container = iommu_data;
 	struct tce_iommu_group *tcegrp;
+	struct tce_iommu_prereg *tcemem, *tmtmp;
 	long i;
 
 	while (tce_groups_attached(container)) {
@@ -428,13 +429,8 @@ static void tce_iommu_release(void *iommu_data)
 		tce_iommu_free_table(container, tbl);
 	}
 
-	while (!list_empty(&container->prereg_list)) {
-		struct tce_iommu_prereg *tcemem;
-
-		tcemem = list_first_entry(&container->prereg_list,
-				struct tce_iommu_prereg, next);
-		WARN_ON_ONCE(tce_iommu_prereg_free(container, tcemem));
-	}
+	list_for_each_entry_safe(tcemem, tmtmp, &container->prereg_list, next)
+		WARN_ON(tce_iommu_prereg_free(container, tcemem));
 
 	tce_iommu_disable(container);
 	if (container->mm)
-- 
2.20.1

