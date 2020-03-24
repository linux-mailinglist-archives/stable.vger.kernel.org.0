Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E598A19189D
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 19:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbgCXSIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 14:08:13 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43479 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728024AbgCXSIN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 14:08:13 -0400
Received: by mail-lj1-f195.google.com with SMTP id g27so10805718ljn.10
        for <stable@vger.kernel.org>; Tue, 24 Mar 2020 11:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=64ZAMpUJ5rH31akevtnc9j967RGejqJSPQFQwpUtFu8=;
        b=mecw7Z1kjIP1pClqvR9MdTgWcQ4OaV74xHWC0Mpa+3eX/nDK6mi+qJwmLGJ39LQsrp
         4fN1MCFaVMeu876vvPiEaQkHZQCGi0dnrT5ggddwnWOOtnmL16DPFVx3V27O54l7eHzy
         Aan2G5o2A2VOZNXuEcynlZEzGCxmmPG5Sk1c8BtH+y5B2eeFYXIld1eo2CfBY4WcLlJx
         UB0w6Th7Wdb5Jlj5bU+LWfkFToxGdyKvwslPt10i/9wbeluAUxc4JbWi0xhOI6QiWZqC
         liBkw1MCsonHMstDrYRF0lvEblTdJ9YCt7k8mXTWhi6fYuO8s7B4bvM/s+lL1yNezVD5
         IGAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=64ZAMpUJ5rH31akevtnc9j967RGejqJSPQFQwpUtFu8=;
        b=ZYkQatZ9pQgsgt4JMt+N6JzSF/9KPoWy2IzqqShhyR3AVCPyXd5umrgbTIprLoim9V
         3/HEapCY1vj/DXhn5kMhfkMuiShUdGLH/MmxAIaNYHMDsRE+cKYHzikekJ67c7qh/Lsd
         N6jUfX76zC7kO8kkHqFP2ZYrEs4CWhGSeus+ujYrAJIwcowyW3NzGxDaBzj+e+IgiEID
         TtFaUeRk+HHC9v3sQhoP6ku+nMx8itJ+aEZeeCf6eB1urrPIMQIf19LSIF36Dr8W1hCS
         D6A1LhEQIWRUvgCfcBjXUNLhyKNkAR5AYBDAytGtTeoxn1sGixi0UccsU935FGy+KQEB
         Z91w==
X-Gm-Message-State: ANhLgQ3EH3aDgukORFdVhXE37wSINxsxrlj5H3sXEC1WczoGANiCzAnw
        Z8uRY/PRBEOpwG9swUK5s3aWvA==
X-Google-Smtp-Source: ADFU+vv12iDbrBNzBpnLat9A0w/VW62S5gPjD4IeUjL69XsldV1NErLUIRHTg4INORpQsC718BcKsg==
X-Received: by 2002:a2e:a0d3:: with SMTP id f19mr17698199ljm.117.1585073290826;
        Tue, 24 Mar 2020 11:08:10 -0700 (PDT)
Received: from localhost.localdomain (h-158-174-22-210.NA.cust.bahnhof.se. [158.174.22.210])
        by smtp.gmail.com with ESMTPSA id s10sm11029858ljp.87.2020.03.24.11.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 11:08:10 -0700 (PDT)
From:   Ulf Hansson <ulf.hansson@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc:     linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH 4.19.113 4/5] mmc: sdhci-omap: Fix busy detection by enabling MMC_CAP_NEED_RSP_BUSY
Date:   Tue, 24 Mar 2020 19:07:59 +0100
Message-Id: <20200324180800.28953-5-ulf.hansson@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324180800.28953-1-ulf.hansson@linaro.org>
References: <20200324180800.28953-1-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 055e04830d4544c57f2a5192a26c9e25915c29c0 ]

It has turned out that the sdhci-omap controller requires the R1B response,
for commands that has this response associated with them. So, converting
from an R1B to an R1 response for a CMD6 for example, leads to problems
with the HW busy detection support.

Fix this by informing the mmc core about the requirement, via setting the
host cap, MMC_CAP_NEED_RSP_BUSY.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reported-by: Anders Roxell <anders.roxell@linaro.org>
Reported-by: Faiz Abbas <faiz_abbas@ti.com>
Cc: <stable@vger.kernel.org>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Tested-by: Faiz Abbas <faiz_abbas@ti.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/sdhci-omap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mmc/host/sdhci-omap.c b/drivers/mmc/host/sdhci-omap.c
index e9793d8e83a0..05ade7a2dd24 100644
--- a/drivers/mmc/host/sdhci-omap.c
+++ b/drivers/mmc/host/sdhci-omap.c
@@ -1147,6 +1147,9 @@ static int sdhci_omap_probe(struct platform_device *pdev)
 	host->mmc_host_ops.execute_tuning = sdhci_omap_execute_tuning;
 	host->mmc_host_ops.enable_sdio_irq = sdhci_omap_enable_sdio_irq;
 
+	/* R1B responses is required to properly manage HW busy detection. */
+	mmc->caps |= MMC_CAP_NEED_RSP_BUSY;
+
 	ret = sdhci_setup_host(host);
 	if (ret)
 		goto err_put_sync;
-- 
2.20.1

