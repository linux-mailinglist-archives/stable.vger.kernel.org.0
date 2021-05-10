Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA1D3786DB
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbhEJLLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:11:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234612AbhEJLFF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:05:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A614C61075;
        Mon, 10 May 2021 10:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644105;
        bh=bfeEcT9P6kGTP+n3dZVdN1PO9w41CUA/HggeoDp0q2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1IcbS9on5cLTsmWgZk54sS0knnaT3rpFkOkk32Z97JSy3+IxaLxMTRD5quzEySHgv
         RUFF19IIl9NLB52DeRLr/KAOuYNHuV9svRFIAg5szQjdKFY/YfSoVx8FJY0OeGwVup
         rtmzXrFU7CwIMjnr8Cnr9KfFzZ2e8ORpbtGDZXw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.11 254/342] Makefile: Move -Wno-unused-but-set-variable out of GCC only block
Date:   Mon, 10 May 2021 12:20:44 +0200
Message-Id: <20210510102018.489144480@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
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
@@ -774,16 +774,16 @@ KBUILD_CFLAGS += -Wno-gnu
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


