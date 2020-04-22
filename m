Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0351B3E8B
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730644AbgDVK0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:26:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730656AbgDVK0D (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:26:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD59120781;
        Wed, 22 Apr 2020 10:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587551163;
        bh=Lh/aVkzRGiJf794rdAEn6bIXmrdHDr/0NaGaE+pi0Js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SBJPfM8o0uO+xq+gq1vyVA0MxWc+Lf7PqRLVq2ft7OatProTHWZSZoJHCPLqhmbdp
         et8p2gHnYh3um6m0sbhIWKLv+A+lsjPbtXAyQEz4RixuXXgpWOugRlK1tBip3qbbJY
         JohPoYMoTJ0YvLJBx21iRco7HtFEoz+5qcFe5/tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 127/166] iommu/vt-d: Add build dependency on IOASID
Date:   Wed, 22 Apr 2020 11:57:34 +0200
Message-Id: <20200422095102.118034582@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



