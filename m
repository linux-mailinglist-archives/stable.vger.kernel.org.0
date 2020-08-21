Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80EF24DE4C
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbgHUR2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:28:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbgHUQOo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:14:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3956D22BF3;
        Fri, 21 Aug 2020 16:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026478;
        bh=M2WL2UqZEDBFR9WlYCqZMED3xmrepfVxWIbSJFDcHNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wOo/FJBF5kQSAaA0b4T9cAaswPWeZ8F55RGixIKEUe10NIsrfrD7UM/sJBLEO/msx
         /jAmNrWbfLlZ9VP4vgIYKRdqImk37t9REJJO8M+9LrGOal8e2N4YaBkJ2Vys7kKIcr
         iUpPjHX7nGoqwH7Qi1hsrAdbx8YxibazU80oPrRM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephan Gerhold <stephan@gerhold.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 11/62] arm64: dts: qcom: msm8916: Pull down PDM GPIOs during sleep
Date:   Fri, 21 Aug 2020 12:13:32 -0400
Message-Id: <20200821161423.347071-11-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161423.347071-1-sashal@kernel.org>
References: <20200821161423.347071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit e2ee9edc282961783d519c760bbaa20fed4dec38 ]

The original qcom kernel changed the PDM GPIOs to be pull-down
during sleep at some point. Reportedly this was done because
there was some "leakage at PDM outputs during sleep":

  https://source.codeaurora.org/quic/la/kernel/msm-3.10/commit/?id=0f87e08c1cd3e6484a6f7fb3e74e37340bdcdee0

I cannot say how effective this is, but everything seems to work
fine with this change so let's apply the same to mainline just
to be sure.

Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20200605185916.318494-3-stephan@gerhold.net
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8916-pins.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8916-pins.dtsi b/arch/arm64/boot/dts/qcom/msm8916-pins.dtsi
index 5785bf0a807ce..591f48a575353 100644
--- a/arch/arm64/boot/dts/qcom/msm8916-pins.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916-pins.dtsi
@@ -569,7 +569,7 @@ pinconf {
 				pins = "gpio63", "gpio64", "gpio65", "gpio66",
 				       "gpio67", "gpio68";
 				drive-strength = <2>;
-				bias-disable;
+				bias-pull-down;
 			};
 		};
 	};
-- 
2.25.1

