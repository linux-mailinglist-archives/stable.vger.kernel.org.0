Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C42532FEA8
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 05:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhCGESU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 23:18:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbhCGERx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 23:17:53 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03DBBC06174A;
        Sat,  6 Mar 2021 20:17:52 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id p21so4172362pgl.12;
        Sat, 06 Mar 2021 20:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BwSr78t+B2LUeJacm/isuxGQ5VeOpmr80Bmxx6BZVJo=;
        b=as0fSSEQ1NH7aMWnQJdht3ERxBRoYl7zromvnpBnG5ajSrMlb8rmFESSDKeHSZjzzy
         tMjAGVm7JrPUrlgks3ZZN95V4PCjjZpHiGJeow1D+uLgD2YpjbH6QsN24WuXveF8OglL
         wTn1e2wj+a3CMGLfOwOXu1LQQrk98KtjFUMAJVEgFXYeW1YMoB9oSHbE5JSDr6/jbYnH
         UYwXNuf+V66jORDBKDQ2nzgySvZktKUESK1EfFS9suQRJxxPc1M+y6uxkWRfxDozgexc
         hgQx6MxapEWZwFNQ9FLVihY0euCGT2J+sSCUUGjr6+XLKdPIxeBnhtNtLgHUtzjhYVqU
         vo0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BwSr78t+B2LUeJacm/isuxGQ5VeOpmr80Bmxx6BZVJo=;
        b=i5TEVSKUM7KC142QvWLD826wUQ90r4PZKdy7jQ7+Sl24u4PpBPacpdJstCccbR8UPn
         nQccG2GEKBMxxLOOIQSpRUa7mzXTIchiZQqGAmJqpxfw1T3nooOOa8n2bghO4FVECk8T
         cGFce72IPnpoHPZwT6XeO1U9BdfowX1mRuw7MWINTo+fju3vJTVQqzDlWdjdasm9aGvG
         kROfRHtawGxfQ2chbrQn4o3Ghu8jIJ2pY2O2cAqmRGknBrvMvhBDE/nN1yPVyKOnsGUM
         Hmofdre2poYxBwIIzrFeTLFnf8C/aH404Y7CrkNdg5tiM7Xk+7WVmhA9h2e3YltaQsqA
         FV2w==
X-Gm-Message-State: AOAM532SWRE2imtDNcY+6ex+BoYm2SGiNVB3P5gGsu1VJj+UcmebJiDI
        ABvhGULDH4SwecB5fIJkUnk=
X-Google-Smtp-Source: ABdhPJxLQpQr+02pM9SlbvqEMAX/ywdeetyk6A67y+MpRa93jDqkPyR1VEHC5c4FGKmWfQkpS9UHzg==
X-Received: by 2002:a62:43:0:b029:1cd:2de2:5a24 with SMTP id 64-20020a6200430000b02901cd2de25a24mr15382313pfa.27.1615090672295;
        Sat, 06 Mar 2021 20:17:52 -0800 (PST)
Received: from z640-arch.lan ([2602:3f:e6a6:5d00::678])
        by smtp.gmail.com with ESMTPSA id l3sm6406619pfc.81.2021.03.06.20.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 20:17:51 -0800 (PST)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        John Crispin <john@phrozen.org>, linux-mips@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] MIPS: pci-mt7620: fix PLL lock check
Date:   Sat,  6 Mar 2021 20:17:24 -0800
Message-Id: <20210307041724.3185139-1-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream a long-standing OpenWrt patch [0] that fixes MT7620 PCIe PLL
lock check. The existing code checks the wrong register bit: PPLL_SW_SET
is not defined in PPLL_CFG1 and bit 31 of PPLL_CFG1 is marked as reserved
in the MT7620 Programming Guide. The correct bit to check for PLL lock
is PPLL_LD (bit 23).

Also reword the error message for clarity.

Without this change it is unlikely that this driver ever worked with
mainline kernel.

[0]: https://lists.infradead.org/pipermail/lede-commits/2017-July/004441.html

Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc: John Crispin <john@phrozen.org>
Cc: linux-mips@vger.kernel.org
Cc: linux-mediatek@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
---
 arch/mips/pci/pci-mt7620.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/mips/pci/pci-mt7620.c b/arch/mips/pci/pci-mt7620.c
index d36061603752..e032932348d6 100644
--- a/arch/mips/pci/pci-mt7620.c
+++ b/arch/mips/pci/pci-mt7620.c
@@ -30,6 +30,7 @@
 #define RALINK_GPIOMODE			0x60
 
 #define PPLL_CFG1			0x9c
+#define PPLL_LD				BIT(23)
 
 #define PPLL_DRV			0xa0
 #define PDRV_SW_SET			BIT(31)
@@ -239,8 +240,8 @@ static int mt7620_pci_hw_init(struct platform_device *pdev)
 	rt_sysc_m32(0, RALINK_PCIE0_CLK_EN, RALINK_CLKCFG1);
 	mdelay(100);
 
-	if (!(rt_sysc_r32(PPLL_CFG1) & PDRV_SW_SET)) {
-		dev_err(&pdev->dev, "MT7620 PPLL unlock\n");
+	if (!(rt_sysc_r32(PPLL_CFG1) & PPLL_LD)) {
+		dev_err(&pdev->dev, "pcie PLL not locked, aborting init\n");
 		reset_control_assert(rstpcie0);
 		rt_sysc_m32(RALINK_PCIE0_CLK_EN, 0, RALINK_CLKCFG1);
 		return -1;
-- 
2.30.1

