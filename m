Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D882E1346
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbgLWCZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:25:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:55734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730466AbgLWCZV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:25:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D734225AA;
        Wed, 23 Dec 2020 02:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690281;
        bh=ElZFJenPwKmFJZjW+9jfyQVKLCCfNn+lzwvk7yJZRsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nh6cGKYJfKQR69+2PzE56TDD9RbLKAm72pqxakXa4+VZrq5Sipm1BhQDv+UUyyF14
         Lw//T0UfrP/9fhV9COSD1ldjc7w+0BBZPnuVR0vvC9ogwtJ6Q4focQ8vN8XSqy4Oad
         CFh+knGBR4ThyHBv8fHa7Ooj8esCful8aIwsBHlygZkPXKwtWgX9dAIhtcQF09FGQ4
         n8jwqBq+1uDQob6lztiNpHabGyipl/SJ6QbBh9s/7GUPhXZyiPxLc/W4blSlUzxLOO
         Mn6XZ6C1DwuF7ZvRo0MDyZ3j5LjPzG1VhV7oDIG31xippr+jtBtDJAHkWzDI/n7wQl
         BsswhE9OjhcVg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 20/48] mmc: tmio: do not print real IOMEM pointer
Date:   Tue, 22 Dec 2020 21:23:48 -0500
Message-Id: <20201223022417.2794032-20-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022417.2794032-1-sashal@kernel.org>
References: <20201223022417.2794032-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit ade8e9d3fb9232ddfb87a4bc641b35b988d9757b ]

Printing kernel pointers is discouraged because they might leak kernel
memory layout.  This fixes smatch warning:

    drivers/mmc/host/tmio_mmc.c:177 tmio_mmc_probe() warn: argument 3 to %08lx specifier is cast from pointer

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20201116164252.44078-1-krzk@kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/tmio_mmc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index e897e7fc3b14c..052093db7d159 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -109,8 +109,7 @@ static int tmio_mmc_probe(struct platform_device *pdev)
 	if (ret)
 		goto host_remove;
 
-	pr_info("%s at 0x%08lx irq %d\n", mmc_hostname(host->mmc),
-		(unsigned long)host->ctl, irq);
+	pr_info("%s at 0x%p irq %d\n", mmc_hostname(host->mmc), host->ctl, irq);
 
 	return 0;
 
-- 
2.27.0

