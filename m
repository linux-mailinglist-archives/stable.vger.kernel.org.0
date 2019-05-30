Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99BDA2F1B3
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbfE3DQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:16:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730572AbfE3DQD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:16:03 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A94E2458A;
        Thu, 30 May 2019 03:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186162;
        bh=08yPMXvX6Vggu36cK+hjFz+G6AYDSqGXrMEMxqNi2Ac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jMKhxT/nntqrZw6YJ67VAzdRt2YSE691w+UPCpe54YyNLwBYcz2Ck7cjpqMrMBSiB
         gcSn86Oqx9Eud42oBDDfyx08aCco1i/sllsoFnpF7Um8qTJXtoL1ACLHjzafRe+s2u
         X1HygizBiXDvQa6X9JqwIil0ptITnUb7H9qxK+fg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Trac Hoang <trac.hoang@broadcom.com>,
        Scott Branden <scott.branden@broadcom.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 011/276] mmc: sdhci-iproc: Set NO_HISPD bit to fix HS50 data hold time problem
Date:   Wed, 29 May 2019 20:02:49 -0700
Message-Id: <20190530030524.271602909@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
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


