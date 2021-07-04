Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40EE33BB069
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbhGDXI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:08:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231195AbhGDXIP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:08:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 961356135D;
        Sun,  4 Jul 2021 23:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439939;
        bh=raElE/LTi6RdTWtu6Qz0VjOIA0GIV9i4FphLeAtxHu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cr0y8w//bhqQ9FOJCpWWyjzKnh4YQEp2mgP8EW/0Kc362G3RxfnrpLAB7VHqCpEUk
         TCuhmCjeod3NG83jcPMPrJkamEu2ZpauMCC1eX6BomGzrgpg0NuLf0kN+jpeq63HKP
         yS+wxbLi3ug93MjMIlXoThL75N7Ie+SeAW7QdO7aHEhxWBK1SeHp1XQIkZjya4etRa
         edGkFs0HiJz46UmlV/9TuWggRrKMy2tgv19GTP24xqYbqS8vogCXFDLgT7v3ruC9xx
         i66SV54cGLloI6prLi7Ymm5BpKawkBVXD/4/iD236lV3liWb6NIWO/nMitKoB8lSRo
         Utb9CHDjyjpyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 57/85] regulator: mt6315: Fix checking return value of devm_regmap_init_spmi_ext
Date:   Sun,  4 Jul 2021 19:03:52 -0400
Message-Id: <20210704230420.1488358-57-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230420.1488358-1-sashal@kernel.org>
References: <20210704230420.1488358-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit 70d654ea3de937d7754c107bb8eeb20e30262c89 ]

devm_regmap_init_spmi_ext() returns ERR_PTR() on error.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Link: https://lore.kernel.org/r/20210615132934.3453965-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/mt6315-regulator.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/mt6315-regulator.c b/drivers/regulator/mt6315-regulator.c
index 6b8be52c3772..7514702f78cf 100644
--- a/drivers/regulator/mt6315-regulator.c
+++ b/drivers/regulator/mt6315-regulator.c
@@ -223,8 +223,8 @@ static int mt6315_regulator_probe(struct spmi_device *pdev)
 	int i;
 
 	regmap = devm_regmap_init_spmi_ext(pdev, &mt6315_regmap_config);
-	if (!regmap)
-		return -ENODEV;
+	if (IS_ERR(regmap))
+		return PTR_ERR(regmap);
 
 	chip = devm_kzalloc(dev, sizeof(struct mt6315_chip), GFP_KERNEL);
 	if (!chip)
-- 
2.30.2

