Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4714B59D735
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348624AbiHWJRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349401AbiHWJP4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:15:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE4C16DAE5;
        Tue, 23 Aug 2022 01:32:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E0D06123D;
        Tue, 23 Aug 2022 08:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68F3C433D6;
        Tue, 23 Aug 2022 08:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243539;
        bh=TmwB1yyIO7hlQxEEZ3YP1Hse/khGDr1TusJ9UJG8jgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KCBR+26xAnyk1YQjv5JdDVTIM8F/AsaRGYO4ew1ReG/eACdxMRFZroWc66BvYZEHK
         IMdkI3peg283gi5yUW2KxU99pmy2EFXZ0+ha+QfqWFi6DWqeRkQGj7T0eenknJGwUR
         qva+cUYbmdcf8HTAF55pWfc/yEYubPs0PT1zWgdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Stafford Horne <shorne@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 309/365] openrisc: io: Define iounmap argument as volatile
Date:   Tue, 23 Aug 2022 10:03:30 +0200
Message-Id: <20220823080131.102623174@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stafford Horne <shorne@gmail.com>

[ Upstream commit 52e0ea900202d23843daee8f7089817e81dd3dd7 ]

When OpenRISC enables PCI it allows for more drivers to be compiled
resulting in exposing the following with -Werror.

    drivers/video/fbdev/riva/fbdev.c: In function 'rivafb_probe':
    drivers/video/fbdev/riva/fbdev.c:2062:42: error:
	    passing argument 1 of 'iounmap' discards 'volatile' qualifier from pointer target type

    drivers/video/fbdev/nvidia/nvidia.c: In function 'nvidiafb_probe':
    drivers/video/fbdev/nvidia/nvidia.c:1414:20: error:
	    passing argument 1 of 'iounmap' discards 'volatile' qualifier from pointer target type

    drivers/scsi/aic7xxx/aic7xxx_osm.c: In function 'ahc_platform_free':
    drivers/scsi/aic7xxx/aic7xxx_osm.c:1231:41: error:
	    passing argument 1 of 'iounmap' discards 'volatile' qualifier from pointer target type

Most architectures define the iounmap argument to be volatile.  To fix this
issue we do the same for OpenRISC.  This patch must go before PCI is enabled on
OpenRISC to avoid any compile failures.

Link: https://lore.kernel.org/lkml/20220729033728.GA2195022@roeck-us.net/
Reported-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/openrisc/include/asm/io.h | 2 +-
 arch/openrisc/mm/ioremap.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/openrisc/include/asm/io.h b/arch/openrisc/include/asm/io.h
index c298061c70a7..8aa3e78181e9 100644
--- a/arch/openrisc/include/asm/io.h
+++ b/arch/openrisc/include/asm/io.h
@@ -31,7 +31,7 @@
 void __iomem *ioremap(phys_addr_t offset, unsigned long size);
 
 #define iounmap iounmap
-extern void iounmap(void __iomem *addr);
+extern void iounmap(volatile void __iomem *addr);
 
 #include <asm-generic/io.h>
 
diff --git a/arch/openrisc/mm/ioremap.c b/arch/openrisc/mm/ioremap.c
index daae13a76743..8ec0dafecf25 100644
--- a/arch/openrisc/mm/ioremap.c
+++ b/arch/openrisc/mm/ioremap.c
@@ -77,7 +77,7 @@ void __iomem *__ref ioremap(phys_addr_t addr, unsigned long size)
 }
 EXPORT_SYMBOL(ioremap);
 
-void iounmap(void __iomem *addr)
+void iounmap(volatile void __iomem *addr)
 {
 	/* If the page is from the fixmap pool then we just clear out
 	 * the fixmap mapping.
-- 
2.35.1



