Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F22F328509
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235312AbhCAQrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:47:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:41538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233864AbhCAQjB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:39:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CD4E64F89;
        Mon,  1 Mar 2021 16:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616094;
        bh=JjAwIPrgwgpeZS6RWNXY1nOgDD/pPxiRnmNbc1xWC7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+ofUIaWSfn5A52FfFq4C2wfyHIyREnKcwQOvfqPY91jmwUY4L3WHA/SxrU66xPTH
         8aXkrthBxb4mY/77nk9cq9h5sDbVGEc9y+urpPb1Oe05ekUHJEpouyXydMKOYGOEul
         ZZItwpVgo2wDh8FxG1uqUv9dz0+B3zAODf0SmOUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Murphy <lists@colorremedies.com>,
        Fangrui Song <maskray@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Mark Wielaard <mark@klomp.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 4.14 008/176] vmlinux.lds.h: add DWARF v5 sections
Date:   Mon,  1 Mar 2021 17:11:21 +0100
Message-Id: <20210301161021.365813691@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

commit 3c4fa46b30c551b1df2fb1574a684f68bc22067c upstream.

We expect toolchains to produce these new debug info sections as part of
DWARF v5. Add explicit placements to prevent the linker warnings from
--orphan-section=warn.

Compilers may produce such sections with explicit -gdwarf-5, or based on
the implicit default version of DWARF when -g is used via DEBUG_INFO.
This implicit default changes over time, and has changed to DWARF v5
with GCC 11.

.debug_sup was mentioned in review, but without compilers producing it
today, let's wait to add it until it becomes necessary.

Cc: stable@vger.kernel.org
Link: https://bugzilla.redhat.com/show_bug.cgi?id=1922707
Reported-by: Chris Murphy <lists@colorremedies.com>
Suggested-by: Fangrui Song <maskray@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Mark Wielaard <mark@klomp.org>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/asm-generic/vmlinux.lds.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -669,8 +669,13 @@
 		/* DWARF 4 */						\
 		.debug_types	0 : { *(.debug_types) }			\
 		/* DWARF 5 */						\
+		.debug_addr	0 : { *(.debug_addr) }			\
+		.debug_line_str	0 : { *(.debug_line_str) }		\
+		.debug_loclists	0 : { *(.debug_loclists) }		\
 		.debug_macro	0 : { *(.debug_macro) }			\
-		.debug_addr	0 : { *(.debug_addr) }
+		.debug_names	0 : { *(.debug_names) }			\
+		.debug_rnglists	0 : { *(.debug_rnglists) }		\
+		.debug_str_offsets	0 : { *(.debug_str_offsets) }
 
 		/* Stabs debugging sections.  */
 #define STABS_DEBUG							\


