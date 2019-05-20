Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60C062355F
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391000AbfETMer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:34:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390996AbfETMeq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:34:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B143920645;
        Mon, 20 May 2019 12:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355686;
        bh=dXH/nS4mlpF/IQzd0TyysBGhvDG6thXV6olAhziA+Ic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mr3QYDaEu71sSYdUEbeVKQpH4C+riG4B2E9mVJFyMBZPlVhHzyCSJRtrWowujuPc8
         /H/k5DArIUtwYJVoz4LtQTy39WLimEaJR0j8M2vdVsIOUN7RkDZU6uARER9Gu8S78l
         g7bhJyjvIjd5Q83Ef/B1aSMc5rv9O7pPgS0xRYls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.1 045/128] mmc: tegra: fix ddr signaling for non-ddr modes
Date:   Mon, 20 May 2019 14:13:52 +0200
Message-Id: <20190520115252.779678553@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sowjanya Komatineni <skomatineni@nvidia.com>

commit 92cd1667d579af5c3ef383680598a112da3695df upstream.

ddr_signaling is set to true for DDR50 and DDR52 modes but is
not set back to false for other modes. This programs incorrect
host clock when mode change happens from DDR52/DDR50 to other
SDR or HS modes like incase of mmc_retune where it switches
from HS400 to HS DDR and then from HS DDR to HS mode and then
to HS200.

This patch fixes the ddr_signaling to set properly for non DDR
modes.

Tested-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Cc: stable@vger.kernel.org # v4.20 +
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-tegra.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -779,6 +779,7 @@ static void tegra_sdhci_set_uhs_signalin
 	bool set_dqs_trim = false;
 	bool do_hs400_dll_cal = false;
 
+	tegra_host->ddr_signaling = false;
 	switch (timing) {
 	case MMC_TIMING_UHS_SDR50:
 	case MMC_TIMING_UHS_SDR104:


