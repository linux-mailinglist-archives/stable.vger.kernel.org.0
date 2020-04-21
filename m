Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049A01B2664
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 14:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgDUMlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 08:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728915AbgDUMlA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 08:41:00 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB02C061A10
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:40:59 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id j1so10871850wrt.1
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y12kj5rwfob3P4HMM4TUh3MSvYrBnXpxaUuKSuJ7rB8=;
        b=SPeFlrNytCRuHZZY7Lm/dvHA1EJZF1+B1QjuWeye/H2AzQcyfGmYjbqStuToDCi1U3
         m+nZDgELcnFFtyeyr6+8wqIFcMlHxrVy7DJZ7LD0GkvvWcsAlJYfeqNl17A3l4kZiQAR
         PU/Ag02LzFqJqmzICC7zfoCc2+OtSfAFcvCDcK42MNGVMT0idQFnECU1DvOdwHN8pFR+
         lo+Lh39+3QEz+6qnw69zUxJ0BYfF/0J/IWkVtnXhvZYZrQc6ozCsG5OrOt7fn8A3wOEo
         l6p6444bYVDUUY0NRvCLpso//mkNPKp4qrtUqBQb0dZ6Mn3NKbyCHb4L+czrUu86YaNK
         oyKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y12kj5rwfob3P4HMM4TUh3MSvYrBnXpxaUuKSuJ7rB8=;
        b=N8+LOIy5ezRhVbAV4D8URdgfuqvIxsm7JeKGxd/A+2BqIJlbUpFWABetRKlNuf1Lcd
         nYA2bpoeE8zE+yfR0dJvEZ7wbp7ceasHZbe/gu82gBxz8Kbmlfp3a8MuAHG3c0Tkotty
         zqJUqfOYxQ1pzT6eBciZkqh+g9Mer3Gsw73+siqsJZHh1GY4EgzZBSCjkUsOmiXRt9BG
         19SejSTLlMO7mVH4CuWWVhnt/kIhjN19Wo9/K5mg4xmEUWDlNQNPdpiVNip8iPNcgHI2
         mHiEZYApDzWpfAGKG8zpWrpdIbx5qUrdq+S5FGJTOFYfHhJkaYzcQ7dvkqoaanmqPakw
         2idw==
X-Gm-Message-State: AGi0PubRZw/amDFP+fUfkhd5JXrSpZibQXeb8GpRWBuJAxeoxNB4vdz8
        Wg7f4RY27wlYlm/i6z+/IBTvxtI4ocw=
X-Google-Smtp-Source: APiQypKUrUHvK1VRzwRgxmcdhpseXaz8POJy4qGtSJUeJXbXz2RCmQ2ZDeMa3xcjUFnh+FI6nAvjcQ==
X-Received: by 2002:adf:80ee:: with SMTP id 101mr12270093wrl.156.1587472858307;
        Tue, 21 Apr 2020 05:40:58 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u3sm3408232wrt.93.2020.04.21.05.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 05:40:57 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 10/24] scsi: ufs: make sure all interrupts are processed
Date:   Tue, 21 Apr 2020 13:40:03 +0100
Message-Id: <20200421124017.272694-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200421124017.272694-1-lee.jones@linaro.org>
References: <20200421124017.272694-1-lee.jones@linaro.org>
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
index c350453246952..f4f2c4f22b5f5 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5366,19 +5366,30 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
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

