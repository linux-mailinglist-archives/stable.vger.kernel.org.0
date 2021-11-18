Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCD9455D77
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 15:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbhKROKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 09:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232492AbhKROKt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 09:10:49 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4FFC061767
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 06:07:48 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so8283711pju.3
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 06:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=P6u8J7brLyBmEDLXugFYKAmBi206N+a+89AT8IOnzaY=;
        b=qOlVu6OovCc2sgBlAROaUKMuOCjes3EV9OFWA44cKHSMmukNxWsBsSSvm2dZUXiLkb
         /us+LaCb+0+r/yQrnZcm2pDXaS8z0EZabuTMMMHRNxzGqpPWfMr6WKy9ufdMaLcw4j1a
         XaZSnbEitTjjNdMt3fsuR2PC5cqPP147DoPWW+ss01hpO9ly79moYQI0BJABq62FClR0
         X3RppVvY8DQeQirCIKGFagjOvXF18uBCWwRrM5tHwYUOB7qGndxX2hoW2VI4IhETHMMV
         EmxUQlnlkCnDFoXpqM5E9kIrh2tHBnHB7CYsHF29Hdlta/JoV7vjsH8KzIkZ8uD00+vb
         LP9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=P6u8J7brLyBmEDLXugFYKAmBi206N+a+89AT8IOnzaY=;
        b=Fw+bLI/a+nu53WCbai18BtwZjOXaSPGzK2R4D0Gv9VBVQ3JhQ93a/UecvqOD3L2rmk
         jHuAmzb3Vnqt7IkZ8gC9hCXfW7i9eZKmQwHqgfJwWYcZDEt+1UyVzWabBSmdp0RDFunu
         fa/JkYVVJ9I2oVv+2e1v3hej56PHIE6e/HWP84wirK8vAjQ0DE/RnnKdBRlgIYoEw5SU
         N/LlqsVoQ7u2QHutnqC0gPPMNwNxcWs69gazKpvi6y2MR4v1CDzErrMaHloFOKpmFNQM
         +HORVngrbgoc5s0G+7hmjEmi+zvD7NeRSj0PmPmaVVFQKaxpw2IeKl75VhsOxTCetp72
         UILA==
X-Gm-Message-State: AOAM532ge2BWz80R6ofZrqfvnFZGNlh8H6/I/d0YmAaalE9DU253y9K1
        feNeuOH7x8PRXNwAZekRXjw=
X-Google-Smtp-Source: ABdhPJzL4D6tp0xwNK5CV9c1f4+Q9MaC/X6URvhwez0MwfM1JxIKP6qX9APqvGMfKU3jLQBJsWI9ZA==
X-Received: by 2002:a17:90a:ec05:: with SMTP id l5mr11084162pjy.68.1637244468342;
        Thu, 18 Nov 2021 06:07:48 -0800 (PST)
Received: from lenovo.spreadtrum.com ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id h196sm3510717pfe.216.2021.11.18.06.07.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Nov 2021 06:07:48 -0800 (PST)
From:   Orson Zhai <orsonzhai@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>, Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>, orson.zhai@gmail.com,
        Orson Zhai <orson.zhai@unisoc.com>
Subject: [PATCH v2 1/2] scsi: ufs: Fix interrupt error message for shared interrupts
Date:   Thu, 18 Nov 2021 22:07:01 +0800
Message-Id: <1637244422-29190-2-git-send-email-orsonzhai@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1637244422-29190-1-git-send-email-orsonzhai@gmail.com>
References: <1637244422-29190-1-git-send-email-orsonzhai@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 6337f58cec030b34ced435b3d9d7d29d63c96e36 ]

The interrupt might be shared, in which case it is not an error for the
interrupt handler to be called when the interrupt status is zero, so don't
print the message unless there was enabled interrupt status.

Link: https://lore.kernel.org/r/20200811133936.19171-1-adrian.hunter@intel.com
Fixes: 9333d7757348 ("scsi: ufs: Fix irq return code")
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Orson Zhai <orson.zhai@unisoc.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 24396f4..a5d4ee6 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5661,7 +5661,7 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 		intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
 	}
 
-	if (retval == IRQ_NONE) {
+	if (enabled_intr_status && retval == IRQ_NONE) {
 		dev_err(hba->dev, "%s: Unhandled interrupt 0x%08x\n",
 					__func__, intr_status);
 		ufshcd_dump_regs(hba, 0, UFSHCI_REG_SPACE_SIZE, "host_regs: ");
-- 
2.7.4

