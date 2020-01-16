Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 703E613E9DE
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391206AbgAPRki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:40:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:57856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393643AbgAPRkh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:40:37 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAAC82473C;
        Thu, 16 Jan 2020 17:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196437;
        bh=qljT4y/A3k246iseBZPFaMQAh1Y9qLsRf7BctsBuqKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nnONuHuR5IWr8X/cMTSdSQ7hwMzAz8jzuVRrMfXV5oy2s8+7iFqQY1TlODQ4oxFpV
         NXQoaE/Pjgmka0xermbvndzgvZOioNNO0kA1O5MwnS78LYLL+DnZemgMaGyPIJK8/H
         9STpOFE/wRD2CNyrOqwyv4Lr7Tz74rK0qf+Lm4NU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filippo Sironi <sironi@amazon.de>, Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.9 202/251] iommu/amd: Wait for completion of IOTLB flush in attach_device
Date:   Thu, 16 Jan 2020 12:35:51 -0500
Message-Id: <20200116173641.22137-162-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
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
index c898c70472bb..bb0448c91f67 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2113,6 +2113,8 @@ static int attach_device(struct device *dev,
 	 */
 	domain_flush_tlb_pde(domain);
 
+	domain_flush_complete(domain);
+
 	return ret;
 }
 
-- 
2.20.1

