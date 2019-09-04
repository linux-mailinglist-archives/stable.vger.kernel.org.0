Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DABEA9105
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389614AbfIDSNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:13:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:57716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390179AbfIDSNF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:13:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6143C206BA;
        Wed,  4 Sep 2019 18:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620784;
        bh=r0SrvcMLry7DKvNjs2Ldsrbj9Ap89oj8kRRUbcQ4JpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f561hXANtH2y2cip/X8RMBk3UU/EGv58L0vjQ6UH+sMf1dWeXNb1TtIhFpFMRQTtJ
         rGwTRucInIJaaOpvs4LhIKVot4hv+r8a0LpPkl1Ji9aSp2kNFg8qMLFXxv3pEa/mQZ
         1JMaHtgeWyYyCDPGMW/e7z3FW1tDBugOPPakdffQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.2 093/143] mmc: sdhci-of-at91: add quirk for broken HS200
Date:   Wed,  4 Sep 2019 19:53:56 +0200
Message-Id: <20190904175317.760831237@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

commit 7871aa60ae0086fe4626abdf5ed13eeddf306c61 upstream.

HS200 is not implemented in the driver, but the controller claims it
through caps. Remove it via a quirk, to make sure the mmc core do not try
to enable HS200, as it causes the eMMC initialization to fail.

Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Acked-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Fixes: bb5f8ea4d514 ("mmc: sdhci-of-at91: introduce driver for the Atmel SDMMC")
Cc: stable@vger.kernel.org # v4.4+
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-of-at91.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mmc/host/sdhci-of-at91.c
+++ b/drivers/mmc/host/sdhci-of-at91.c
@@ -357,6 +357,9 @@ static int sdhci_at91_probe(struct platf
 	pm_runtime_set_autosuspend_delay(&pdev->dev, 50);
 	pm_runtime_use_autosuspend(&pdev->dev);
 
+	/* HS200 is broken at this moment */
+	host->quirks2 = SDHCI_QUIRK2_BROKEN_HS200;
+
 	ret = sdhci_add_host(host);
 	if (ret)
 		goto pm_runtime_disable;


