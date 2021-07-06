Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D81F03BCC2B
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbhGFLSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:18:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232428AbhGFLSZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:18:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBDBC61C5E;
        Tue,  6 Jul 2021 11:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570146;
        bh=NOfpLa5aBZ+YeJoN+sifc7XSiFFqJYiYutLvPXV94U8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T2bNnL3TjPRPkqVs0/SAEtvyn87BzSzpv6qAwh5oIDiaRG7CvDZKvlB1FAvMttJzH
         y65tQ+adw6Va1foNxtuHjg6ZA0A3U5pG5y6/9PPXdIXZSoBORn2ghict5tAG91mruI
         7Rj1ddAWvEubxlrhcwJxVCX75FjgpSgTQQ2SKeOURSy3xcI9lDU+Ns19eXANGqpQyh
         a31lODI/v3due7ZKdEiWZZPE89LQ4PNQgHNsWT5b3ePw4y50fkN/a3SqqaKX6YlpkQ
         CDiQ4hX1P1UjLBTY48rqjc3TuRSkRTF70nUI/TsqUm4OmhM/H+2rY4od9JTHLLiCT5
         dLn/mawA/Jpew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 070/189] clk: tegra: tegra124-emc: Fix clock imbalance in emc_set_timing()
Date:   Tue,  6 Jul 2021 07:12:10 -0400
Message-Id: <20210706111409.2058071-70-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit f13570e7e830ca4fbf4869015af8492b8918445e ]

After calling clk_prepare_enable(), clk_disable_unprepare() needs
be called when prepare_timing_change() failed.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/tegra/clk-tegra124-emc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/tegra/clk-tegra124-emc.c b/drivers/clk/tegra/clk-tegra124-emc.c
index bdf6f4a51617..74c1d894cca8 100644
--- a/drivers/clk/tegra/clk-tegra124-emc.c
+++ b/drivers/clk/tegra/clk-tegra124-emc.c
@@ -249,8 +249,10 @@ static int emc_set_timing(struct tegra_clk_emc *tegra,
 	div = timing->parent_rate / (timing->rate / 2) - 2;
 
 	err = tegra->prepare_timing_change(emc, timing->rate);
-	if (err)
+	if (err) {
+		clk_disable_unprepare(timing->parent);
 		return err;
+	}
 
 	spin_lock_irqsave(tegra->lock, flags);
 
-- 
2.30.2

