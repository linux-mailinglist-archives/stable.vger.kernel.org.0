Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F5F37CE4E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239374AbhELRE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:04:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:35834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237858AbhELQnN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:43:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71CD561E63;
        Wed, 12 May 2021 16:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836027;
        bh=s3fs+d7DM0D3Pak4pMME1GorsdZa5K1kStQQtzsU3DA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JYjjn4z3LXX2pshfrhmwaNlCqTYUfO+0zZGT4FO1nbOiuLp63uiOwimqGrz1Z5TXb
         6Qd3xPYP6NmkWcARl4DXxETj6EkK0yNjUD9f7GMWuNeYsfSPDmjENL9/LShfzS6z7K
         +NioNeAMO0LeB/emOepkk6Q4X9h0Z8iZq1Sz2CXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, iommu@lists.linux-foundation.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Robert Richter <rrichter@amd.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 581/677] iommu/amd: Put newline after closing bracket in warning
Date:   Wed, 12 May 2021 16:50:27 +0200
Message-Id: <20210512144856.691534251@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Menzel <pmenzel@molgen.mpg.de>

[ Upstream commit 304c73ba69459d4c18c2a4b843be6f5777b4b85c ]

Currently, on the Dell OptiPlex 5055 the EFR mismatch warning looks like
below.

    [    1.479774] smpboot: CPU0: AMD Ryzen 5 PRO 1500 Quad-Core Processor (family: 0x17, model: 0x1, stepping: 0x1)
    […]
    [    2.507370] AMD-Vi: [Firmware Warn]: EFR mismatch. Use IVHD EFR (0xf77ef22294ada : 0x400f77ef22294ada
                   ).

Add the newline after the `).`, so it’s on one line.

Fixes: a44092e326d4 ("iommu/amd: Use IVHD EFR for early initialization of IOMMU features")
Cc: iommu@lists.linux-foundation.org
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Robert Richter <rrichter@amd.com>
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
Link: https://lore.kernel.org/r/20210412180141.29605-1-pmenzel@molgen.mpg.de
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 321f5906e6ed..f7e31018cd0b 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -1837,7 +1837,7 @@ static void __init late_iommu_features_init(struct amd_iommu *iommu)
 	 * IVHD and MMIO conflict.
 	 */
 	if (features != iommu->features)
-		pr_warn(FW_WARN "EFR mismatch. Use IVHD EFR (%#llx : %#llx\n).",
+		pr_warn(FW_WARN "EFR mismatch. Use IVHD EFR (%#llx : %#llx).\n",
 			features, iommu->features);
 }
 
-- 
2.30.2



