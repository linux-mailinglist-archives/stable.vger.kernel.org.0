Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 798FA4156C7
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 05:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239363AbhIWDng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 23:43:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239296AbhIWDl6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 23:41:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B37A6134F;
        Thu, 23 Sep 2021 03:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368398;
        bh=9AtloOx4nKpyDowAK6RtfaHu26eLyUL/U/Nx60hTpaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pL9qv8jsYFxM35HgytIhVHfJLC1QcXKaB4dAoktorRJ0B6gfsB0W7+YfEkFN73JsF
         l3m19dvz5/IHgnpjXkktSVt/NGyKOwHnVEZ99ic0nNGNqwe6r13VeuB2SToDB8FLpH
         w4GVp5WUOEA8TI/fiY2lXJqWNPh2iKxOvr3xNgtFH3wYCpurEJpNFZr/PlRtNDEQZG
         SERFLc4fJGQhIbqY2waipY1080CmfA9BLItnFwAEa6EmHp4nzBzKylnZfOOSwR1xMV
         pWsXU+ekMJW2mD09rJ1UtpV/5XOQgUHZrnV2W81pbzrvvVTj55J3wqpJ4hctrykoQ7
         gHWeP8tb4Kb/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, ldewangan@nvidia.com,
        broonie@kernel.org, thierry.reding@gmail.com, jonathanh@nvidia.com,
        linux-spi@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 15/15] spi: Fix tegra20 build with CONFIG_PM=n
Date:   Wed, 22 Sep 2021 23:39:29 -0400
Message-Id: <20210923033929.1421446-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923033929.1421446-1-sashal@kernel.org>
References: <20210923033929.1421446-1-sashal@kernel.org>
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
index c6b80a60951b..bc3097e5cc26 100644
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

