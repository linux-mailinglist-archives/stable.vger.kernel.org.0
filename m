Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD93106EF6
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbfKVKyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:54:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:40196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727991AbfKVKyd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:54:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10EF620706;
        Fri, 22 Nov 2019 10:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420071;
        bh=5ZZg/xigrTA2+oyrMBGTOMx97kcHllNc7EFKeSaV/nQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vPj6wGbVT9wKmO/kQ45Ay0l1k4eSSw+5RrXporQnB4c2QNg6jtXsK6X8n16aZjno3
         eW8HwPrIllHm2EAWRVIecz48I0OBdO1rYbSE0ZuMF1E6zL2XM8ZQpMW3X6+8aOx4yX
         taOGaCR8aGFFba23jyyC2M3c/5ax/C41Zw5MJwUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 105/122] pinctrl: gemini: Mask and set properly
Date:   Fri, 22 Nov 2019 11:29:18 +0100
Message-Id: <20191122100832.406597374@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit d17f477c5bc6b4a5dd9f51ae263870da132a8e89 ]

The code was written under the assumption that the
regmap_update_bits() would mask the bits in the mask and
set the bits in the value.

It missed the points that it will not set bits in the value
unless these are also masked in the mask. Set value bits
that are not in the mask will simply be ignored.

Fixes: 06351d133dea ("pinctrl: add a Gemini SoC pin controller")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-gemini.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-gemini.c b/drivers/pinctrl/pinctrl-gemini.c
index 39e6221e71000..05441dc2519d2 100644
--- a/drivers/pinctrl/pinctrl-gemini.c
+++ b/drivers/pinctrl/pinctrl-gemini.c
@@ -2164,7 +2164,8 @@ static int gemini_pmx_set_mux(struct pinctrl_dev *pctldev,
 		 func->name, grp->name);
 
 	regmap_read(pmx->map, GLOBAL_MISC_CTRL, &before);
-	regmap_update_bits(pmx->map, GLOBAL_MISC_CTRL, grp->mask,
+	regmap_update_bits(pmx->map, GLOBAL_MISC_CTRL,
+			   grp->mask | grp->value,
 			   grp->value);
 	regmap_read(pmx->map, GLOBAL_MISC_CTRL, &after);
 
-- 
2.20.1



