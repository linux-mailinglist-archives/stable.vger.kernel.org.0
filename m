Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0AB61B4312
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 13:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbgDVLUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 07:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726812AbgDVLUU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 07:20:20 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC25C03C1A9
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:20 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id t63so1865446wmt.3
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A8S99CHf5RS+VxaoEq44CGEyVEy00UWcqSXyWTfMRic=;
        b=ghQniqQuPXT66oglCzo+AqpUidzsJ61bm3SwRAxT2b6c7dgbsTDiovjTz8BCnrstE0
         owBg0mlY38iJBrsxhZB++j3V/YCVa8HwQXXoIT2PerUm1Cn8sJ+fE+HxDJrS88uCbXdx
         ez9FdU/JjJVo/6Y2EO3I+q9IKTsUONuXTHngMSOa6vcpGFcbmR2zZK5rMuBoLdsu26FW
         iX+mwCVgVyujpL78juu9w9afHJcTRxEnC7Y2tPiSq5JG8Qk/Jt+Q33Dv6AyC4XvvJ7e5
         p+NUlmv+xr1YNQYNR4eBFU5/QDfgNZ2OgtpDmdp8PvTQQkn384E5GXShPO46dYEnBO/X
         zOeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A8S99CHf5RS+VxaoEq44CGEyVEy00UWcqSXyWTfMRic=;
        b=VAIZhv70Tj5Ylv0+G+Ni64HVgbF+iFQ1RIe4q2ijlBF0dumEclw7qW0FtT+dwHH5Im
         sp0pKvbTwdwf7kNmp6OkjcjM6Hm1+RiHaVpwnWAOXkgXGAez0AEMOLEBP7NNDss5SCuz
         u/RS/ckE3ydE6cVmWLtSeKJ9QWv+3cbLMxsEbCHgVcwaSu7//Ewm9hs7rg59VT5B7LEN
         54DzJdeALfdUZfuoUNsx/QqcD2LsLTq8iPjB2kOZJRB2LUTw61QC1aBsai9NGvJ0M3Cp
         l6F07j76vNeEQYUovJHz0aUVC6Ugqcs/BLmyi+SNSGE+YCH+UUCnPf+Ff1rEh9FbmSKv
         ASAA==
X-Gm-Message-State: AGi0Pub4juvF7mT/c4kfNIuLOJ9sDGlAxJiZrDghdSm7Lh0F8GcsgUYg
        WC6ICLQrdwczkOcdmAeZYrRZA8/hxtg=
X-Google-Smtp-Source: APiQypJ6SOz70BKGpfudns2Kpkskzj6eMebRy8evi0he5NDN1VDfAYZRn3V90pwFom0tOXVUWIty9Q==
X-Received: by 2002:a05:600c:20f:: with SMTP id 15mr10337628wmi.71.1587554418967;
        Wed, 22 Apr 2020 04:20:18 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id n6sm8247255wrs.81.2020.04.22.04.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 04:20:18 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 13/21] scsi: ufs: make sure all interrupts are processed
Date:   Wed, 22 Apr 2020 12:19:49 +0100
Message-Id: <20200422111957.569589-14-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200422111957.569589-1-lee.jones@linaro.org>
References: <20200422111957.569589-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Venkat Gopalakrishnan <venkatg@codeaurora.org>

[ Upstream commit 7f6ba4f12e6cbfdefbb95cfd8fc67ece6c15d799 ]

As multiple requests are submitted to the ufs host controller in
parallel there could be instances where the command completion interrupt
arrives later for a request that is already processed earlier as the
corresponding doorbell was cleared when handling the previous
interrupt. Read the interrupt status in a loop after processing the
received interrupt to catch such interrupts and handle it.

Signed-off-by: Venkat Gopalakrishnan <venkatg@codeaurora.org>
Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/ufs/ufshcd.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0b268f0151c67..84ab53d6d1daf 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4401,19 +4401,30 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 	u32 intr_status, enabled_intr_status;
 	irqreturn_t retval = IRQ_NONE;
 	struct ufs_hba *hba = __hba;
+	int retries = hba->nutrs;
 
 	spin_lock(hba->host->host_lock);
 	intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
-	enabled_intr_status =
-		intr_status & ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
 
-	if (intr_status)
-		ufshcd_writel(hba, intr_status, REG_INTERRUPT_STATUS);
+	/*
+	 * There could be max of hba->nutrs reqs in flight and in worst case
+	 * if the reqs get finished 1 by 1 after the interrupt status is
+	 * read, make sure we handle them by checking the interrupt status
+	 * again in a loop until we process all of the reqs before returning.
+	 */
+	do {
+		enabled_intr_status =
+			intr_status & ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
+		if (intr_status)
+			ufshcd_writel(hba, intr_status, REG_INTERRUPT_STATUS);
+		if (enabled_intr_status) {
+			ufshcd_sl_intr(hba, enabled_intr_status);
+			retval = IRQ_HANDLED;
+		}
+
+		intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
+	} while (intr_status && --retries);
 
-	if (enabled_intr_status) {
-		ufshcd_sl_intr(hba, enabled_intr_status);
-		retval = IRQ_HANDLED;
-	}
 	spin_unlock(hba->host->host_lock);
 	return retval;
 }
-- 
2.25.1

