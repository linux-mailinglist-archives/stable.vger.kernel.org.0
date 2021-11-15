Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A911C450E2F
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240746AbhKOSNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:13:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:46094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240111AbhKOSFi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9104E6326E;
        Mon, 15 Nov 2021 17:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998138;
        bh=vK/HTMWTfjRLJpSwaIEj7JzTqq6BFceDyO7ZZ90Xxoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kdCIt5pY1doboVg8dJWcsFrTVOQPaNQXVpNC0NLBueXz/UoduXF4GlMjOvW+oKUOg
         bP6zEqocQrW4JLn9ewp9CRf/8q9yA2NDrwNxiFdswxzdoJFk0RMHf+rpX3JtKjkE3S
         +txhDUQ93zk8+RPw9xY77dd4QiTV9NLCK0akm7DA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huacai Chen <chenhuacai@kernel.org>,
        k2ci robot <kernel-bot@kylinos.cn>,
        Jackie Liu <liuyun01@kylinos.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 402/575] MIPS: loongson64: make CPU_LOONGSON64 depends on MIPS_FP_SUPPORT
Date:   Mon, 15 Nov 2021 18:02:07 +0100
Message-Id: <20211115165357.668632599@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index 1a63f592034eb..5c6e9ed9b2a75 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1380,6 +1380,7 @@ config CPU_LOONGSON64
 	select MIPS_ASID_BITS_VARIABLE
 	select MIPS_PGD_C0_CONTEXT
 	select MIPS_L1_CACHE_SHIFT_6
+	select MIPS_FP_SUPPORT
 	select GPIOLIB
 	select SWIOTLB
 	select HAVE_KVM
-- 
2.33.0



