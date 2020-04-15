Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00DF51AA418
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897150AbgDONRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 09:17:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897023AbgDOLfH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:35:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DAE720737;
        Wed, 15 Apr 2020 11:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950507;
        bh=KYVbrnZQ7AJD/sDVMLkUCoghFt+lMHOAtPcsirwNruA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Prjyj7l3xruxhM6RL78CqDas1WmxzHzeRx/DURClwHMUri2xL0/NhAsNP0sBn9ctH
         aSFOoXuq+huekZjnW8EoMr+bfoo4tGYAK6T/yqUshm+FgDC7o2QpO2jAPfa0Nolbpp
         RH5TmCGa86BKO2YqzTGBDy0ZTDvl6dApna0oWQYI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 018/129] memory: tegra: Correct debugfs clk rate-range on Tegra20
Date:   Wed, 15 Apr 2020 07:32:53 -0400
Message-Id: <20200415113445.11881-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415113445.11881-1-sashal@kernel.org>
References: <20200415113445.11881-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 2243af41115d0e36e6414df6dd2a0386e022d9f8 ]

Correctly set clk rate-range if number of available timings is zero.
This fixes noisy "invalid range [4294967295, 0]" error messages during
boot.

Fixes: 8209eefa3d37 ("memory: tegra: Implement EMC debugfs interface on Tegra20")
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/tegra/tegra20-emc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/memory/tegra/tegra20-emc.c b/drivers/memory/tegra/tegra20-emc.c
index 8ae474d9bfb90..b16715e9515d0 100644
--- a/drivers/memory/tegra/tegra20-emc.c
+++ b/drivers/memory/tegra/tegra20-emc.c
@@ -628,6 +628,11 @@ static void tegra_emc_debugfs_init(struct tegra_emc *emc)
 			emc->debugfs.max_rate = emc->timings[i].rate;
 	}
 
+	if (!emc->num_timings) {
+		emc->debugfs.min_rate = clk_get_rate(emc->clk);
+		emc->debugfs.max_rate = emc->debugfs.min_rate;
+	}
+
 	err = clk_set_rate_range(emc->clk, emc->debugfs.min_rate,
 				 emc->debugfs.max_rate);
 	if (err < 0) {
-- 
2.20.1

