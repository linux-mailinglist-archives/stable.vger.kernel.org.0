Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1219A4914BD
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244809AbiARCX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:23:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245085AbiARCWw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:22:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBABFC06177A;
        Mon, 17 Jan 2022 18:22:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6FBFB8123A;
        Tue, 18 Jan 2022 02:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD9EC36AE3;
        Tue, 18 Jan 2022 02:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472569;
        bh=CmSybgOq/1GrlnZRx5Nae4PVMVICbBeGwoklSLliBzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UhWucttEKeX3gdn3Zo/0TV/1DDOeiKlnroyFdwhch0fl6YU6R1J2xAonaqDXRD9NR
         ozVqy0YqPd3bv1jSPnvMCvi8oxjp9Fu64WjYeoHWEYO3n34jqlcTTpXMjMyOm29e32
         v8VeWGoAWZltKBqhVqI0UPt8yZ290yzjQMXWtefb0GiY7zCAwLvB/FFSf2r/ma7fMV
         TXV5+d6IezIeoKaiknucL04rC9ZcyRoSbphOmj9YeF3IonARrV2rKrOHT3KI4sG2qU
         h67O2BiSzyrVlRCcA+zA3PsGYPUl/6/zGVJhNu7p9C3iCuU7DVW4HDGqhWzP21nv4F
         H07Tpyty+77kQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Lucas Stach <l.stach@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Peng Fan <peng.fan@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, aford173@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 057/217] soc: imx: gpcv2: Synchronously suspend MIX domains
Date:   Mon, 17 Jan 2022 21:17:00 -0500
Message-Id: <20220118021940.1942199-57-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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
index b8d52d8d29dbb..e757044ab7512 100644
--- a/drivers/soc/imx/gpcv2.c
+++ b/drivers/soc/imx/gpcv2.c
@@ -377,7 +377,7 @@ static int imx_pgc_power_down(struct generic_pm_domain *genpd)
 		}
 	}
 
-	pm_runtime_put(domain->dev);
+	pm_runtime_put_sync_suspend(domain->dev);
 
 	return 0;
 
-- 
2.34.1

