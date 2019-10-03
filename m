Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB058CA9C9
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405529AbfJCQrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:47:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:33122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405525AbfJCQrm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:47:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7341820865;
        Thu,  3 Oct 2019 16:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121262;
        bh=OOYbtDl++mAga3Ve0irijuGjJiSWW+eTKM4eu1A5L8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dmaOrg9IpUSx48tyB/Krv2f3i1ZgOOwLltlPK6sXb5WiAFv2w0mSkMdFjAwr7LAlc
         A4t16dYz0ceorZwFlZf3OiAPCxQfx/4VvSXShmuYXsIJ8sYOleBUUM5XUmD6YPff4Z
         q8od3fvejAPk0CIVEGEfj1kWErWHbMjqziSCqkdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Al Cooper <alcooperx@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 213/344] mmc: sdhci: Fix incorrect switch to HS mode
Date:   Thu,  3 Oct 2019 17:52:58 +0200
Message-Id: <20191003154601.306159884@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Cooper <alcooperx@gmail.com>

[ Upstream commit c894e33ddc1910e14d6f2a2016f60ab613fd8b37 ]

When switching from any MMC speed mode that requires 1.8v
(HS200, HS400 and HS400ES) to High Speed (HS) mode, the system
ends up configured for SDR12 with a 50MHz clock which is an illegal
mode.

This happens because the SDHCI_CTRL_VDD_180 bit in the
SDHCI_HOST_CONTROL2 register is left set and when this bit is
set, the speed mode is controlled by the SDHCI_CTRL_UHS field
in the SDHCI_HOST_CONTROL2 register. The SDHCI_CTRL_UHS field
will end up being set to 0 (SDR12) by sdhci_set_uhs_signaling()
because there is no UHS mode being set.

The fix is to change sdhci_set_uhs_signaling() to set the
SDHCI_CTRL_UHS field to SDR25 (which is the same as HS) for
any switch to HS mode.

This was found on a new eMMC controller that does strict checking
of the speed mode and the corresponding clock rate. It caused the
switch to HS400 mode to fail because part of the sequence to switch
to HS400 requires a switch from HS200 to HS before going to HS400.

Suggested-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Al Cooper <alcooperx@gmail.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index a5dc5aae973e6..c66e66fbaeb40 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1849,7 +1849,9 @@ void sdhci_set_uhs_signaling(struct sdhci_host *host, unsigned timing)
 		ctrl_2 |= SDHCI_CTRL_UHS_SDR104;
 	else if (timing == MMC_TIMING_UHS_SDR12)
 		ctrl_2 |= SDHCI_CTRL_UHS_SDR12;
-	else if (timing == MMC_TIMING_UHS_SDR25)
+	else if (timing == MMC_TIMING_SD_HS ||
+		 timing == MMC_TIMING_MMC_HS ||
+		 timing == MMC_TIMING_UHS_SDR25)
 		ctrl_2 |= SDHCI_CTRL_UHS_SDR25;
 	else if (timing == MMC_TIMING_UHS_SDR50)
 		ctrl_2 |= SDHCI_CTRL_UHS_SDR50;
-- 
2.20.1



