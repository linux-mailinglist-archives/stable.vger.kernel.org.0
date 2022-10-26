Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC59460E93F
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 21:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234339AbiJZTnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 15:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235058AbiJZTmn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 15:42:43 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC6AC58BA
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 12:42:29 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id r61-20020a17090a43c300b00212f4e9cccdso3725127pjg.5
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 12:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PdKdi7U4SmFj0opqdWI8W6jamLQm1HEBWFpXKlflndY=;
        b=SWTE6P9QNXY1Z9Rs2EGlY2N1EtdUHngKz+3tEaOqDETcbCRxqr5XVtVo+tzidBfnly
         rdUMvhgihdoOVRoThHw1Lqo55HesJYQqRoXpK+SsSHkWsd22be5pn11cdJr9iYT7Nptg
         k1K/YF78Bo9W5QKKZOPDz7epnyS4bNuYrDNDs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PdKdi7U4SmFj0opqdWI8W6jamLQm1HEBWFpXKlflndY=;
        b=RSaKJEiLzF84eNbXkrFM6mFV8xAC3oXC4TVTSk/8dqtLcnV24LGnM1WYjy6517GgGC
         xzhlCnnETSarB8DxioODj5WnVDG3ZtXRrflLTpoZLR2LcfuJcgnKLbn11HxvzkwcLMPH
         z3UqwHgs/6PpK7ND0l1YWe662GM/Ab8Eo090M65QujvBykdVWdVUi9JIstspHzY9G6DK
         8BPf9jY1Ccl+ONINfgiavRfBAUktJb4Hl2vLfdZXKEXOLQvbETmCO53wDjKDdWRBuFiN
         m2hrs48st6Fs2lmPOpLQSy5awV6XvfjuBC5fyojecLFV2+GHuViE8kClw3YJDBnLK3a0
         fUEQ==
X-Gm-Message-State: ACrzQf1L+3gXLB4EomYkCiAoknkZQLyi+x4DAieSENlQv6Tar2vW9fIr
        ITqIufpMXZLfEOftRR9zNqUW2Q==
X-Google-Smtp-Source: AMsMyM5hyd4eCNYOvaxSEKcBE2XsLoSrLSAhoCKCB+/WuE/WdlJli7RvnWKlc0gcAvx3yJnIiWlTwg==
X-Received: by 2002:a17:903:22cb:b0:186:a8ae:d0ff with SMTP id y11-20020a17090322cb00b00186a8aed0ffmr17416652plg.71.1666813348867;
        Wed, 26 Oct 2022 12:42:28 -0700 (PDT)
Received: from localhost ([2620:15c:9d:2:c9e3:74f3:6b2b:135])
        by smtp.gmail.com with UTF8SMTPSA id h11-20020a170902f2cb00b001837463f654sm3245037plc.251.2022.10.26.12.42.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Oct 2022 12:42:28 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Shawn Guo <shawnguo@kernel.org>, linux-mmc@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Bjorn Andersson <andersson@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Andy Gross <agross@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Al Cooper <alcooperx@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Haibo Chen <haibo.chen@nxp.com>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Brian Norris <briannorris@chromium.org>, stable@vger.kernel.org
Subject: [PATCH v4 1/7] mmc: cqhci: Provide helper for resetting both SDHCI and CQHCI
Date:   Wed, 26 Oct 2022 12:42:03 -0700
Message-Id: <20221026124150.v4.1.Ie85faa09432bfe1b0890d8c24ff95e17f3097317@changeid>
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
In-Reply-To: <20221026194209.3758834-1-briannorris@chromium.org>
References: <20221026194209.3758834-1-briannorris@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Several SDHCI drivers need to deactivate command queueing in their reset
hook (see sdhci_cqhci_reset() / sdhci-pci-core.c, for example), and
several more are coming.

Those reset implementations have some small subtleties (e.g., ordering
of initialization of SDHCI vs. CQHCI might leave us resetting with a
NULL ->cqe_private), and are often identical across different host
drivers.

We also don't want to force a dependency between SDHCI and CQHCI, or
vice versa; non-SDHCI drivers use CQHCI, and SDHCI drivers might support
command queueing through some other means.

So, implement a small helper, to avoid repeating the same mistakes in
different drivers. Simply stick it in a header, because it's so small it
doesn't deserve its own module right now, and inlining to each driver is
pretty reasonable.

This is marked for -stable, as it is an important prerequisite patch for
several SDHCI controller bugfixes that follow.

Cc: <stable@vger.kernel.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
---

Changes in v4:
 - Whitespace fixup
 - Add Adrian's Ack

Changes in v3:
 - New in v3 (replacing a simple 'cqe_private == NULL' patch in v2)

 drivers/mmc/host/sdhci-cqhci.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 drivers/mmc/host/sdhci-cqhci.h

diff --git a/drivers/mmc/host/sdhci-cqhci.h b/drivers/mmc/host/sdhci-cqhci.h
new file mode 100644
index 000000000000..cf8e7ba71bbd
--- /dev/null
+++ b/drivers/mmc/host/sdhci-cqhci.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright 2022 The Chromium OS Authors
+ *
+ * Support that applies to the combination of SDHCI and CQHCI, while not
+ * expressing a dependency between the two modules.
+ */
+
+#ifndef __MMC_HOST_SDHCI_CQHCI_H__
+#define __MMC_HOST_SDHCI_CQHCI_H__
+
+#include "cqhci.h"
+#include "sdhci.h"
+
+static inline void sdhci_and_cqhci_reset(struct sdhci_host *host, u8 mask)
+{
+	if ((host->mmc->caps2 & MMC_CAP2_CQE) && (mask & SDHCI_RESET_ALL) &&
+	    host->mmc->cqe_private)
+		cqhci_deactivate(host->mmc);
+
+	sdhci_reset(host, mask);
+}
+
+#endif /* __MMC_HOST_SDHCI_CQHCI_H__ */
-- 
2.38.0.135.g90850a2211-goog

