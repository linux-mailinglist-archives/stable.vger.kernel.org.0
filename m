Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81C712F297
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730059AbfE3DPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:15:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728325AbfE3DO7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:14:59 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27F672456F;
        Thu, 30 May 2019 03:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186098;
        bh=jCWnGsAAbuluNuNPeEC/tiHdJn5qmn0z9MOTxt9bhV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i2xFpfKQd2mdFacyPqSm933rgrXe15IHyreTj4KBXYoTKQUanQJG7ZS4CJYUW1NhO
         j78UB1/x/qvmgrztBjwiW/6C0V+j5h1MB2bdEkZOmIUV4j/SAzH+6BTwaIh0puOSsJ
         Wvn0SrlRscO7DLoXPJzgAeBOF31a4IZTNwC9Q0GU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 233/346] scsi: ufs: Fix regulator load and icc-level configuration
Date:   Wed, 29 May 2019 20:05:06 -0700
Message-Id: <20190530030552.848943898@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0487fff76632ec023d394a05b82e87a971db8c03 ]

Currently if a regulator has "<name>-fixed-regulator" property in device
tree, it will skip current limit initialization.  This lead to a zero
"max_uA" value in struct ufs_vreg.

However, "regulator_set_load" operation shall be required on regulators
which have valid current limits, otherwise a zero "max_uA" set by
"regulator_set_load" may cause unexpected behavior when this regulator is
enabled or set as high power mode.

Similarly, in device's icc_level configuration flow, the target icc_level
shall be updated if regulator also has valid current limit, otherwise a
wrong icc_level will be calculated by zero "max_uA" and thus causes
unexpected results after it is written to device.

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Acked-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 2ddf24466a62e..75d7267b73879 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6286,19 +6286,19 @@ static u32 ufshcd_find_max_sup_active_icc_level(struct ufs_hba *hba,
 		goto out;
 	}
 
-	if (hba->vreg_info.vcc)
+	if (hba->vreg_info.vcc && hba->vreg_info.vcc->max_uA)
 		icc_level = ufshcd_get_max_icc_level(
 				hba->vreg_info.vcc->max_uA,
 				POWER_DESC_MAX_ACTV_ICC_LVLS - 1,
 				&desc_buf[PWR_DESC_ACTIVE_LVLS_VCC_0]);
 
-	if (hba->vreg_info.vccq)
+	if (hba->vreg_info.vccq && hba->vreg_info.vccq->max_uA)
 		icc_level = ufshcd_get_max_icc_level(
 				hba->vreg_info.vccq->max_uA,
 				icc_level,
 				&desc_buf[PWR_DESC_ACTIVE_LVLS_VCCQ_0]);
 
-	if (hba->vreg_info.vccq2)
+	if (hba->vreg_info.vccq2 && hba->vreg_info.vccq2->max_uA)
 		icc_level = ufshcd_get_max_icc_level(
 				hba->vreg_info.vccq2->max_uA,
 				icc_level,
@@ -7001,6 +7001,15 @@ static int ufshcd_config_vreg_load(struct device *dev, struct ufs_vreg *vreg,
 	if (!vreg)
 		return 0;
 
+	/*
+	 * "set_load" operation shall be required on those regulators
+	 * which specifically configured current limitation. Otherwise
+	 * zero max_uA may cause unexpected behavior when regulator is
+	 * enabled or set as high power mode.
+	 */
+	if (!vreg->max_uA)
+		return 0;
+
 	ret = regulator_set_load(vreg->reg, ua);
 	if (ret < 0) {
 		dev_err(dev, "%s: %s set load (ua=%d) failed, err=%d\n",
-- 
2.20.1



