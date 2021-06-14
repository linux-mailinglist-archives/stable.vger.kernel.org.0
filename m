Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E296D3A6355
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234787AbhFNLL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234722AbhFNLGm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:06:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA28F6192B;
        Mon, 14 Jun 2021 10:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667532;
        bh=VDGTvehYTiZwDYip8hKvER9rrmV2fTvKrE5Cf+RAinE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fyA8Hl4XcCn5/pkub97vHCJvrxGTRqIifWQO5XtFH7d9+BxtYr3Owlv+t4Jo080Xs
         bQ0qHISGPZmtbLKQUbFfiKhozOg3SwYZ4+Zt/D6Ic7nH183gkPQtipC9qINtFgRaGV
         2IWdKmdNLwgErDe31tHi5F4d+F6JAlOkXR2tSsAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 5.10 106/131] vmlinux.lds.h: Avoid orphan section with !SMP
Date:   Mon, 14 Jun 2021 12:27:47 +0200
Message-Id: <20210614102656.601568681@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
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
@@ -971,6 +971,7 @@
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 #define PERCPU_DECRYPTED_SECTION					\
 	. = ALIGN(PAGE_SIZE);						\
+	*(.data..decrypted)						\
 	*(.data..percpu..decrypted)					\
 	. = ALIGN(PAGE_SIZE);
 #else


