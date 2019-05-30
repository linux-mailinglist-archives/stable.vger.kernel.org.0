Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5E3D2F115
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730910AbfE3DRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:17:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730906AbfE3DRE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:17:04 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BABB245D7;
        Thu, 30 May 2019 03:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186223;
        bh=pVWxZxbNvKqIRiN5qwRTrLrmotdfRvBhYgFWEWGfkok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MmOs5rLSsjLoqMYNF7fphZsxFs8tUeJu0PIOmX6OtiRqdTboMLw8o7GeiKioR5DaT
         X4NW4kSIz/umMlRT8uhlOH6WL9P/Yg540cQTWikqyOKrpnJ8nssTaVPXMM1jKsAgG9
         Ofr7EaH+YmcBge7Zb1cfV0QIbWrotkV6FYl+MzaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wen.yang99@zte.com.cn>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-gpio@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 117/276] pinctrl: samsung: fix leaked of_node references
Date:   Wed, 29 May 2019 20:04:35 -0700
Message-Id: <20190530030533.228413356@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 44b9f86cd41db6c522effa5aec251d664a52fbc0 ]

The call to of_find_compatible_node returns a node pointer with refcount
incremented thus it must be explicitly decremented after the last
usage.

Detected by coccinelle with the following warnings:
./drivers/pinctrl/samsung/pinctrl-exynos-arm.c:76:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 66, but without a corresponding object release within this function.
./drivers/pinctrl/samsung/pinctrl-exynos-arm.c:82:1-7: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 66, but without a corresponding object release within this function.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Kukjin Kim <kgene@kernel.org>
Cc: linux-samsung-soc@vger.kernel.org
Cc: linux-gpio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/samsung/pinctrl-exynos-arm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/samsung/pinctrl-exynos-arm.c b/drivers/pinctrl/samsung/pinctrl-exynos-arm.c
index 44c6b753f692a..85ddf49a51885 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos-arm.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos-arm.c
@@ -71,6 +71,7 @@ s5pv210_retention_init(struct samsung_pinctrl_drv_data *drvdata,
 	}
 
 	clk_base = of_iomap(np, 0);
+	of_node_put(np);
 	if (!clk_base) {
 		pr_err("%s: failed to map clock registers\n", __func__);
 		return ERR_PTR(-EINVAL);
-- 
2.20.1



