Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDAE63CBB1
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 14:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388917AbfFKMck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 08:32:40 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:45504 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388910AbfFKMck (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 08:32:40 -0400
Received: by mail-lf1-f68.google.com with SMTP id u10so9151409lfm.12
        for <stable@vger.kernel.org>; Tue, 11 Jun 2019 05:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=HU9V86GjpX1Lj12E8HWKI4k2gg4I+vpQIUImDCvzWsk=;
        b=Yg8wAqxtQ164zzGBJZ+PSgz4OXKHa+BMpdSLeROa+LthHzMbkjsycGsXdulp1vuBt8
         wFcx8V53bpgpwEdomtgsYfi9jG6nCbdKwNPdiipsd59bPELpBhN5Cy6P9pvBuK9QT931
         wDKtuzLKIPtSOkC98IQtTSI1/IFFeFq48SB6L/f17m8wYzTTPc6Lhx1e1bYnjV5LviTM
         dPEZbj0uSf1XRAgY+vERPKPWe4nU/BY4V7cwDpQsIjrdTinPdUg4f3TdmT+CPIBENWLf
         F6wxj5Uk1QciZygwjIt1FPTVduN/tRKsmvmZ1mjOXEZv8Uf8d//P5iZwwnjGEWMpYt4V
         ezIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HU9V86GjpX1Lj12E8HWKI4k2gg4I+vpQIUImDCvzWsk=;
        b=WD0txCnoYcbW84+1rI+Pu6nO68aOjEF6zKwsAXxEQXJnLkgartjH2QsWs2l0cSrpo4
         JeUUwIF1bzBbDAsmmvVqwzHnZVZjYiAPH7G6o94ifFbmm5XIIixtb7cwt/9fB5wP9QtP
         aFgIu4BmPpQH9iazIKM8cFLbfbFxKrtjq2Otgd/8LHrVfAJgz5/mviDcla7cn5RIfq4P
         L2LnrJEbsrvSsOSI/tT2uVDYrwZakXJES7Nr6MeYiUUvZ9bqsGyvH+Wnbks3PWPgHoNt
         bXUjJKywNxuCqULAjiGoRGVPsxO6w50FeZNr4gZo3IuE0mxRJYJYNMH3sHTChJ4uiZJc
         kZYQ==
X-Gm-Message-State: APjAAAXP6RN64TEJkovuFV2Bk9LBASGEapBE7xheJ2vXEOWF47jhKw2E
        VpvsVI29OQ+Q/RcwasZtxaMPqA==
X-Google-Smtp-Source: APXvYqyr2XAwpPPGK8DQ5jtLb+Bh0lIdk3lLxo3JrCyUxs9sNBmrrWH/obZnkRHF9jPP1YigO5UxhA==
X-Received: by 2002:ac2:4312:: with SMTP id l18mr32475375lfh.139.1560256358658;
        Tue, 11 Jun 2019 05:32:38 -0700 (PDT)
Received: from uffe-XPS-13-9360.ideon.se ([85.235.10.227])
        by smtp.gmail.com with ESMTPSA id m4sm2570653ljc.56.2019.06.11.05.32.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 05:32:37 -0700 (PDT)
From:   Ulf Hansson <ulf.hansson@linaro.org>
To:     linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Douglas Anderson <dianders@chromium.org>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Brian Norris <briannorris@chromium.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Guenter Roeck <groeck@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] mmc: core: Prevent processing SDIO IRQs when the card is suspended
Date:   Tue, 11 Jun 2019 14:32:21 +0200
Message-Id: <20190611123221.11580-1-ulf.hansson@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Processing of SDIO IRQs must obviously be prevented while the card is
system suspended, otherwise we may end up trying to communicate with an
uninitialized SDIO card.

Reports throughout the years shows that this is not only a theoretical
problem, but a real issue. So, let's finally fix this problem, by keeping
track of the state for the card and bail out before processing the SDIO
IRQ, in case the card is suspended.

Cc: stable@vger.kernel.org
Reported-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---

This has only been compile tested so far, any help for real test on HW is
greatly appreciated.

Note that, this is only the initial part of what is needed to make power
management of SDIO card more robust, but let's start somewhere and continue to
improve things.

The next step I am looking at right now, is to make sure the SDIO IRQ is turned
off during system suspend, unless it's supported as a system wakeup (and enabled
to be used).

---
 drivers/mmc/core/sdio.c     | 7 +++++++
 drivers/mmc/core/sdio_irq.c | 4 ++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index d1aa1c7577bb..9951295d3220 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -937,6 +937,10 @@ static int mmc_sdio_pre_suspend(struct mmc_host *host)
  */
 static int mmc_sdio_suspend(struct mmc_host *host)
 {
+	/* Prevent processing of SDIO IRQs in suspended state. */
+	mmc_card_set_suspended(host->card);
+	cancel_delayed_work_sync(&host->sdio_irq_work);
+
 	mmc_claim_host(host);
 
 	if (mmc_card_keep_power(host) && mmc_card_wake_sdio_irq(host))
@@ -985,6 +989,9 @@ static int mmc_sdio_resume(struct mmc_host *host)
 		err = sdio_enable_4bit_bus(host->card);
 	}
 
+	/* Allow SDIO IRQs to be processed again. */
+	mmc_card_clr_suspended(host->card);
+
 	if (!err && host->sdio_irqs) {
 		if (!(host->caps2 & MMC_CAP2_SDIO_IRQ_NOTHREAD))
 			wake_up_process(host->sdio_irq_thread);
diff --git a/drivers/mmc/core/sdio_irq.c b/drivers/mmc/core/sdio_irq.c
index 931e6226c0b3..9f54a259a1b3 100644
--- a/drivers/mmc/core/sdio_irq.c
+++ b/drivers/mmc/core/sdio_irq.c
@@ -34,6 +34,10 @@ static int process_sdio_pending_irqs(struct mmc_host *host)
 	unsigned char pending;
 	struct sdio_func *func;
 
+	/* Don't process SDIO IRQs if the card is suspended. */
+	if (mmc_card_suspended(card))
+		return 0;
+
 	/*
 	 * Optimization, if there is only 1 function interrupt registered
 	 * and we know an IRQ was signaled then call irq handler directly.
-- 
2.17.1

