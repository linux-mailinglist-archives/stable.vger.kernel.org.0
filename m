Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F93313626
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbhBHPGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:06:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:52048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232208AbhBHPEe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:04:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C106C64E29;
        Mon,  8 Feb 2021 15:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796623;
        bh=wEFg040k+Z5m9ZxtD+zFzKC9MeiI/trvGdmifnjE0Nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j/fyy4PU5oLWDHq2TKZ0KJtoahxbPaWDeDgtn2XKHwXjsed9hztn+zl9WROY+4fg3
         bZnJGPSI6rzAlzY3fWDWjs1e+D5zQNQkItZS8jTaUvsLZi2MOWAbm0ZBFCswEp125o
         ryz9UCz3b94axcLW/TTdLflE2FkkP3TyQOzTG4AE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <james.hogan@imgtec.com>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 21/38] ELF/MIPS build fix
Date:   Mon,  8 Feb 2021 16:00:43 +0100
Message-Id: <20210208145806.116824584@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145805.279815326@linuxfoundation.org>
References: <20210208145805.279815326@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ralf Baechle <ralf@linux-mips.org>

commit f43edca7ed08fc02279f2a62015da5cb6aa0ad61 upstream.

CONFIG_MIPS32_N32=y but CONFIG_BINFMT_ELF disabled results in the
following linker errors:

  arch/mips/built-in.o: In function `elf_core_dump':
  binfmt_elfn32.c:(.text+0x23dbc): undefined reference to `elf_core_extra_phdrs'
  binfmt_elfn32.c:(.text+0x246e4): undefined reference to `elf_core_extra_data_size'
  binfmt_elfn32.c:(.text+0x248d0): undefined reference to `elf_core_write_extra_phdrs'
  binfmt_elfn32.c:(.text+0x24ac4): undefined reference to `elf_core_write_extra_data'

CONFIG_MIPS32_O32=y but CONFIG_BINFMT_ELF disabled results in the following
linker errors:

  arch/mips/built-in.o: In function `elf_core_dump':
  binfmt_elfo32.c:(.text+0x28a04): undefined reference to `elf_core_extra_phdrs'
  binfmt_elfo32.c:(.text+0x29330): undefined reference to `elf_core_extra_data_size'
  binfmt_elfo32.c:(.text+0x2951c): undefined reference to `elf_core_write_extra_phdrs'
  binfmt_elfo32.c:(.text+0x29710): undefined reference to `elf_core_write_extra_data'

This is because binfmt_elfn32 and binfmt_elfo32 are using symbols from
elfcore but for these configurations elfcore will not be built.

Fixed by making elfcore selectable by a separate config symbol which
unlike the current mechanism can also be used from other directories
than kernel/, then having each flavor of ELF that relies on elfcore.o,
select it in Kconfig, including CONFIG_MIPS32_N32 and CONFIG_MIPS32_O32
which fixes this issue.

Link: http://lkml.kernel.org/r/20160520141705.GA1913@linux-mips.org
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Reviewed-by: James Hogan <james.hogan@imgtec.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/Kconfig |    1 +
 fs/Kconfig.binfmt |    8 ++++++++
 kernel/Makefile   |    4 +---
 3 files changed, 10 insertions(+), 3 deletions(-)

--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -2990,6 +2990,7 @@ config MIPS32_N32
 config BINFMT_ELF32
 	bool
 	default y if MIPS32_O32 || MIPS32_N32
+	select ELFCORE
 
 endmenu
 
--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -1,6 +1,7 @@
 config BINFMT_ELF
 	bool "Kernel support for ELF binaries"
 	depends on MMU && (BROKEN || !FRV)
+	select ELFCORE
 	default y
 	---help---
 	  ELF (Executable and Linkable Format) is a format for libraries and
@@ -26,6 +27,7 @@ config BINFMT_ELF
 config COMPAT_BINFMT_ELF
 	bool
 	depends on COMPAT && BINFMT_ELF
+	select ELFCORE
 
 config ARCH_BINFMT_ELF_STATE
 	bool
@@ -34,6 +36,7 @@ config BINFMT_ELF_FDPIC
 	bool "Kernel support for FDPIC ELF binaries"
 	default y
 	depends on (FRV || BLACKFIN || (SUPERH32 && !MMU) || C6X)
+	select ELFCORE
 	help
 	  ELF FDPIC binaries are based on ELF, but allow the individual load
 	  segments of a binary to be located in memory independently of each
@@ -43,6 +46,11 @@ config BINFMT_ELF_FDPIC
 
 	  It is also possible to run FDPIC ELF binaries on MMU linux also.
 
+config ELFCORE
+	bool
+	help
+	  This option enables kernel/elfcore.o.
+
 config CORE_DUMP_DEFAULT_ELF_HEADERS
 	bool "Write ELF core dumps with partial segments"
 	default y
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -77,9 +77,7 @@ obj-$(CONFIG_TASK_DELAY_ACCT) += delayac
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 obj-$(CONFIG_TRACEPOINTS) += tracepoint.o
 obj-$(CONFIG_LATENCYTOP) += latencytop.o
-obj-$(CONFIG_BINFMT_ELF) += elfcore.o
-obj-$(CONFIG_COMPAT_BINFMT_ELF) += elfcore.o
-obj-$(CONFIG_BINFMT_ELF_FDPIC) += elfcore.o
+obj-$(CONFIG_ELFCORE) += elfcore.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_TRACE_CLOCK) += trace/


