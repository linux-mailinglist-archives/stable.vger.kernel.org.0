Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAFEA56FDC0
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234154AbiGKJ76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234211AbiGKJ7E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:59:04 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAA7B6290;
        Mon, 11 Jul 2022 02:27:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B477ECE1268;
        Mon, 11 Jul 2022 09:27:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E774C34115;
        Mon, 11 Jul 2022 09:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531650;
        bh=73Uh7vu2OsPbWICEJYHjM7Eli153prRiBAG3rtQxm8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r8svoC5bvpKyqWRQ47p0LXKJKTdNaA3PEnsjKhDpg7rdD+syy0T08eixgbRdBbE7v
         Be9m8oIwukF5Y2jBQfvZT0l6076zy6oCzfDAkQAbLMWq77o269ras3bgBWEWvsGEqu
         yBv5Z4c8oWXO6ITuP+Wtii4kjqqhC6CdYtwW9YY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 183/230] arm64: dts: qcom: sdm845: use dispcc AHB clock for mdss node
Date:   Mon, 11 Jul 2022 11:07:19 +0200
Message-Id: <20220711090609.301392757@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 3ba500dee327e0261e728edec8a4f2f563d2760c ]

It was noticed that on sdm845 after an MDSS suspend/resume cycle the
driver can not read HW_REV registers properly (they will return 0
instead). Chaning the "iface" clock from <&gcc GCC_DISP_AHB_CLK> to
<&dispcc DISP_CC_MDSS_AHB_CLK> fixes the issue.

Fixes: 08c2a076d18f ("arm64: dts: qcom: sdm845: Add dpu to sdm845 dts file")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220531124735.1165582-1-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index d20eacfc1017..ea7a272d267a 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -4147,7 +4147,7 @@
 
 			power-domains = <&dispcc MDSS_GDSC>;
 
-			clocks = <&gcc GCC_DISP_AHB_CLK>,
+			clocks = <&dispcc DISP_CC_MDSS_AHB_CLK>,
 				 <&dispcc DISP_CC_MDSS_MDP_CLK>;
 			clock-names = "iface", "core";
 
-- 
2.35.1



