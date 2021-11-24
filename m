Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65AB645BE0E
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhKXMoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:44:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:50508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344502AbhKXMmd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:42:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0D8A613D3;
        Wed, 24 Nov 2021 12:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756707;
        bh=ZYPUhYwebUc3sEertd8HK7XzmaU+NO2fC8amo9Puuiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qZ+Ph71bn525Mn/MhkOpPcTudxrs2GtG2udR5GFYU0OfTK4ZaLe/8bllmgfF//c3F
         6oSUWSLthXVnaicsThm4MapsSHs63j3S7fmnqc8DOLtKTxwu1ryu2kxiD/2S7T023K
         lWBB8mhm3tgreZ1EwnM39MGhUruRN6BfXCzBhQgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huacai Chen <chenhuacai@kernel.org>,
        k2ci robot <kernel-bot@kylinos.cn>,
        Jackie Liu <liuyun01@kylinos.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 143/251] MIPS: loongson64: make CPU_LOONGSON64 depends on MIPS_FP_SUPPORT
Date:   Wed, 24 Nov 2021 12:56:25 +0100
Message-Id: <20211124115715.227750657@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jackie Liu <liuyun01@kylinos.cn>

[ Upstream commit 7f3b3c2bfa9c93ab9b5595543496f570983dc330 ]

mach/loongson64 fails to build when the FPU support is disabled:

arch/mips/loongson64/cop2-ex.c:45:15: error: implicit declaration of function ‘__is_fpu_owner’; did you mean ‘is_fpu_owner’? [-Werror=implicit-function-declaration]
arch/mips/loongson64/cop2-ex.c:98:30: error: ‘struct thread_struct’ has no member named ‘fpu’
arch/mips/loongson64/cop2-ex.c:99:30: error: ‘struct thread_struct’ has no member named ‘fpu’
arch/mips/loongson64/cop2-ex.c:131:43: error: ‘struct thread_struct’ has no member named ‘fpu’
arch/mips/loongson64/cop2-ex.c:137:38: error: ‘struct thread_struct’ has no member named ‘fpu’
arch/mips/loongson64/cop2-ex.c:203:30: error: ‘struct thread_struct’ has no member named ‘fpu’
arch/mips/loongson64/cop2-ex.c:219:30: error: ‘struct thread_struct’ has no member named ‘fpu’
arch/mips/loongson64/cop2-ex.c:283:38: error: ‘struct thread_struct’ has no member named ‘fpu’
arch/mips/loongson64/cop2-ex.c:301:38: error: ‘struct thread_struct’ has no member named ‘fpu’

Fixes: ef2f826c8f2f ("MIPS: Loongson-3: Enable the COP2 usage")
Suggested-by: Huacai Chen <chenhuacai@kernel.org>
Reviewed-by: Huacai Chen <chenhuacai@kernel.org>
Reported-by: k2ci robot <kernel-bot@kylinos.cn>
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 49c540790fd2d..8e77149d658fc 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1383,6 +1383,7 @@ config CPU_LOONGSON3
 	select WEAK_REORDERING_BEYOND_LLSC
 	select MIPS_PGD_C0_CONTEXT
 	select MIPS_L1_CACHE_SHIFT_6
+	select MIPS_FP_SUPPORT
 	select GPIOLIB
 	help
 		The Loongson 3 processor implements the MIPS64R2 instruction
-- 
2.33.0



