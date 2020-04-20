Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13A11B0A97
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbgDTMtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:49:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729372AbgDTMtV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:49:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC854206DD;
        Mon, 20 Apr 2020 12:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386960;
        bh=6YjASFFVxwE3VqsyQJNxszZUs30KyKYvr0RNtLN3I10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v7MHeO3RhyzkiK8qG8boWxNY/ZbYCgEmv5pJG2V13NqtjdbPClNy/YeFY9KQi2May
         xmA8AIgkMMa4T2MWZwStZ9kG2UUqauRo/4z23cyovh2Bo/U8lE7BLCg12NR+5tsICl
         GGtvxiT2Q9zZ7wSvvjAgSBpUF2uA2kJYCoW+xPe4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.19 36/40] wil6210: ignore HALP ICR if already handled
Date:   Mon, 20 Apr 2020 14:39:46 +0200
Message-Id: <20200420121506.506206486@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121444.178150063@linuxfoundation.org>
References: <20200420121444.178150063@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maya Erez <merez@codeaurora.org>

commit 979c9d8d01c482b1befb44dc639ecb907b5a37bd upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/wil6210/interrupt.c |   12 ++++++++----
 drivers/net/wireless/ath/wil6210/main.c      |    3 +++
 drivers/net/wireless/ath/wil6210/wil6210.h   |    1 +
 3 files changed, 12 insertions(+), 4 deletions(-)

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
@@ -590,10 +590,14 @@ static irqreturn_t wil6210_irq_misc(int
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
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -1814,11 +1814,14 @@ void wil_halp_vote(struct wil6210_priv *
 
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
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -778,6 +778,7 @@ struct wil_halp {
 	struct mutex		lock; /* protect halp ref_cnt */
 	unsigned int		ref_cnt;
 	struct completion	comp;
+	u8			handle_icr;
 };
 
 struct wil_blob_wrapper {


