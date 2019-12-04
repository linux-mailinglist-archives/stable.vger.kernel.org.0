Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A439511323D
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbfLDSGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:06:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:55560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728490AbfLDSGq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:06:46 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2F3520675;
        Wed,  4 Dec 2019 18:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482805;
        bh=Qfbrh3CAl/9De393ORqQNDprdkPEaFRcGApPRM3ToAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MQyq6/yKgp9sbPWfGb7GpO3N4TiNhj64aauWxFF0UNY/Z8fqGo1n2K5KkpFVwPTgb
         cueRXsKchQnRwOlen+gTLtNMREGrxpDPJalYv2noAXCT1HA9IqLDdmnkwLHOzF0CuS
         23td3Mk8rPXK+qjD23Y+hzkol7ZLdsoxLf6P5Dl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 097/209] vfio/spapr_tce: Get rid of possible infinite loop
Date:   Wed,  4 Dec 2019 18:55:09 +0100
Message-Id: <20191204175328.542496478@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b4c68f3b82be9..eba9aaf3cc17c 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -409,6 +409,7 @@ static void tce_iommu_release(void *iommu_data)
 {
 	struct tce_container *container = iommu_data;
 	struct tce_iommu_group *tcegrp;
+	struct tce_iommu_prereg *tcemem, *tmtmp;
 	long i;
 
 	while (tce_groups_attached(container)) {
@@ -431,13 +432,8 @@ static void tce_iommu_release(void *iommu_data)
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



