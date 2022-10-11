Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3055FB4F5
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiJKOuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiJKOuU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:50:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C4125580;
        Tue, 11 Oct 2022 07:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2DBE611C1;
        Tue, 11 Oct 2022 14:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32A6C433D6;
        Tue, 11 Oct 2022 14:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499818;
        bh=KBWu++gIPGD4ncerWq2wte8CwzamDKgcnfo2AUOgxEo=;
        h=From:To:Cc:Subject:Date:From;
        b=CLoF6F1mqg//mSLnMq59jzWBr/XEFUiQEkdruySslLIfj1GFzLXkOVG/23GmTUCWA
         fcZuTA/0yYg0OfFUcrCNOus+QVzGcfAuyQ0ZKTketN1YtJ8u8iumjHh4xtcGd+Z/sX
         3lW+M24D4fQI9RRsvE9L6SmxCaOpdibREPCzfmgxWS8f08G6SV1ZySz/pgAHb8vFmH
         rIbDH3zGYiUiGlamRqmCtfz5lO0wTWkvPzXUTmiJMomTiro4BMecw5fBvKiOhxNOI7
         zfJUIK3kdjAzj4ucZjVR2Yuug1JALU9MRBiLOZO8nj2kFzT0IlCrZeTTduyOUYtNM2
         WELHBhQ2N8cgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rajendra Nayak <quic_rjendra@quicinc.com>,
        Sibi Sankar <quic_sibis@quicinc.com>,
        Steev Klimaszewski <steev@kali.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        robh+dt@kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 01/46] arm64: dts: qcom: sdm845: narrow LLCC address space
Date:   Tue, 11 Oct 2022 10:49:29 -0400
Message-Id: <20221011145015.1622882-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 300b5f661eebefb8571841b78091343eb87eca54 ]

The Last Level Cache Controller (LLCC) device does not need to access
entire LLCC address space.  Currently driver uses only hardware info and
status registers which both reside in LLCC0_COMMON range (offset
0x30000, size 0x1000).  Narrow the address space to allow binding other
drivers to rest of LLCC address space.

Cc: Rajendra Nayak <quic_rjendra@quicinc.com>
Cc: Sibi Sankar <quic_sibis@quicinc.com>
Reported-by: Steev Klimaszewski <steev@kali.org>
Suggested-by: Sibi Sankar <quic_sibis@quicinc.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Tested-by: Steev Klimaszewski <steev@kali.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220728113748.170548-11-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index f0e286715d1b..4d5ae5897d1d 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -2138,7 +2138,7 @@ uart15: serial@a9c000 {
 
 		llcc: system-cache-controller@1100000 {
 			compatible = "qcom,sdm845-llcc";
-			reg = <0 0x01100000 0 0x200000>, <0 0x01300000 0 0x50000>;
+			reg = <0 0x01100000 0 0x31000>, <0 0x01300000 0 0x50000>;
 			reg-names = "llcc_base", "llcc_broadcast_base";
 			interrupts = <GIC_SPI 582 IRQ_TYPE_LEVEL_HIGH>;
 		};
-- 
2.35.1

