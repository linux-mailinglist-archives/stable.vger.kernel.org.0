Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D643BB113
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhGDXKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:10:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232214AbhGDXKG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:10:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07F306141C;
        Sun,  4 Jul 2021 23:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440049;
        bh=raElE/LTi6RdTWtu6Qz0VjOIA0GIV9i4FphLeAtxHu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WY2WEJL8tB8Q2Se0ECpbVo/4D+hwkZfYXUVpkyHRq7FD8py58icXHlxnVv8fGdB1/
         WoLnA9nSO/LSrSlN7QQ5gbQZNOrVtljbTbJ1XRpbTbV6DoaQomUJWEI4CDsXobC4kw
         Sdmb2qv8eX30PlYGvWMEJFw4+1GOshDIVjSrHaBeePOpFcM34e88sJyrRoaUSx28Nl
         yNHg4kOr3hs/VPKJXrp79Fk+siYW5EPhkL7oZ8n+Pb2RazUmm07L59Fl7lzNv3YnFI
         ElVJPe4M3JNBK+Jq9CA/dQy8BBQkAlX/0GfW17OCXaL8bV/CteJ3OwAuylMNLiooqg
         XwbOM9N548vFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 54/80] regulator: mt6315: Fix checking return value of devm_regmap_init_spmi_ext
Date:   Sun,  4 Jul 2021 19:05:50 -0400
Message-Id: <20210704230616.1489200-54-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230616.1489200-1-sashal@kernel.org>
References: <20210704230616.1489200-1-sashal@kernel.org>
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

