Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D123CA8B1
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242095AbhGOTCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:02:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241618AbhGOS7Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:59:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DB25613D8;
        Thu, 15 Jul 2021 18:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375361;
        bh=NOfpLa5aBZ+YeJoN+sifc7XSiFFqJYiYutLvPXV94U8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CUYBn7N2UD33lMDEcUG0tuxXn6Eq9CberA1jxw7s155BdBkqr/MIpuWNGx4Zm76sh
         AXgzkjkGpm/zihDs5TauEDqSk1XsVBG+WgXsw2Sg3+JqB8aJ12bnFzvcbCTZqzeHl4
         UAagsfhkQ/OE2/U2i6IoNdwNH0sWjEZwcfZ8XARo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 053/242] clk: tegra: tegra124-emc: Fix clock imbalance in emc_set_timing()
Date:   Thu, 15 Jul 2021 20:36:55 +0200
Message-Id: <20210715182601.670310684@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



