Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 681193A037B
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237240AbhFHTRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:17:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:37984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237237AbhFHTPt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:15:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16F9F61953;
        Tue,  8 Jun 2021 18:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178234;
        bh=+wQ8+LE8IG7lh9L8LyganhbGoLUbeFd4VZGjTbTX/E8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DiszrmjOzRVA2COPLjyGZ/dZVK3JyhR1auKghbovu640qANpQv0Ms+OS+oYdiaYiL
         aYJ27u1jQTMJHAlkZXs7c26d7RK41IAF87BW3Z3USQp636yUPSUObRx+pFBLftxEW9
         b4VZ3+WTwnEc33u8OAj1gCU8f4xrVAF35RbIxGAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 082/161] riscv: vdso: fix and clean-up Makefile
Date:   Tue,  8 Jun 2021 20:26:52 +0200
Message-Id: <20210608175948.212710173@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 772d7891e8b3b0baae7bb88a294d61fd07ba6d15 ]

Running "make" on an already compiled kernel tree will rebuild the
kernel even without any modifications:

  CALL    linux/scripts/checksyscalls.sh
  CALL    linux/scripts/atomic/check-atomics.sh
  CHK     include/generated/compile.h
  SO2S    arch/riscv/kernel/vdso/vdso-syms.S
  AS      arch/riscv/kernel/vdso/vdso-syms.o
  AR      arch/riscv/kernel/vdso/built-in.a
  AR      arch/riscv/kernel/built-in.a
  AR      arch/riscv/built-in.a
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  AR      init/built-in.a
  LD      vmlinux.o

The reason is "Any target that utilizes if_changed must be listed in
$(targets), otherwise the command line check will fail, and the target
will always be built" as explained by Documentation/kbuild/makefiles.rst

Fix this build bug by adding vdso-syms.S to $(targets)

At the same time, there are two trivial clean up modifications:

- the vdso-dummy.o is not needed any more after so remove it.

- vdso.lds is a generated file, so it should be prefixed with
  $(obj)/ instead of $(src)/

Fixes: c2c81bb2f691 ("RISC-V: Fix the VDSO symbol generaton for binutils-2.35+")
Cc: stable@vger.kernel.org
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/vdso/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index ca2b40dfd24b..24d936c147cd 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -23,7 +23,7 @@ ifneq ($(c-gettimeofday-y),)
 endif
 
 # Build rules
-targets := $(obj-vdso) vdso.so vdso.so.dbg vdso.lds vdso-dummy.o
+targets := $(obj-vdso) vdso.so vdso.so.dbg vdso.lds vdso-syms.S
 obj-vdso := $(addprefix $(obj)/, $(obj-vdso))
 
 obj-y += vdso.o vdso-syms.o
@@ -41,7 +41,7 @@ KASAN_SANITIZE := n
 $(obj)/vdso.o: $(obj)/vdso.so
 
 # link rule for the .so file, .lds has to be first
-$(obj)/vdso.so.dbg: $(src)/vdso.lds $(obj-vdso) FORCE
+$(obj)/vdso.so.dbg: $(obj)/vdso.lds $(obj-vdso) FORCE
 	$(call if_changed,vdsold)
 LDFLAGS_vdso.so.dbg = -shared -s -soname=linux-vdso.so.1 \
 	--build-id=sha1 --hash-style=both --eh-frame-hdr
-- 
2.30.2



