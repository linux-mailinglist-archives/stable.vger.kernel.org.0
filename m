Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C77F52C9BDE
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390007AbgLAJMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:12:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:50318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390022AbgLAJMx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:12:53 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31C5420770;
        Tue,  1 Dec 2020 09:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813957;
        bh=M+XAIcM5levjL+hXw4vdea57kjm6p9vwSMf2RP4oqpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RPv8+Vx9xmrnhIxiuiJoXGfaBjj28Emp3IU67/tslv/NIJ7djNweZQPBXgk5PJVcU
         SLsQlmdCRCNL1ECNRrtrVl+8YI1RqXsEdnJm3c3SgG08Mz1ZJbZ5FYPJA5jr1l+8rB
         04wmqrK/rCo6BHdctuayeBKTQK4llZVm++TnV0os=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        Adrian Huang <ahuang12@lenovo.com>
Subject: [PATCH 5.9 118/152] x86/tboot: Dont disable swiotlb when iommu is forced on
Date:   Tue,  1 Dec 2020 09:53:53 +0100
Message-Id: <20201201084727.257311425@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit e2be2a833ab5338fa5b8b99ba622b911d96f1795 ]

After commit 327d5b2fee91c ("iommu/vt-d: Allow 32bit devices to uses DMA
domain"), swiotlb could also be used for direct memory access if IOMMU
is enabled but a device is configured to pass through the DMA translation.
Keep swiotlb when IOMMU is forced on, otherwise, some devices won't work
if "iommu=pt" kernel parameter is used.

Fixes: 327d5b2fee91 ("iommu/vt-d: Allow 32bit devices to uses DMA domain")
Reported-and-tested-by: Adrian Huang <ahuang12@lenovo.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20201125014124.4070776-1-baolu.lu@linux.intel.com
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=210237
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/tboot.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index 420be871d9d45..ae64f98ec2ab6 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -514,13 +514,10 @@ int tboot_force_iommu(void)
 	if (!tboot_enabled())
 		return 0;
 
-	if (no_iommu || swiotlb || dmar_disabled)
+	if (no_iommu || dmar_disabled)
 		pr_warn("Forcing Intel-IOMMU to enabled\n");
 
 	dmar_disabled = 0;
-#ifdef CONFIG_SWIOTLB
-	swiotlb = 0;
-#endif
 	no_iommu = 0;
 
 	return 1;
-- 
2.27.0



