Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10DB37C904
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236048AbhELQOb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:14:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237182AbhELQDx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:03:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2BF46197F;
        Wed, 12 May 2021 15:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833634;
        bh=dWeYRC+Ru7a+A0L0UXgoaQBLPRsbVWw6JdB9hViz1JU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fwd9Bv/PeCeE0NSkXS8733fCuzS66YczAT9BRIlvXFryR52sJzFPy6OJrfTqGKBGL
         orZHiXOZVKJad7TZtk+7uWeyIoyQtMCJL8/YiUNZ+3OukueEJ682zt4owOsSQNLR+4
         7Hj9Vofv1j6z/KKnF37J1sk4gCk0RT6kThB+iCZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Iskren Chernev <iskren.chernev@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 229/601] ARM: dts: qcom: msm8974-samsung-klte: correct fuel gauge interrupt trigger level
Date:   Wed, 12 May 2021 16:45:06 +0200
Message-Id: <20210512144835.372289797@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 5fde3361ba57a9b4eb560dabf859176909d61004 ]

The Maxim fuel gauge datasheets describe the interrupt line as active
low with a requirement of acknowledge from the CPU.  The falling edge
interrupt will mostly work but it's not correct.

Fixes: da8d46992e67 ("ARM: dts: qcom: msm8974-klte: Add fuel gauge")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Acked-By: Iskren Chernev <iskren.chernev@gmail.com>
Tested-By: Iskren Chernev <iskren.chernev@gmail.com>
Link: https://lore.kernel.org/r/20210303182816.137255-2-krzk@kernel.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts b/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts
index 97352de91314..64a3fdb79539 100644
--- a/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts
+++ b/arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts
@@ -691,7 +691,7 @@
 			maxim,rcomp = /bits/ 8 <0x56>;
 
 			interrupt-parent = <&pma8084_gpios>;
-			interrupts = <21 IRQ_TYPE_EDGE_FALLING>;
+			interrupts = <21 IRQ_TYPE_LEVEL_LOW>;
 
 			pinctrl-names = "default";
 			pinctrl-0 = <&fuelgauge_pin>;
-- 
2.30.2



