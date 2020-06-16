Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3E01FB999
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729794AbgFPQFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 12:05:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732473AbgFPPtM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:49:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2F1F2071A;
        Tue, 16 Jun 2020 15:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322552;
        bh=cR0PP+/MQZYLqQf3bbJfXoLuvhvnjpmt6Okx0cKiyf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ugzR4CCo6RiDW7hayB/yjARNCvFGaFMe8YkxepG4xMJGHEyWq8KiKIxER1s335Iy/
         mpuxje/ygGgOdt8pPBpkompgBZnpdOl0OPQrZlWphe0b8l65MFRYoAwN6u6Vt4/fdQ
         KBFHQvS2o1oNCh1/ABqhskzS2NzKdmv/c5itCu1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Fangrui Song <maskray@google.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jian Cai <jiancai@google.com>,
        Ilie Halip <ilie.halip@gmail.com>
Subject: [PATCH 5.6 013/161] elfnote: mark all .note sections SHF_ALLOC
Date:   Tue, 16 Jun 2020 17:33:23 +0200
Message-Id: <20200616153107.043647293@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

commit 51da9dfb7f20911ae4e79e9b412a9c2d4c373d4b upstream.

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
Cc: Jian Cai <jiancai@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/elfnote.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/elfnote.h
+++ b/include/linux/elfnote.h
@@ -54,7 +54,7 @@
 .popsection				;
 
 #define ELFNOTE(name, type, desc)		\
-	ELFNOTE_START(name, type, "")		\
+	ELFNOTE_START(name, type, "a")		\
 		desc			;	\
 	ELFNOTE_END
 


