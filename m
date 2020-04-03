Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB09119D691
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 14:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403921AbgDCMSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 08:18:34 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34182 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403845AbgDCMSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 08:18:34 -0400
Received: by mail-wm1-f68.google.com with SMTP id c195so1979996wme.1
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 05:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F5CTVmkRwDkF7Ni00En7JXaK7NKNpAYGpg2igcv3wbI=;
        b=L9tQB3ghDCnewGpOkXdr/8JncLn8h/PBJ3qPokTrPFy8OaZesVvTBJYAi7keZ1PegF
         4slFHAkHNZ1Q/a1SDQxaBfO+/nNpQITQ49KcETbAPRJMFsb7CqelmuZA05jZtQDGZTMj
         nJaZXnOR2jFypxY2rM5kLl7/fLzQsVqu/5/P98Apvf+oIPu6aVG1SD7dWrspMoRs3yd2
         G6ZMKddCKDQez6OcN9gygvj48ghoiqgMLJTmFvYfTVXvgTAt2V5PFANxQ641HG6Lcl0R
         3G62BqHFuxgMKU52o2QKtUFhDIOQEwBYvqiQpIkjjhP7lp/hqDboWOz6qjKL2pGGgFDs
         e5kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F5CTVmkRwDkF7Ni00En7JXaK7NKNpAYGpg2igcv3wbI=;
        b=newxhzGRTMLEsiz5VGDiubhtT06em5LGxIP/e5kBCRGx74F4pj/fGHj5miVIqS8jqV
         gaFMh86ISSybNM5H9dXnAunToLiIjWhwCN/3i2DAq8h2AOAPBGwQxHFaGhthQjh4Wt4h
         ruhhqXMFWL85sHLA4ot+ZtZ/WIBxvC++ZBaLcEPnN1b6j0znUu4Mb7VNI0bEpAzFJyUF
         /ZCrUFgT2jTUo8Yil19hI4VtM6fCXQNv0aX/PiXv/gvEBnCzyis84+eBmDfI8Q7xu/1j
         1jPeVlKuPG1rXMI8O8GMgPAA2Qi2gF4CaN3HLRLnnfxFxrJXLk09ybF/wcWsiqPQ98ED
         +BYg==
X-Gm-Message-State: AGi0PuZEYZ+nSM7Gs9BLmu7JFMB0X+P/K5tfltWnDubDNhp1OASq7yvI
        9NoBMQSX19bH/jHf59rxAjnApHaiuOk=
X-Google-Smtp-Source: APiQypJFKtYvYU9aGsWlTzKg8zJeeKX75dlrkJmCkNM3UVzKlct9/EUJFnIRxG1I7OEbv5fNDPCMog==
X-Received: by 2002:a1c:9652:: with SMTP id y79mr8445507wmd.89.1585916311042;
        Fri, 03 Apr 2020 05:18:31 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.179])
        by smtp.gmail.com with ESMTPSA id l185sm11377712wml.44.2020.04.03.05.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 05:18:30 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.19 06/13] wil6210: ignore HALP ICR if already handled
Date:   Fri,  3 Apr 2020 13:18:52 +0100
Message-Id: <20200403121859.901838-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200403121859.901838-1-lee.jones@linaro.org>
References: <20200403121859.901838-1-lee.jones@linaro.org>
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

