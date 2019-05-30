Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A88B2EE08
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731788AbfE3DnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:43:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:60964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732423AbfE3DVD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:21:03 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E687324987;
        Thu, 30 May 2019 03:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186463;
        bh=ee9eDab6zbIDJ0+JeCxbHQiGoNKeXIPi9XsN+fuz58M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zd/z4PZY9evqTiDowp7UA434PHC8lVeUV1rxKt3ZecRfTzn4H61XYGxYYqs/rhJOL
         +ScRzFm9NarGjdTaLWQOslICpvuuZrsRpG0gbvkJcoQntXXkX+tGpUyCiOdGhqLqHv
         8BpNiKP6cUih4dGfqhWKPlXxJji2Xy2MQ8VNsfYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yinbo Zhu <yinbo.zhu@nxp.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 081/128] mmc: sdhci-of-esdhc: add erratum eSDHC-A001 and A-008358 support
Date:   Wed, 29 May 2019 20:06:53 -0700
Message-Id: <20190530030449.224188224@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030432.977908967@linuxfoundation.org>
References: <20190530030432.977908967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 05cb6b2a66fa7837211a060878e91be5eb10cb07 ]

eSDHC-A001: The data timeout counter (SYSCTL[DTOCV]) is not
reliable for DTOCV values 0x4(2^17 SD clock), 0x8(2^21 SD clock),
and 0xC(2^25 SD clock). The data timeout counter can count from
2^13–2^27, but for values 2^17, 2^21, and 2^25, the timeout
counter counts for only 2^13 SD clocks.
A-008358: The data timeout counter value loaded into the timeout
counter is less than expected and can result into early timeout
error in case of eSDHC data transactions. The table below shows
the expected vs actual timeout period for different values of
SYSCTL[DTOCV]:
these two erratum has the same quirk to control it, and set
SDHCI_QUIRK_RESET_AFTER_REQUEST to fix above issue.

Signed-off-by: Yinbo Zhu <yinbo.zhu@nxp.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-of-esdhc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-of-esdhc.c b/drivers/mmc/host/sdhci-of-esdhc.c
index 4db2769ea20c1..6f11cd95bb5fb 100644
--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -636,8 +636,10 @@ static int sdhci_esdhc_probe(struct platform_device *pdev)
 	if (esdhc->vendor_ver > VENDOR_V_22)
 		host->quirks &= ~SDHCI_QUIRK_NO_BUSY_IRQ;
 
-	if (of_find_compatible_node(NULL, NULL, "fsl,p2020-esdhc"))
+	if (of_find_compatible_node(NULL, NULL, "fsl,p2020-esdhc")) {
 		host->quirks2 |= SDHCI_QUIRK_RESET_AFTER_REQUEST;
+		host->quirks2 |= SDHCI_QUIRK_BROKEN_TIMEOUT_VAL;
+	}
 
 	if (of_device_is_compatible(np, "fsl,p5040-esdhc") ||
 	    of_device_is_compatible(np, "fsl,p5020-esdhc") ||
-- 
2.20.1



