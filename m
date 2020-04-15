Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E5E1AA283
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505578AbgDOM4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:56:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897188AbgDOLgz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:36:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1A1321582;
        Wed, 15 Apr 2020 11:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950615;
        bh=Lh/aVkzRGiJf794rdAEn6bIXmrdHDr/0NaGaE+pi0Js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jNopdLB0c3vCNfqass8jIKcY4/bhdeowJ29yCo4UGUOc1cWl05gbYU8CptZFceUpE
         iAcs3/pMMP0QZZOPcGhm2yxOR1eAMGp0J1QISXRhXJ+hk5mql0rGbQ8ubAl0RZx4GF
         kmPDaFte6FcyYjGDFVQAPFAoThOJYRJeJcPR81jI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.6 108/129] iommu/vt-d: Add build dependency on IOASID
Date:   Wed, 15 Apr 2020 07:34:23 -0400
Message-Id: <20200415113445.11881-108-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415113445.11881-1-sashal@kernel.org>
References: <20200415113445.11881-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

[ Upstream commit 4a663dae47316ae8b97d5b77025fe7dfd9d3487f ]

IOASID code is needed by VT-d scalable mode for PASID allocation.
Add explicit dependency such that IOASID is built-in whenever Intel
IOMMU is enabled.
Otherwise, aux domain code will fail when IOMMU is built-in and IOASID
is compiled as a module.

Fixes: 59a623374dc38 ("iommu/vt-d: Replace Intel specific PASID allocator with IOASID")
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index d2fade9849997..25149544d57c9 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -188,6 +188,7 @@ config INTEL_IOMMU
 	select NEED_DMA_MAP_STATE
 	select DMAR_TABLE
 	select SWIOTLB
+	select IOASID
 	help
 	  DMA remapping (DMAR) devices support enables independent address
 	  translations for Direct Memory Access (DMA) from devices.
-- 
2.20.1

