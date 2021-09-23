Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8956A415725
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 05:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239793AbhIWDqf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 23:46:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239741AbhIWDoa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 23:44:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 148626135A;
        Thu, 23 Sep 2021 03:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368475;
        bh=uyIjuT+4JR6/En6HSFZak4qsxmwjzchBwls2cvImhoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BxbEyPZRlkeLaApBUXeYiyVrJ+9PRUeZUh0+Zb/X+kcqAX+/8c+Ej+jm4x9rs+bzE
         bbh5EMDI1dtjHz9kNb8Zvu+27SqOWa53GB8lFURZWmcGNUsPB135v8pI3TpdHVyZG4
         03jUSLPEMnHA+DO3ESYH6Eecg0lIJpCT6zUT24SkixVVO59m84Ym5Q4fAz5/rnXa6J
         N51l5CRhy8a8n1QsFS2zvjp5d7luI8u5GqM49RKJJ8S01O/FhEFCBqxVQHEyyYZqCq
         MW18/+v5/oWkqoWfsRl+1BjuAIR2PpKUQKwLXiKSWwrb32aSB8OJAy4bcufk3ocVYR
         5KZ/IdLEU4aqQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, ldewangan@nvidia.com,
        broonie@kernel.org, thierry.reding@gmail.com, jonathanh@nvidia.com,
        linux-spi@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 10/10] spi: Fix tegra20 build with CONFIG_PM=n
Date:   Wed, 22 Sep 2021 23:40:53 -0400
Message-Id: <20210923034055.1422059-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923034055.1422059-1-sashal@kernel.org>
References: <20210923034055.1422059-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit efafec27c5658ed987e720130772f8933c685e87 ]

Without CONFIG_PM enabled, the SET_RUNTIME_PM_OPS() macro ends up being
empty, and the only use of tegra_slink_runtime_{resume,suspend} goes
away, resulting in

  drivers/spi/spi-tegra20-slink.c:1200:12: error: ‘tegra_slink_runtime_resume’ defined but not used [-Werror=unused-function]
   1200 | static int tegra_slink_runtime_resume(struct device *dev)
        |            ^~~~~~~~~~~~~~~~~~~~~~~~~~
  drivers/spi/spi-tegra20-slink.c:1188:12: error: ‘tegra_slink_runtime_suspend’ defined but not used [-Werror=unused-function]
   1188 | static int tegra_slink_runtime_suspend(struct device *dev)
        |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~

mark the functions __maybe_unused to make the build happy.

This hits the alpha allmodconfig build (and others).

Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra20-slink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-tegra20-slink.c b/drivers/spi/spi-tegra20-slink.c
index 9f14560686b6..88bfe7682a9e 100644
--- a/drivers/spi/spi-tegra20-slink.c
+++ b/drivers/spi/spi-tegra20-slink.c
@@ -1210,7 +1210,7 @@ static int tegra_slink_resume(struct device *dev)
 }
 #endif
 
-static int tegra_slink_runtime_suspend(struct device *dev)
+static int __maybe_unused tegra_slink_runtime_suspend(struct device *dev)
 {
 	struct spi_master *master = dev_get_drvdata(dev);
 	struct tegra_slink_data *tspi = spi_master_get_devdata(master);
@@ -1222,7 +1222,7 @@ static int tegra_slink_runtime_suspend(struct device *dev)
 	return 0;
 }
 
-static int tegra_slink_runtime_resume(struct device *dev)
+static int __maybe_unused tegra_slink_runtime_resume(struct device *dev)
 {
 	struct spi_master *master = dev_get_drvdata(dev);
 	struct tegra_slink_data *tspi = spi_master_get_devdata(master);
-- 
2.30.2

