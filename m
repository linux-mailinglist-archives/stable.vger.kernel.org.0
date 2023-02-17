Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9010969AF02
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 16:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbjBQPHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 10:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbjBQPHF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 10:07:05 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FEC26FF00
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 07:06:45 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id g29so470774eda.5
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 07:06:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AfR58zk5Lq0Y4NpQRVcnXrMaw/hr0XQUMG7wTZBuFEA=;
        b=xltorjJqnSMn9avO+CAsyd8bicX3NQVHPp2PNAklprp4tJLGKGevWTMcEr34ls0ZFC
         0bR/EVXvyCS4R+RWN8/dbeBa7h0tRyd1m+OL80XEfzI8MHMmrl3exVUscP7io7EsB+Qa
         QjtZEUk+8K0oUV4OYsdx2ubv3woHrCuuGsCAn+WSQf8t8WfDFfBk+kl+6q9C27hg0+Xu
         L4Jj4rmMKdBgC2Sp2oc01OLN3V9PQk5YFyLPYGBC2FN+EyBcpO3JZveG+9m+/Rc+hAVj
         Q085YiwR1p+xvLr36lC9k811UeBquC44G4SKDBBpsaNBjY4Mo8NqL9CpcjFIrPBTfl5m
         zSZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AfR58zk5Lq0Y4NpQRVcnXrMaw/hr0XQUMG7wTZBuFEA=;
        b=P7Ua1JkWmu4XUF9KvVaFtRX3DX6i+Ohv2cJVO8z94+mU0uWwwEJkXR8nafA1jTx9kr
         STC1mcw5WzRdV5p3T1OUUAsQr6E5OFFLkq1Gs3Ia+rhduPqGJsnIqHK5RXbW0isqyCI0
         HvVlr0Hy2WHaOtICSdZcEkdrtRtxxzuevKUyl2wvFL3HCECI74sayqrjNhWyrvRPJlk2
         WhF5yWGIR7tkxKk6Uz/qXF1L6gAT87Xk0U/RqX0eSy8U4JgkdTdrn+GdoOBUYuHy8eQX
         QDZa3+FgYk/3BdIa00IX15pLjvDE7tt8Gv3AWv5CatF+10Vd+gGPBJnn3tKa19EmGxXz
         aEKA==
X-Gm-Message-State: AO0yUKVIEXs2SFylhS+726VHGqSkyGe4gtSyxntyaqthx0uocVOzj5al
        nygm2pgh76uTR44ONjZeTlQ/cw==
X-Google-Smtp-Source: AK7set/KwPZmBYn2iAIMR26SlMvThSNNLiKnjZs3zyLE9MpxGJ+X05/w4/XNBlegEFA+gRT9U4tMJw==
X-Received: by 2002:a17:906:5a4c:b0:8b1:811e:cd30 with SMTP id my12-20020a1709065a4c00b008b1811ecd30mr2904858ejc.22.1676646401896;
        Fri, 17 Feb 2023 07:06:41 -0800 (PST)
Received: from krzk-bin.. ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id fx15-20020a170906b74f00b008b14ba6c954sm2221303ejb.194.2023.02.17.07.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 07:06:41 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        - <patches@opensource.cirrus.com>,
        Adrien Grassein <adrien.grassein@gmail.com>,
        Randy Li <ayaka@soulik.info>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 3/3] ARM: dts: exynos: fix WM8960 clock name in Itop Elite
Date:   Fri, 17 Feb 2023 16:06:27 +0100
Message-Id: <20230217150627.779764-3-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230217150627.779764-1-krzysztof.kozlowski@linaro.org>
References: <20230217150627.779764-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The WM8960 Linux driver expects the clock to be named "mclk".  Otherwise
the clock will be ignored and not prepared/enabled by the driver.

Cc: <stable@vger.kernel.org>
Fixes: 339b2fb36a67 ("ARM: dts: exynos: Add TOPEET itop elite based board")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 arch/arm/boot/dts/exynos4412-itop-elite.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4412-itop-elite.dts b/arch/arm/boot/dts/exynos4412-itop-elite.dts
index b596e997e451..6260da187e92 100644
--- a/arch/arm/boot/dts/exynos4412-itop-elite.dts
+++ b/arch/arm/boot/dts/exynos4412-itop-elite.dts
@@ -182,7 +182,7 @@ codec: audio-codec@1a {
 		compatible = "wlf,wm8960";
 		reg = <0x1a>;
 		clocks = <&pmu_system_controller 0>;
-		clock-names = "MCLK1";
+		clock-names = "mclk";
 		wlf,shared-lrclk;
 		#sound-dai-cells = <0>;
 	};
-- 
2.34.1

