Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C583283A0
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235449AbhCAQWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:22:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:56668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237794AbhCAQUw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:20:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A94C64EE0;
        Mon,  1 Mar 2021 16:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615480;
        bh=y2hJpKZgckiSorK2E4ipUwnd6NpQ/kSOiDd/rt32SlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hCoLQ8E1Rh4FsDfLZD4hZ/pOjdFbAZla/GeLIIU85SipkGQD9DNnd1tQUNpom3X4Y
         WNxeLGwbKPgowdXVuLNPvYaI//c2ycLIGG0iI4XPWFy72lqElrxQN7T/9N8L5qBh9h
         G/hUJGtFENDWlXtI/Lh4MvOkzzqILvXZuZrieWDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Murzin <vladimir.murzin@arm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 44/93] ARM: 9046/1: decompressor: Do not clear SCTLR.nTLSMD for ARMv7+ cores
Date:   Mon,  1 Mar 2021 17:12:56 +0100
Message-Id: <20210301161009.071922394@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161006.881950696@linuxfoundation.org>
References: <20210301161006.881950696@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Murzin <vladimir.murzin@arm.com>

[ Upstream commit 2acb909750431030b65a0a2a17fd8afcbd813a84 ]

It was observed that decompressor running on hardware implementing ARM v8.2
Load/Store Multiple Atomicity and Ordering Control (LSMAOC), say, as guest,
would stuck just after:

Uncompressing Linux... done, booting the kernel.

The reason is that it clears nTLSMD bit when disabling caches:

  nTLSMD, bit [3]

  When ARMv8.2-LSMAOC is implemented:

    No Trap Load Multiple and Store Multiple to
    Device-nGRE/Device-nGnRE/Device-nGnRnE memory.

    0b0 All memory accesses by A32 and T32 Load Multiple and Store
        Multiple at EL1 or EL0 that are marked at stage 1 as
        Device-nGRE/Device-nGnRE/Device-nGnRnE memory are trapped and
        generate a stage 1 Alignment fault.

    0b1 All memory accesses by A32 and T32 Load Multiple and Store
        Multiple at EL1 or EL0 that are marked at stage 1 as
        Device-nGRE/Device-nGnRE/Device-nGnRnE memory are not trapped.

  This bit is permitted to be cached in a TLB.

  This field resets to 1.

  Otherwise:

  Reserved, RES1

So as effect we start getting traps we are not quite ready for.

Looking into history it seems that mask used for SCTLR clear came from
the similar code for ARMv4, where bit[3] is the enable/disable bit for
the write buffer. That not applicable to ARMv7 and onwards, so retire
that bit from the masks.

Fixes: 7d09e85448dfa78e3e58186c934449aaf6d49b50 ("[ARM] 4393/2: ARMv7: Add uncompressing code for the new CPU Id format")
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/compressed/head.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 856913705169f..082d036e95649 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -1074,9 +1074,9 @@ __armv4_mmu_cache_off:
 __armv7_mmu_cache_off:
 		mrc	p15, 0, r0, c1, c0
 #ifdef CONFIG_MMU
-		bic	r0, r0, #0x000d
+		bic	r0, r0, #0x0005
 #else
-		bic	r0, r0, #0x000c
+		bic	r0, r0, #0x0004
 #endif
 		mcr	p15, 0, r0, c1, c0	@ turn MMU and cache off
 		mov	r12, lr
-- 
2.27.0



