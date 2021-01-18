Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1612FA31B
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389321AbhAROcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:32:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:37938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390806AbhARLm7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:42:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A068221EC;
        Mon, 18 Jan 2021 11:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970151;
        bh=woSES6KfNv28HGzlVcIEfla3NdPm1zWNe2Ynmnbv140=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0rmZwz5o7/jifHLFoFHdRQ2VCzECGT6k0PjLN3hPXk6a2fCMN3UGpLA/sLFIr3PQ0
         86nw9kkeENnjClNHEBwBzawhJm5csynfJmu8Dwcl3a/6BQKQy90ObP6DnBDcijqWwp
         ZWnfmyyCy3qxiA4Ow53uAI0mfkHIV0hKJZwl4RXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/152] ARC: build: move symlink creation to arch/arc/Makefile to avoid race
Date:   Mon, 18 Jan 2021 12:33:53 +0100
Message-Id: <20210118113355.575352360@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit c5e6ae563c802c4d828d42e134af64004db2e58c ]

If you run 'make uImage uImage.gz' with the parallel option, uImage.gz
will be created by two threads simultaneously.

This is because arch/arc/Makefile does not specify the dependency
between uImage and uImage.gz. Hence, GNU Make assumes they can be
built in parallel. One thread descends into arch/arc/boot/ to create
uImage, and another to create uImage.gz.

Please notice the same log is displayed twice in the following steps:

  $ export CROSS_COMPILE=<your-arc-compiler-prefix>
  $ make -s ARCH=arc defconfig
  $ make -j$(nproc) ARCH=arc uImage uImage.gz
  [ snip ]
    LD      vmlinux
    SORTTAB vmlinux
    SYSMAP  System.map
    OBJCOPY arch/arc/boot/vmlinux.bin
    OBJCOPY arch/arc/boot/vmlinux.bin
    GZIP    arch/arc/boot/vmlinux.bin.gz
    GZIP    arch/arc/boot/vmlinux.bin.gz
    UIMAGE  arch/arc/boot/uImage.gz
    UIMAGE  arch/arc/boot/uImage.gz
  Image Name:   Linux-5.10.0-rc4-00003-g62f23044
  Created:      Sun Nov 22 02:52:26 2020
  Image Type:   ARC Linux Kernel Image (gzip compressed)
  Data Size:    2109376 Bytes = 2059.94 KiB = 2.01 MiB
  Load Address: 80000000
  Entry Point:  80004000
    Image arch/arc/boot/uImage is ready
  Image Name:   Linux-5.10.0-rc4-00003-g62f23044
  Created:      Sun Nov 22 02:52:26 2020
  Image Type:   ARC Linux Kernel Image (gzip compressed)
  Data Size:    2815455 Bytes = 2749.47 KiB = 2.69 MiB
  Load Address: 80000000
  Entry Point:  80004000

This is a race between the two threads trying to write to the same file
arch/arc/boot/uImage.gz. This is a potential problem that can generate
a broken file.

I fixed a similar problem for ARM by commit 3939f3345050 ("ARM: 8418/1:
add boot image dependencies to not generate invalid images").

I highly recommend to avoid such build rules that cause a race condition.

Move the uImage rule to arch/arc/Makefile.

Another strangeness is that arch/arc/boot/Makefile compares the
timestamps between $(obj)/uImage and $(obj)/uImage.*:

  $(obj)/uImage: $(obj)/uImage.$(suffix-y)
          @ln -sf $(notdir $<) $@
          @echo '  Image $@ is ready'

This does not work as expected since $(obj)/uImage is a symlink.
The symlink should be created in a phony target rule.

I used $(kecho) instead of echo to suppress the message
'Image arch/arc/boot/uImage is ready' when the -s option is given.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/Makefile      | 13 ++++++++++++-
 arch/arc/boot/Makefile | 11 +----------
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/arc/Makefile b/arch/arc/Makefile
index cf9da9aea12ac..578bdbbb0fa7f 100644
--- a/arch/arc/Makefile
+++ b/arch/arc/Makefile
@@ -102,11 +102,22 @@ libs-y		+= arch/arc/lib/ $(LIBGCC)
 
 boot		:= arch/arc/boot
 
-boot_targets := uImage uImage.bin uImage.gz uImage.lzma
+boot_targets := uImage.bin uImage.gz uImage.lzma
 
 PHONY += $(boot_targets)
 $(boot_targets): vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
 
+uimage-default-y			:= uImage.bin
+uimage-default-$(CONFIG_KERNEL_GZIP)	:= uImage.gz
+uimage-default-$(CONFIG_KERNEL_LZMA)	:= uImage.lzma
+
+PHONY += uImage
+uImage: $(uimage-default-y)
+	@ln -sf $< $(boot)/uImage
+	@$(kecho) '  Image $(boot)/uImage is ready'
+
+CLEAN_FILES += $(boot)/uImage
+
 archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
diff --git a/arch/arc/boot/Makefile b/arch/arc/boot/Makefile
index 538b92f4dd253..3b1f8a69a89ef 100644
--- a/arch/arc/boot/Makefile
+++ b/arch/arc/boot/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-targets := vmlinux.bin vmlinux.bin.gz uImage
+targets := vmlinux.bin vmlinux.bin.gz
 
 # uImage build relies on mkimage being availble on your host for ARC target
 # You will need to build u-boot for ARC, rename mkimage to arc-elf32-mkimage
@@ -13,11 +13,6 @@ LINUX_START_TEXT = $$(readelf -h vmlinux | \
 UIMAGE_LOADADDR    = $(CONFIG_LINUX_LINK_BASE)
 UIMAGE_ENTRYADDR   = $(LINUX_START_TEXT)
 
-suffix-y := bin
-suffix-$(CONFIG_KERNEL_GZIP)	:= gz
-suffix-$(CONFIG_KERNEL_LZMA)	:= lzma
-
-targets += uImage
 targets += uImage.bin
 targets += uImage.gz
 targets += uImage.lzma
@@ -42,7 +37,3 @@ $(obj)/uImage.gz: $(obj)/vmlinux.bin.gz FORCE
 
 $(obj)/uImage.lzma: $(obj)/vmlinux.bin.lzma FORCE
 	$(call if_changed,uimage,lzma)
-
-$(obj)/uImage: $(obj)/uImage.$(suffix-y)
-	@ln -sf $(notdir $<) $@
-	@echo '  Image $@ is ready'
-- 
2.27.0



