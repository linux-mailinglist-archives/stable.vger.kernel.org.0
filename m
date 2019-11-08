Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7FD5F48FB
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390827AbfKHMAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:00:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:58592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390612AbfKHLn5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:43:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 024A521D6C;
        Fri,  8 Nov 2019 11:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213436;
        bh=Je3mY+k6AJwFTQTtplBtM3RDBofS3mlAZmUdYt0ev6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iNcfln5jQaHRqzCC5LyKe+l/ZHFCflfHAMT2Pa6IefqzkuMMIOoGlUVLcqzhAPBtq
         300FbYzNQaiIragc1DYBXE/JLtriDs9DpOKL8pFFNikuV7mXnEeLy0Abmcr8E74n6m
         bVJ1y3R+E9Gvnr2hg2680B3fk8+/4gfC+E5C+m68=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Schmitt <Sven.Schmitt@mixed-mode.de>,
        Sven Schmitt <sven.schmitt@mixed-mode.de>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 033/103] soc: imx: gpc: fix PDN delay
Date:   Fri,  8 Nov 2019 06:41:58 -0500
Message-Id: <20191108114310.14363-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114310.14363-1-sashal@kernel.org>
References: <20191108114310.14363-1-sashal@kernel.org>
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
index c54d229f8da49..3a12123de4662 100644
--- a/drivers/soc/imx/gpc.c
+++ b/drivers/soc/imx/gpc.c
@@ -73,7 +73,7 @@ static int imx6_pm_domain_power_off(struct generic_pm_domain *genpd)
 		return -EBUSY;
 
 	/* Read ISO and ISO2SW power down delays */
-	regmap_read(pd->regmap, pd->reg_offs + GPC_PGC_PUPSCR_OFFS, &val);
+	regmap_read(pd->regmap, pd->reg_offs + GPC_PGC_PDNSCR_OFFS, &val);
 	iso = val & 0x3f;
 	iso2sw = (val >> 8) & 0x3f;
 
-- 
2.20.1

