Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A659FA9103
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389772AbfIDSND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:13:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390179AbfIDSND (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:13:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B27A5206BA;
        Wed,  4 Sep 2019 18:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620782;
        bh=OLFtpclpiY3L431sI5w25mUeBSBh2tQ9Un+0qIjRWU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2nFrNQGyLr75UfmrHpusiopadiOZLTwtZLf13ecZ2WNMF4bTndEK51CkC3YEMDAPE
         SIc86Ns1wtqmfMfDd31cTmdjWdX2Xz0kXdqMTEjjFlc+IcCpa8JtqtxHE/G1Bza2iX
         aIk4wTmFpktMooc/k74LZPJVDJF+ktpc92wc/7fo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.2 092/143] Revert "mmc: sdhci-tegra: drop ->get_ro() implementation"
Date:   Wed,  4 Sep 2019 19:53:55 +0200
Message-Id: <20190904175317.714028721@linuxfoundation.org>
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

From: Dmitry Osipenko <digetx@gmail.com>

commit 0f686ca933597cfcc0636253fc1740423c062ec7 upstream.

The WRITE_PROTECT bit is always in a "protected mode" on Tegra and
WP-GPIO state need to be used instead. In a case of the GPIO absence,
write-enable should be assumed. External SD is writable once again as
a result of this patch because the offending commit changed behaviour for
the case of a missing WP-GPIO to fall back to WRITE_PROTECT bit-checking,
which is incorrect for Tegra.

Cc: stable@vger.kernel.org # v5.1+
Fixes: e8391453e27f ("mmc: sdhci-tegra: drop ->get_ro() implementation")
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-tegra.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -258,6 +258,16 @@ static void tegra210_sdhci_writew(struct
 	}
 }
 
+static unsigned int tegra_sdhci_get_ro(struct sdhci_host *host)
+{
+	/*
+	 * Write-enable shall be assumed if GPIO is missing in a board's
+	 * device-tree because SDHCI's WRITE_PROTECT bit doesn't work on
+	 * Tegra.
+	 */
+	return mmc_gpio_get_ro(host->mmc);
+}
+
 static bool tegra_sdhci_is_pad_and_regulator_valid(struct sdhci_host *host)
 {
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
@@ -1224,6 +1234,7 @@ static const struct cqhci_host_ops sdhci
 };
 
 static const struct sdhci_ops tegra_sdhci_ops = {
+	.get_ro     = tegra_sdhci_get_ro,
 	.read_w     = tegra_sdhci_readw,
 	.write_l    = tegra_sdhci_writel,
 	.set_clock  = tegra_sdhci_set_clock,
@@ -1279,6 +1290,7 @@ static const struct sdhci_tegra_soc_data
 };
 
 static const struct sdhci_ops tegra114_sdhci_ops = {
+	.get_ro     = tegra_sdhci_get_ro,
 	.read_w     = tegra_sdhci_readw,
 	.write_w    = tegra_sdhci_writew,
 	.write_l    = tegra_sdhci_writel,
@@ -1332,6 +1344,7 @@ static const struct sdhci_tegra_soc_data
 };
 
 static const struct sdhci_ops tegra210_sdhci_ops = {
+	.get_ro     = tegra_sdhci_get_ro,
 	.read_w     = tegra_sdhci_readw,
 	.write_w    = tegra210_sdhci_writew,
 	.write_l    = tegra_sdhci_writel,
@@ -1366,6 +1379,7 @@ static const struct sdhci_tegra_soc_data
 };
 
 static const struct sdhci_ops tegra186_sdhci_ops = {
+	.get_ro     = tegra_sdhci_get_ro,
 	.read_w     = tegra_sdhci_readw,
 	.write_l    = tegra_sdhci_writel,
 	.set_clock  = tegra_sdhci_set_clock,


