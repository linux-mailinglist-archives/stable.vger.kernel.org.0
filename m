Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C781B6905EB
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 11:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjBIK72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 05:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjBIK7X (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 05:59:23 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B63156EE7
        for <stable@vger.kernel.org>; Thu,  9 Feb 2023 02:58:53 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id j23so1399508wra.0
        for <stable@vger.kernel.org>; Thu, 09 Feb 2023 02:58:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pd0EQYT3xvLBAFUxEB4SCOk7tTyLtVzSlTgWwVunhmk=;
        b=UFZhwjMoAe2pnTCeATgA/mdyCkRt4+QrdBV6RUM2SauFGIs3EVL7kYrr2Gdk0/5NOB
         CehvN6CB9zsV3ASLc1n09sE5dpdnTw1HXQ2m+q8jdg4YHEk0oXkJMcuS/e/JRiuAx9j1
         ynt4EweDSuSOrbWbsswRcIpDcZZNlDZHbt1P484cFTMhsHaWFkrmQT09T4RFzR1kIYcu
         hCw1QzT0mHQrdZZfUPBvfRJwAlYPlMZwHq0DpqP8ZL9JORVeBTq/aaGjU1bDAxC4hIvL
         XkTkQJiogrOQTRAYE8/oSVjdrah3IXTBYUlxeM0VdyQLQ/fieNt6FMT2EljGzvnkpwHM
         5oHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pd0EQYT3xvLBAFUxEB4SCOk7tTyLtVzSlTgWwVunhmk=;
        b=N+lSXFtx6hpSvTNWcchGkXx5p8a1gNhssJ7xgEP3/xOFAA5sxwpkGRTzDMewYp31xi
         5lCx2pqeHXfkYR+4SFjqEKPo/uEchBYMkt9ZXvVVNkae9e4/7M+RPTWxOqMZyGSO3OK3
         25RpJrt3wfESJLP9x+//QV122zMxcwseMeXhKMb27D2XUdVyzkmCiUI5ExRYycDXwNZf
         25VAQncwNFImtzRwv8yfMNsPBuhGyrJYaRs1UfebYOmKvEL2KyQ1Ig7svw3wcepcq+Gm
         6iG3eh5FE07Xq5/lC+L2qy82pN55ZUymNWt5YXwSf8iP4q/cKEVF0NUhZfh62zBTiGS+
         mTyg==
X-Gm-Message-State: AO0yUKUt3C83CmMRKFyZ0fp0nfaFN5M5FL45r6/cwBgxcvNO00q1aBGX
        3HtNrx9HRsWKVXO9mHmpA7fADQ==
X-Google-Smtp-Source: AK7set/R3KiMZzutxvymKpWErO+61RIIKefXKnc/dsa7Oh8E0bx1yHDWxhuoSFrpG29x5LeTQHhe9A==
X-Received: by 2002:adf:a306:0:b0:2c5:3cd0:88e7 with SMTP id c6-20020adfa306000000b002c53cd088e7mr977911wrb.29.1675940330748;
        Thu, 09 Feb 2023 02:58:50 -0800 (PST)
Received: from krzk-bin.. ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id g7-20020a5d6987000000b002be063f6820sm927987wru.81.2023.02.09.02.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 02:58:50 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Anand Moon <linux.amoon@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 3/6] ARM: dts: exynos: correct TMU phandle in Exynos5250
Date:   Thu,  9 Feb 2023 11:58:38 +0100
Message-Id: <20230209105841.779596-3-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209105841.779596-1-krzysztof.kozlowski@linaro.org>
References: <20230209105841.779596-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

TMU node uses 0 as thermal-sensor-cells, thus thermal zone referencing
it must not have an argument to phandle.

Cc: <stable@vger.kernel.org>
Fixes: 9843a2236003 ("ARM: dts: Provide dt bindings identical for Exynos TMU")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 arch/arm/boot/dts/exynos5250.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index c76c3a79bbc6..89c8665ac9aa 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -1105,7 +1105,7 @@ timer {
 &cpu_thermal {
 	polling-delay-passive = <0>;
 	polling-delay = <0>;
-	thermal-sensors = <&tmu 0>;
+	thermal-sensors = <&tmu>;
 
 	cooling-maps {
 		map0 {
-- 
2.34.1

