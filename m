Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78036424B6E
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 02:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240154AbhJGA7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 20:59:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240107AbhJGA7v (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 20:59:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A31076113E;
        Thu,  7 Oct 2021 00:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633568278;
        bh=CNly1xY8zFxdamrbIgx3E0GxH18/+5wSfPanZ5ny/4E=;
        h=Date:From:To:Subject:From;
        b=qyE3OcJJDVeL3QaheIJMeGcE6Y4eppUY/x2Gwk3+qCYTXUzgEmPBEnCQsArFz5PZN
         u0OhuO51+bSciiwDPgncqIvbCNYz3foTeHCSmVTy6DqcBbYwyzAGgiM/n5sSi0dS5A
         StaqC0B289yOiSsGFvLcxCO7CkzGs+uNUxx3qA1M=
Date:   Wed, 06 Oct 2021 17:57:58 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, brho@google.com, catalin.marinas@arm.com,
        lukas.bulwahn@gmail.com, mm-commits@vger.kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, stable@vger.kernel.org
Subject:  + elfcore-correct-reference-to-config_uml.patch added to
 -mm tree
Message-ID: <20211007005758.YOU3TAhWN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: elfcore: correct reference to CONFIG_UML
has been added to the -mm tree.  Its filename is
     elfcore-correct-reference-to-config_uml.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/elfcore-correct-reference-to-config_uml.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/elfcore-correct-reference-to-config_uml.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
+#if defined(CONFIG_UML) || defined(CONFIG_IA64)
 /*
  * These functions parameterize elf_core_dump in fs/binfmt_elf.c to write out
  * extra segments containing the gate DSO contents.  Dumping its
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are

elfcore-correct-reference-to-config_uml.patch

