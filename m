Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA1E19C9BE
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388761AbgDBTRK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:17:10 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34482 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388894AbgDBTRK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:17:10 -0400
Received: by mail-wm1-f67.google.com with SMTP id c195so343676wme.1
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=A8S99CHf5RS+VxaoEq44CGEyVEy00UWcqSXyWTfMRic=;
        b=v5BeuaoDO0EL7H3q8d4EuQWq/0pllBHWTbDa/Rb4N6TISKWrxbeR5aTuZL5rzm6UTt
         smoUAOiakNi0GByKY8y+yCoqp9uBn4pmeK2ln8G9DISff0HLO024kAiDMwyzt5TMlnuA
         hKZPIvUWa3mB+lt26WFMzRgMrpNTWvfRRyqRvLVkCGJDQyRT+k6mZTJuMp2IIqC9eM8+
         4uRU2pW+P90iMCwK7kEdeZeUG+sV/ucRJKBzm7/pcXE3O/jdlPjcQJaf49GTQV9ceUQK
         QqSdadAG7CETvdQ2Ka2RYWm+1k5BjkB/DMr0+guuAiv4B2cTtylKSkCPRzo6G+xMgDcc
         GyfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A8S99CHf5RS+VxaoEq44CGEyVEy00UWcqSXyWTfMRic=;
        b=WkialVU4n+J+DH0JkrO7vLY6pi3tDKXJ2I1HxKThuW1bC5ZAAcQW469p6Pg7X32KNM
         TTHC8JV8gVnuEBWidt7GYV7OK+DKYmQyfZG35ooCp5Jcw1WsYcuT7nov8Yx8nEj2eh24
         XEYUWAcX3/B2jixoYKKVelcQ4bNOPjXyV6Jak3OZ6Qwgp6P7mL05MRI0fYKDi2S27RFr
         L/G+mMsD+BmZZGz9GrDWDPwcvhsK3troC2ube56NMTdquVHq58HzcnJQL3cCh0Ks3HSu
         QkSmdOBOJDaoBjF4hp1CAPiMmNlP2fPOmqmIV8fjjLjmzgYa+HQ4PNzSh6keDpmRWVnB
         iYIQ==
X-Gm-Message-State: AGi0PuY0IXPjxXFAbJ7Jlc/j7Gfq+nD+qmWKH/4ZzPuJ05OyG2MVgF9j
        dc+VcEKhDcKiLeQ1Bd6eWq1AGXb8Q1Jt6A==
X-Google-Smtp-Source: APiQypLcJAJJLHdGZfq+8k/PgxPqW/YXUoHq/kzAazAY8+cBsO7Y/mRci8QYbJ5zybvAJZG2+OnPCA==
X-Received: by 2002:a7b:c185:: with SMTP id y5mr5033334wmi.90.1585855028179;
        Thu, 02 Apr 2020 12:17:08 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y1sm879050wmd.14.2020.04.02.12.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:17:07 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 14/24] scsi: ufs: make sure all interrupts are processed
Date:   Thu,  2 Apr 2020 20:17:37 +0100
Message-Id: <20200402191747.789097-14-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191747.789097-1-lee.jones@linaro.org>
References: <20200402191747.789097-1-lee.jones@linaro.org>
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

