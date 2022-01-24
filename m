Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C94F449A96C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322579AbiAYDWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:22:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36566 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356658AbiAXUa7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:30:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8412B8122F;
        Mon, 24 Jan 2022 20:30:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14446C340E5;
        Mon, 24 Jan 2022 20:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056256;
        bh=AVS6YlCd6nL9wQwBLEsf4GAKIMAubryRmJhe5dWA2fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dq3jE+DJu+z6H9qN5rxwyZkTvxJYM1m2sgLKWiGjhvpBK5CvTz8lw4IfJwYVesZM2
         kKSucoTJpdQvlYSygLWQir6/FxTE0t48TNkHbU4hvk275kLlzzQ9G9Dvvy9hv1x1MY
         Y+hP2SgcAMuKDoz5x+KBrkqnhdXEWVai7LD/FdLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 423/846] iommu/amd: Remove useless irq affinity notifier
Date:   Mon, 24 Jan 2022 19:39:00 +0100
Message-Id: <20220124184115.571529842@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

[ Upstream commit 575f5cfb13c84f324f9898383fa4a5694e53c9ef ]

iommu->intcapxt_notify field is no longer used
after a switch to a separate domain was done

Fixes: d1adcfbb520c ("iommu/amd: Fix IOMMU interrupt generation in X2APIC mode")
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20211123161038.48009-6-mlevitsk@redhat.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/amd_iommu_types.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index 8dbe61e2b3c15..8394c2787ff89 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -643,8 +643,6 @@ struct amd_iommu {
 	/* DebugFS Info */
 	struct dentry *debugfs;
 #endif
-	/* IRQ notifier for IntCapXT interrupt */
-	struct irq_affinity_notify intcapxt_notify;
 };
 
 static inline struct amd_iommu *dev_to_amd_iommu(struct device *dev)
-- 
2.34.1



