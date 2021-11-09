Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D970844B6F4
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344863AbhKIWax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:30:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:51456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344898AbhKIW2s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:28:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F75B61A4E;
        Tue,  9 Nov 2021 22:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496434;
        bh=O6e18vFZhKt3sYLd34LORcnLDzPlwi0fHOrjzZsA4EI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ALLDALF32xzxhANvydqM03EQw/f7qvGwURoB/OUTQLW1gTy03p/0xAcDJBzSqdkIt
         IfiPCYr/F9bsCg4JXeSQgjgmRmYGrKVHPy29+HRE6H+GJiCywYZKH/eOFsagu7ZVCC
         vGioe/n5MSkcE+09N33aM/Zj4fHUB0OaxE9E/27t0iPUc62AtNA2vjnZAJD/IuYWfH
         /mlPWWT6DP7L7wRegJ36/t907B1IJiUWLxigDPH1/YW3+frfs/33eXoD4bNsj4ykMC
         Xxzt5eTUj+ngqBcuPKx5WAiTb2c3nkcsL2v0iGWMJFIEdSd1JhysRoLn9YHfIMzj/u
         F3z+cQdq/dzCg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Eero Tamminen <eero.t.tamminen@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>, joro@8bytes.org,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.14 55/75] iommu/vt-d: Do not falsely log intel_iommu is unsupported kernel option
Date:   Tue,  9 Nov 2021 17:18:45 -0500
Message-Id: <20211109221905.1234094-55-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221905.1234094-1-sashal@kernel.org>
References: <20211109221905.1234094-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

[ Upstream commit 5240aed2cd2594fb392239f11b9681e5e1591619 ]

Handling of intel_iommu kernel command line option should return "true" to
indicate option is valid and so avoid logging it as unknown by the core
parsing code.

Also log unknown sub-options at the notice level to let user know of
potential typos or similar.

Reported-by: Eero Tamminen <eero.t.tamminen@intel.com>
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://lore.kernel.org/r/20210831112947.310080-1-tvrtko.ursulin@linux.intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20211014053839.727419-2-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index dd22fc7d51764..663ef69769f2b 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -439,6 +439,7 @@ static int __init intel_iommu_setup(char *str)
 {
 	if (!str)
 		return -EINVAL;
+
 	while (*str) {
 		if (!strncmp(str, "on", 2)) {
 			dmar_disabled = 0;
@@ -465,13 +466,16 @@ static int __init intel_iommu_setup(char *str)
 		} else if (!strncmp(str, "tboot_noforce", 13)) {
 			pr_info("Intel-IOMMU: not forcing on after tboot. This could expose security risk for tboot\n");
 			intel_iommu_tboot_noforce = 1;
+		} else {
+			pr_notice("Unknown option - '%s'\n", str);
 		}
 
 		str += strcspn(str, ",");
 		while (*str == ',')
 			str++;
 	}
-	return 0;
+
+	return 1;
 }
 __setup("intel_iommu=", intel_iommu_setup);
 
-- 
2.33.0

