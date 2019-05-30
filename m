Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9E922F564
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728631AbfE3Eq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:46:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728604AbfE3DLf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:35 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C37F024481;
        Thu, 30 May 2019 03:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185894;
        bh=zPhkdEyPvLEDVt6X262QEz0UmdGy+4Dt+gYYbqb9aNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TQDKMxDoogpg5fwN6aMpcjmT1aQRqVc1hQw6FD4L0od7GkQrfZriyv9zq/M3IP18d
         Hzwm0ywneo7Ec5+IUJNH0YCTlMKcc2KL9OpL8C/+aFXmu9P6BUrVNn3IDxxnFe+65C
         3JmUXGTTFuIzuliqmuUbG848E+ZhZER7knX5+MDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 258/405] scsi: ufs: Fix regulator load and icc-level configuration
Date:   Wed, 29 May 2019 20:04:16 -0700
Message-Id: <20190530030554.019527182@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
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
index e040f9dd9ff32..58e0bd1dac9b4 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6294,19 +6294,19 @@ static u32 ufshcd_find_max_sup_active_icc_level(struct ufs_hba *hba,
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
@@ -7004,6 +7004,15 @@ static int ufshcd_config_vreg_load(struct device *dev, struct ufs_vreg *vreg,
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



