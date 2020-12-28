Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298872E642A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404333AbgL1Nmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:42:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:40824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391447AbgL1Nk4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:40:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4515E208B3;
        Mon, 28 Dec 2020 13:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162840;
        bh=t/rfeu57RAL2bNFOcWNdK40LMyWaEQqN6/nhxeaZb58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sFctida2v5ix7x+Hcx5CHUXau2VxsafzE7ybhZSjgo3uxAtsqkuGf5qmKwwXh8QQ8
         M3f7x3blikg40dgBATX07HSkcEmuNZtbev8WJdgdga7pn12nJBNNkHIseBSGTU11l3
         9gWERg6C7gS5v5jG3D1pAVisMh/daotv+M236eqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Boichat <drinkcat@chromium.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 080/453] soc: mediatek: Check if power domains can be powered on at boot time
Date:   Mon, 28 Dec 2020 13:45:16 +0100
Message-Id: <20201228124941.088928381@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Boichat <drinkcat@chromium.org>

[ Upstream commit 4007844b05815717f522c7ea9914e24ad0ff6c79 ]

In the error case, where a power domain cannot be powered on
successfully at boot time (in mtk_register_power_domains),
pm_genpd_init would still be called with is_off=false, and the
system would later try to disable the power domain again, triggering
warnings as disabled clocks are disabled again (and other potential
issues).

Also print a warning splat in that case, as this should never
happen.

Fixes: c84e358718a66f7 ("soc: Mediatek: Add SCPSYS power domain driver")
Signed-off-by: Nicolas Boichat <drinkcat@chromium.org>
Link: https://lore.kernel.org/r/20200928113107.v2.1.I5e6f8c262031d0451fe7241b744f4f3111c1ce71@changeid
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mtk-scpsys.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/mediatek/mtk-scpsys.c b/drivers/soc/mediatek/mtk-scpsys.c
index 503222d0d0da1..75f25f08245fd 100644
--- a/drivers/soc/mediatek/mtk-scpsys.c
+++ b/drivers/soc/mediatek/mtk-scpsys.c
@@ -446,6 +446,7 @@ static void mtk_register_power_domains(struct platform_device *pdev,
 	for (i = 0; i < num; i++) {
 		struct scp_domain *scpd = &scp->domains[i];
 		struct generic_pm_domain *genpd = &scpd->genpd;
+		bool on;
 
 		/*
 		 * Initially turn on all domains to make the domains usable
@@ -453,9 +454,9 @@ static void mtk_register_power_domains(struct platform_device *pdev,
 		 * software.  The unused domains will be switched off during
 		 * late_init time.
 		 */
-		genpd->power_on(genpd);
+		on = !WARN_ON(genpd->power_on(genpd) < 0);
 
-		pm_genpd_init(genpd, NULL, false);
+		pm_genpd_init(genpd, NULL, !on);
 	}
 
 	/*
-- 
2.27.0



