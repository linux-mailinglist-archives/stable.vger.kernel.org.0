Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F6A35CBEC
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244449AbhDLQZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:25:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243810AbhDLQYl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:24:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5950061288;
        Mon, 12 Apr 2021 16:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244663;
        bh=hHIQYb42wdWozvUKH6R1Uzezj7+klWmXY0qSapeadp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OGqFORcNoUdFpxh9qWircI7bertpx74a4Ccq1vxg4SBgANOWOoJP63d277K2u5Kfi
         Mh6+IGRLiWUfRLdME6MdFUFIb1bMYvqAy7YRs6qJLXwpwTCBd1o3gBTXKNSSf4Uz8K
         4Bzq3kMmO5xCAvo3Vzi3Flj7un5COKTvqAmHgQfihqcKZj4T1orLCSyGztVret/YX8
         SVWNt8ND5bG38LnvEa9ayu7v7/FIsqvYXRv781lAzkrGxqPOZZZFn5de5Wu1zd2g+c
         IRI1+msp4nUjBwcerrB/QxAIRpJIX8pDMHBWlZDMFfP9ZijLrJVNe0btpmdFZgxyWq
         z1ZcMuQBDDFIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.10 17/46] ARM: omap1: fix building with clang IAS
Date:   Mon, 12 Apr 2021 12:23:32 -0400
Message-Id: <20210412162401.314035-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162401.314035-1-sashal@kernel.org>
References: <20210412162401.314035-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

