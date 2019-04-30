Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBF3F86F
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbfD3Ljo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:39:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727936AbfD3Ljm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:39:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C6C12173E;
        Tue, 30 Apr 2019 11:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624382;
        bh=OSovCw99t+fe1qPIzosQ6np7feDDRH7Hul/2hG9iB5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wz8gGnG4JvrWT4/9mc7gJJlb5n0EqYHgnrb07KF/DauJHdHQX8byCWJESb06sjszz
         1gU7hwhWb78newtyG61+yJY/dFHIura7SFh4zY/yXorqs4IiZb11b6N+jh8NJsKL2d
         fTMc9Z1ydoeIADzB6EaBKRleb4S4Oftcjehff69U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 4.9 14/41] ARM: 8857/1: efi: enable CP15 DMB instructions before cleaning the cache
Date:   Tue, 30 Apr 2019 13:38:25 +0200
Message-Id: <20190430113528.465419917@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113524.451237916@linuxfoundation.org>
References: <20190430113524.451237916@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

commit e17b1af96b2afc38e684aa2f1033387e2ed10029 upstream.

The EFI stub is entered with the caches and MMU enabled by the
firmware, and once the stub is ready to hand over to the decompressor,
we clean and disable the caches.

The cache clean routines use CP15 barrier instructions, which can be
disabled via SCTLR. Normally, when using the provided cache handling
routines to enable the caches and MMU, this bit is enabled as well.
However, but since we entered the stub with the caches already enabled,
this routine is not executed before we call the cache clean routines,
resulting in undefined instruction exceptions if the firmware never
enabled this bit.

So set the bit explicitly in the EFI entry code, but do so in a way that
guarantees that the resulting code can still run on v6 cores as well
(which are guaranteed to have CP15 barriers enabled)

Cc: <stable@vger.kernel.org> # v4.9+
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/compressed/head.S |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -1383,7 +1383,21 @@ ENTRY(efi_stub_entry)
 
 		@ Preserve return value of efi_entry() in r4
 		mov	r4, r0
-		bl	cache_clean_flush
+
+		@ our cache maintenance code relies on CP15 barrier instructions
+		@ but since we arrived here with the MMU and caches configured
+		@ by UEFI, we must check that the CP15BEN bit is set in SCTLR.
+		@ Note that this bit is RAO/WI on v6 and earlier, so the ISB in
+		@ the enable path will be executed on v7+ only.
+		mrc	p15, 0, r1, c1, c0, 0	@ read SCTLR
+		tst	r1, #(1 << 5)		@ CP15BEN bit set?
+		bne	0f
+		orr	r1, r1, #(1 << 5)	@ CP15 barrier instructions
+		mcr	p15, 0, r1, c1, c0, 0	@ write SCTLR
+ ARM(		.inst	0xf57ff06f		@ v7+ isb	)
+ THUMB(		isb						)
+
+0:		bl	cache_clean_flush
 		bl	cache_off
 
 		@ Set parameters for booting zImage according to boot protocol


