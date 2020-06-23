Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4152059B3
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 19:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387536AbgFWRnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 13:43:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733209AbgFWRfl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 13:35:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21E30207F9;
        Tue, 23 Jun 2020 17:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592933741;
        bh=qa3ui2/kDGMV+cg74CBa2bCjyT0eCU4DDQlNS1iEZY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AJill2gcN6v+6mGk4/2Z5HHxZWDumye57oY2ZVNd4bVHgmlLTDxblXYFuMkt/mJ/N
         RRKWHHWXtoFEs2k6+FoojW0DGuC680eLRoa4yMKoZzPqdHiZH/bjqgyhy2Gh9lKHd1
         j7H+LoPGj5/W4rXnSyegc6rE2DSSEkbZFAxkBV5k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vidya Sagar <vidyas@nvidia.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 14/28] pinctrl: tegra: Use noirq suspend/resume callbacks
Date:   Tue, 23 Jun 2020 13:35:09 -0400
Message-Id: <20200623173523.1355411-14-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200623173523.1355411-1-sashal@kernel.org>
References: <20200623173523.1355411-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vidya Sagar <vidyas@nvidia.com>

[ Upstream commit 782b6b69847f34dda330530493ea62b7de3fd06a ]

Use noirq suspend/resume callbacks as other drivers which implement
noirq suspend/resume callbacks (Ex:- PCIe) depend on pinctrl driver to
configure the signals used by their respective devices in the noirq phase.

Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20200604174935.26560-1-vidyas@nvidia.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/tegra/pinctrl-tegra.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/tegra/pinctrl-tegra.c b/drivers/pinctrl/tegra/pinctrl-tegra.c
index 21661f6490d68..195cfe557511b 100644
--- a/drivers/pinctrl/tegra/pinctrl-tegra.c
+++ b/drivers/pinctrl/tegra/pinctrl-tegra.c
@@ -731,8 +731,8 @@ static int tegra_pinctrl_resume(struct device *dev)
 }
 
 const struct dev_pm_ops tegra_pinctrl_pm = {
-	.suspend = &tegra_pinctrl_suspend,
-	.resume = &tegra_pinctrl_resume
+	.suspend_noirq = &tegra_pinctrl_suspend,
+	.resume_noirq = &tegra_pinctrl_resume
 };
 
 static bool tegra_pinctrl_gpio_node_has_range(struct tegra_pmx *pmx)
-- 
2.25.1

