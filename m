Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 055233C3173
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235192AbhGJClX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:41:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235800AbhGJCjr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:39:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8190261412;
        Sat, 10 Jul 2021 02:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884556;
        bh=L97dLeP6erxCCovARaRHBZiyyAeRSD+wLyweSRUnot8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sp3hE/zHs8gNWD3l1LbG+YY53HGqIrHdSfK7N/PPsS7GowTjAlVEH0SE+poQ3lW39
         WYrhMiTaiyr7pBaYAq/C/q+b5v3RK2uMuqV6TF03i20S1ilyD2GThrMvCMXU95ath3
         K20vcI+daPCzf5IuE1xvtvQkAtmjG+UE6TmLRWiVXYUOBGBu3DeRfS8JoUSpBV66MI
         pfLwcjIDsUZZVaqv2ITenyKewa7Ikgu2RUzU/FqA5LaR+BQhy4O+y53Qvpz6B2lm6H
         Id7w4TKRzhF1zTvOekxH6fBniH/H7/LW1jA6H0Yp6+ego15KuUakIgcqgr3OP0NpZn
         Eqx8k/c+l6reA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiajun Cao <jjcao20@fudan.edu.cn>, Xin Tan <tanxin.ctf@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 28/33] ALSA: hda: Add IRQ check for platform_get_irq()
Date:   Fri,  9 Jul 2021 22:35:10 -0400
Message-Id: <20210710023516.3172075-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023516.3172075-1-sashal@kernel.org>
References: <20210710023516.3172075-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiajun Cao <jjcao20@fudan.edu.cn>

[ Upstream commit 8c13212443230d03ff25014514ec0d53498c0912 ]

The function hda_tegra_first_init() neglects to check the return
value after executing platform_get_irq().

hda_tegra_first_init() should check the return value (if negative
error number) for errors so as to not pass a negative value to
the devm_request_irq().

Fix it by adding a check for the return value irq_id.

Signed-off-by: Jiajun Cao <jjcao20@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Reviewed-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20210622131947.94346-1-jjcao20@fudan.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_tegra.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/pci/hda/hda_tegra.c b/sound/pci/hda/hda_tegra.c
index e85fb04ec7be..b567c4bdae00 100644
--- a/sound/pci/hda/hda_tegra.c
+++ b/sound/pci/hda/hda_tegra.c
@@ -363,6 +363,9 @@ static int hda_tegra_first_init(struct azx *chip, struct platform_device *pdev)
 	unsigned short gcap;
 	int irq_id = platform_get_irq(pdev, 0);
 
+	if (irq_id < 0)
+		return irq_id;
+
 	err = hda_tegra_init_chip(chip, pdev);
 	if (err)
 		return err;
-- 
2.30.2

