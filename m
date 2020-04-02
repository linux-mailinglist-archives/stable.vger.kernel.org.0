Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45C4B19C997
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389367AbgDBTNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:13:17 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37029 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388710AbgDBTNR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:13:17 -0400
Received: by mail-wr1-f66.google.com with SMTP id w10so5624827wrm.4
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=XoWmUFiAcZDOb1PivsC2LiGGC4W07FOzPfrnGgXof+U=;
        b=IjUSqVAVJjYsnks7ra61YrZqheeXNvmnJ/f7ow0W8jPoXOFliAVp/g5YdWVOM7xwwl
         tPn/2Eo5u3s1MWshRVFoD+v3LoXuLNLIplZOu0amrGr1zjjxNJaTycWpQy1kifDWA/BE
         F+9lJIUXlm+GfEXFon4ThF4Wvc6jQGW7Wn/wZMXFTKpJqRgTSe8kFyu+95LYi65i/QZs
         IPRezjvtr4LkN+HJqBcb7eRK4SicTdpv0gwbenKl50I+OFsLLb74SiQp+TOckdD0i/Dx
         c47cEC/K0DO0ew8+Zrxm1g9/m9Rw8YbKhURHimQTTVtfK9mQNo+N/VjSlhZp1gs1drtM
         EJFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XoWmUFiAcZDOb1PivsC2LiGGC4W07FOzPfrnGgXof+U=;
        b=aKvnkkSRSGCB841DWmk5Z9WDqbmVZ66uPhDTPXhccPgigjnVEeidNpFxxomnnIx3/V
         gjqUOr9QKcUQAep/stwieEH0FnbdKY4MJmibj2z+gp22VlinOOwWcQOfBmDeFp4r26E8
         4wWnamEB4LMv3AAZPHHddRp9Rx7f/Ar0fQR7+J8IovxiLImqEVczAqVFlyPUkxdXSTsq
         BWa14Hbfvf4ViPingVqyOr1/zW1iJlEm57BhcRPMb2Sxg/dOtPYeKPqVfI8gZqBQk15A
         sR1m+txkDgvgV8cW78yuUtMIHX9eK02ZfGhZhGCD4atq7yF9l5khuMID4nL0mMFstyuG
         h5mQ==
X-Gm-Message-State: AGi0PuaMRGvw8+bUAa3txozfPsK4oZvDrTFALO3VMx5ZNh6QNRWqW3zx
        wnhWxQGNWtnBtjy1I6wD+O+OhCy2waS5fw==
X-Google-Smtp-Source: APiQypJaQON/BzEZtAksfaR78tsePpILzgjbUKKiG/ZlG8paKXCYlBzTouQOfqJTEITOsaLCl+dxvA==
X-Received: by 2002:a5d:6450:: with SMTP id d16mr4910250wrw.151.1585854795145;
        Thu, 02 Apr 2020 12:13:15 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y12sm5511514wrn.55.2020.04.02.12.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:13:14 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 16/33] scsi: ufs: make sure all interrupts are processed
Date:   Thu,  2 Apr 2020 20:13:36 +0100
Message-Id: <20200402191353.787836-16-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191353.787836-1-lee.jones@linaro.org>
References: <20200402191353.787836-1-lee.jones@linaro.org>
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
index d25082e573e0a..059ae83412068 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5363,19 +5363,30 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
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

