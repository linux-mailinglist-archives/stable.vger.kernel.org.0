Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2F96AEA97
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbjCGRfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:35:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbjCGRex (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:34:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD39093E33
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:31:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D5C361521
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:31:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C0FC4339C;
        Tue,  7 Mar 2023 17:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210260;
        bh=PYNVio+z85vN0S/li/R9g78JoBx1KGn2xAbZRCbjbCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rBdB+TKrVvVj2cYHawDLPhkNBq7iU91k3jBSlJbUAixgwSLyVBagPFQM1JUHesSoW
         zMLgpPJY1nqBaw0ttTeu7AxWIdP0KuSoVc3EZc2wIGaUlm5o3j/bUY2U31waLyNU+Y
         93lOh7ZjtuoeBF2+N7F7ZjQzRGuCmItYPsUrKFb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>,
        Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0484/1001] mfd: cs5535: Dont build on UML
Date:   Tue,  7 Mar 2023 17:54:16 +0100
Message-Id: <20230307170042.407536781@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 5ec32a3e4053c1a726b45381d56aa9e39eaf3911 ]

The cs5535-mfd driver uses CPU-specific data that is not available
for ARCH=um builds, so don't allow it to be built for UML.

Prevents these build errors:

In file included from ../arch/x86/include/asm/olpc.h:7,
                 from ../drivers/mfd/cs5535-mfd.c:17:
../arch/x86/include/asm/geode.h: In function ‘is_geode_gx’:
../arch/x86/include/asm/geode.h:16:31: error: ‘struct cpuinfo_um’ has no member named ‘x86_vendor’
   16 |         return ((boot_cpu_data.x86_vendor == X86_VENDOR_NSC) &&
../arch/x86/include/asm/geode.h:16:46: error: ‘X86_VENDOR_NSC’ undeclared (first use in this function); did you mean ‘X86_VENDOR_ANY’?
   16 |         return ((boot_cpu_data.x86_vendor == X86_VENDOR_NSC) &&
../arch/x86/include/asm/geode.h:17:31: error: ‘struct cpuinfo_um’ has no member named ‘x86’
   17 |                 (boot_cpu_data.x86 == 5) &&
../arch/x86/include/asm/geode.h:18:31: error: ‘struct cpuinfo_um’ has no member named ‘x86_model’
   18 |                 (boot_cpu_data.x86_model == 5));
../arch/x86/include/asm/geode.h: In function ‘is_geode_lx’:
../arch/x86/include/asm/geode.h:23:31: error: ‘struct cpuinfo_um’ has no member named ‘x86_vendor’
   23 |         return ((boot_cpu_data.x86_vendor == X86_VENDOR_AMD) &&
../arch/x86/include/asm/geode.h:23:46: error: ‘X86_VENDOR_AMD’ undeclared (first use in this function); did you mean ‘X86_VENDOR_ANY’?
   23 |         return ((boot_cpu_data.x86_vendor == X86_VENDOR_AMD) &&
../arch/x86/include/asm/geode.h:24:31: error: ‘struct cpuinfo_um’ has no member named ‘x86’
   24 |                 (boot_cpu_data.x86 == 5) &&
../arch/x86/include/asm/geode.h:25:31: error: ‘struct cpuinfo_um’ has no member named ‘x86_model’
   25 |                 (boot_cpu_data.x86_model == 10));

Fixes: 68f5d3f3b654 ("um: add PCI over virtio emulation driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20221201012541.11809-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 30db49f318668..7ed31fbd8c7fa 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -15,6 +15,7 @@ config MFD_CS5535
 	tristate "AMD CS5535 and CS5536 southbridge core functions"
 	select MFD_CORE
 	depends on PCI && (X86_32 || (X86 && COMPILE_TEST))
+	depends on !UML
 	help
 	  This is the core driver for CS5535/CS5536 MFD functions.  This is
 	  necessary for using the board's GPIO and MFGPT functionality.
-- 
2.39.2



