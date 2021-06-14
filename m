Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625F23A6421
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235102AbhFNLVB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:21:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233111AbhFNLSr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:18:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D7F561982;
        Mon, 14 Jun 2021 10:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667865;
        bh=Bge5c0b/iT0SVxCvuVyMopNP2QY2m1T1tH3IZCXBjfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RG0xpaERbqYqLwVCrgMwkRlxy+w6+LmcGqXqznXoOfBXU63Tg39WWhYmE4nXCyMHv
         smKl8i54n7LNBKpbKeMSjYLgVqQvMMSBM9UMAx1Qf//PNeIgYbu56cKto2eukj6Nv3
         XnRMG8mi6Sqw9rETMQwBJTH9hteFOnj1ZaxrylBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tor Vic <torvic9@mailbox.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.12 061/173] x86, lto: Pass -stack-alignment only on LLD < 13.0.0
Date:   Mon, 14 Jun 2021 12:26:33 +0200
Message-Id: <20210614102700.196041570@linuxfoundation.org>
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

From: Tor Vic <torvic9@mailbox.org>

commit 2398ce80152aae33b9501ef54452e09e8e8d4262 upstream.

Since LLVM commit 3787ee4, the '-stack-alignment' flag has been dropped
[1], leading to the following error message when building a LTO kernel
with Clang-13 and LLD-13:

    ld.lld: error: -plugin-opt=-: ld.lld: Unknown command line argument
    '-stack-alignment=8'.  Try 'ld.lld --help'
    ld.lld: Did you mean '--stackrealign=8'?

It also appears that the '-code-model' flag is not necessary anymore
starting with LLVM-9 [2].

Drop '-code-model' and make '-stack-alignment' conditional on LLD < 13.0.0.

These flags were necessary because these flags were not encoded in the
IR properly, so the link would restart optimizations without them. Now
there are properly encoded in the IR, and these flags exposing
implementation details are no longer necessary.

[1] https://reviews.llvm.org/D103048
[2] https://reviews.llvm.org/D52322

Cc: stable@vger.kernel.org
Link: https://github.com/ClangBuiltLinux/linux/issues/1377
Signed-off-by: Tor Vic <torvic9@mailbox.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/f2c018ee-5999-741e-58d4-e482d5246067@mailbox.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Makefile |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -192,8 +192,9 @@ endif
 KBUILD_LDFLAGS += -m elf_$(UTS_MACHINE)
 
 ifdef CONFIG_LTO_CLANG
-KBUILD_LDFLAGS	+= -plugin-opt=-code-model=kernel \
-		   -plugin-opt=-stack-alignment=$(if $(CONFIG_X86_32),4,8)
+ifeq ($(shell test $(CONFIG_LLD_VERSION) -lt 130000; echo $$?),0)
+KBUILD_LDFLAGS	+= -plugin-opt=-stack-alignment=$(if $(CONFIG_X86_32),4,8)
+endif
 endif
 
 ifdef CONFIG_X86_NEED_RELOCS


