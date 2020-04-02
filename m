Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED2DD19C97B
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730837AbgDBTLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:11:35 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45007 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389109AbgDBTLe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:11:34 -0400
Received: by mail-wr1-f65.google.com with SMTP id m17so5535089wrw.11
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=F5CTVmkRwDkF7Ni00En7JXaK7NKNpAYGpg2igcv3wbI=;
        b=gCVR1lXloWKANyvhcZUFiqytlFIY2CA97FGvJ1ABZI48YzZB0oyaa/HU40nntiB97b
         7ZG0szRIy8OZqmvLG1sg4WWGRNt0E6BuGJHCOi/5UndYDWCFgOULdl8FLa6BclMILRN5
         MpikEuSQknx1hRnJsIYQKelCk3mLMXxlTKopBAhHCvtjzTBQAiuV4Pq/Lui6EQhbtOW0
         waBztOX3Zocjnsf6UyJfa6BTOHOY97YPfkPP0TTLwCfJB8+8wG2k1J1kZ6Vo0ZvJTDkF
         ScVaJBLokf7tBxbFEwLhHhhsLjgkKUIj/nfLVIK6Y9ZapONG28946vIxqMC1cecb2xwj
         X0HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F5CTVmkRwDkF7Ni00En7JXaK7NKNpAYGpg2igcv3wbI=;
        b=SDeprpu2mZh81+VOcrSnlgiQbkcYb477KpYpgHO440iXM8rXsjNT064s5B5oHpPZkl
         CiFflNjO2l8Ew561YIDszZbHpsr/BjI7Fyarj7++gFlaxW69sppq+/zhV++1ZKdwfcAb
         jHessuC6uV1iK0dV9zO+XBqzQmJUmGJX5gmsyCfZ1jpG+20W3MzknXfMFHrHbasawrNA
         VoaWE/i5eJ5g6t/MByY8CWDFB86UST2qCwCwo+jveV1paFwbzfHRteqXMGIpO8NJB3KA
         f5Wk9eJRg3k9LVsPbnd1vu/1/TWSAbU4QTrehghg1So9vFhdLt5C0MFXDLkbAnfqGd6w
         1EEg==
X-Gm-Message-State: AGi0PubxR+bW3faRKrZRhHtbHwv7BCn2hPcmuIYlO/SqdPA69wZ7mfdy
        4aWVLD2ldwzJdVtbERlFD4Zaj/PvTH/+KQ==
X-Google-Smtp-Source: APiQypKWFAAfyy4v1IJibAM8F+dKk4tI8CN/usIgRM0B44jA2ZCYRqPP7aAzdfjrP93/3u7CbZYP3A==
X-Received: by 2002:a5d:6a10:: with SMTP id m16mr5288386wru.371.1585854693219;
        Thu, 02 Apr 2020 12:11:33 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id s15sm8442164wrt.16.2020.04.02.12.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:11:31 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 06/14] wil6210: ignore HALP ICR if already handled
Date:   Thu,  2 Apr 2020 20:12:12 +0100
Message-Id: <20200402191220.787381-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191220.787381-1-lee.jones@linaro.org>
References: <20200402191220.787381-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maya Erez <merez@codeaurora.org>

[ Upstream commit 979c9d8d01c482b1befb44dc639ecb907b5a37bd ]

HALP ICR is set as long as the FW should stay awake.
To prevent its multiple handling the driver masks this IRQ bit.
However, if there is a different MISC ICR before the driver clears
this bit, there is a risk of race condition between HALP mask and
unmask. This race leads to HALP timeout, in case it is mistakenly
masked.
Add an atomic flag to indicate if HALP ICR should be handled.

Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/wil6210/interrupt.c | 12 ++++++++----
 drivers/net/wireless/ath/wil6210/main.c      |  3 +++
 drivers/net/wireless/ath/wil6210/wil6210.h   |  1 +
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 0655cd8845142..d161dc930313d 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2012-2017 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -590,10 +590,14 @@ static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
 	}
 
 	if (isr & BIT_DMA_EP_MISC_ICR_HALP) {
-		wil_dbg_irq(wil, "irq_misc: HALP IRQ invoked\n");
-		wil6210_mask_halp(wil);
 		isr &= ~BIT_DMA_EP_MISC_ICR_HALP;
-		complete(&wil->halp.comp);
+		if (wil->halp.handle_icr) {
+			/* no need to handle HALP ICRs until next vote */
+			wil->halp.handle_icr = false;
+			wil_dbg_irq(wil, "irq_misc: HALP IRQ invoked\n");
+			wil6210_mask_halp(wil);
+			complete(&wil->halp.comp);
+		}
 	}
 
 	wil->isr_misc = isr;
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 10673fa9388ec..28d2bfd0fde79 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -1814,11 +1814,14 @@ void wil_halp_vote(struct wil6210_priv *wil)
 
 	if (++wil->halp.ref_cnt == 1) {
 		reinit_completion(&wil->halp.comp);
+		/* mark to IRQ context to handle HALP ICR */
+		wil->halp.handle_icr = true;
 		wil6210_set_halp(wil);
 		rc = wait_for_completion_timeout(&wil->halp.comp, to_jiffies);
 		if (!rc) {
 			wil_err(wil, "HALP vote timed out\n");
 			/* Mask HALP as done in case the interrupt is raised */
+			wil->halp.handle_icr = false;
 			wil6210_mask_halp(wil);
 		} else {
 			wil_dbg_irq(wil,
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 75fe1a3b70466..6a05f59ee58e9 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -778,6 +778,7 @@ struct wil_halp {
 	struct mutex		lock; /* protect halp ref_cnt */
 	unsigned int		ref_cnt;
 	struct completion	comp;
+	u8			handle_icr;
 };
 
 struct wil_blob_wrapper {
-- 
2.25.1

