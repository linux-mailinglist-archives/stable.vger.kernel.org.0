Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4CC201347
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390793AbgFSP7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:59:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392339AbgFSPO4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:14:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 158B8218AC;
        Fri, 19 Jun 2020 15:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579695;
        bh=jPxXse+cQPfEmZrr9f0Q4FwlTl3ase3YR4MRbsFeDCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QLmxtxFOJRoY8yrQeoYYpuhsKNL4BaMneTfVeI4yAH93STCWOL3MJ0oGUmB1QX7gf
         K3lVM0CHQIdXmg29atxR2MuVAFe5fcawdXUpfT1ExOkOSvWAUwr7J2F3et5N6aFXBN
         lyrTOhR7Z6FRmq+Qgh/hnJ7oAKEKh0xDrk/mfEXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 232/261] powerpc/kasan: Fix issues by lowering KASAN_SHADOW_END
Date:   Fri, 19 Jun 2020 16:34:03 +0200
Message-Id: <20200619141700.994873502@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 3a66a24f6060e6775f8c02ac52329ea0152d7e58 upstream.

At the time being, KASAN_SHADOW_END is 0x100000000, which
is 0 in 32 bits representation.

This leads to a couple of issues:
- kasan_remap_early_shadow_ro() does nothing because the comparison
k_cur < k_end is always false.
- In ptdump, address comparison for markers display fails and the
marker's name is printed at the start of the KASAN area instead of
being printed at the end.

However, there is no need to shadow the KASAN shadow area itself,
so the KASAN shadow area can stop shadowing memory at the start
of itself.

With a PAGE_OFFSET set to 0xc0000000, KASAN shadow area is then going
from 0xf8000000 to 0xff000000.

Fixes: cbd18991e24f ("powerpc/mm: Fix an Oops in kasan_mmu_init()")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/ae1a3c0d19a37410c209c3fc453634cfcc0ee318.1589866984.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/kasan.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/powerpc/include/asm/kasan.h
+++ b/arch/powerpc/include/asm/kasan.h
@@ -23,9 +23,7 @@
 
 #define KASAN_SHADOW_OFFSET	ASM_CONST(CONFIG_KASAN_SHADOW_OFFSET)
 
-#define KASAN_SHADOW_END	0UL
-
-#define KASAN_SHADOW_SIZE	(KASAN_SHADOW_END - KASAN_SHADOW_START)
+#define KASAN_SHADOW_END	(-(-KASAN_SHADOW_START >> KASAN_SHADOW_SCALE_SHIFT))
 
 #ifdef CONFIG_KASAN
 void kasan_early_init(void);


