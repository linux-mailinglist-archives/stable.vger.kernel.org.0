Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1A74AAD1D
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 00:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381478AbiBEXzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 18:55:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358044AbiBEXzV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 18:55:21 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92C5C061348
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 15:55:20 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id t7so14143753ljc.10
        for <stable@vger.kernel.org>; Sat, 05 Feb 2022 15:55:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5JpO8nSCWJ5pgptNli9YTAFT4dwCDnKUHXT3U/sWX34=;
        b=jeH1FymdtDrFt4JFK2U8rZPl/qhXcuT4lIIWA1/Q8bbL8go6L/+z4LwPC12T9mD7WZ
         Vs2unmWHAxo7ah4tkQFHWOpdZ0+Pqa4KbTOBsb10Zq4kkpsZRpUmXMW9eT/jjPCAGKHa
         Dif+MELfHTijFnd5qqZAkWMqnP3j/u7G7Nv//eCFKbHKhVOS5beoMDUjpPk1cez+Bz3U
         ePPtNUNg2b20GxRRIU4yVlGDs0dM9+I9IccZaTU6E6r+rrH4mfK9SMTStdgmgbsEMYR/
         cpmyHlD20cK3z0Z+jqF9hnMPwmtB9u2KTtQCqbgHkZKNw3BpZeYCfo+XduTKnKQB4rfo
         R1Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5JpO8nSCWJ5pgptNli9YTAFT4dwCDnKUHXT3U/sWX34=;
        b=7EsuzD4BpULzbDFnDLuvaxBgmDu18Rhv4ZZqyzm6zkO75vQ4uNYa2+MRqsgYo20X2b
         rWI8yFCY5ZN/oS2dJFwjfNjLGOBV32hipjfE6Gcw3Y8mnPHyM41jzIv+26A3L0gqnswi
         /DHrp2TIQe9+ePugaqQ9q32t3KRp8QT7kxoQhMXNT/KWhPuAPnb6+PqqtkTuIKFUrPjI
         sjrrm6O22aiN2beUTVGjkzHwefo/yBdoZQidnxqfbNK9Ed4dqWsVykah63KerzZMBYL4
         Enoc9dabBEqTnCpqGnnudxOJYuafvA01mGYW1LwyitOIU4gqHy333rcTmnPJE7WuuXnW
         QzOQ==
X-Gm-Message-State: AOAM531pnR8fIaK/c0SEzc3gms6ikS8DkYTlHIWD4ps7QKlh/igKgmyy
        khhAtDgmfXJtb/OCjLIs+Ji8YA==
X-Google-Smtp-Source: ABdhPJyOsBz2Y4FU0mvX5RK+wfUe32KmfN65duRJAv+4ri3J7IvpqWW/+gG2JqOLCtvIoyPWnzUOgw==
X-Received: by 2002:a05:651c:a12:: with SMTP id k18mr4206115ljq.156.1644105319159;
        Sat, 05 Feb 2022 15:55:19 -0800 (PST)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id m12sm893906lfj.90.2022.02.05.15.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 15:55:18 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     arm@kernel.org, soc@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        stable@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>
Subject: [PATCH] ARM: dts: Fix boot regression on Skomer
Date:   Sun,  6 Feb 2022 00:53:12 +0100
Message-Id: <20220205235312.446730-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The signal routing on the Skomer board was incorrect making
it impossible to mount root from the SD card. Fix this up.

Cc: stable@vger.kernel.org
Cc: Stefan Hansson <newbyte@disroot.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ARM SoC folks: please apply this directly for fixes.
---
 arch/arm/boot/dts/ste-ux500-samsung-skomer.dts | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts b/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts
index 9d09dffc1aa5..1129b5049805 100644
--- a/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts
+++ b/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts
@@ -207,10 +207,6 @@ mmc@80126000 {
 			cap-sd-highspeed;
 			cap-mmc-highspeed;
 			/* All direction control is used */
-			st,sig-dir-cmd;
-			st,sig-dir-dat0;
-			st,sig-dir-dat2;
-			st,sig-dir-dat31;
 			st,sig-pin-fbclk;
 			full-pwr-cycle;
 			vmmc-supply = <&ab8500_ldo_aux3_reg>;
-- 
2.34.1

