Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 458D3F4AAF
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387443AbfKHLj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:39:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:52404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387416AbfKHLj2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:39:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5701720869;
        Fri,  8 Nov 2019 11:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213168;
        bh=ebQIMzzwp7S1oC4ON3K8TO3u8DuQh6RB9yjA/WfUMZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jrFnPZsocyUn8NAEVVOOpvrrGxuhOLmAiuPV0NlHRtsc+d9kZTdxx1i+n0KoT+Uez
         aRcF563PYcFUuSSnFLQTUy3m20gXlo6oD3IbTwl2x2xuMgpaaYFlJQUMA8AHaXvQhi
         k/clEoOPQ5Tze5YhAJTgABY6XH/p9JwQPxKXRAjU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Schmitt <Sven.Schmitt@mixed-mode.de>,
        Sven Schmitt <sven.schmitt@mixed-mode.de>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 069/205] soc: imx: gpc: fix PDN delay
Date:   Fri,  8 Nov 2019 06:35:36 -0500
Message-Id: <20191108113752.12502-69-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schmitt <Sven.Schmitt@mixed-mode.de>

[ Upstream commit 9f4d61d531e0efc9c3283963ae5ef7e314579191 ]

imx6_pm_domain_power_off() reads iso and iso2sw from GPC_PGC_PUPSCR_OFFS
which stores the power up delays.
So use GPC_PGC_PDNSCR_OFFS for the correct delays.

Signed-off-by: Sven Schmitt <sven.schmitt@mixed-mode.de>
Reviewed-by: Leonard Crestez <leonard.crestez@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/gpc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/imx/gpc.c b/drivers/soc/imx/gpc.c
index b3da635970ea7..d160fc2a7b7a2 100644
--- a/drivers/soc/imx/gpc.c
+++ b/drivers/soc/imx/gpc.c
@@ -69,7 +69,7 @@ static int imx6_pm_domain_power_off(struct generic_pm_domain *genpd)
 	u32 val;
 
 	/* Read ISO and ISO2SW power down delays */
-	regmap_read(pd->regmap, pd->reg_offs + GPC_PGC_PUPSCR_OFFS, &val);
+	regmap_read(pd->regmap, pd->reg_offs + GPC_PGC_PDNSCR_OFFS, &val);
 	iso = val & 0x3f;
 	iso2sw = (val >> 8) & 0x3f;
 
-- 
2.20.1

