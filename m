Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E445FB721
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbiJKP3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbiJKP2d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 11:28:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D60B03D3;
        Tue, 11 Oct 2022 08:19:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CF8C611CB;
        Tue, 11 Oct 2022 14:53:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53D9C433D6;
        Tue, 11 Oct 2022 14:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665500021;
        bh=hLRDqKpU8NCQ6gseRmtzQqT678P4Fbj2rKxKZCNBxkU=;
        h=From:To:Cc:Subject:Date:From;
        b=NaLxQcIY4Tk/NCjnvVYIUsia2UHV+6hh7qm1lumvfuamhHhRzO7boaQVqxTGPDcBS
         /H3DWoXBbyi2Tdv33/zUGmVZyrYUZVa9Auaw9yjBweCmexEp9/V+uVN9tnpXn8bKTc
         xLXQSOIf/OuYhUgRf0DzAmWQh6utMey0ZFsWSFoZM2XADQaC1PUUEfQRtJRXc8/5jB
         VWMv8MFUBN2YEba0NqcdS9+qrYQ+mQSsEXjTLvyZ201G1WS7bdi0Dpw4+/BfJTKaFW
         04HQj4fyZgkCEuzfqqwKIxqmxRImXUGCgxNvl4xNsRtFjvNqWTeC8OslIpu1Zv14al
         oxCKye03vny0w==
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
Subject: [PATCH AUTOSEL 5.4 01/13] arm64: dts: qcom: sdm845: narrow LLCC address space
Date:   Tue, 11 Oct 2022 10:53:26 -0400
Message-Id: <20221011145338.1624591-1-sashal@kernel.org>
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
index 2287354fef86..76f905c32aee 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -1359,7 +1359,7 @@ uart15: serial@a9c000 {
 
 		cache-controller@1100000 {
 			compatible = "qcom,sdm845-llcc";
-			reg = <0 0x01100000 0 0x200000>, <0 0x01300000 0 0x50000>;
+			reg = <0 0x01100000 0 0x31000>, <0 0x01300000 0 0x50000>;
 			reg-names = "llcc_base", "llcc_broadcast_base";
 			interrupts = <GIC_SPI 582 IRQ_TYPE_LEVEL_HIGH>;
 		};
-- 
2.35.1

