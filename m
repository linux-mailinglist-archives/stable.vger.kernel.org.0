Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617CC43A00D
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbhJYT0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:26:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235020AbhJYTZE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:25:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A18860724;
        Mon, 25 Oct 2021 19:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189734;
        bh=0wFitQqf99HsEpCzMQH91BM2topCFOK6sfiIcLLqbFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nxwETVCwgXow9aYYIbcMSdsQk2YrbRTbJXg0Nf3Joui6wlTASaiZa/82bTtDu0LFw
         cRzo9Wd+7AuW0/D0qOKvLz2BO15vU2O/x0LM4CFnDuGmlAINtfCQROxJ2q26L7iBBS
         PEPiAtDpSdckBkrCl+1pjcV0CJnviTsQeEYwNAqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Barret Rhoden <brho@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 13/30] elfcore: correct reference to CONFIG_UML
Date:   Mon, 25 Oct 2021 21:14:33 +0200
Message-Id: <20211025190926.144818719@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190922.089277904@linuxfoundation.org>
References: <20211025190922.089277904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

commit b0e901280d9860a0a35055f220e8e457f300f40a upstream.

Commit 6e7b64b9dd6d ("elfcore: fix building with clang") introduces
special handling for two architectures, ia64 and User Mode Linux.
However, the wrong name, i.e., CONFIG_UM, for the intended Kconfig
symbol for User-Mode Linux was used.

Although the directory for User Mode Linux is ./arch/um; the Kconfig
symbol for this architecture is called CONFIG_UML.

Luckily, ./scripts/checkkconfigsymbols.py warns on non-existing configs:

  UM
  Referencing files: include/linux/elfcore.h
  Similar symbols: UML, NUMA

Correct the name of the config to the intended one.

[akpm@linux-foundation.org: fix um/x86_64, per Catalin]
  Link: https://lkml.kernel.org/r/20211006181119.2851441-1-catalin.marinas@arm.com
  Link: https://lkml.kernel.org/r/YV6pejGzLy5ppEpt@arm.com

Link: https://lkml.kernel.org/r/20211006082209.417-1-lukas.bulwahn@gmail.com
Fixes: 6e7b64b9dd6d ("elfcore: fix building with clang")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Barret Rhoden <brho@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/elfcore.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/elfcore.h
+++ b/include/linux/elfcore.h
@@ -58,7 +58,7 @@ static inline int elf_core_copy_task_xfp
 }
 #endif
 
-#if defined(CONFIG_UM) || defined(CONFIG_IA64)
+#if (defined(CONFIG_UML) && defined(CONFIG_X86_32)) || defined(CONFIG_IA64)
 /*
  * These functions parameterize elf_core_dump in fs/binfmt_elf.c to write out
  * extra segments containing the gate DSO contents.  Dumping its


