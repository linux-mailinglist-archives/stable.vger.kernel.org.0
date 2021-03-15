Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659D133B60A
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhCON5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231925AbhCON41 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:56:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73EA164EFD;
        Mon, 15 Mar 2021 13:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816586;
        bh=dyFux2b2LyDMCXe/IMqQ3EfGFCXl+2a5DzNiD2gn5G0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0t6gP978ISpAj9tCduL5YiGJANRS/gIBqabHtW0al2MnBjgrlFkiCezuc2nfLcku+
         FRdoXt8PWwHOLkIuk6GuxBETqpPzbfQ4SSnPV1HB4Jp85qLwNfncHihc6UHz/vu/d8
         BfKL14WxNWSvepvxLv1oVk4+YOBDGDhyiQwRwdp4=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Maciej W. Rozycki" <macro@orcam.me.uk>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.11 006/306] crypto: mips/poly1305 - enable for all MIPS processors
Date:   Mon, 15 Mar 2021 14:51:09 +0100
Message-Id: <20210315135507.836410524@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit 6c810cf20feef0d4338e9b424ab7f2644a8b353e upstream.

The MIPS Poly1305 implementation is generic MIPS code written such as to
support down to the original MIPS I and MIPS III ISA for the 32-bit and
64-bit variant respectively.  Lift the current limitation then to enable
code for MIPSr1 ISA or newer processors only and have it available for
all MIPS processors.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: a11d055e7a64 ("crypto: mips/poly1305 - incorporate OpenSSL/CRYPTOGAMS optimized implementation")
Cc: stable@vger.kernel.org # v5.5+
Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/crypto/Makefile |    4 ++--
 crypto/Kconfig            |    2 +-
 drivers/net/Kconfig       |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/mips/crypto/Makefile
+++ b/arch/mips/crypto/Makefile
@@ -12,8 +12,8 @@ AFLAGS_chacha-core.o += -O2 # needed to
 obj-$(CONFIG_CRYPTO_POLY1305_MIPS) += poly1305-mips.o
 poly1305-mips-y := poly1305-core.o poly1305-glue.o
 
-perlasm-flavour-$(CONFIG_CPU_MIPS32) := o32
-perlasm-flavour-$(CONFIG_CPU_MIPS64) := 64
+perlasm-flavour-$(CONFIG_32BIT) := o32
+perlasm-flavour-$(CONFIG_64BIT) := 64
 
 quiet_cmd_perlasm = PERLASM $@
       cmd_perlasm = $(PERL) $(<) $(perlasm-flavour-y) $(@)
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -772,7 +772,7 @@ config CRYPTO_POLY1305_X86_64
 
 config CRYPTO_POLY1305_MIPS
 	tristate "Poly1305 authenticator algorithm (MIPS optimized)"
-	depends on CPU_MIPS32 || (CPU_MIPS64 && 64BIT)
+	depends on MIPS
 	select CRYPTO_ARCH_HAVE_LIB_POLY1305
 
 config CRYPTO_MD4
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -92,7 +92,7 @@ config WIREGUARD
 	select CRYPTO_POLY1305_ARM if ARM
 	select CRYPTO_CURVE25519_NEON if ARM && KERNEL_MODE_NEON
 	select CRYPTO_CHACHA_MIPS if CPU_MIPS32_R2
-	select CRYPTO_POLY1305_MIPS if CPU_MIPS32 || (CPU_MIPS64 && 64BIT)
+	select CRYPTO_POLY1305_MIPS if MIPS
 	help
 	  WireGuard is a secure, fast, and easy to use replacement for IPSec
 	  that uses modern cryptography and clever networking tricks. It's


