Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 513E43782C7
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbhEJKh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:37:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232012AbhEJKfu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:35:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43A446193E;
        Mon, 10 May 2021 10:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642540;
        bh=2JQfH85XNP2RL5okaG0KWzxJRkefleC9dvgww4fg4t0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dZCJXnCBX27GAhgVX9RuufsdwVLDqlByf+QvrL4lcd+sC85+qLLsu1K41SQqYN+vj
         mZ24f93tpwxhtlbxv2I6rvu2hLsQZ7CWq20pGffAilG96lL0YoBOw04oRZ5gjvxIL6
         L+/DVS7++aWVahVfplGss37JRGZXrwtavgSco4u8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.4 137/184] Makefile: Move -Wno-unused-but-set-variable out of GCC only block
Date:   Mon, 10 May 2021 12:20:31 +0200
Message-Id: <20210510101954.642986524@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit 885480b084696331bea61a4f7eba10652999a9c1 upstream.

Currently, -Wunused-but-set-variable is only supported by GCC so it is
disabled unconditionally in a GCC only block (it is enabled with W=1).
clang currently has its implementation for this warning in review so
preemptively move this statement out of the GCC only block and wrap it
with cc-disable-warning so that both compilers function the same.

Cc: stable@vger.kernel.org
Link: https://reviews.llvm.org/D100581
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -765,16 +765,16 @@ KBUILD_CFLAGS += -Wno-tautological-compa
 KBUILD_CFLAGS += -mno-global-merge
 else
 
-# These warnings generated too much noise in a regular build.
-# Use make W=1 to enable them (see scripts/Makefile.extrawarn)
-KBUILD_CFLAGS += -Wno-unused-but-set-variable
-
 # Warn about unmarked fall-throughs in switch statement.
 # Disabled for clang while comment to attribute conversion happens and
 # https://github.com/ClangBuiltLinux/linux/issues/636 is discussed.
 KBUILD_CFLAGS += $(call cc-option,-Wimplicit-fallthrough,)
 endif
 
+# These warnings generated too much noise in a regular build.
+# Use make W=1 to enable them (see scripts/Makefile.extrawarn)
+KBUILD_CFLAGS += $(call cc-disable-warning, unused-but-set-variable)
+
 KBUILD_CFLAGS += $(call cc-disable-warning, unused-const-variable)
 ifdef CONFIG_FRAME_POINTER
 KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls


