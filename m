Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA29240E681
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346936AbhIPRWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:22:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351939AbhIPRUA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:20:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94D2661A2C;
        Thu, 16 Sep 2021 16:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810502;
        bh=zwOIMvoBmS6R/zgbikS3UgbFPZyQvie+oCY0Ss1puM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lskV4hVI7lo2JA1h8LL+Av7Gbtg74H/HQgqKcVwrQSVLz+926qgflrFry5KSdcEKk
         qmEJpwJURid1js0vVkMukKtovF30vcLFCmBIngK/MvzQKhGsoR987lclIBcDO4DbIz
         hD6RU4nNuvYn0IGCx71/LAafqN8W5gLflUIs7bZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 132/432] scsi: ufs: ufs-exynos: Fix static checker warning
Date:   Thu, 16 Sep 2021 17:58:01 +0200
Message-Id: <20210916155815.234784735@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alim Akhtar <alim.akhtar@samsung.com>

[ Upstream commit 313bf281f2091552f509fd05a74172c70ce7572f ]

clk_get_rate() returns unsigned long and currently this driver stores the
return value in u32 type, resulting the below warning:

Fixed smatch warnings:

        drivers/scsi/ufs/ufs-exynos.c:286 exynos_ufs_get_clk_info()
        warn: wrong type for 'ufs->mclk_rate' (should be 'ulong')

        drivers/scsi/ufs/ufs-exynos.c:287 exynos_ufs_get_clk_info()
        warn: wrong type for 'pclk_rate' (should be 'ulong')

Link: https://lore.kernel.org/r/20210819171131.55912-1-alim.akhtar@samsung.com
Fixes: 55f4b1f73631 ("scsi: ufs: ufs-exynos: Add UFS host support for Exynos SoCs")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs-exynos.c | 4 ++--
 drivers/scsi/ufs/ufs-exynos.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index cf46d6f86e0e..427a2ff7e9da 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -260,7 +260,7 @@ static int exynos_ufs_get_clk_info(struct exynos_ufs *ufs)
 	struct ufs_hba *hba = ufs->hba;
 	struct list_head *head = &hba->clk_list_head;
 	struct ufs_clk_info *clki;
-	u32 pclk_rate;
+	unsigned long pclk_rate;
 	u32 f_min, f_max;
 	u8 div = 0;
 	int ret = 0;
@@ -299,7 +299,7 @@ static int exynos_ufs_get_clk_info(struct exynos_ufs *ufs)
 	}
 
 	if (unlikely(pclk_rate < f_min || pclk_rate > f_max)) {
-		dev_err(hba->dev, "not available pclk range %d\n", pclk_rate);
+		dev_err(hba->dev, "not available pclk range %lu\n", pclk_rate);
 		ret = -EINVAL;
 		goto out;
 	}
diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index 67505fe32ebf..dadf4fd10dd8 100644
--- a/drivers/scsi/ufs/ufs-exynos.h
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -184,7 +184,7 @@ struct exynos_ufs {
 	u32 pclk_div;
 	u32 pclk_avail_min;
 	u32 pclk_avail_max;
-	u32 mclk_rate;
+	unsigned long mclk_rate;
 	int avail_ln_rx;
 	int avail_ln_tx;
 	int rx_sel_idx;
-- 
2.30.2



