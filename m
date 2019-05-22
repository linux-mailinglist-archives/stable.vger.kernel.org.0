Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E74326E90
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732018AbfEVTup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:50:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731981AbfEVT01 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:26:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01E6A217D9;
        Wed, 22 May 2019 19:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553187;
        bh=vSmiZq5dxqYPiG2qfKNaV+N43JayFslu7smwEAuFZVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bVyDPt7FeZMknPh0OF0YUrRDoz7rwcimWamdCz3AYYnqj6syuwymzT6KxCSd6+UOA
         SdL/3UgIX7Py4YJcasvipC7/MiPMG/6FRlwehooolV+CmdbVEBBQ0VNClIV/5n2EPY
         r0ek8GTG/0Tv90Z5DHdskptb8DEz/pIvbUj2PTj4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Yang <wen.yang99@zte.com.cn>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-gpio@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 102/317] pinctrl: samsung: fix leaked of_node references
Date:   Wed, 22 May 2019 15:20:03 -0400
Message-Id: <20190522192338.23715-102-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192338.23715-1-sashal@kernel.org>
References: <20190522192338.23715-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <wen.yang99@zte.com.cn>

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

