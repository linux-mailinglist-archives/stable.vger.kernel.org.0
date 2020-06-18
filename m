Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFE81FDDBE
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731187AbgFRB2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:28:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:36606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732027AbgFRB2H (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:28:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09702221F3;
        Thu, 18 Jun 2020 01:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443686;
        bh=eJRf/DLe3SoTgQ+rYReWSmo1n75LlOi6Lxrz7lpF1ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gqw9zfcyEBnJr93X2YAXkUEsRBcrEy8WIFVbwqTyPWPYiBzlcLyl6hNlTnWqup4pU
         ksBj6lCuHqb26kywPBZvHe5ea9HhQyH4TnlX8T4SRYL8Z7e4XLfOSn5LfqsaUTU8UH
         uT4jRuKO5QJjfsWdXy+1knEMQ5doZgQ+VRz8WjwU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Fangrui Song <maskray@google.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Ilie Halip <ilie.halip@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.14 099/108] elfnote: mark all .note sections SHF_ALLOC
Date:   Wed, 17 Jun 2020 21:25:51 -0400
Message-Id: <20200618012600.608744-99-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012600.608744-1-sashal@kernel.org>
References: <20200618012600.608744-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

[ Upstream commit 51da9dfb7f20911ae4e79e9b412a9c2d4c373d4b ]

ELFNOTE_START allows callers to specify flags for .pushsection assembler
directives.  All callsites but ELF_NOTE use "a" for SHF_ALLOC.  For vdso's
that explicitly use ELF_NOTE_START and BUILD_SALT, the same section is
specified twice after preprocessing, once with "a" flag, once without.
Example:

.pushsection .note.Linux, "a", @note ;
.pushsection .note.Linux, "", @note ;

While GNU as allows this ordering, it warns for the opposite ordering,
making these directives position dependent.  We'd prefer not to precisely
match this behavior in Clang's integrated assembler.  Instead, the non
__ASSEMBLY__ definition of ELF_NOTE uses
__attribute__((section(".note.Linux"))) which is created with SHF_ALLOC,
so let's make the __ASSEMBLY__ definition of ELF_NOTE consistent with C
and just always use "a" flag.

This allows Clang to assemble a working mainline (5.6) kernel via:
$ make CC=clang AS=clang

Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Fangrui Song <maskray@google.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/913
Link: http://lkml.kernel.org/r/20200325231250.99205-1-ndesaulniers@google.com
Debugged-by: Ilie Halip <ilie.halip@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/elfnote.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/elfnote.h b/include/linux/elfnote.h
index f236f5b931b2..7fdd7f355b52 100644
--- a/include/linux/elfnote.h
+++ b/include/linux/elfnote.h
@@ -54,7 +54,7 @@
 .popsection				;
 
 #define ELFNOTE(name, type, desc)		\
-	ELFNOTE_START(name, type, "")		\
+	ELFNOTE_START(name, type, "a")		\
 		desc			;	\
 	ELFNOTE_END
 
-- 
2.25.1

