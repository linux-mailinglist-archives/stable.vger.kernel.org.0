Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4BAF20E805
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389984AbgF2WCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:02:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726244AbgF2SfX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2517A24769;
        Mon, 29 Jun 2020 15:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444083;
        bh=qa3ui2/kDGMV+cg74CBa2bCjyT0eCU4DDQlNS1iEZY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xc4DIldNNt9tT+ej7s+3Nts8Y2SiZgN4+6UX6L953SCl9htu6aCgx9TpczQYUKs9x
         tNyGzK0RM1nDqgqf6nVF4bnuRsbiO7ErmMUaVB5g+U57cSyUgFSB5oaEKsmUEgbjQc
         T5lFSgK0A+Yf0XAiIr6aiCX9I4EKnLOdXS95BYz0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vidya Sagar <vidyas@nvidia.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 193/265] pinctrl: tegra: Use noirq suspend/resume callbacks
Date:   Mon, 29 Jun 2020 11:17:06 -0400
Message-Id: <20200629151818.2493727-194-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
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

