Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E753EFE7D9
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 23:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbfKOWeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 17:34:01 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38397 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727080AbfKOWeB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 17:34:01 -0500
Received: by mail-pl1-f194.google.com with SMTP id q18so1926155pls.5
        for <stable@vger.kernel.org>; Fri, 15 Nov 2019 14:33:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2t2lfkYvCG1qZ4zH71UsZZVKevqEX7pyTohdYU3/dDg=;
        b=TSxkLjjusnWyOxYQuwJ0yeo2qVuacsTryAzYn0nABmfZ+giChdSbiAlTILiu0av+QY
         jkWKBo4DLgZtHrpz+tdF+VlAgQsfA3OdIm5fhLhv9vSP8EAGtXSK+OSQOTBRtAQcct2g
         QR0Sglw0sLDa8vkUzDJ7iwCPgDCjEiKh+VvE3qSkwQesXq0iaKdptZvJJxiDYbc1N+j4
         xaT/k5+AjeJLF9P+ANrQoOWHWCa16LHqeI0KGWEjIvKKArK5TYv/F94+FbsrOhMSzjwN
         nH0qNcPvGaUtYtZ3JDYIjIjaFjXf66XE2kFG4WMS8hUVt2ONxPzvC68OWC0+AqOf4NGA
         wEtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2t2lfkYvCG1qZ4zH71UsZZVKevqEX7pyTohdYU3/dDg=;
        b=gnV30p4F2VFX5wwXWpfmtY79OoA4ZAC2hj/FDfihSiOs9HSS6vSrKf2FeK+rSDT+J8
         7sOznzFXB/H7L37jgFv9V+i7R0RZUjtomZA5yimw4Nwbml4W1XkyU1OcMsA6cgy32m7Z
         jr/MrDVK1ONDhrn/tTE1FPZj7zWBpCgavfNxdz7V7zB2YJbzeu27HHw7Jl28iYlMb0Bd
         MpH2eq6tHz2vKdMnlFZUWeqja7rDhxtGL49MbikNrR+0/WTf4sAKs/QC6dMuwt/Q13UR
         u0/FVLNykdlCXUq2rdrF+kRiowXCD9cakHYdxOxOm71paM08Vk21O0oY+DI3NDyqwdAI
         CKzQ==
X-Gm-Message-State: APjAAAVYOE5P2LSmQ6sGmlr/p1iyFUsQaugBRlT0Hlus8VD2uy/w2cE9
        mMf2IQOD5Si/kDnkj89pbsEvMKosOPg=
X-Google-Smtp-Source: APXvYqyCcGnCxpjNDXnOlQ5PDU1yc/iIX1FpvG9yax85c887grRTZSpLNG9/CAqWEFTR/yqC0+Ui1Q==
X-Received: by 2002:a17:902:9a47:: with SMTP id x7mr3791386plv.84.1573857238838;
        Fri, 15 Nov 2019 14:33:58 -0800 (PST)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id m15sm11699724pfh.19.2019.11.15.14.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 14:33:58 -0800 (PST)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [stable 4.19+][PATCH 02/20] ARM: dts: stm32: relax qspi pins slew-rate for stm32mp157
Date:   Fri, 15 Nov 2019 15:33:38 -0700
Message-Id: <20191115223356.27675-2-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191115223356.27675-1-mathieu.poirier@linaro.org>
References: <20191115223356.27675-1-mathieu.poirier@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrice Chotard <patrice.chotard@st.com>

commit 86ec2e1739aa1d6565888b4b2059fa47354e1a89 upstream

Relax qspi pins slew-rate to minimize peak currents.

Fixes: 844030057339 ("ARM: dts: stm32: add flash nor support on stm32mp157c eval board")

Link: https://lore.kernel.org/r/20191025130122.11407-1-alexandre.torgue@st.com
Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: stable <stable@vger.kernel.org> # 4.19+
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 arch/arm/boot/dts/stm32mp157-pinctrl.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp157-pinctrl.dtsi b/arch/arm/boot/dts/stm32mp157-pinctrl.dtsi
index c4851271e810..d9dce0c804e1 100644
--- a/arch/arm/boot/dts/stm32mp157-pinctrl.dtsi
+++ b/arch/arm/boot/dts/stm32mp157-pinctrl.dtsi
@@ -290,13 +290,13 @@
 						 <STM32_PINMUX('F', 6, AF9)>; /* QSPI_BK1_IO3 */
 					bias-disable;
 					drive-push-pull;
-					slew-rate = <3>;
+					slew-rate = <1>;
 				};
 				pins2 {
 					pinmux = <STM32_PINMUX('B', 6, AF10)>; /* QSPI_BK1_NCS */
 					bias-pull-up;
 					drive-push-pull;
-					slew-rate = <3>;
+					slew-rate = <1>;
 				};
 			};
 
@@ -308,13 +308,13 @@
 						 <STM32_PINMUX('G', 7, AF11)>; /* QSPI_BK2_IO3 */
 					bias-disable;
 					drive-push-pull;
-					slew-rate = <3>;
+					slew-rate = <1>;
 				};
 				pins2 {
 					pinmux = <STM32_PINMUX('C', 0, AF10)>; /* QSPI_BK2_NCS */
 					bias-pull-up;
 					drive-push-pull;
-					slew-rate = <3>;
+					slew-rate = <1>;
 				};
 			};
 
-- 
2.17.1

