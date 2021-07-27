Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B7B3D75EF
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 15:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236678AbhG0NUF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 09:20:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236832AbhG0NTP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 09:19:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 237F361A3D;
        Tue, 27 Jul 2021 13:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627391955;
        bh=mBenjGICbGqU4sL6JcNUEpVkieVEjgsM+z7KIGEOHJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+ugYWeP/xvYjK61sZjwE7Adtl7tA54WmBj/QmbJ4IbA+c5tQJogoYfdVvAr1Aszh
         OTDAubGyMZrwSvslfFFro7iMdbMdJEVUPBz/LnCWentKQgXG7yPwOgq0X0C9Aq3aLh
         7+EwPPOGxdgJ9bW3mN3EQ9/HSPVlDjbgOS08c1Y2Lucjp/Sl3V0kZCXMq3WNByV3gL
         3lvZ4twRvnY+/X7etSxvwC9nwAI7pqIyLdO0XfpDklCU/g2RcHVpT4srAa64Jl0um5
         kv+02QVCPtz1ONRcPZ2PDWYPL+MvyddRXX9AnA0LLNpQ1hjMHeS0snc+7gTXwOvW+2
         3M83u2DaMtLBA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 05/21] regulator: mtk-dvfsrc: Fix wrong dev pointer for devm_regulator_register
Date:   Tue, 27 Jul 2021 09:18:52 -0400
Message-Id: <20210727131908.834086-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727131908.834086-1-sashal@kernel.org>
References: <20210727131908.834086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit ea986908ccfcc53204a03bb0841227e1b26578c4 ]

If use dev->parent, the regulator_unregister will not be called when this
driver is unloaded. Fix it by using dev instead.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Link: https://lore.kernel.org/r/20210702142140.2678130-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/mtk-dvfsrc-regulator.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/regulator/mtk-dvfsrc-regulator.c b/drivers/regulator/mtk-dvfsrc-regulator.c
index d3d876198d6e..234af3a66c77 100644
--- a/drivers/regulator/mtk-dvfsrc-regulator.c
+++ b/drivers/regulator/mtk-dvfsrc-regulator.c
@@ -179,8 +179,7 @@ static int dvfsrc_vcore_regulator_probe(struct platform_device *pdev)
 	for (i = 0; i < regulator_init_data->size; i++) {
 		config.dev = dev->parent;
 		config.driver_data = (mt_regulators + i);
-		rdev = devm_regulator_register(dev->parent,
-					       &(mt_regulators + i)->desc,
+		rdev = devm_regulator_register(dev, &(mt_regulators + i)->desc,
 					       &config);
 		if (IS_ERR(rdev)) {
 			dev_err(dev, "failed to register %s\n",
-- 
2.30.2

