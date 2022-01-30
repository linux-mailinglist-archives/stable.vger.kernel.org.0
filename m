Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0784A3744
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 16:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355445AbiA3P1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Jan 2022 10:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355439AbiA3P1Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Jan 2022 10:27:24 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C95C061714;
        Sun, 30 Jan 2022 07:27:24 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id n12-20020a05600c3b8c00b0034eb13edb8eso6541004wms.0;
        Sun, 30 Jan 2022 07:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M0F+HzCmfFkZhhA5GVZSk7LS0FRyBdrUMs+hALno+og=;
        b=HHH4AjpTv8Dw7eKZmrdJJqAKeEvQW3gjfra/tFHN2EzVsGB5vgB9PDUrwdhsq3yeQS
         swwE6CWvjOG5oPntOl2fG04zLhKbmfvFnZJpiCGQB3+qJsM6WS7sWn6WEF94hi7YI2N9
         c+3Jt5c+IVclsUFFbNznJZQF8J/na1I9Yt87uWAow/BpliPWnw+nNuc/Y0f4IlbLffir
         0TAgsiiaDgqaayi8MGXSIwmEqU2Kkv/pPMwprRFGSx9MNau3nykRDZsa+dhhy8UWHQpV
         XSHvIdOixgflew0M6Apa2xfNb+yVOEWyJ1hQNGVlkYvFS3DHJVeJhcxKZId5Zg8QvbsV
         pN0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M0F+HzCmfFkZhhA5GVZSk7LS0FRyBdrUMs+hALno+og=;
        b=s3210S5mBzCA/dae4XyikA627Ozgq6LqmGVNCeUYE1rUssKIB3qMNhUEuLOFP7DlN3
         a9laolPKmAR4tqcfvj6TJAxPo3NzlotS7YzPD56pqf5qSWXwkYl/iUhjMTSQMQwlVKMe
         bb5+JE+Gf+TnvBYTPiKdUPr70V1eaXk/9+0gVMv8mLOV5m3izznuQSmHmrX1cVwfoBRD
         0toNHzLhr8coGtVQx0NWuWRVLsFlNTdQMlRUrXr/STgZskiwvZq3GodSliXjp+N/uMMq
         zOrFsCuHPGV+sdjZgqaQyT3LTKzoGX8IA2wscjeXrCXnV+MGv8dKQrtF0TPIE9GuBWHm
         GUEQ==
X-Gm-Message-State: AOAM530sRQaOvDT43xrjU6B7T6CNqXJgOZqSAmCfyPQcbse2XtAcXZxw
        CtzCUYj84hUe60Erwr2kbvk=
X-Google-Smtp-Source: ABdhPJzlQoKGNrSZe/aJNh2YZSd7efE3HmJEbXmeg+HInoCCF6VtWJp/rJQaZd77rIekxd6/ddYWUQ==
X-Received: by 2002:a1c:1f0c:: with SMTP id f12mr14939908wmf.44.1643556443067;
        Sun, 30 Jan 2022 07:27:23 -0800 (PST)
Received: from localhost.localdomain ([195.245.21.30])
        by smtp.gmail.com with ESMTPSA id n11sm7477781wms.3.2022.01.30.07.27.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jan 2022 07:27:22 -0800 (PST)
From:   Alexander Sverdlin <alexander.sverdlin@gmail.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Alexander Sverdlin <alexander.sverdlin@gmail.com>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Russell King <linux@armlinux.org.uk>,
        Nikita Shubin <nikita.shubin@maquefel.me>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        kernel test robot <lkp@intel.com>, stable@vger.kernel.org
Subject: [PATCH v2] ep93xx: clock: Fix UAF in ep93xx_clk_register_gate()
Date:   Sun, 30 Jan 2022 16:25:02 +0100
Message-Id: <20220130152502.236531-1-alexander.sverdlin@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

arch/arm/mach-ep93xx/clock.c:154:2: warning: Use of memory after it is freed [clang-analyzer-unix.Malloc]
arch/arm/mach-ep93xx/clock.c:151:2: note: Taking true branch
if (IS_ERR(clk))
^
arch/arm/mach-ep93xx/clock.c:152:3: note: Memory is released
kfree(psc);
^~~~~~~~~~
arch/arm/mach-ep93xx/clock.c:154:2: note: Use of memory after it is freed
return &psc->hw;
^ ~~~~~~~~

Link: https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org/thread/B5YCO2NJEXINCYE26Y255LCVMO55BGWW/
Reported-by: kernel test robot <lkp@intel.com>
Fixes: 9645ccc7bd7a ("ep93xx: clock: convert in-place to COMMON_CLK")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
---
Changelog:
v2:
- Thanks to Nick for the hint to use ERR_CAST()

 arch/arm/mach-ep93xx/clock.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-ep93xx/clock.c b/arch/arm/mach-ep93xx/clock.c
index cc75087134d3..4aee14f18123 100644
--- a/arch/arm/mach-ep93xx/clock.c
+++ b/arch/arm/mach-ep93xx/clock.c
@@ -148,8 +148,10 @@ static struct clk_hw *ep93xx_clk_register_gate(const char *name,
 	psc->lock = &clk_lock;
 
 	clk = clk_register(NULL, &psc->hw);
-	if (IS_ERR(clk))
+	if (IS_ERR(clk)) {
 		kfree(psc);
+		return ERR_CAST(clk);
+	}
 
 	return &psc->hw;
 }
-- 
2.34.1

