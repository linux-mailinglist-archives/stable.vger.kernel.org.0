Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F89419187C
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 19:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbgCXSHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 14:07:10 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:35855 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727310AbgCXSHJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 14:07:09 -0400
Received: by mail-lf1-f68.google.com with SMTP id s1so14031089lfd.3
        for <stable@vger.kernel.org>; Tue, 24 Mar 2020 11:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f8SsdXxw6WR8Wur1e28lt2OagUPIvgDuohaIqQCKjAs=;
        b=TIel5Uag6dZ3G0P5rfvaRxHE+J6faOARtdYwQWa0o7ycd/GgSLvBZmXGfzUYoA3wCR
         chLelbgWdGy0YTF6/9ycMDGKSUub/JCYmjc2JVNFkp6Cf6vDkWUDMRmlndg1zFYOXSOr
         5V6elXA2S6f9Nmf0RqrO77kmdvuaN1Qad+WEHn/Dfra1Pq9pOhrYZBAbEHGQpbLnRrXb
         1giw7FMuH6ECSXaE0gM2ElHm8kskRBz2SpCUv2VTYsjS9FJuULzLdyVT2KZ0KxMJrl8N
         QvH11UsguqzJv36qR9I6ffVNRkhQbGZrA0/3LBceTHkbbARh4W41jHq4SJIqLS+CCu7q
         W0wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f8SsdXxw6WR8Wur1e28lt2OagUPIvgDuohaIqQCKjAs=;
        b=MJVCR40Otd/DK63KdkwMRbnc/cYOfG8U9F8YsDeEtnq6x6z5cumbfF9dvaDorQnW4E
         Cr+xCVjvdGgaVjAdS0itZ8UkIaL0ZjXuXiaDtaSvc3SFSBzp8YeRKISSD1EXN/gwBamV
         SHVEuRAIcxCnWzXuRfuB37QYYfVeU3tytU1Slo1q10MfnSppJhDTm2lKvymwOglz0Mpm
         A8aWfrCd4CfdfqFVhZx2A4c4jIu9bgTLNCcKa9Jl4RpHqZLe7vzUcDwjDDw6EzEOs44H
         o1LpT5aM7JvkyA5NQed0JrQvbFGeRm1ud+8HrS3i7CIOC8vIbEU03nQkiThxGRrJCFY6
         8B9w==
X-Gm-Message-State: ANhLgQ0yaS9up9zaX1b2PXcfYAug8WKDzhRtBRQpZBHIkgFQHkCMhqIs
        SQwDYfCmAcd0oDBh+6VU7jdoQQ==
X-Google-Smtp-Source: ADFU+vs1iKgFEQHMKMWWpUIuZuzM5YuqIBxiTCl2JAnxIR+KDVwYeJ+0kD/ZNvy1xNOu0SxrTNAc4Q==
X-Received: by 2002:a19:be11:: with SMTP id o17mr7367103lff.168.1585073227363;
        Tue, 24 Mar 2020 11:07:07 -0700 (PDT)
Received: from localhost.localdomain (h-158-174-22-210.NA.cust.bahnhof.se. [158.174.22.210])
        by smtp.gmail.com with ESMTPSA id 203sm10519660ljf.65.2020.03.24.11.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 11:07:06 -0700 (PDT)
From:   Ulf Hansson <ulf.hansson@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc:     linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Bitan Biswas <bbiswas@nvidia.com>,
        Peter Geis <pgwipeout@gmail.com>
Subject: [PATCH 5.5.12 5/5] mmc: sdhci-tegra: Fix busy detection by enabling MMC_CAP_NEED_RSP_BUSY
Date:   Tue, 24 Mar 2020 19:06:50 +0100
Message-Id: <20200324180650.28819-6-ulf.hansson@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324180650.28819-1-ulf.hansson@linaro.org>
References: <20200324180650.28819-1-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d2f8bfa4bff5028bc40ed56b4497c32e05b0178f ]

It has turned out that the sdhci-tegra controller requires the R1B response,
for commands that has this response associated with them. So, converting
from an R1B to an R1 response for a CMD6 for example, leads to problems
with the HW busy detection support.

Fix this by informing the mmc core about the requirement, via setting the
host cap, MMC_CAP_NEED_RSP_BUSY.

Reported-by: Bitan Biswas <bbiswas@nvidia.com>
Reported-by: Peter Geis <pgwipeout@gmail.com>
Suggested-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Cc: <stable@vger.kernel.org>
Tested-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Tested-By: Peter Geis <pgwipeout@gmail.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/sdhci-tegra.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index 403ac44a7378..a25c3a4d3f6c 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -1552,6 +1552,9 @@ static int sdhci_tegra_probe(struct platform_device *pdev)
 	if (tegra_host->soc_data->nvquirks & NVQUIRK_ENABLE_DDR50)
 		host->mmc->caps |= MMC_CAP_1_8V_DDR;
 
+	/* R1B responses is required to properly manage HW busy detection. */
+	host->mmc->caps |= MMC_CAP_NEED_RSP_BUSY;
+
 	tegra_sdhci_parse_dt(host);
 
 	tegra_host->power_gpio = devm_gpiod_get_optional(&pdev->dev, "power",
-- 
2.20.1

