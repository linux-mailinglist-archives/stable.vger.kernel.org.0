Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21397205964
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 19:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387606AbgFWRkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 13:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387530AbgFWRgQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 13:36:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B454D207E8;
        Tue, 23 Jun 2020 17:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592933775;
        bh=JQCWNfOt0DHc1emiaikqQlj/f/EBGVEXcXNGQXArUyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tCXyHwcMgGwr6qBHAEUUlWBHGyuzvSWYoKetF00raGsezvKEP152OyQjSmyo3yFJY
         mFB7bK5jcEPIA2fxOacdINK+U2nnZe9TIM4ZUngBYllcSJmHWzp2LoO2o9Twyh4i6g
         Xw+H0lEnXZ+ZHKT72UZM8wfSV8jorTAELr6alsTg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vidya Sagar <vidyas@nvidia.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 13/24] pinctrl: tegra: Use noirq suspend/resume callbacks
Date:   Tue, 23 Jun 2020 13:35:48 -0400
Message-Id: <20200623173559.1355728-13-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200623173559.1355728-1-sashal@kernel.org>
References: <20200623173559.1355728-1-sashal@kernel.org>
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
index e9a7cbb9aa336..01bcef2c01bcf 100644
--- a/drivers/pinctrl/tegra/pinctrl-tegra.c
+++ b/drivers/pinctrl/tegra/pinctrl-tegra.c
@@ -685,8 +685,8 @@ static int tegra_pinctrl_resume(struct device *dev)
 }
 
 const struct dev_pm_ops tegra_pinctrl_pm = {
-	.suspend = &tegra_pinctrl_suspend,
-	.resume = &tegra_pinctrl_resume
+	.suspend_noirq = &tegra_pinctrl_suspend,
+	.resume_noirq = &tegra_pinctrl_resume
 };
 
 static bool gpio_node_has_range(const char *compatible)
-- 
2.25.1

