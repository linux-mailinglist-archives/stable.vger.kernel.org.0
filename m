Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDF866C64B
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389989AbfGRDPb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:15:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:52684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392066AbfGRDPa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:15:30 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 396B92053B;
        Thu, 18 Jul 2019 03:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419729;
        bh=FX2Z3hQoitXwGVLYWO2ffrDXB/93Wnqv7jzv26SpfMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PzeIqagLPln0AVj4RVFuqBLP2+xH+9i02Q+D6VM0SaIROGGOQHL1fywje1DO4W2nQ
         xhjG1S02y4Yi2AhPFspUPgf6QVpDRGH0rmL3H/6Aqf8wm2NjeqOvVIW6LxnyYBpG93
         QuO2OtLHbV3t7J2JzLEwQeVuHsKFOX/D3nFqnRpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Olof Johansson <olof@lixom.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 30/40] ARM: omap2: remove incorrect __init annotation
Date:   Thu, 18 Jul 2019 12:02:26 +0900
Message-Id: <20190718030049.653464043@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030039.676518610@linuxfoundation.org>
References: <20190718030039.676518610@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 27e23d8975270df6999f8b5b3156fc0c04927451 ]

omap3xxx_prm_enable_io_wakeup() is marked __init, but its caller is not, so
we get a warning with clang-8:

WARNING: vmlinux.o(.text+0x343c8): Section mismatch in reference from the function omap3xxx_prm_late_init() to the function .init.text:omap3xxx_prm_enable_io_wakeup()
The function omap3xxx_prm_late_init() references
the function __init omap3xxx_prm_enable_io_wakeup().
This is often because omap3xxx_prm_late_init lacks a __init
annotation or the annotation of omap3xxx_prm_enable_io_wakeup is wrong.

When building with gcc, omap3xxx_prm_enable_io_wakeup() is always
inlined, so we never noticed in the past.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Andrew Murray <andrew.murray@arm.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/prm3xxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/prm3xxx.c b/arch/arm/mach-omap2/prm3xxx.c
index 62680aad2126..b5ce9ca76336 100644
--- a/arch/arm/mach-omap2/prm3xxx.c
+++ b/arch/arm/mach-omap2/prm3xxx.c
@@ -430,7 +430,7 @@ static void omap3_prm_reconfigure_io_chain(void)
  * registers, and omap3xxx_prm_reconfigure_io_chain() must be called.
  * No return value.
  */
-static void __init omap3xxx_prm_enable_io_wakeup(void)
+static void omap3xxx_prm_enable_io_wakeup(void)
 {
 	if (prm_features & PRM_HAS_IO_WAKEUP)
 		omap2_prm_set_mod_reg_bits(OMAP3430_EN_IO_MASK, WKUP_MOD,
-- 
2.20.1



