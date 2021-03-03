Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0917132BC03
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240636AbhCCNfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:35:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242918AbhCCBQs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 20:16:48 -0500
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 41074C061788;
        Tue,  2 Mar 2021 17:16:06 -0800 (PST)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 5CA5492009C; Wed,  3 Mar 2021 02:16:04 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 512CB92009B;
        Wed,  3 Mar 2021 02:16:04 +0100 (CET)
Date:   Wed, 3 Mar 2021 02:16:04 +0100 (CET)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
cc:     "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        George Cherian <gcherian@marvell.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, stable@vger.kernel.org
Subject: [PATCH] crypto: mips/poly1305 - enable for all MIPS processors
Message-ID: <alpine.DEB.2.21.2103030122010.19637@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The MIPS Poly1305 implementation is generic MIPS code written such as to 
support down to the original MIPS I and MIPS III ISA for the 32-bit and 
64-bit variant respectively.  Lift the current limitation then to enable 
code for MIPSr1 ISA or newer processors only and have it available for 
all MIPS processors.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: a11d055e7a64 ("crypto: mips/poly1305 - incorporate OpenSSL/CRYPTOGAMS optimized implementation")
Cc: stable@vger.kernel.org # v5.5+
---
On Wed, 3 Mar 2021, Jason A. Donenfeld wrote:

> >> Would you mind sending this for 5.12 in an rc at some point, rather
> >> than waiting for 5.13? I'd like to see this backported to 5.10 and 5.4
> >> for OpenWRT.
> >
> > why is this so important for OpenWRT ? Just to select CRYPTO_POLY1305_MIPS
> > ?
> 
> Yes. The performance boost on Octeon is significant for WireGuard users.

 But that's the wrong fix for that purpose.  I've skimmed over that module 
and there's nothing MIPS64-specific there.  In fact it's plain generic 
MIPS assembly, with some R2 optimisations enabled where applicable but not 
necessary (and then R6 tweaks, but that's irrelevant here).

 As a matter of interest I have just built it successfully for a MIPS I 
DECstation configuration:

$ file arch/mips/crypto/poly1305-mips.ko
arch/mips/crypto/poly1305-mips.ko: ELF 32-bit LSB relocatable, MIPS, MIPS-I version 1 (SYSV), BuildID[sha1]=d36384d94f60ba7deff638ca8a24500120b45b56, not stripped
$ 

Patch included, please apply.

 So while your change is surely right, what you want is this really.

  Maciej
---
 arch/mips/crypto/Makefile |    4 ++--
 crypto/Kconfig            |    2 +-
 drivers/net/Kconfig       |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

Index: linux/arch/mips/crypto/Makefile
===================================================================
--- linux.orig/arch/mips/crypto/Makefile
+++ linux/arch/mips/crypto/Makefile
@@ -12,8 +12,8 @@ AFLAGS_chacha-core.o += -O2 # needed to
 obj-$(CONFIG_CRYPTO_POLY1305_MIPS) += poly1305-mips.o
 poly1305-mips-y := poly1305-core.o poly1305-glue.o
 
-perlasm-flavour-$(CONFIG_CPU_MIPS32) := o32
-perlasm-flavour-$(CONFIG_CPU_MIPS64) := 64
+perlasm-flavour-$(CONFIG_32BIT) := o32
+perlasm-flavour-$(CONFIG_64BIT) := 64
 
 quiet_cmd_perlasm = PERLASM $@
       cmd_perlasm = $(PERL) $(<) $(perlasm-flavour-y) $(@)
Index: linux/crypto/Kconfig
===================================================================
--- linux.orig/crypto/Kconfig
+++ linux/crypto/Kconfig
@@ -772,7 +772,7 @@ config CRYPTO_POLY1305_X86_64
 
 config CRYPTO_POLY1305_MIPS
 	tristate "Poly1305 authenticator algorithm (MIPS optimized)"
-	depends on CPU_MIPS32 || (CPU_MIPS64 && 64BIT)
+	depends on MIPS
 	select CRYPTO_ARCH_HAVE_LIB_POLY1305
 
 config CRYPTO_MD4
Index: linux/drivers/net/Kconfig
===================================================================
--- linux.orig/drivers/net/Kconfig
+++ linux/drivers/net/Kconfig
@@ -92,7 +92,7 @@ config WIREGUARD
 	select CRYPTO_POLY1305_ARM if ARM
 	select CRYPTO_CURVE25519_NEON if ARM && KERNEL_MODE_NEON
 	select CRYPTO_CHACHA_MIPS if CPU_MIPS32_R2
-	select CRYPTO_POLY1305_MIPS if CPU_MIPS32 || (CPU_MIPS64 && 64BIT)
+	select CRYPTO_POLY1305_MIPS if MIPS
 	help
 	  WireGuard is a secure, fast, and easy to use replacement for IPSec
 	  that uses modern cryptography and clever networking tricks. It's
