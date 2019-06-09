Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA833A8A3
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388287AbfFIRCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:02:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388280AbfFIRCl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:02:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B57A206C3;
        Sun,  9 Jun 2019 17:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099760;
        bh=Ysv8MVANL+aQS4kM+idzj4ZuPxGYH7yNlLHqDFbdGQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nVydQy5qwohcGLSA/Ib7HOFX9r3Ffpx8R3CsYaQjSyPuALERtvmMCBp8x5ZuDhn8b
         nAMsokeZWX1ihG+teYDsrydl+6Fx6OJAD0YCdsxrW6WP1Pj9gawnrwnSDraQcbF5Lg
         Eit2e8lpi+Yq31BTuGdCrmQ3Yt7P7HF7e/BQuA2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 156/241] scsi: ufs: Fix regulator load and icc-level configuration
Date:   Sun,  9 Jun 2019 18:41:38 +0200
Message-Id: <20190609164152.271776031@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
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
index c94d465de941e..ed76381fce4cc 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4144,19 +4144,19 @@ static u32 ufshcd_find_max_sup_active_icc_level(struct ufs_hba *hba,
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
@@ -4390,6 +4390,15 @@ static int ufshcd_config_vreg_load(struct device *dev, struct ufs_vreg *vreg,
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



