Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C8F43A2FC
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237682AbhJYTzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:55:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237734AbhJYTts (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:49:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 436E06124A;
        Mon, 25 Oct 2021 19:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190921;
        bh=K3+SaxvkrwV/W9djGHzCVpWcQIlGR9BGbA+DJOCbpj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1GANwCn6PDpJI6e2MtqC+2v5xcj3tkXZmqeDFItjseScZgTgeZUFchUOshK0BKlxy
         Cz47eMh3sJ/bZjI3H/9aYyCAh3kLM/E4fuTPn9uJvnbc2K3pdUF8qSLqWMv3R4ygw0
         FjJhc5mrBruUiZnJMivBYnIxNggLJ0GL67o3+TL4=
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
Subject: [PATCH 5.14 083/169] elfcore: correct reference to CONFIG_UML
Date:   Mon, 25 Oct 2021 21:14:24 +0200
Message-Id: <20211025191027.802923341@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
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
@@ -109,7 +109,7 @@ static inline int elf_core_copy_task_fpr
 #endif
 }
 
-#if defined(CONFIG_UM) || defined(CONFIG_IA64)
+#if (defined(CONFIG_UML) && defined(CONFIG_X86_32)) || defined(CONFIG_IA64)
 /*
  * These functions parameterize elf_core_dump in fs/binfmt_elf.c to write out
  * extra segments containing the gate DSO contents.  Dumping its


