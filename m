Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C89378803
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238885AbhEJLUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:20:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236420AbhEJLIF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:08:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3779D61991;
        Mon, 10 May 2021 11:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644466;
        bh=wI1dsvOOauyYQKFpCjEHM1QSg0+agMfdoJoT1LE5Xrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FaG8YonKFPLkZhq8YsNI29wDdR5nvWww9X3QofAd61rwmU5QE1kAEXXHqZRkUmFGF
         HUxoM7kTG8No7I5bb1yTmpMeFCQMHTqIoWMHFPcz/zUXQNm2HbjAZExRBCcgt6tjXV
         wIMEv+Ao/Vn3Ycly+eBrJFATBn2YibjJEzzCdOUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Nicolas Chauvet <kwizart@gmail.com>,
        Matt Merhar <mattmerhar@protonmail.com>
Subject: [PATCH 5.12 094/384] soc/tegra: pmc: Fix completion of power-gate toggling
Date:   Mon, 10 May 2021 12:18:03 +0200
Message-Id: <20210510102017.990505289@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit c45e66a6b9f40f2e95bc6d97fbf3daa1ebe88c6b ]

The SW-initiated power gate toggling is dropped by PMC if there is
contention with a HW-initiated toggling, i.e. when one of CPU cores is
gated by cpuidle driver. Software should retry the toggling after 10
microseconds on Tegra20/30 SoCs, hence add the retrying. On Tegra114+ the
toggling method was changed in hardware, the TOGGLE_START bit indicates
whether PMC is busy or could accept the command to toggle, hence handle
that bit properly.

The problem pops up after enabling dynamic power gating of 3D hardware,
where 3D power domain fails to turn on/off "randomly".

The programming sequence and quirks are documented in TRMs, but PMC
driver obliviously re-used the Tegra20 logic for Tegra30+, which strikes
back now. The 10 microseconds and other timeouts aren't documented in TRM,
they are taken from downstream kernel.

Link: https://nv-tegra.nvidia.com/gitweb/?p=linux-2.6.git;a=commit;h=311dd1c318b70e93bcefec15456a10ff2b9eb0ff
Link: https://nv-tegra.nvidia.com/gitweb/?p=linux-3.10.git;a=commit;h=7f36693c47cb23730a6b2822e0975be65fb0c51d
Tested-by: Peter Geis <pgwipeout@gmail.com> # Ouya T30
Tested-by: Nicolas Chauvet <kwizart@gmail.com> # PAZ00 T20 and TK1 T124
Tested-by: Matt Merhar <mattmerhar@protonmail.com> # Ouya T30
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/pmc.c | 70 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 65 insertions(+), 5 deletions(-)

diff --git a/drivers/soc/tegra/pmc.c b/drivers/soc/tegra/pmc.c
index df9a5ca8c99c..0118bd986f90 100644
--- a/drivers/soc/tegra/pmc.c
+++ b/drivers/soc/tegra/pmc.c
@@ -317,6 +317,8 @@ struct tegra_pmc_soc {
 				   bool invert);
 	int (*irq_set_wake)(struct irq_data *data, unsigned int on);
 	int (*irq_set_type)(struct irq_data *data, unsigned int type);
+	int (*powergate_set)(struct tegra_pmc *pmc, unsigned int id,
+			     bool new_state);
 
 	const char * const *reset_sources;
 	unsigned int num_reset_sources;
@@ -517,6 +519,63 @@ static int tegra_powergate_lookup(struct tegra_pmc *pmc, const char *name)
 	return -ENODEV;
 }
 
+static int tegra20_powergate_set(struct tegra_pmc *pmc, unsigned int id,
+				 bool new_state)
+{
+	unsigned int retries = 100;
+	bool status;
+	int ret;
+
+	/*
+	 * As per TRM documentation, the toggle command will be dropped by PMC
+	 * if there is contention with a HW-initiated toggling (i.e. CPU core
+	 * power-gated), the command should be retried in that case.
+	 */
+	do {
+		tegra_pmc_writel(pmc, PWRGATE_TOGGLE_START | id, PWRGATE_TOGGLE);
+
+		/* wait for PMC to execute the command */
+		ret = readx_poll_timeout(tegra_powergate_state, id, status,
+					 status == new_state, 1, 10);
+	} while (ret == -ETIMEDOUT && retries--);
+
+	return ret;
+}
+
+static inline bool tegra_powergate_toggle_ready(struct tegra_pmc *pmc)
+{
+	return !(tegra_pmc_readl(pmc, PWRGATE_TOGGLE) & PWRGATE_TOGGLE_START);
+}
+
+static int tegra114_powergate_set(struct tegra_pmc *pmc, unsigned int id,
+				  bool new_state)
+{
+	bool status;
+	int err;
+
+	/* wait while PMC power gating is contended */
+	err = readx_poll_timeout(tegra_powergate_toggle_ready, pmc, status,
+				 status == true, 1, 100);
+	if (err)
+		return err;
+
+	tegra_pmc_writel(pmc, PWRGATE_TOGGLE_START | id, PWRGATE_TOGGLE);
+
+	/* wait for PMC to accept the command */
+	err = readx_poll_timeout(tegra_powergate_toggle_ready, pmc, status,
+				 status == true, 1, 100);
+	if (err)
+		return err;
+
+	/* wait for PMC to execute the command */
+	err = readx_poll_timeout(tegra_powergate_state, id, status,
+				 status == new_state, 10, 100000);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 /**
  * tegra_powergate_set() - set the state of a partition
  * @pmc: power management controller
@@ -526,7 +585,6 @@ static int tegra_powergate_lookup(struct tegra_pmc *pmc, const char *name)
 static int tegra_powergate_set(struct tegra_pmc *pmc, unsigned int id,
 			       bool new_state)
 {
-	bool status;
 	int err;
 
 	if (id == TEGRA_POWERGATE_3D && pmc->soc->has_gpu_clamps)
@@ -539,10 +597,7 @@ static int tegra_powergate_set(struct tegra_pmc *pmc, unsigned int id,
 		return 0;
 	}
 
-	tegra_pmc_writel(pmc, PWRGATE_TOGGLE_START | id, PWRGATE_TOGGLE);
-
-	err = readx_poll_timeout(tegra_powergate_state, id, status,
-				 status == new_state, 10, 100000);
+	err = pmc->soc->powergate_set(pmc, id, new_state);
 
 	mutex_unlock(&pmc->powergates_lock);
 
@@ -2699,6 +2754,7 @@ static const struct tegra_pmc_soc tegra20_pmc_soc = {
 	.regs = &tegra20_pmc_regs,
 	.init = tegra20_pmc_init,
 	.setup_irq_polarity = tegra20_pmc_setup_irq_polarity,
+	.powergate_set = tegra20_powergate_set,
 	.reset_sources = NULL,
 	.num_reset_sources = 0,
 	.reset_levels = NULL,
@@ -2757,6 +2813,7 @@ static const struct tegra_pmc_soc tegra30_pmc_soc = {
 	.regs = &tegra20_pmc_regs,
 	.init = tegra20_pmc_init,
 	.setup_irq_polarity = tegra20_pmc_setup_irq_polarity,
+	.powergate_set = tegra20_powergate_set,
 	.reset_sources = tegra30_reset_sources,
 	.num_reset_sources = ARRAY_SIZE(tegra30_reset_sources),
 	.reset_levels = NULL,
@@ -2811,6 +2868,7 @@ static const struct tegra_pmc_soc tegra114_pmc_soc = {
 	.regs = &tegra20_pmc_regs,
 	.init = tegra20_pmc_init,
 	.setup_irq_polarity = tegra20_pmc_setup_irq_polarity,
+	.powergate_set = tegra114_powergate_set,
 	.reset_sources = tegra30_reset_sources,
 	.num_reset_sources = ARRAY_SIZE(tegra30_reset_sources),
 	.reset_levels = NULL,
@@ -2925,6 +2983,7 @@ static const struct tegra_pmc_soc tegra124_pmc_soc = {
 	.regs = &tegra20_pmc_regs,
 	.init = tegra20_pmc_init,
 	.setup_irq_polarity = tegra20_pmc_setup_irq_polarity,
+	.powergate_set = tegra114_powergate_set,
 	.reset_sources = tegra30_reset_sources,
 	.num_reset_sources = ARRAY_SIZE(tegra30_reset_sources),
 	.reset_levels = NULL,
@@ -3048,6 +3107,7 @@ static const struct tegra_pmc_soc tegra210_pmc_soc = {
 	.regs = &tegra20_pmc_regs,
 	.init = tegra20_pmc_init,
 	.setup_irq_polarity = tegra20_pmc_setup_irq_polarity,
+	.powergate_set = tegra114_powergate_set,
 	.irq_set_wake = tegra210_pmc_irq_set_wake,
 	.irq_set_type = tegra210_pmc_irq_set_type,
 	.reset_sources = tegra210_reset_sources,
-- 
2.30.2



