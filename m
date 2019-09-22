Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12596BA547
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 20:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408135AbfIVSz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:55:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408127AbfIVSz7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:55:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E0B1206C2;
        Sun, 22 Sep 2019 18:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178558;
        bh=2RCEg7l97LRwKRzZakcVXzs9bT+W5NfSG1bK1ShynnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X0vuYwA1ReBKJGVmJ/5hZj1CkAP9RdcBr7/SxSDDQu7rC9LwJBzeRbRVtJiyFf4GB
         amgc3yu0tJ+hfD5BNVhUv5A4zfoGdrH/78ZRKdDVCfyPRh4VLKwsuTuqjvkIrO8dl9
         PBXJHFLDy5ZAplnhDkFrDaXSiJM5PUVQyKEozTzI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yazen Ghannam <yazen.ghannam@amd.com>,
        Borislav Petkov <bp@suse.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        James Morse <james.morse@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 073/128] EDAC/amd64: Recognize DRAM device type ECC capability
Date:   Sun, 22 Sep 2019 14:53:23 -0400
Message-Id: <20190922185418.2158-73-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185418.2158-1-sashal@kernel.org>
References: <20190922185418.2158-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yazen Ghannam <yazen.ghannam@amd.com>

[ Upstream commit f8be8e5680225ac9caf07d4545f8529b7395327f ]

AMD Family 17h systems support x4 and x16 DRAM devices. However, the
device type is not checked when setting mci.edac_ctl_cap.

Set the appropriate capability flag based on the device type.

Default to x8 DRAM device when neither the x4 or x16 bits are set.

 [ bp: reverse cpk_en check to save an indentation level. ]

Fixes: 2d09d8f301f5 ("EDAC, amd64: Determine EDAC MC capabilities on Fam17h")
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Link: https://lkml.kernel.org/r/20190821235938.118710-3-Yazen.Ghannam@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/amd64_edac.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index e2addb2bca296..1613df20774f9 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -3101,12 +3101,15 @@ static bool ecc_enabled(struct pci_dev *F3, u16 nid)
 static inline void
 f17h_determine_edac_ctl_cap(struct mem_ctl_info *mci, struct amd64_pvt *pvt)
 {
-	u8 i, ecc_en = 1, cpk_en = 1;
+	u8 i, ecc_en = 1, cpk_en = 1, dev_x4 = 1, dev_x16 = 1;
 
 	for (i = 0; i < NUM_UMCS; i++) {
 		if (pvt->umc[i].sdp_ctrl & UMC_SDP_INIT) {
 			ecc_en &= !!(pvt->umc[i].umc_cap_hi & UMC_ECC_ENABLED);
 			cpk_en &= !!(pvt->umc[i].umc_cap_hi & UMC_ECC_CHIPKILL_CAP);
+
+			dev_x4  &= !!(pvt->umc[i].dimm_cfg & BIT(6));
+			dev_x16 &= !!(pvt->umc[i].dimm_cfg & BIT(7));
 		}
 	}
 
@@ -3114,8 +3117,15 @@ f17h_determine_edac_ctl_cap(struct mem_ctl_info *mci, struct amd64_pvt *pvt)
 	if (ecc_en) {
 		mci->edac_ctl_cap |= EDAC_FLAG_SECDED;
 
-		if (cpk_en)
+		if (!cpk_en)
+			return;
+
+		if (dev_x4)
 			mci->edac_ctl_cap |= EDAC_FLAG_S4ECD4ED;
+		else if (dev_x16)
+			mci->edac_ctl_cap |= EDAC_FLAG_S16ECD16ED;
+		else
+			mci->edac_ctl_cap |= EDAC_FLAG_S8ECD8ED;
 	}
 }
 
-- 
2.20.1

