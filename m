Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4202A588A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731144AbgKCUqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:46:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:35124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730405AbgKCUqH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:46:07 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1738A223EA;
        Tue,  3 Nov 2020 20:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436366;
        bh=9l3Ke7dunEKAavCVd2ys4l8KPLnSr6pSzFI8GTFy9Q0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kScGadfIPtcClMnRBPyOLpqd1DW/PmX8l42Mw3bO+Xxf9cIT9hsp8o44plXC5tvLW
         FVve+zm7ImEwq13NFcmbElS3/Hj0+NfraQkspiTBw7r/lWIY9m/UnzcX6fkenl8aGH
         loje5Ypk9iDpbo+qLDFoKOVTtl91QBOEEOLewcms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Cai <jiancai@google.com>,
        =?UTF-8?q?F=C4=81ng-ru=C3=AC=20S=C3=B2ng?= <maskray@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>,
        Ingo Molnar <mingo@kernel.org>,
        Luis Lozano <llozano@google.com>,
        Manoj Gupta <manojgupta@google.com>, linux-arch@vger.kernel.org
Subject: [PATCH 5.9 182/391] vmlinux.lds.h: Add PGO and AutoFDO input sections
Date:   Tue,  3 Nov 2020 21:33:53 +0100
Message-Id: <20201103203359.166923971@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

commit eff8728fe69880d3f7983bec3fb6cea4c306261f upstream.

Basically, consider .text.{hot|unlikely|unknown}.* part of .text, too.

When compiling with profiling information (collected via PGO
instrumentations or AutoFDO sampling), Clang will separate code into
.text.hot, .text.unlikely, or .text.unknown sections based on profiling
information. After D79600 (clang-11), these sections will have a
trailing `.` suffix, ie.  .text.hot., .text.unlikely., .text.unknown..

When using -ffunction-sections together with profiling infomation,
either explicitly (FGKASLR) or implicitly (LTO), code may be placed in
sections following the convention:
.text.hot.<foo>, .text.unlikely.<bar>, .text.unknown.<baz>
where <foo>, <bar>, and <baz> are functions.  (This produces one section
per function; we generally try to merge these all back via linker script
so that we don't have 50k sections).

For the above cases, we need to teach our linker scripts that such
sections might exist and that we'd explicitly like them grouped
together, otherwise we can wind up with code outside of the
_stext/_etext boundaries that might not be mapped properly for some
architectures, resulting in boot failures.

If the linker script is not told about possible input sections, then
where the section is placed as output is a heuristic-laiden mess that's
non-portable between linkers (ie. BFD and LLD), and has resulted in many
hard to debug bugs.  Kees Cook is working on cleaning this up by adding
--orphan-handling=warn linker flag used in ARCH=powerpc to additional
architectures. In the case of linker scripts, borrowing from the Zen of
Python: explicit is better than implicit.

Also, ld.bfd's internal linker script considers .text.hot AND
.text.hot.* to be part of .text, as well as .text.unlikely and
.text.unlikely.*. I didn't see support for .text.unknown.*, and didn't
see Clang producing such code in our kernel builds, but I see code in
LLVM that can produce such section names if profiling information is
missing. That may point to a larger issue with generating or collecting
profiles, but I would much rather be safe and explicit than have to
debug yet another issue related to orphan section placement.

Reported-by: Jian Cai <jiancai@google.com>
Suggested-by: Fāng-ruì Sòng <maskray@google.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Luis Lozano <llozano@google.com>
Tested-by: Manoj Gupta <manojgupta@google.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: linux-arch@vger.kernel.org
Cc: stable@vger.kernel.org
Link: https://sourceware.org/git/?p=binutils-gdb.git;a=commitdiff;h=add44f8d5c5c05e08b11e033127a744d61c26aee
Link: https://sourceware.org/git/?p=binutils-gdb.git;a=commitdiff;h=1de778ed23ce7492c523d5850c6c6dbb34152655
Link: https://reviews.llvm.org/D79600
Link: https://bugs.chromium.org/p/chromium/issues/detail?id=1084760
Link: https://lore.kernel.org/r/20200821194310.3089815-7-keescook@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Debugged-by: Luis Lozano <llozano@google.com>

---
 include/asm-generic/vmlinux.lds.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -581,7 +581,10 @@
  */
 #define TEXT_TEXT							\
 		ALIGN_FUNCTION();					\
-		*(.text.hot TEXT_MAIN .text.fixup .text.unlikely)	\
+		*(.text.hot .text.hot.*)				\
+		*(TEXT_MAIN .text.fixup)				\
+		*(.text.unlikely .text.unlikely.*)			\
+		*(.text.unknown .text.unknown.*)			\
 		NOINSTR_TEXT						\
 		*(.text..refcount)					\
 		*(.ref.text)						\


