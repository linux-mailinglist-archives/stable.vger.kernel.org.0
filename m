Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1A624A8E13
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354469AbiBCUfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:35:01 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36244 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354643AbiBCUdm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:33:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E3B2B835A9;
        Thu,  3 Feb 2022 20:33:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B9DC340E8;
        Thu,  3 Feb 2022 20:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920420;
        bh=Y4I1XbzZkketrSB1+LOJA9GxTunIlw/Msl9gsyKUgh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tV5OxCNbVUmXyMeCjkcqrGJijUkfygCsLAdJcrUhnHBdVqcybLRceA5exWe5jC8oW
         rF4msIOK2Ja0x6kcNUI9EKxD12hbdo/4SelCt7zNQmfDCekf2yzAGCgJe+qXq4NbBs
         bjZcQp9DRArx6eyW/ttUXGOW04Xmpx+howysXjgtABQ9PfcL3T5dzjIWyxp7+6+Bzl
         MzEjqDU3EXjSryUJasQcUcejeMsgSkKFJhmNPucpqqgq40a+43ByJYC4KYycDIbZvf
         SHrHKX8bZTEnY3DvtPmfVb0xryqiba3hZWIhG92UADFldFtZ249ducJjTr1jc7FH+s
         X4P8cx4KDvSgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaoke Wang <xkernel.wang@foxmail.com>,
        Bean Huo <beanhuo@micron.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        bvanassche@acm.org, stanley.chu@mediatek.com, avri.altman@wdc.com,
        s.shtylyov@omprussia.ru, srinivas.kandagatla@linaro.org,
        huyue2@yulong.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 24/41] scsi: ufs: ufshcd-pltfrm: Check the return value of devm_kstrdup()
Date:   Thu,  3 Feb 2022 15:32:28 -0500
Message-Id: <20220203203245.3007-24-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203245.3007-1-sashal@kernel.org>
References: <20220203203245.3007-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoke Wang <xkernel.wang@foxmail.com>

[ Upstream commit a65b32748f4566f986ba2495a8236c141fa42a26 ]

devm_kstrdup() returns pointer to allocated string on success, NULL on
failure. So it is better to check the return value of it.

Link: https://lore.kernel.org/r/tencent_4257E15D4A94FF9020DDCC4BB9B21C041408@qq.com
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 8b16bbbcb806c..87975d1a21c8b 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -92,6 +92,11 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 		clki->min_freq = clkfreq[i];
 		clki->max_freq = clkfreq[i+1];
 		clki->name = devm_kstrdup(dev, name, GFP_KERNEL);
+		if (!clki->name) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
 		if (!strcmp(name, "ref_clk"))
 			clki->keep_link_active = true;
 		dev_dbg(dev, "%s: min %u max %u name %s\n", "freq-table-hz",
@@ -127,6 +132,8 @@ static int ufshcd_populate_vreg(struct device *dev, const char *name,
 		return -ENOMEM;
 
 	vreg->name = devm_kstrdup(dev, name, GFP_KERNEL);
+	if (!vreg->name)
+		return -ENOMEM;
 
 	snprintf(prop_name, MAX_PROP_SIZE, "%s-max-microamp", name);
 	if (of_property_read_u32(np, prop_name, &vreg->max_uA)) {
-- 
2.34.1

