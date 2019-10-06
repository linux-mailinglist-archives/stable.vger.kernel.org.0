Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0C43CD4C7
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbfJFR27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:28:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728891AbfJFR26 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:28:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96F142133F;
        Sun,  6 Oct 2019 17:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382938;
        bh=idS9ft4PoldZTWTcbysRgHOMFEngjStNMRW5fk1OU7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AOV68vEKcLTD1B9pCw8xQBlpnMhaHUg+lSXi25bJBXH1fHmudYkjynmc3m2O3EjT2
         jfQ3O7np+FqYwJmEGliiH9YS0E3wKtOoup6s/eW0E5FCNszresX4X3aVVfark5JHEW
         MmNKnX8pjxl1DbJZsusX8l0duDo6sDWJIdtGW79E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 026/106] pinctrl: tegra: Fix write barrier placement in pmx_writel
Date:   Sun,  6 Oct 2019 19:20:32 +0200
Message-Id: <20191006171137.992118437@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171124.641144086@linuxfoundation.org>
References: <20191006171124.641144086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sowjanya Komatineni <skomatineni@nvidia.com>

[ Upstream commit c2cf351eba2ff6002ce8eb178452219d2521e38e ]

pmx_writel uses writel which inserts write barrier before the
register write.

This patch has fix to replace writel with writel_relaxed followed
by a readback and memory barrier to ensure write operation is
completed for successful pinctrl change.

Acked-by: Thierry Reding <treding@nvidia.com>
Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Link: https://lore.kernel.org/r/1565984527-5272-2-git-send-email-skomatineni@nvidia.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/tegra/pinctrl-tegra.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/tegra/pinctrl-tegra.c b/drivers/pinctrl/tegra/pinctrl-tegra.c
index 1aba75897d147..26a3f1eb9c6bf 100644
--- a/drivers/pinctrl/tegra/pinctrl-tegra.c
+++ b/drivers/pinctrl/tegra/pinctrl-tegra.c
@@ -40,7 +40,9 @@ static inline u32 pmx_readl(struct tegra_pmx *pmx, u32 bank, u32 reg)
 
 static inline void pmx_writel(struct tegra_pmx *pmx, u32 val, u32 bank, u32 reg)
 {
-	writel(val, pmx->regs[bank] + reg);
+	writel_relaxed(val, pmx->regs[bank] + reg);
+	/* make sure pinmux register write completed */
+	pmx_readl(pmx, bank, reg);
 }
 
 static int tegra_pinctrl_get_groups_count(struct pinctrl_dev *pctldev)
-- 
2.20.1



