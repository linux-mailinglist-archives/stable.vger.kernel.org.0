Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4299C260143
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 19:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730910AbgIGRCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 13:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729835AbgIGQd1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 12:33:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4937821927;
        Mon,  7 Sep 2020 16:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496406;
        bh=MfRNgySIkpHHnYNgad/82iP6adXIbt8e2kLzPLxy684=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aISA6hhybXRrGXN/MWFBn5JBR09pWSFPhkSAV/cVy5mE/mbpMwLbO6QrnUYy30jmq
         jT6WJ2fuYaFmMHL+1syaff3+PaBGYmSY86JaCjOHF+e4WtTmYBkT4uQ8JPxp1IyNfO
         2UTYKpTuEXEUrSOcmJtsBF4SLS/mMMh0Wqyz1+hs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.8 52/53] iommu/amd: Do not use IOMMUv2 functionality when SME is active
Date:   Mon,  7 Sep 2020 12:32:18 -0400
Message-Id: <20200907163220.1280412-52-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163220.1280412-1-sashal@kernel.org>
References: <20200907163220.1280412-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

[ Upstream commit 2822e582501b65707089b097e773e6fd70774841 ]

When memory encryption is active the device is likely not in a direct
mapped domain. Forbid using IOMMUv2 functionality for now until finer
grained checks for this have been implemented.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Link: https://lore.kernel.org/r/20200824105415.21000-3-joro@8bytes.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu_v2.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/iommu/amd/iommu_v2.c b/drivers/iommu/amd/iommu_v2.c
index e4b025c5637c4..5a188cac7a0f1 100644
--- a/drivers/iommu/amd/iommu_v2.c
+++ b/drivers/iommu/amd/iommu_v2.c
@@ -737,6 +737,13 @@ int amd_iommu_init_device(struct pci_dev *pdev, int pasids)
 
 	might_sleep();
 
+	/*
+	 * When memory encryption is active the device is likely not in a
+	 * direct-mapped domain. Forbid using IOMMUv2 functionality for now.
+	 */
+	if (mem_encrypt_active())
+		return -ENODEV;
+
 	if (!amd_iommu_v2_supported())
 		return -ENODEV;
 
-- 
2.25.1

