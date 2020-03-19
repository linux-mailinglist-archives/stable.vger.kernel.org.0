Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA5718B704
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729839AbgCSNUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:20:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727572AbgCSNUW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:20:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22B9A206D7;
        Thu, 19 Mar 2020 13:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624021;
        bh=XIYQlR1EVOXx86grHh39EgqW2g1lPWyYdx38Han+qrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XSlOKLOTP3g/khBRnzJNpBOOeQvHtScozetSXxdio+dpwr46nSR8Q24XN1DYB60Kj
         5+K+vkEInU0m5A48RnEpjQbLneyAS025/u7vHaamwJRiqb+XZj2oqQWjCw6MFtifKG
         bJZe7KB0sMw9lJTSZUta3xKoe4G+yzdfrtLAujis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/48] mmc: sdhci-omap: Fix busy detection by enabling MMC_CAP_NEED_RSP_BUSY
Date:   Thu, 19 Mar 2020 14:03:48 +0100
Message-Id: <20200319123905.165728366@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123902.941451241@linuxfoundation.org>
References: <20200319123902.941451241@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-omap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mmc/host/sdhci-omap.c b/drivers/mmc/host/sdhci-omap.c
index 5698af25caef6..79ee5fc5a2013 100644
--- a/drivers/mmc/host/sdhci-omap.c
+++ b/drivers/mmc/host/sdhci-omap.c
@@ -1109,6 +1109,9 @@ static int sdhci_omap_probe(struct platform_device *pdev)
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



