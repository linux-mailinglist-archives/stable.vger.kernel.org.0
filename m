Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D922E2EC21
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731580AbfE3DSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:18:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:50856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731572AbfE3DSb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:31 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8559424790;
        Thu, 30 May 2019 03:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186310;
        bh=08yPMXvX6Vggu36cK+hjFz+G6AYDSqGXrMEMxqNi2Ac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YIaWTc/56qE4vXjzvprByRMOPxKCaAHkrR8WGQioRAIdB3fB1oWAkp/XMLI48ukSF
         5CIUlyS6Q4blhPbRihcZj5OFqBu6s+dChMvjJDerAZaA3Ta6YXc1Fii9rRdE58/7HP
         extZWm02Wfq8M4ollFIzIqzV8VOKj07eRwS1QQYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Trac Hoang <trac.hoang@broadcom.com>,
        Scott Branden <scott.branden@broadcom.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.14 010/193] mmc: sdhci-iproc: Set NO_HISPD bit to fix HS50 data hold time problem
Date:   Wed, 29 May 2019 20:04:24 -0700
Message-Id: <20190530030448.838388806@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trac Hoang <trac.hoang@broadcom.com>

commit ec0970e0a1b2c807c908d459641a9f9a1be3e130 upstream.

The iproc host eMMC/SD controller hold time does not meet the
specification in the HS50 mode.  This problem can be mitigated
by disabling the HISPD bit; thus forcing the controller output
data to be driven on the falling clock edges rather than the
rising clock edges.

Stable tag (v4.12+) chosen to assist stable kernel maintainers so that
the change does not produce merge conflicts backporting to older kernel
versions. In reality, the timing bug existed since the driver was first
introduced but there is no need for this driver to be supported in kernel
versions that old.

Cc: stable@vger.kernel.org # v4.12+
Signed-off-by: Trac Hoang <trac.hoang@broadcom.com>
Signed-off-by: Scott Branden <scott.branden@broadcom.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-iproc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-iproc.c
+++ b/drivers/mmc/host/sdhci-iproc.c
@@ -209,7 +209,8 @@ static const struct sdhci_iproc_data ipr
 
 static const struct sdhci_pltfm_data sdhci_iproc_pltfm_data = {
 	.quirks = SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK |
-		  SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12,
+		  SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12 |
+		  SDHCI_QUIRK_NO_HISPD_BIT,
 	.quirks2 = SDHCI_QUIRK2_ACMD23_BROKEN,
 	.ops = &sdhci_iproc_ops,
 };


