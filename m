Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7611E41218B
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358395AbhITSG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:06:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357041AbhITSCo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:02:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E030D63244;
        Mon, 20 Sep 2021 17:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158193;
        bh=pPr+lQJQa08wUC9dVB/PsHh1UA4Qgln97N5XbGeZTMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B3MLcK6tn22EZyFIv6XQt102ML8g4MZD1XvRs6QMOpIDhEER+fK/kHfQzYdd10OY5
         Sbr2WohCs9JsKitkAlsR81ryS7wc8Ofuc1I5MKdEuD/mTOu8agDz6wQWvIPf/4btxb
         EtG7fk0JERTd7HCMdyDcJ1G0NzUB0cdo9FLzC/3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaehyoung Choi <jkkkkk.choi@samsung.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 042/260] pinctrl: samsung: Fix pinctrl bank pin count
Date:   Mon, 20 Sep 2021 18:41:00 +0200
Message-Id: <20210920163932.546676444@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
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
index f26574ef234a..601fffeba39f 100644
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



