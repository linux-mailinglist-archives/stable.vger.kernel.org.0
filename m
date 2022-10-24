Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4E560B75E
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbiJXTXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbiJXTV5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:21:57 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105B93EA4A
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 10:57:29 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id d59-20020a17090a6f4100b00213202d77e1so2127829pjk.2
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 10:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aHRjtpJRM3U1ghY1hCFtCgckU5MadMj28s/UZ9ZqXJY=;
        b=huM5ypBTUsffC1by9Jd9TL5QHxmbKm3XfeGX4DjCG2CA1f88rtNfIcdskO8MVHkZ96
         Vesb6S2I1QxVDYiE1YZC336xhLf5LG+Ffg3a3xgl52ahBWt7nRsFgYugqfogVOhTYztP
         bJvp7aFAa5/SlYxVzpmhRUN73Lh+HFi81d6cw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aHRjtpJRM3U1ghY1hCFtCgckU5MadMj28s/UZ9ZqXJY=;
        b=XIW970/2u3RycCZepki/JXyR6GBmBwvzd4vtbKJ9iF5XW7C50rUBmi4xlzzCLRvtzL
         C95bTU5W6H8WNiK6zPKPvoM3PeA4tjewUkUHODm9wRvD8EuassTyM3/k7uLlyT6nGYbd
         dWSCxWmHkLRx6C8zS+rJ+T7b7v4i4spCL2zvapyJNs52QXSkCcZDY21oxhHf544U7sfK
         brjL/PNXnPWjqKhp38YzzfJpIIqbxx+FRkxl1mAgJrXn8PJI5JCXN3IIBBuIVynIVdo1
         ieUqKFeVwOcTJQJnFXzaxoo+Y41cmv0hSIAXpNZtpTpUBBeAA1pH26K2dLZR1pHPpDsK
         YN0A==
X-Gm-Message-State: ACrzQf3FWgBNFnCMGo0yNwBK+Jus4rduKxdeWeqpb/OzkIdlAg5XF7Ef
        9tr/5hkcPvpLeIq2/3EKvqxPBQ==
X-Google-Smtp-Source: AMsMyM5udnYbAi+mguFLjBH9/86VARsZ4rUjL1aBNXirhO+r5bbW6Xf3s3tZlK3VBYD0PAM8q0X5uw==
X-Received: by 2002:a17:90a:1690:b0:212:f865:4f0e with SMTP id o16-20020a17090a169000b00212f8654f0emr11266624pja.197.1666634172695;
        Mon, 24 Oct 2022 10:56:12 -0700 (PDT)
Received: from localhost ([2620:15c:9d:2:808b:e2f6:edcf:ccb0])
        by smtp.gmail.com with UTF8SMTPSA id d28-20020aa797bc000000b0056c0d129edfsm90824pfq.121.2022.10.24.10.56.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 10:56:12 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Shawn Lin <shawn.lin@rock-chips.com>, linux-mmc@vger.kernel.org,
        Al Cooper <alcooperx@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-arm-msm@vger.kernel.org, Haibo Chen <haibo.chen@nxp.com>,
        Andy Gross <agross@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Faiz Abbas <faiz_abbas@ti.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Brian Norris <briannorris@chromium.org>, stable@vger.kernel.org
Subject: [PATCH v3 1/7] mmc: cqhci: Provide helper for resetting both SDHCI and CQHCI
Date:   Mon, 24 Oct 2022 10:54:55 -0700
Message-Id: <20221024105229.v3.1.Ie85faa09432bfe1b0890d8c24ff95e17f3097317@changeid>
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
In-Reply-To: <20221024175501.2265400-1-briannorris@chromium.org>
References: <20221024175501.2265400-1-briannorris@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
---

Changes in v3:
 - New in v3 (replacing a simple 'cqe_private == NULL' patch in v2)

 drivers/mmc/host/sdhci-cqhci.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 drivers/mmc/host/sdhci-cqhci.h

diff --git a/drivers/mmc/host/sdhci-cqhci.h b/drivers/mmc/host/sdhci-cqhci.h
new file mode 100644
index 000000000000..270ab1f1de3c
--- /dev/null
+++ b/drivers/mmc/host/sdhci-cqhci.h
@@ -0,0 +1,25 @@
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
+
+#endif /* __MMC_HOST_SDHCI_CQHCI_H__ */
-- 
2.38.0.135.g90850a2211-goog

