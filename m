Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F286E328FE7
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242643AbhCAT66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:58:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:55182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241858AbhCATrb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:47:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C60FA65131;
        Mon,  1 Mar 2021 17:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618220;
        bh=62bPEAtgnrBZ63UwLRFJH8vt9ogszcva3eIdWy3LYXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AiVe1MAAHCyEIt5DD6C3hN0CzpBX0SJ+ZPVvNB1Xs1pLR+QEMeZ63u3se8Woc9tkp
         cSc1+QITYa3bwwM+0WR2SZSzglVy49TK45zXVrDVN9GuFZbYLXT5yhJeAYr2zkKu6b
         CRyt7v6F7jWIG75zV8kzTV9IlUzkg+kJZXRX7tSg=
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
Subject: [PATCH 5.10 001/663] vmlinux.lds.h: add DWARF v5 sections
Date:   Mon,  1 Mar 2021 17:04:09 +0100
Message-Id: <20210301161141.844318190@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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
@@ -828,8 +828,13 @@
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
 
 /* Stabs debugging sections. */
 #define STABS_DEBUG							\


