Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F7F1D85E6
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730768AbgERRvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:51:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730807AbgERRvF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:51:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6533820674;
        Mon, 18 May 2020 17:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824264;
        bh=WmONSK4ctFdQWjz26WZgwfs5SpenNY5/I3xlW0g0H4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nSoHist7/jqWI0XlRi95ZYfvIjBdhez75e7bz0DYFU6sN8jO9EwmAyPIEQPEQpd66
         CC5j9Fynee6AsPH1hKWnhHA7MUnSOGq7scnzCRvFbGZ+Fv0Q+zfjiwnao+EEblMAgF
         42g7mDOkFbz3oqMHvMEjVrummft9JvN9Rdp1VKuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Golovin <dima@golovin.in>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ilie Halip <ilie.halip@gmail.com>,
        Fangrui Song <maskray@google.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 22/80] riscv: fix vdso build with lld
Date:   Mon, 18 May 2020 19:36:40 +0200
Message-Id: <20200518173454.857080221@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.097837707@linuxfoundation.org>
References: <20200518173450.097837707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilie Halip <ilie.halip@gmail.com>

[ Upstream commit 3c1918c8f54166598195d938564072664a8275b1 ]

When building with the LLVM linker this error occurrs:
    LD      arch/riscv/kernel/vdso/vdso-syms.o
  ld.lld: error: no input files

This happens because the lld treats -R as an alias to -rpath, as opposed
to ld where -R means --just-symbols.

Use the long option name for compatibility between the two.

Link: https://github.com/ClangBuiltLinux/linux/issues/805
Reported-by: Dmitry Golovin <dima@golovin.in>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Ilie Halip <ilie.halip@gmail.com>
Reviewed-by: Fangrui Song <maskray@google.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/vdso/Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index 87f71a6cd3ef8..1dd134fc0d84a 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -30,15 +30,15 @@ $(obj)/vdso.so.dbg: $(src)/vdso.lds $(obj-vdso) FORCE
 	$(call if_changed,vdsold)
 
 # We also create a special relocatable object that should mirror the symbol
-# table and layout of the linked DSO.  With ld -R we can then refer to
-# these symbols in the kernel code rather than hand-coded addresses.
+# table and layout of the linked DSO. With ld --just-symbols we can then
+# refer to these symbols in the kernel code rather than hand-coded addresses.
 
 SYSCFLAGS_vdso.so.dbg = -shared -s -Wl,-soname=linux-vdso.so.1 \
                             $(call cc-ldoption, -Wl$(comma)--hash-style=both)
 $(obj)/vdso-dummy.o: $(src)/vdso.lds $(obj)/rt_sigreturn.o FORCE
 	$(call if_changed,vdsold)
 
-LDFLAGS_vdso-syms.o := -r -R
+LDFLAGS_vdso-syms.o := -r --just-symbols
 $(obj)/vdso-syms.o: $(obj)/vdso-dummy.o FORCE
 	$(call if_changed,ld)
 
-- 
2.20.1



