Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0E536E2EF
	for <lists+stable@lfdr.de>; Thu, 29 Apr 2021 03:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232947AbhD2BY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 21:24:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:59030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229794AbhD2BY5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Apr 2021 21:24:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B49A5610FA;
        Thu, 29 Apr 2021 01:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619659452;
        bh=4Hd6dK6eIjF8l59EgDDYr45OuQJR8Yqbc8fdCNhcpyk=;
        h=From:To:Cc:Subject:Date:From;
        b=Zc6KpNZ3re98d4jLG7D1Jjuj6wDjVcpW5n1++rnsqWPCsHuP+cganlwOPmRwyOSF8
         lqkWNr7AGpvw40mv8V01RvbHOsrG4bf8Hlef8bunEngVr3Pv1+12lfV/v1kb9Axq/0
         37GHP0y7HNNGBNUOXyA0NWCHTyO3xIuSj8HZ1QnGx5srMc3An8kKL4t5ykpNu3cLVf
         +l+pdegnA95lsYeZP+tYs4DV3/4R23S4Z3grpgqiGkQr0SlOIG/OQRqzH7UCExXKOH
         jmPqdAya3rOf0lR4eTY+4j+e1vBJGjnKHjEK+CLsgLXGES+RiltVxoMtrnLbULV5Zs
         bI+OzDLZUDR3w==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <nathan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] Makefile: Move -Wno-unused-but-set-variable out of GCC only block
Date:   Wed, 28 Apr 2021 18:23:50 -0700
Message-Id: <20210429012350.600951-1-nathan@kernel.org>
X-Mailer: git-send-email 2.31.1.362.g311531c9de
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently, -Wunused-but-set-variable is only supported by GCC so it is
disabled unconditionally in a GCC only block (it is enabled with W=1).
clang currently has its implementation for this warning in review so
preemptively move this statement out of the GCC only block and wrap it
with cc-disable-warning so that both compilers function the same.

Cc: stable@vger.kernel.org
Link: https://reviews.llvm.org/D100581
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 Makefile | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index f03888cdba4e..911d839cfea8 100644
--- a/Makefile
+++ b/Makefile
@@ -775,16 +775,16 @@ KBUILD_CFLAGS += -Wno-gnu
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

base-commit: d8201efe75e13146ebde433745c7920e15593baf
-- 
2.31.1.362.g311531c9de

