Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 789A610140C
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727588AbfKSF3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:29:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:48342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729029AbfKSF3o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:29:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA33F222A2;
        Tue, 19 Nov 2019 05:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141383;
        bh=ebQIMzzwp7S1oC4ON3K8TO3u8DuQh6RB9yjA/WfUMZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oikY+HNh4t0U7TDh8UBSJ3ZcXNIHtceZ0QIfw00ykoCzb4QfqhxVjh46PxDequWvn
         Hw+P6xdrBg1xnF6ycd8Q+1zDaDVM+L2iH9gzWpKxw3JDRKwo/DSiNyx6EKM8+NmJGW
         nqNX/a0z28bOuxHekwO6SQIhXIdhX/x4GyfL6XT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schmitt <sven.schmitt@mixed-mode.de>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 101/422] soc: imx: gpc: fix PDN delay
Date:   Tue, 19 Nov 2019 06:14:58 +0100
Message-Id: <20191119051405.781082004@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



