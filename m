Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2B443A8AF
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730635AbfFIRDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:03:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732837AbfFIRDJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:03:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D065208C0;
        Sun,  9 Jun 2019 17:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099788;
        bh=Lh9Dkd6Y3/+2LvDhB4b1Vd+pgnkf/pcUUr63DEubOSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x5ZGq5giKDLh34cp07DEuOOy0O1q4mgF1TUl3fy849EVhsZa39gbOAqZQM15KSdkl
         oyb/gglu/vftGdSMHVFhhgii9pQ6nNDIHQBP6KiB73OjUcRu3TsGr4hbZ2YBciDJvA
         n6/C42STw7ATO7y8sAGHhX1kw273p3OR+mJu9Fxc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yinbo Zhu <yinbo.zhu@nxp.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 139/241] mmc: sdhci-of-esdhc: add erratum eSDHC5 support
Date:   Sun,  9 Jun 2019 18:41:21 +0200
Message-Id: <20190609164151.800823151@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a46e42712596b51874f04c73f1cdf1017f88df52 ]

Software writing to the Transfer Type configuration register
(system clock domain) can cause a setup/hold violation in the
CRC flops (card clock domain), which can cause write accesses
to be sent with corrupt CRC values. This issue occurs only for
write preceded by read. this erratum is to fix this issue.

Signed-off-by: Yinbo Zhu <yinbo.zhu@nxp.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-of-esdhc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mmc/host/sdhci-of-esdhc.c b/drivers/mmc/host/sdhci-of-esdhc.c
index ac66c61d9433c..a5a11e7ab53b4 100644
--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -624,6 +624,9 @@ static int sdhci_esdhc_probe(struct platform_device *pdev)
 	if (esdhc->vendor_ver > VENDOR_V_22)
 		host->quirks &= ~SDHCI_QUIRK_NO_BUSY_IRQ;
 
+	if (of_find_compatible_node(NULL, NULL, "fsl,p2020-esdhc"))
+		host->quirks2 |= SDHCI_QUIRK_RESET_AFTER_REQUEST;
+
 	if (of_device_is_compatible(np, "fsl,p5040-esdhc") ||
 	    of_device_is_compatible(np, "fsl,p5020-esdhc") ||
 	    of_device_is_compatible(np, "fsl,p4080-esdhc") ||
-- 
2.20.1



