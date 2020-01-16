Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B55A13EF85
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392776AbgAPR3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:29:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:41522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392773AbgAPR3h (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:29:37 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 684FC24710;
        Thu, 16 Jan 2020 17:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195777;
        bh=2R4B2/vf3mjrXyH9tuvIXZbFvpPaJG90eTaq68jtLPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hjksb+TUUuU8hl4i1P4K2hn4oSz/PK4vrnojL0P34mZtpJ17Kdk19n1+Q/H3V3gGn
         N+KNv1eHMokJVFxCukVepG5yORNX0ivdXGExvI1NC3Q1OHcqYoRgbhZhTMF/nI9Acu
         UEDduoAU7ucMYAWnTGknhX9zr/8uYF/DJWRa3lB0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filippo Sironi <sironi@amazon.de>, Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.14 302/371] iommu/amd: Wait for completion of IOTLB flush in attach_device
Date:   Thu, 16 Jan 2020 12:22:54 -0500
Message-Id: <20200116172403.18149-245-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filippo Sironi <sironi@amazon.de>

[ Upstream commit 0b15e02f0cc4fb34a9160de7ba6db3a4013dc1b7 ]

To make sure the domain tlb flush completes before the
function returns, explicitly wait for its completion.

Signed-off-by: Filippo Sironi <sironi@amazon.de>
Fixes: 42a49f965a8d ("amd-iommu: flush domain tlb when attaching a new device")
[joro: Added commit message and fixes tag]
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd_iommu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index d09c24825734..778f167be2d3 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2160,6 +2160,8 @@ static int attach_device(struct device *dev,
 	 */
 	domain_flush_tlb_pde(domain);
 
+	domain_flush_complete(domain);
+
 	return ret;
 }
 
-- 
2.20.1

