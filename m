Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFCBBA6B5
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407880AbfIVSwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:52:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407872AbfIVSwY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:52:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94C5421479;
        Sun, 22 Sep 2019 18:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178343;
        bh=17ENxLHu3L2mMH6u0ZNP5nKyjgrAqv2BiX847xF1hn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l3MqsoQhWJyAqz3ZO/23kwum1JwfrNPwYy6JjFYsKcEufDgwkhI5SrlFW7AZoYlv4
         w0V5ewWFSbwqk3WLJ41rbCZ0KL/AuUaOe133znaJ6Q1XsVCiQuhCEivA1nljpjlgJA
         030xXl4fT303BsK83x8Bea+JFp3TGSojxNMJX3uE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yazen Ghannam <yazen.ghannam@amd.com>,
        Borislav Petkov <bp@suse.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        James Morse <james.morse@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 103/185] EDAC/amd64: Recognize DRAM device type ECC capability
Date:   Sun, 22 Sep 2019 14:48:01 -0400
Message-Id: <20190922184924.32534-103-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
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
index dd60cf5a3d969..ffe56a8fe39da 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -3150,12 +3150,15 @@ static bool ecc_enabled(struct pci_dev *F3, u16 nid)
 static inline void
 f17h_determine_edac_ctl_cap(struct mem_ctl_info *mci, struct amd64_pvt *pvt)
 {
-	u8 i, ecc_en = 1, cpk_en = 1;
+	u8 i, ecc_en = 1, cpk_en = 1, dev_x4 = 1, dev_x16 = 1;
 
 	for_each_umc(i) {
 		if (pvt->umc[i].sdp_ctrl & UMC_SDP_INIT) {
 			ecc_en &= !!(pvt->umc[i].umc_cap_hi & UMC_ECC_ENABLED);
 			cpk_en &= !!(pvt->umc[i].umc_cap_hi & UMC_ECC_CHIPKILL_CAP);
+
+			dev_x4  &= !!(pvt->umc[i].dimm_cfg & BIT(6));
+			dev_x16 &= !!(pvt->umc[i].dimm_cfg & BIT(7));
 		}
 	}
 
@@ -3163,8 +3166,15 @@ f17h_determine_edac_ctl_cap(struct mem_ctl_info *mci, struct amd64_pvt *pvt)
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

