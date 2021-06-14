Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346473A6477
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234286AbhFNLZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:25:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235664AbhFNLWf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:22:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86DFC61004;
        Mon, 14 Jun 2021 10:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667963;
        bh=SvIFKyFTzEBCbJeOLBKzTTL8LUvaywYM8029Bdcwc5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zZ1u5wyowo3KhifQQRk4v1rM/5LdImCLVxGHq09z1HSV3fbSYqBP15LuCn1hvxST/
         zAT1vNczUyk/oB/pboMFCQcniugqd+nzcbd9v1Akyfst9ZPEnepQ7zSTEm2Ro/8iLO
         +YAOCMG6DIb+EuAFJjJVabCewNYPGmx4xrQgqUnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 5.12 143/173] vmlinux.lds.h: Avoid orphan section with !SMP
Date:   Mon, 14 Jun 2021 12:27:55 +0200
Message-Id: <20210614102702.917568235@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit d4c6399900364facd84c9e35ce1540b6046c345f upstream.

With x86_64_defconfig and the following configs, there is an orphan
section warning:

CONFIG_SMP=n
CONFIG_AMD_MEM_ENCRYPT=y
CONFIG_HYPERVISOR_GUEST=y
CONFIG_KVM=y
CONFIG_PARAVIRT=y

ld: warning: orphan section `.data..decrypted' from `arch/x86/kernel/cpu/vmware.o' being placed in section `.data..decrypted'
ld: warning: orphan section `.data..decrypted' from `arch/x86/kernel/kvm.o' being placed in section `.data..decrypted'

These sections are created with DEFINE_PER_CPU_DECRYPTED, which
ultimately turns into __PCPU_ATTRS, which in turn has a section
attribute with a value of PER_CPU_BASE_SECTION + the section name. When
CONFIG_SMP is not set, the base section is .data and that is not
currently handled in any linker script.

Add .data..decrypted to PERCPU_DECRYPTED_SECTION, which is included in
PERCPU_INPUT -> PERCPU_SECTION, which is include in the x86 linker
script when either CONFIG_X86_64 or CONFIG_SMP is unset, taking care of
the warning.

Fixes: ac26963a1175 ("percpu: Introduce DEFINE_PER_CPU_DECRYPTED")
Link: https://github.com/ClangBuiltLinux/linux/issues/1360
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nick Desaulniers <ndesaulniers@google.com> # build
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20210506001410.1026691-1-nathan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/asm-generic/vmlinux.lds.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -943,6 +943,7 @@
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 #define PERCPU_DECRYPTED_SECTION					\
 	. = ALIGN(PAGE_SIZE);						\
+	*(.data..decrypted)						\
 	*(.data..percpu..decrypted)					\
 	. = ALIGN(PAGE_SIZE);
 #else


