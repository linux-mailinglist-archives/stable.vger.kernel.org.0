Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCE2433EA1
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 20:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234954AbhJSSlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 14:41:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234909AbhJSSlv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Oct 2021 14:41:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B70366115B;
        Tue, 19 Oct 2021 18:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634668778;
        bh=12gmNCoV4L3BrlYCUtMYSA6j3eg9CHt0zqFLUpLz/1Y=;
        h=Date:From:To:Subject:From;
        b=eO9HycFJeXEDIxzeN6Ubtyid/HU+GXmGyogdqBHQEiQEajfcuE3sAnyp/O/NnBf5H
         TXDRENnysfBK/D5n9sgjUzslwLKMWqBjnk9a2kta+yqNQ+8yv3IiBvCpmZIbN8y+Wx
         HZIERCFedjMWKnAftnYcKa9iy2pnS83f6NmdITno=
Date:   Tue, 19 Oct 2021 11:39:37 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, brho@google.com, catalin.marinas@arm.com,
        lukas.bulwahn@gmail.com, mm-commits@vger.kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, stable@vger.kernel.org
Subject:  [merged] elfcore-correct-reference-to-config_uml.patch
 removed from -mm tree
Message-ID: <20211019183937.sc_lxFhfk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: elfcore: correct reference to CONFIG_UML
has been removed from the -mm tree.  Its filename was
     elfcore-correct-reference-to-config_uml.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: elfcore: correct reference to CONFIG_UML

Commit 6e7b64b9dd6d ("elfcore: fix building with clang") introduces
special handling for two architectures, ia64 and User Mode Linux. 
However, the wrong name, i.e., CONFIG_UM, for the intended Kconfig symbol
for User-Mode Linux was used.

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
---

 include/linux/elfcore.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/elfcore.h~elfcore-correct-reference-to-config_uml
+++ a/include/linux/elfcore.h
@@ -109,7 +109,7 @@ static inline int elf_core_copy_task_fpr
 #endif
 }
 
-#if defined(CONFIG_UM) || defined(CONFIG_IA64)
+#if (defined(CONFIG_UML) && defined(CONFIG_X86_32)) || defined(CONFIG_IA64)
 /*
  * These functions parameterize elf_core_dump in fs/binfmt_elf.c to write out
  * extra segments containing the gate DSO contents.  Dumping its
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are

memory-remove-unused-config_mem_block_size.patch

