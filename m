Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7037192A2
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfEITJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 15:09:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726928AbfEISoN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:44:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26A622183F;
        Thu,  9 May 2019 18:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427452;
        bh=kK9Pt881y0iJMVCE/1Tw2pAk1AeqHYFGjcCEGqps8o4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lTXtCp5SlbkkxmrZ3J9gAzHo44wG84edbrv64ev9M3rgX8qXtFvn612yIixFtHLjD
         TgGXZu8FHxbxa35ShU6b+MZmHiVEhyA0V4h2/uwwQF/HW94fEVJow3lRio1VbEHcM6
         Y248HiswEl87+tGsITgs17kpRSi79iu7soIDsXz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 16/28] iommu/amd: Set exclusion range correctly
Date:   Thu,  9 May 2019 20:42:08 +0200
Message-Id: <20190509181253.539116825@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181247.647767531@linuxfoundation.org>
References: <20190509181247.647767531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3c677d206210f53a4be972211066c0f1cd47fe12 ]

The exlcusion range limit register needs to contain the
base-address of the last page that is part of the range, as
bits 0-11 of this register are treated as 0xfff by the
hardware for comparisons.

So correctly set the exclusion range in the hardware to the
last page which is _in_ the range.

Fixes: b2026aa2dce44 ('x86, AMD IOMMU: add functions for programming IOMMU MMIO space')
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd_iommu_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 157e93421fb81..13bbe5795e4e4 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -318,7 +318,7 @@ static void iommu_write_l2(struct amd_iommu *iommu, u8 address, u32 val)
 static void iommu_set_exclusion_range(struct amd_iommu *iommu)
 {
 	u64 start = iommu->exclusion_start & PAGE_MASK;
-	u64 limit = (start + iommu->exclusion_length) & PAGE_MASK;
+	u64 limit = (start + iommu->exclusion_length - 1) & PAGE_MASK;
 	u64 entry;
 
 	if (!iommu->exclusion_start)
-- 
2.20.1



