Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6561D12C8F2
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733216AbfL2R6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:58:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:49680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387563AbfL2R6e (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:58:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91B29206DB;
        Sun, 29 Dec 2019 17:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642314;
        bh=ERtaFdC9N6xEElVdzSDWmHwbMCz6EfEWnyaQ8wF2c8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bJ4tj8hYHJ8vNeVUYFBCy4Jz5d7BjzB4QLkA9vsclYBOxSQvrscQDMNaZl8r6qGBj
         TSuzn2D2F0TRvN7iszMrLgt3IwGRWh0r+YYJn9V2llzcXZC6EltPnmUQGnUNsKiryy
         fhZnFgmJoV6mxij7zjH1XPspkGDckQXpaDXq90/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 432/434] mmc: sdhci: Add a quirk for broken command queuing
Date:   Sun, 29 Dec 2019 18:28:05 +0100
Message-Id: <20191229172732.081217620@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 75d27ea1abf7af3cc2cdec3513e74f52191605c8 upstream.

Command queuing has been reported broken on some systems based on Intel
GLK. A separate patch disables command queuing in some cases.

This patch adds a quirk for broken command queuing, which enables users
with problems to disable command queuing using sdhci module parameters for
quirks.

Fixes: 8ee82bda230f ("mmc: sdhci-pci: Add CQHCI support for Intel GLK")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20191217095349.14592-2-adrian.hunter@intel.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci.c |    3 +++
 drivers/mmc/host/sdhci.h |    2 ++
 2 files changed, 5 insertions(+)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -3756,6 +3756,9 @@ int sdhci_setup_host(struct sdhci_host *
 		       mmc_hostname(mmc), host->version);
 	}
 
+	if (host->quirks & SDHCI_QUIRK_BROKEN_CQE)
+		mmc->caps2 &= ~MMC_CAP2_CQE;
+
 	if (host->quirks & SDHCI_QUIRK_FORCE_DMA)
 		host->flags |= SDHCI_USE_SDMA;
 	else if (!(host->caps & SDHCI_CAN_DO_SDMA))
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -409,6 +409,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_BROKEN_CARD_DETECTION		(1<<15)
 /* Controller reports inverted write-protect state */
 #define SDHCI_QUIRK_INVERTED_WRITE_PROTECT		(1<<16)
+/* Controller has unusable command queue engine */
+#define SDHCI_QUIRK_BROKEN_CQE				(1<<17)
 /* Controller does not like fast PIO transfers */
 #define SDHCI_QUIRK_PIO_NEEDS_DELAY			(1<<18)
 /* Controller does not have a LED */


