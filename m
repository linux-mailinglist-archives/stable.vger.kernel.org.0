Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4B4411FFB
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353845AbhITRrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:47:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353609AbhITRpX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:45:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A24F061BA1;
        Mon, 20 Sep 2021 17:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157807;
        bh=HPYpkxje5A75Sc8lJa/b9NbomOpU5DjyVWfkYIKEeLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HeffZlhARaGl9QyfbOnv25tgHKLFgAt0AS9Uxkg1cTHPlr2OVfI1/bBHJzasZ3gPH
         RXRxi2v0dLzdrmolkGRYk53RiK7TMqXpl6ue/2zqh0t0+TTr7M4UakHJX+FgbRTVtM
         5x7mBg13UegLYX6Sp7kL7r6Qt31RnYsCN7SrL7SI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaehyoung Choi <jkkkkk.choi@samsung.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 160/293] pinctrl: samsung: Fix pinctrl bank pin count
Date:   Mon, 20 Sep 2021 18:42:02 +0200
Message-Id: <20210920163938.763834627@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaehyoung Choi <jkkkkk.choi@samsung.com>

[ Upstream commit 70115558ab02fe8d28a6634350b3491a542aaa02 ]

Commit 1abd18d1a51a ("pinctrl: samsung: Register pinctrl before GPIO")
changes the order of GPIO and pinctrl registration: now pinctrl is
registered before GPIO. That means gpio_chip->ngpio is not set when
samsung_pinctrl_register() called, and one cannot rely on that value
anymore. Use `pin_bank->nr_pins' instead of `pin_bank->gpio_chip.ngpio'
to fix mentioned inconsistency.

Fixes: 1abd18d1a51a ("pinctrl: samsung: Register pinctrl before GPIO")
Signed-off-by: Jaehyoung Choi <jkkkkk.choi@samsung.com>
Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
Link: https://lore.kernel.org/r/20210730192905.7173-1-semen.protsenko@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/samsung/pinctrl-samsung.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.c b/drivers/pinctrl/samsung/pinctrl-samsung.c
index c05217edcb0e..82407e4a1642 100644
--- a/drivers/pinctrl/samsung/pinctrl-samsung.c
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.c
@@ -918,7 +918,7 @@ static int samsung_pinctrl_register(struct platform_device *pdev,
 		pin_bank->grange.pin_base = drvdata->pin_base
 						+ pin_bank->pin_base;
 		pin_bank->grange.base = pin_bank->grange.pin_base;
-		pin_bank->grange.npins = pin_bank->gpio_chip.ngpio;
+		pin_bank->grange.npins = pin_bank->nr_pins;
 		pin_bank->grange.gc = &pin_bank->gpio_chip;
 		pinctrl_add_gpio_range(drvdata->pctl_dev, &pin_bank->grange);
 	}
-- 
2.30.2



