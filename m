Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3324329AA
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 00:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233465AbhJRWSW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 18:18:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229790AbhJRWSW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 18:18:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04B6660F57;
        Mon, 18 Oct 2021 22:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634595370;
        bh=Yz2lCk1Gf5tedBMNA+38DGAKcpNnkhSAKgZ0A5gvbh0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GMQ4t42U7CC/bxhAiH0AA6UqQqMIma1TqkHM4nyvWu56GJ1RWbmTlOsv/FTDKnLke
         hD87i5LWDVgcKY00Q62NMyt5Bur6gESg0dZI90nQDnVx2X6HBfDXjZKyJ+LOmTN01Y
         I+hvgaEW5cW218FL3Lj3a01veubK7qVkX1CwM8bQ=
Date:   Mon, 18 Oct 2021 15:16:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de, brho@google.com,
        catalin.marinas@arm.com, linux-mm@kvack.org,
        lukas.bulwahn@gmail.com, mm-commits@vger.kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 15/19] elfcore: correct reference to CONFIG_UML
Message-ID: <20211018221609.zmtVj1PE3%akpm@linux-foundation.org>
In-Reply-To: <20211018151438.f2246e2656c041b6753a8bdd@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
