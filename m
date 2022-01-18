Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCEF491ABD
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344651AbiARDCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:02:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352247AbiARC71 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:59:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC603C0619D0;
        Mon, 17 Jan 2022 18:34:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39751611F2;
        Tue, 18 Jan 2022 02:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97157C36AE3;
        Tue, 18 Jan 2022 02:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473273;
        bh=EQRRA9PuObldp87ocMm+5sG91qe7TgelMcXd6092xrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lIdae4cov+x7nM+MeTuOF+7HeCw0ouM+NEF+ntzZf128evMB1m0/can4Vv0HrUtQa
         pM43aSA1M/NU0JPzj+HeWnw0MldPVsiloKOr/bS6BS4xVTvIYnjhtNaXdD59Ib6bsn
         5+a1639l9+JiSOgrnjai5mminSdgmgcqkWK4kMN0VpbrKLwyQzR0LsNLu02Udmn9YQ
         ZiNJuAEVjJLPAbxd54rztY7EQqR/z10dGHjBozs5hu9RAd4oASZZGXYs45GalcezeZ
         jXqc9WruyHImfEgTUNzCyHneSIjMozH7hdya0LeIoCpgS6gbT3+SvD7Y2v9sJHLEnd
         yZroGUkHotgMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Lucas Stach <l.stach@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Peng Fan <peng.fan@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, aford173@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 050/188] soc: imx: gpcv2: Synchronously suspend MIX domains
Date:   Mon, 17 Jan 2022 21:29:34 -0500
Message-Id: <20220118023152.1948105-50-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit f756f435f7dd823f2d4bd593ce1bf3168def1308 ]

In case the following power domain sequence happens, iMX8M Mini always hangs:
  gpumix:on -> gpu:on -> gpu:off -> gpu:on
This is likely due to another quirk of the GPC block. This situation can be
prevented by always synchronously powering off both the domain and MIX domain.
Make it so. This turns the aforementioned sequence into:
  gpumix:on -> gpu:on -> gpu:off -> gpumix:off -> gpumix:on -> gpu:on

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Frieder Schrempf <frieder.schrempf@kontron.de>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: NXP Linux Team <linux-imx@nxp.com>
Cc: Peng Fan <peng.fan@nxp.com>
Cc: Shawn Guo <shawnguo@kernel.org>
Acked-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/gpcv2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/imx/gpcv2.c b/drivers/soc/imx/gpcv2.c
index 8b7a01773aec2..b4aa28420f2a8 100644
--- a/drivers/soc/imx/gpcv2.c
+++ b/drivers/soc/imx/gpcv2.c
@@ -369,7 +369,7 @@ static int imx_pgc_power_down(struct generic_pm_domain *genpd)
 		}
 	}
 
-	pm_runtime_put(domain->dev);
+	pm_runtime_put_sync_suspend(domain->dev);
 
 	return 0;
 
-- 
2.34.1

