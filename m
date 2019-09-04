Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7712A9014
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389459AbfIDSHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:07:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388138AbfIDSHc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:07:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA90B206B8;
        Wed,  4 Sep 2019 18:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620451;
        bh=oefQlcXlXBGt5Pz+10mh105K6JtFKDQSmaifvQ6ZOZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mpY1aPAKLmUQro0LZqhrJBNIthaeXZvoZx6Rt/0TQtWbA0e5TtGBPkrnozcB8fhZT
         XUjuPS43GwnTwJeJJ4GgkgQcC4TBE08lArOdOdtOUB+hwMDzQ+TTmOUm+ugXEq5n+O
         YVIMnISoas2yEeVnU9NgwAS94ZEHC8tT9Uc+zwbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 63/93] mmc: sdhci-of-at91: add quirk for broken HS200
Date:   Wed,  4 Sep 2019 19:54:05 +0200
Message-Id: <20190904175308.420017894@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
References: <20190904175302.845828956@linuxfoundation.org>
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
@@ -365,6 +365,9 @@ static int sdhci_at91_probe(struct platf
 	pm_runtime_set_autosuspend_delay(&pdev->dev, 50);
 	pm_runtime_use_autosuspend(&pdev->dev);
 
+	/* HS200 is broken at this moment */
+	host->quirks2 = SDHCI_QUIRK2_BROKEN_HS200;
+
 	ret = sdhci_add_host(host);
 	if (ret)
 		goto pm_runtime_disable;


