Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D21C1674DA
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387408AbgBUISP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:18:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:56090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387795AbgBUISO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:18:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F3F424696;
        Fri, 21 Feb 2020 08:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273094;
        bh=lWAgD2Omqn54//9A3l2dvEl/1ZU//HbLZ4rJgI2VEQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ir0RE0xxBVWS9cvQs/S3Kuohn0DEmTbT8+qFKs3a0Wb343Gn11ar1Rm5R1sHTQXXz
         8cWSp0RK/hLXxQOCN0tOWW9XF31iP4+496VaCOqWz7mbBCiqSX91MCZzp1FHlp9KJn
         ykwhgbm/5DbrAiU0S22YbJ0p00euE70K7na1fCv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 043/191] ARM: 8952/1: Disable kmemleak on XIP kernels
Date:   Fri, 21 Feb 2020 08:40:16 +0100
Message-Id: <20200221072257.058524321@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincenzo Frascino <vincenzo.frascino@arm.com>

[ Upstream commit bc420c6ceefbb86cbbc8c00061bd779c17fa6997 ]

Kmemleak relies on specific symbols to register the read only data
during init (e.g. __start_ro_after_init).
Trying to build an XIP kernel on arm results in the linking error
reported below because when this option is selected read only data
after init are not allowed since .data is read only (.rodata).

  arm-linux-gnueabihf-ld: mm/kmemleak.o: in function `kmemleak_init':
  kmemleak.c:(.init.text+0x148): undefined reference to `__end_ro_after_init'
  arm-linux-gnueabihf-ld: kmemleak.c:(.init.text+0x14c):
     undefined reference to `__end_ro_after_init'
  arm-linux-gnueabihf-ld: kmemleak.c:(.init.text+0x150):
     undefined reference to `__start_ro_after_init'
  arm-linux-gnueabihf-ld: kmemleak.c:(.init.text+0x156):
     undefined reference to `__start_ro_after_init'
  arm-linux-gnueabihf-ld: kmemleak.c:(.init.text+0x162):
     undefined reference to `__start_ro_after_init'
  arm-linux-gnueabihf-ld: kmemleak.c:(.init.text+0x16a):
     undefined reference to `__start_ro_after_init'
  linux/Makefile:1078: recipe for target 'vmlinux' failed

Fix the issue enabling kmemleak only on non XIP kernels.

Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 185e552f14610..9f03befdfbf06 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -61,7 +61,7 @@ config ARM
 	select HAVE_EBPF_JIT if !CPU_ENDIAN_BE32
 	select HAVE_CONTEXT_TRACKING
 	select HAVE_C_RECORDMCOUNT
-	select HAVE_DEBUG_KMEMLEAK
+	select HAVE_DEBUG_KMEMLEAK if !XIP_KERNEL
 	select HAVE_DMA_CONTIGUOUS if MMU
 	select HAVE_DYNAMIC_FTRACE if (!XIP_KERNEL) && !CPU_ENDIAN_BE32 && MMU
 	select HAVE_DYNAMIC_FTRACE_WITH_REGS if HAVE_DYNAMIC_FTRACE
-- 
2.20.1



