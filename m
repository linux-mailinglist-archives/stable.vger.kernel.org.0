Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE6E37C872
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233055AbhELQIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:08:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232659AbhELQDy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:03:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B12F61977;
        Wed, 12 May 2021 15:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833631;
        bh=uIIUr9Nce5xNttf0QwWCdOvzuCLPW0+qCPHXlmEqrXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OjlsU7sXRUJ/IXco2KszQJCwq5SMqyme30oEU3avQrx/GjMRouemKjLg8/3RHzGrC
         2hJZeS+M5iWQ4PzEAWjOC0pqHVEgsMY7KXpFoYC7feKVhS5Jl2cPuUGN1kud/TmWvb
         M2Q9g/dJ4F1uLW2Hgqp0a5qc4lHDZREndjzwoVJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Iskren Chernev <iskren.chernev@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 228/601] ARM: dts: qcom: msm8974-lge-nexus5: correct fuel gauge interrupt trigger level
Date:   Wed, 12 May 2021 16:45:05 +0200
Message-Id: <20210512144835.340505848@linuxfoundation.org>
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

[ Upstream commit 9d816b423dab5b59beec5e39b97428feac599ba7 ]

The Maxim fuel gauge datasheets describe the interrupt line as active
low with a requirement of acknowledge from the CPU.  The falling edge
interrupt will mostly work but it's not correct.

Fixes: 45dfa741df86 ("ARM: dts: qcom: msm8974-lge-nexus5: Add fuel gauge")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Acked-by: Iskren Chernev <iskren.chernev@gmail.com>
Link: https://lore.kernel.org/r/20210303182816.137255-1-krzk@kernel.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dts b/arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dts
index e769f638f205..4c6f54aa9f66 100644
--- a/arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dts
+++ b/arch/arm/boot/dts/qcom-msm8974-lge-nexus5-hammerhead.dts
@@ -575,7 +575,7 @@
 			maxim,rcomp = /bits/ 8 <0x4d>;
 
 			interrupt-parent = <&msmgpio>;
-			interrupts = <9 IRQ_TYPE_EDGE_FALLING>;
+			interrupts = <9 IRQ_TYPE_LEVEL_LOW>;
 
 			pinctrl-names = "default";
 			pinctrl-0 = <&fuelgauge_pin>;
-- 
2.30.2



