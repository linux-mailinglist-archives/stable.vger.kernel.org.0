Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2FF44B5DC
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245631AbhKIWXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:23:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:41762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343989AbhKIWWJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:22:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 396D261360;
        Tue,  9 Nov 2021 22:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496308;
        bh=gjUG6+LBHjMZ1Kr7edkSf0qs+90PlyljuxOKpiXbHnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VQTNuEweTrU3WWfTzlhCmQQn9OkZUKqPbovlQWS+2myUFtv/16fYKbUjDfi5+wQzh
         5+TE4YCxwD5UbY55GQ5h2WIzA2QywmveMWH6XQSP+w034CfLRI9EcYcTOCirA1kUje
         1CSl991dcwG7gqeKMqmO3pKRjkfv0nnGj4Ud6HJpxoWOiQmY7u2cj88VC/v/MhW1N4
         fqwgzVP0juUpfEmUG8aGX3wjEkSC8iYT3Bv4cBw/UrGsgpUVmy+Hka0vZ1sQggT4HQ
         2AuY341p7DNFgOKDDGBAxOg2cVsTFC5GwlAaS4998ZQ4hl8BhTzCwOymMIjoPmBHbw
         9C8oPK3W8XUEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Eero Tamminen <eero.t.tamminen@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>, joro@8bytes.org,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.15 59/82] iommu/vt-d: Do not falsely log intel_iommu is unsupported kernel option
Date:   Tue,  9 Nov 2021 17:16:17 -0500
Message-Id: <20211109221641.1233217-59-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
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
index d75f59ae28e6e..9a356075d3450 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -412,6 +412,7 @@ static int __init intel_iommu_setup(char *str)
 {
 	if (!str)
 		return -EINVAL;
+
 	while (*str) {
 		if (!strncmp(str, "on", 2)) {
 			dmar_disabled = 0;
@@ -441,13 +442,16 @@ static int __init intel_iommu_setup(char *str)
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

