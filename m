Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 726056A37C4
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbjB0CLZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:11:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbjB0CKZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:10:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B791ACD6;
        Sun, 26 Feb 2023 18:09:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAFE960CF9;
        Mon, 27 Feb 2023 02:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB19C4339E;
        Mon, 27 Feb 2023 02:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463383;
        bh=rwWXx6jHu9ylwz22lCxyEK8t1Ny7aUK9qcAcQ/C9Et8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D/0eo7lPd/PVXcD0YYMo4aWyWlmQa9EzzQ7UUyvc0EbiXkLvrihIjQvf0GYX0dcxu
         2G5ufZv4vXO12/Pf+DiTTwv6dKA8vMbZUDOxcycs+oAq03SqnWYXBFJyWHas/rbtxz
         yO0hblaXnvtuQE0Xo/REBK6ayUg3YnLbyBy8xMQ5xBDtSVjSyV7GY+8Gk0FChrNX2q
         upCYxiPasAbrs8cb5ukea/Q/EQo845S83OFiDT3r74Umam6XRrilHmdeISYaS0RO4n
         oRQiq60d5FfDh3hZXFyYzXstHGyBfhEIIyti0vmN9V4PqEEotOmP5B79oFeM+A7efo
         9nKhxyXed3kSw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        linux-samsung-soc@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.2 37/60] regulator: s5m8767: Bounds check id indexing into arrays
Date:   Sun, 26 Feb 2023 21:00:22 -0500
Message-Id: <20230227020045.1045105-37-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020045.1045105-1-sashal@kernel.org>
References: <20230227020045.1045105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit e314e15a0b58f9d051c00b25951073bcdae61953 ]

The compiler has no way to know if "id" is within the array bounds of
the regulators array. Add a check for this and a build-time check that
the regulators and reg_voltage_map arrays are sized the same. Seen with
GCC 13:

../drivers/regulator/s5m8767.c: In function 's5m8767_pmic_probe':
../drivers/regulator/s5m8767.c:936:35: warning: array subscript [0, 36] is outside array bounds of 'struct regulator_desc[37]' [-Warray-bounds=]
  936 |                         regulators[id].vsel_reg =
      |                         ~~~~~~~~~~^~~~

Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-samsung-soc@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230128005358.never.313-kees@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/s5m8767.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 35269f9982105..754c6fcc6e642 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -923,10 +923,14 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 
 	for (i = 0; i < pdata->num_regulators; i++) {
 		const struct sec_voltage_desc *desc;
-		int id = pdata->regulators[i].id;
+		unsigned int id = pdata->regulators[i].id;
 		int enable_reg, enable_val;
 		struct regulator_dev *rdev;
 
+		BUILD_BUG_ON(ARRAY_SIZE(regulators) != ARRAY_SIZE(reg_voltage_map));
+		if (WARN_ON_ONCE(id >= ARRAY_SIZE(regulators)))
+			continue;
+
 		desc = reg_voltage_map[id];
 		if (desc) {
 			regulators[id].n_voltages =
-- 
2.39.0

