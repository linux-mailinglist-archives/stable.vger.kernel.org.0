Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59FBA17C00C
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 15:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgCFOQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 09:16:42 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:33541 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbgCFOQm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Mar 2020 09:16:42 -0500
Received: by mail-lf1-f68.google.com with SMTP id c20so2074473lfb.0
        for <stable@vger.kernel.org>; Fri, 06 Mar 2020 06:16:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9/0gI8ozQuxXpqjac2sUOEwjrc0MZgkTZf8Mr1Hp6Z8=;
        b=g6MK4Dz2QTTwOchAt/bZludSNiE1qznro2tEwdQ+lN0IwcwvagVPwYV5X3RCu3MsGX
         sOYGk9wMmhLCum0JYYcLvVM40NNBdZhXKtS1vAdl3i0RK7HAdcDQQIAB9elAGwVJvPkV
         I2nVa+mmig6+mzLBg4+XDyb65QIPknOReIBBUpNTt89rgFnmd9CMIyszMRBDFH288vT9
         V8P4YMf7zvD2elx4eHMzucw4WUREyxAROzSvjPjXmD4R5b4xTwa5Khzguld7USWwbJA+
         kY5K6dVpRm3Wo29rRmngsc7hd9qfFt9ipWnTLAiiwoy3Y+vVLivvS4x4eQ+GWAT+kms4
         z6fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9/0gI8ozQuxXpqjac2sUOEwjrc0MZgkTZf8Mr1Hp6Z8=;
        b=LEfjEecz7+j6xRqq4r3TCzdN7fdxX9I8x1/RBdaYt9ky7nS5AizhX7XVUunkHGhNNZ
         lHQuzKXA1vdEuLraOCk64DjBmpTaG7VM5DPeNEdFGNWa1j/ebYNQUjBWEqT/TUyZlULV
         44UNeerruYlme/GyilbIfeJiaaXeeh3BUnxL08MirIkAiLfXborwz1QF4W0yIvv5f1XP
         w9Nw5M6AP4JAw9QEVAGoKXp3D2jUbEpqnfxPVAh2pZnqB9Kf1AQVZ1DcyPapvuMEdXmA
         +BF/pzDeLPbSNK++8J/7DtLouKM5AVNW3bUxbVFZxWC0/ER3QCC9sbnUcduHVWUxfFtR
         lwjg==
X-Gm-Message-State: ANhLgQ0C8eVYQuC7TpGLEZo5LwxQPgzLZuvDrdN7nbbfIc4s4PjSA64/
        JCbw2LW6D+sfU9UaQEWR1PMwWA==
X-Google-Smtp-Source: ADFU+vua8wOdWgh1ZGzlneSxkj1QwGcR0M4r32jtX0/GZXVhZS3OB+rKpPcQ3EiomUCXXxoe/GKFzQ==
X-Received: by 2002:ac2:50c7:: with SMTP id h7mr2141447lfm.101.1583504199950;
        Fri, 06 Mar 2020 06:16:39 -0800 (PST)
Received: from genomnajs.ideon.se ([85.235.10.227])
        by smtp.gmail.com with ESMTPSA id s17sm13765957lfs.6.2020.03.06.06.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 06:16:39 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-gpio@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Brian Masney <masneyb@onstation.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] pinctrl: qcom: ssbi-gpio: Fix fwspec parsing bug
Date:   Fri,  6 Mar 2020 15:16:37 +0100
Message-Id: <20200306141637.1434388-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We are parsing SSBI gpios as fourcell fwspecs but they are
twocell. Probably a simple copy-and-paste bug.

Tested on the APQ8060 DragonBoard and after this ethernet
and MMC card detection works again.

Cc: Brian Masney <masneyb@onstation.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: stable@vger.kernel.org
Fixes: ae436fe81053 ("pinctrl: ssbi-gpio: convert to hierarchical IRQ helpers in gpio core")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c b/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c
index dca86886b1f9..6b7f0d56a532 100644
--- a/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c
+++ b/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c
@@ -794,7 +794,7 @@ static int pm8xxx_gpio_probe(struct platform_device *pdev)
 	girq->fwnode = of_node_to_fwnode(pctrl->dev->of_node);
 	girq->parent_domain = parent_domain;
 	girq->child_to_parent_hwirq = pm8xxx_child_to_parent_hwirq;
-	girq->populate_parent_fwspec = gpiochip_populate_parent_fwspec_fourcell;
+	girq->populate_parent_fwspec = gpiochip_populate_parent_fwspec_twocell;
 	girq->child_offset_to_irq = pm8xxx_child_offset_to_irq;
 	girq->child_irq_domain_ops.translate = pm8xxx_domain_translate;
 
-- 
2.24.1

