Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDFCC2E6659
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733080AbgL1NTx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:19:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:48458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733006AbgL1NTx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:19:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D48F22583;
        Mon, 28 Dec 2020 13:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161552;
        bh=C3YwL2f4xogoUOPxv3liD/thayajrduA9lFFDYXaz+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VbJ2DTMmBnrYbWLCmyboBemxCiQtDgoY0I6GMs8grdDKvnb+ubuyynw6xvAsK1kwm
         IifAGCrV/OTZjSFqcmNZWJW1dzAKfP5qGkGu0XIxDEOaMX7csl0I6Bp1cL/NeWly9g
         xFoREWYCnP3ib7bESx8sHSyhOUnPciXfTpOyaUes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Golovin <dima@golovin.in>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Fangrui Song <maskray@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 4.19 001/346] Kbuild: do not emit debug info for assembly with LLVM_IAS=1
Date:   Mon, 28 Dec 2020 13:45:20 +0100
Message-Id: <20201228124919.821830406@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

commit b8a9092330da2030496ff357272f342eb970d51b upstream.

Clang's integrated assembler produces the warning for assembly files:

warning: DWARF2 only supports one section per compilation unit

If -Wa,-gdwarf-* is unspecified, then debug info is not emitted for
assembly sources (it is still emitted for C sources).  This will be
re-enabled for newer DWARF versions in a follow up patch.

Enables defconfig+CONFIG_DEBUG_INFO to build cleanly with
LLVM=1 LLVM_IAS=1 for x86_64 and arm64.

Cc: <stable@vger.kernel.org>
Link: https://github.com/ClangBuiltLinux/linux/issues/716
Reported-by: Dmitry Golovin <dima@golovin.in>
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Suggested-by: Dmitry Golovin <dima@golovin.in>
Suggested-by: Nathan Chancellor <natechancellor@gmail.com>
Suggested-by: Sedat Dilek <sedat.dilek@gmail.com>
Reviewed-by: Fangrui Song <maskray@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
[nd: backport to avoid conflicts from:
  commit 10e68b02c861 ("Makefile: support compressed debug info")
  commit 7b16994437c7 ("Makefile: Improve compressed debug info support detection")
  commit 695afd3d7d58 ("kbuild: Simplify DEBUG_INFO Kconfig handling")]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    3 +++
 1 file changed, 3 insertions(+)

--- a/Makefile
+++ b/Makefile
@@ -745,8 +745,11 @@ KBUILD_CFLAGS   += $(call cc-option, -gs
 else
 KBUILD_CFLAGS	+= -g
 endif
+ifneq ($(LLVM_IAS),1)
 KBUILD_AFLAGS	+= -Wa,-gdwarf-2
 endif
+endif
+
 ifdef CONFIG_DEBUG_INFO_DWARF4
 KBUILD_CFLAGS	+= $(call cc-option, -gdwarf-4,)
 endif


