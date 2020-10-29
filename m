Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC2729DF0E
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 01:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729209AbgJ2A67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 20:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731592AbgJ2A66 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 20:58:58 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F65CC0613CF;
        Wed, 28 Oct 2020 17:58:58 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id y14so900103pfp.13;
        Wed, 28 Oct 2020 17:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=QXZW3YRniP2oFz8GgSPBsCUD7y+Lc+Kxo6AM/U3WDKg=;
        b=aD2Q4zyGY7pl2vRzW3Lqto70bdEXz+rEqmitWIloR2NIklBwD1IqzezdsDGc/m/uOt
         AUx7OLTMusO/FlXpctRhC2xZZ0KyXAMpMjkOWUOz38Xz8mMSLmzuk4JrkEFoClgdFD8r
         9uyFPaoLx/4F+dWqyoMqsLAsHWRvx6LuMJqUXAo1No2MxUOwYvE4DXiYO5zVoi5WEVV6
         aGytRsoGuXYjFkAPKcnXhKNmf2woEdPWqn3YjhVVJLLf6V63Oxgf3QzQfX/BdTicjvcL
         qPXSO++B2LGlW3IxRzb/Zm2bsobLGM8HskDLOzyjBUE9QFTvQKn2tWm+buVYy+aL1KmB
         9hSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QXZW3YRniP2oFz8GgSPBsCUD7y+Lc+Kxo6AM/U3WDKg=;
        b=TCrLBhvgO63COvG7UFMAZ8QseLazNNzBj7C9UpusHirk6RSgl61DdNK9n34UK8qVfv
         2ry26YVvGXcyNUhN5TWdEXfoFktq3YDlhdiZivq/E+zkdB6CdOIeC+j5b8Tabro9sl6u
         ru7pppOjLW59ML9p5AK/lqH2M9tS/aT9lguuLGGcDUXWA+nebo4tWhuraWMnORAiDOUy
         bEs2GH8TeNg80Wx5htPzJzKY5Cw+WhJU/AT0r6e39tESW9j2Jk49TkytuTU+r8hkHdpN
         JS/gjAp0fXF17327DEd+9l+QUyGOEG5nZl2tEVQGAj75tK4uD8gTXoP2bINEjnKmeBVx
         C02w==
X-Gm-Message-State: AOAM533jvndUxifZ9Ec6Pmrq3qXse7YnyVIMOnRl4UGuHjeZ64QE0b27
        P3w0iqII90tIDT9u+1Tj7vc=
X-Google-Smtp-Source: ABdhPJwHYHtZDoWjTOFCCY0oE5fBhRiAfCMsITm7seMXgOmTo6kV1tReuWLw058ICrVo9olQUusKUw==
X-Received: by 2002:a17:90a:c48:: with SMTP id u8mr1526949pje.121.1603933137689;
        Wed, 28 Oct 2020 17:58:57 -0700 (PDT)
Received: from Asurada-Nvidia.nvidia.com (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id d145sm819343pfd.136.2020.10.28.17.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 17:58:57 -0700 (PDT)
From:   Nicolin Chen <nicoleotsuka@gmail.com>
To:     jonathanh@nvidia.com, thierry.reding@gmail.com, sboyd@kernel.org,
        mturquette@baylibre.com, pgaikwad@nvidia.com,
        pdeschrijver@nvidia.com
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-clk@vger.kernel.org
Subject: [PATCH] clk: tegra: Do not return 0 on failure
Date:   Wed, 28 Oct 2020 17:48:20 -0700
Message-Id: <20201029004820.9062-1-nicoleotsuka@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Return values from read_dt_param() will be either TRUE (1) or
FALSE (0), while dfll_fetch_pwm_params() returns 0 on success
or an ERR code on failure.

So this patch fixes the bug of returning 0 on failure.

Fixes: 36541f0499fe ("clk: tegra: dfll: support PWM regulator control")
Cc: <stable@vger.kernel.org>
Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
---
 drivers/clk/tegra/clk-dfll.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/tegra/clk-dfll.c b/drivers/clk/tegra/clk-dfll.c
index cfbaa90c7adb..a5f526bb0483 100644
--- a/drivers/clk/tegra/clk-dfll.c
+++ b/drivers/clk/tegra/clk-dfll.c
@@ -1856,13 +1856,13 @@ static int dfll_fetch_pwm_params(struct tegra_dfll *td)
 			    &td->reg_init_uV);
 	if (!ret) {
 		dev_err(td->dev, "couldn't get initialized voltage\n");
-		return ret;
+		return -EINVAL;
 	}
 
 	ret = read_dt_param(td, "nvidia,pwm-period-nanoseconds", &pwm_period);
 	if (!ret) {
 		dev_err(td->dev, "couldn't get PWM period\n");
-		return ret;
+		return -EINVAL;
 	}
 	td->pwm_rate = (NSEC_PER_SEC / pwm_period) * (MAX_DFLL_VOLTAGES - 1);
 
-- 
2.17.1

