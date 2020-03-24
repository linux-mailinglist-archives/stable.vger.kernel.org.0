Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF58619187A
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 19:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbgCXSHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 14:07:08 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40549 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727611AbgCXSHI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 14:07:08 -0400
Received: by mail-lf1-f66.google.com with SMTP id j17so14050675lfe.7
        for <stable@vger.kernel.org>; Tue, 24 Mar 2020 11:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=55Q5nK7DG2eakt4E8m0DEdylbWI2T3RG1qzE0tCmg/8=;
        b=FUWdRuu5vsxI3HC6P64JoXJtDbK6QBLk09WCVOmnUvAnRi7eErR6n4kqgkitPA6vbX
         qSnMbErz4PUwBbW5GlnEsWUKFWczjocGrffDE+sqLqkxYWNpYaVGYvlVL97U9/ZLrdwv
         yb2UQjsA5/kw5TLMljXvFSMEg3nrKi2tVE0HDTeNqS8s7pjjMB9fYQcLsxE1ZnE8ljfw
         QuJtDvrZMWmzHwxNris1nSs/wu5dV4ImEIodjQu8UJQ1Kdp4fvu+ik883auF1Hyx12QM
         SujojXlJJoY42Y3nYgp5xyx0XuAEG9GwjWAQ/fL7MSeQCcYwnejnZ1y/O7e4B7V//+9T
         nWpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=55Q5nK7DG2eakt4E8m0DEdylbWI2T3RG1qzE0tCmg/8=;
        b=ErKIjIxmbc/hBtjcRkb6Me8C39QbAwa4RjK+dfdlwKzkpB9u1kto60EKyF/Ie/rZbe
         DGa0hSM8uzezKrvC9XyOaROHYS2x8nWMftOdpfxtKK8mtlZvpUwBBiu6YZTj9SwgXSAO
         jC9omGtMf9jrdLe/soSKGxcSSqyWrVS7HazVZd62WFkzLpvqI7QETiXZwX+Qinb8uUrg
         8oz1H4VmOsB18fvU6xHUCQRNa/4iAFXk/42MXg+ha8yvPEE+W3OaceEEa9GDYb9iP9Wu
         mFHrj6Uv+3D4uskx/7xOjrQLiQtaNZ7ui10rqJ4Qgrwy550U/HiCd4JzuYetfnIKlYuZ
         F8eg==
X-Gm-Message-State: ANhLgQ2lC+gNsO/kM8FSQ9kqmxBGz+IaFso8vOMfHs9dL5WfKgJf/TYI
        vubcy2iY2VN+qATKEw9wnwfvVA==
X-Google-Smtp-Source: ADFU+vts+159LopaFbTmUdKm7ulidUw/f0T6q2tUCX+fPHQ7W4pHAHRl85wpcQb4rfnQwTe/mDPEkA==
X-Received: by 2002:a19:3847:: with SMTP id d7mr7807086lfj.158.1585073225534;
        Tue, 24 Mar 2020 11:07:05 -0700 (PDT)
Received: from localhost.localdomain (h-158-174-22-210.NA.cust.bahnhof.se. [158.174.22.210])
        by smtp.gmail.com with ESMTPSA id 203sm10519660ljf.65.2020.03.24.11.07.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 11:07:04 -0700 (PDT)
From:   Ulf Hansson <ulf.hansson@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc:     linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH 5.5.12 4/5] mmc: sdhci-omap: Fix busy detection by enabling MMC_CAP_NEED_RSP_BUSY
Date:   Tue, 24 Mar 2020 19:06:49 +0100
Message-Id: <20200324180650.28819-5-ulf.hansson@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324180650.28819-1-ulf.hansson@linaro.org>
References: <20200324180650.28819-1-ulf.hansson@linaro.org>
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
index 083e7e053c95..d3135249b2e4 100644
--- a/drivers/mmc/host/sdhci-omap.c
+++ b/drivers/mmc/host/sdhci-omap.c
@@ -1134,6 +1134,9 @@ static int sdhci_omap_probe(struct platform_device *pdev)
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

