Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98C23642D3
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239941AbhDSNLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:11:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239478AbhDSNKy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:10:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 457D3613F7;
        Mon, 19 Apr 2021 13:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837824;
        bh=hHIQYb42wdWozvUKH6R1Uzezj7+klWmXY0qSapeadp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iOSprCLEbsH7gLjmd1jFsVgPgGYx2TTe4JBfkmnsM3Lft0j8qAAtKzUD1YQ3rQI+H
         5q9oMbtfNElb5Il3/Vvg2XPW7o17RM5u8nPOfl+PMbTY6QD2kFaMzJJ7vgU1BJkYRX
         glHVyoy7KMoibKWXdVttffsKJIX5iS87psM9BwEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 032/122] ARM: omap1: fix building with clang IAS
Date:   Mon, 19 Apr 2021 15:05:12 +0200
Message-Id: <20210419130531.256164935@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 28399a5a6d569c9bdb612345e4933046ca37cde5 ]

The clang integrated assembler fails to build one file with
a complex asm instruction:

arch/arm/mach-omap1/ams-delta-fiq-handler.S:249:2: error: invalid instruction, any one of the following would fix this:
 mov r10, #(1 << (((NR_IRQS_LEGACY + 12) - NR_IRQS_LEGACY) % 32)) @ set deferred_fiq bit
 ^
arch/arm/mach-omap1/ams-delta-fiq-handler.S:249:2: note: instruction requires: armv6t2
 mov r10, #(1 << (((NR_IRQS_LEGACY + 12) - NR_IRQS_LEGACY) % 32)) @ set deferred_fiq bit
 ^
arch/arm/mach-omap1/ams-delta-fiq-handler.S:249:2: note: instruction requires: thumb2
 mov r10, #(1 << (((NR_IRQS_LEGACY + 12) - NR_IRQS_LEGACY) % 32)) @ set deferred_fiq bit
 ^

The problem is that 'NR_IRQS_LEGACY' is not defined here. Apparently
gas does not care because we first add and then subtract this number,
leading to the immediate value to be the same regardless of the
specific definition of NR_IRQS_LEGACY.

Neither the way that 'gas' just silently builds this file, nor the
way that clang IAS makes nonsensical suggestions for how to fix it
is great. Fortunately there is an easy fix, which is to #include
the header that contains the definition.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20210308153430.2530616-1-arnd@kernel.org'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap1/ams-delta-fiq-handler.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-omap1/ams-delta-fiq-handler.S b/arch/arm/mach-omap1/ams-delta-fiq-handler.S
index 14a6c3eb3298..f745a65d3bd7 100644
--- a/arch/arm/mach-omap1/ams-delta-fiq-handler.S
+++ b/arch/arm/mach-omap1/ams-delta-fiq-handler.S
@@ -15,6 +15,7 @@
 #include <linux/platform_data/gpio-omap.h>
 
 #include <asm/assembler.h>
+#include <asm/irq.h>
 
 #include "ams-delta-fiq.h"
 #include "board-ams-delta.h"
-- 
2.30.2



