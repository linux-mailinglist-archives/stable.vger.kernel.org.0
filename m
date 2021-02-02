Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B2230C2E3
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 16:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234933AbhBBPDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 10:03:05 -0500
Received: from 8bytes.org ([81.169.241.247]:54122 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234847AbhBBPC6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 10:02:58 -0500
X-Greylist: delayed 464 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Feb 2021 10:02:57 EST
Received: from cap.home.8bytes.org (p549adcf6.dip0.t-ipconnect.de [84.154.220.246])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id E2AC1171;
        Tue,  2 Feb 2021 15:54:27 +0100 (CET)
From:   Joerg Roedel <joro@8bytes.org>
To:     iommu@lists.linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        stable@vger.kernel.org
Subject: [PATCH] iommu: Check dev->iommu in dev_iommu_priv_get() before dereferencing it
Date:   Tue,  2 Feb 2021 15:54:19 +0100
Message-Id: <20210202145419.29143-1-joro@8bytes.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The dev_iommu_priv_get() needs a similar check to
dev_iommu_fwspec_get() to make sure no NULL-ptr is dereferenced.

Fixes: 05a0542b456e1 ("iommu/amd: Store dev_data as device iommu private data")
Reference: https://bugzilla.kernel.org/show_bug.cgi?id=211241
Cc: stable@vger.kernel.org	# v5.8+
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 include/linux/iommu.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 524ffc2ff64f..5b3a7a08dc70 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -616,7 +616,10 @@ static inline void dev_iommu_fwspec_set(struct device *dev,
 
 static inline void *dev_iommu_priv_get(struct device *dev)
 {
-	return dev->iommu->priv;
+	if (dev->iommu)
+		return dev->iommu->priv;
+	else
+		return NULL;
 }
 
 static inline void dev_iommu_priv_set(struct device *dev, void *priv)
-- 
2.30.0

