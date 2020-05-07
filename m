Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7337F1C8F3F
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbgEGOaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:30:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:59002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728798AbgEGOaR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:30:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59CE820936;
        Thu,  7 May 2020 14:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861817;
        bh=CO+uLJ9HtvcYQ6CT6nxFh7UjZ++6KERn7qAMs6zWCrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lxUEcEC5E933FDW5SWaXIBvoiaxEggsarmRaOfOf4uECEA5GJXe3VxUSQSoPZkS0n
         74pc7Q6WTr6sDMpQe5hsZxxVQis2zrxj92EfQi6M9yXh+xUOeMK3fEo3wh+3xHSe86
         qXDsneHyfW8P/yL/fEJqrAaqeFDPq9Adw1ItQ1+4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.9 11/11] iommu/amd: Fix legacy interrupt remapping for x2APIC-enabled system
Date:   Thu,  7 May 2020 10:30:03 -0400
Message-Id: <20200507143003.27047-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507143003.27047-1-sashal@kernel.org>
References: <20200507143003.27047-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

[ Upstream commit b74aa02d7a30ee5e262072a7d6e8deff10b37924 ]

Currently, system fails to boot because the legacy interrupt remapping
mode does not enable 128-bit IRTE (GA), which is required for x2APIC
support.

Fix by using AMD_IOMMU_GUEST_IR_LEGACY_GA mode when booting with
kernel option amd_iommu_intr=legacy instead. The initialization
logic will check GASup and automatically fallback to using
AMD_IOMMU_GUEST_IR_LEGACY if GA mode is not supported.

Fixes: 3928aa3f5775 ("iommu/amd: Detect and enable guest vAPIC support")
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Link: https://lore.kernel.org/r/1587562202-14183-1-git-send-email-suravee.suthikulpanit@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd_iommu_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index c113e46fdc3ab..e6ae8d1239842 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -2574,7 +2574,7 @@ static int __init parse_amd_iommu_intr(char *str)
 {
 	for (; *str; ++str) {
 		if (strncmp(str, "legacy", 6) == 0) {
-			amd_iommu_guest_ir = AMD_IOMMU_GUEST_IR_LEGACY;
+			amd_iommu_guest_ir = AMD_IOMMU_GUEST_IR_LEGACY_GA;
 			break;
 		}
 		if (strncmp(str, "vapic", 5) == 0) {
-- 
2.20.1

