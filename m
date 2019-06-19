Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 753E44B8E9
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 14:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731703AbfFSMmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 08:42:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727244AbfFSMmt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jun 2019 08:42:49 -0400
Received: from PC-kkoz.proceq.com (unknown [213.160.61.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE1EF214AF;
        Wed, 19 Jun 2019 12:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560948168;
        bh=1iswHEKvg2N6GFKVSrd6ivye0IWOxcy+C74XG2ERJsg=;
        h=From:To:Cc:Subject:Date:From;
        b=JgJwMZptZUvOqcBvcdXvtgsqNx17SlRbDIx/rSD1FVT3s2GoPQUJbd64Oeh6nzYpI
         FDT04Ylqzmi8R+NW7w47hUXk9qwGbPDsW9ysemPJnrRMTNPHa80Yh3gYTQElBfRHs1
         O2fghrXjC+1ogUvuIuub8nYG/ghaxbJmmcAnI3AQ=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Sangbeom Kim <sbkim73@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc:     Georg Waibel <georg.waibel@sensor-technik.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        stable@vger.kernel.org
Subject: [PATCH] regulator: s2mps11: Fix ERR_PTR dereference on GPIO lookup failure
Date:   Wed, 19 Jun 2019 14:42:39 +0200
Message-Id: <1560948159-21926-1-git-send-email-krzk@kernel.org>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If devm_gpiod_get_from_of_node() call returns ERR_PTR, it is assigned
into an array of GPIO descriptors and used later because such error is
not treated as critical thus it is not propagated back to the probe
function.

All code later expects that such GPIO descriptor is either a NULL or
proper value.  This later might lead to dereference of ERR_PTR.

Only devices with S2MPS14 flavor are affected (other do not control
regulators with GPIOs).

Fixes: 1c984942f0a4 ("regulator: s2mps11: Pass descriptor instead of GPIO number")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

---

The exact error condition was not tested because I do not have board
with S2MPS14.
---
 drivers/regulator/s2mps11.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 134c62db36c5..af9bf10b4c33 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -824,6 +824,7 @@ static void s2mps14_pmic_dt_parse_ext_control_gpio(struct platform_device *pdev,
 		if (IS_ERR(gpio[reg])) {
 			dev_err(&pdev->dev, "Failed to get control GPIO for %d/%s\n",
 				reg, rdata[reg].name);
+			gpio[reg] = NULL;
 			continue;
 		}
 		if (gpio[reg])
-- 
2.7.4

