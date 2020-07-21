Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A87D228760
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 19:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730452AbgGURbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 13:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729207AbgGURbh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 13:31:37 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9FC8C061794
        for <stable@vger.kernel.org>; Tue, 21 Jul 2020 10:31:36 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id m81so26245742ybf.6
        for <stable@vger.kernel.org>; Tue, 21 Jul 2020 10:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=3P1vHvrPLTxN1NHkXs2uZZPKcTk+Bw2pv9V8iB8AxW0=;
        b=ndyjrJMiUCmnrZOZOnqQOMimH5626tf5eIVETa9PZmrsX0cIIIBPHqsUK9inX4ZM6f
         2RgGEO6cdVvguwhofgXb4eY5hWcHVMB8AvyuSiJda+MsEP+mwmeNodtoWEyPBXcGtcKF
         R2TrqlfeB6/uj9aQlspVjf0ZW35RmSwqvdn16jOx5k7sBXjLkpo78kc9jSsBG/a+AX7I
         daRJt5/SUmRxDn/WsIFwoC9UsXdOltbepP/KD2lnz4JCXB7/zwTPZRbGrVf5VZiscGAJ
         haYJIwaxjaOKxDZJ9Mfwm+HHI2cSzl6YGFgA1vXGJ6zvQRSrD35LHUqnEUTljXbLMGXr
         CIrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=3P1vHvrPLTxN1NHkXs2uZZPKcTk+Bw2pv9V8iB8AxW0=;
        b=MnjciDlJwE5VQkihlCjRwQAyPGg8v5PJho/HBz0TyZMepSmI6eoW9wyn//+qKDtf3b
         4Ab+3hiKCSABAnPkLm+BZJOckM4XoaVGm7NRjF5hxUGWh8tLK9TeO8vhjHd7t5156jwf
         bGRemBgla5gerhJKTLLQDLa3dzNW3XUcpJ2o96piuC8G3QfDmaS97/LYwvJCGAZLPXKr
         T9zQ4Q7xP8OYWnCXJInpexJkWlVzY5BLf9oYMxNZqOX/DLvHwiA5nygDLJk67jpc3X5F
         dxRWLHdVytx2od2HG6DtPtsPAty6jNPO7tDsGysOJ90ALiyCTm6udxHerihBPSaC5eVn
         ydaQ==
X-Gm-Message-State: AOAM531PHrs2m6i/c1LkoT5TSGfiVzIk5Hbu6NN9bXct/++gyGeLm1pK
        R0ZfklDxWZVeRCZSJQDE/FHQ0S4koArn
X-Google-Smtp-Source: ABdhPJxg7/bEtBd0hMf07VdcctlhouFzcAcr78tDomM8KEZwdBH+gFuxaoC+pSZ3ZJpJs1uxudD4n81ESEtr
X-Received: by 2002:a25:9302:: with SMTP id f2mr43552634ybo.238.1595352695977;
 Tue, 21 Jul 2020 10:31:35 -0700 (PDT)
Date:   Tue, 21 Jul 2020 10:31:23 -0700
Message-Id: <20200721173125.1273884-1-maskray@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
Subject: [PATCH v3] Makefile: Fix GCC_TOOLCHAIN_DIR prefix for Clang cross compilation
From:   Fangrui Song <maskray@google.com>
To:     Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Cc:     Jian Cai <jiancai@google.com>, Bill Wendling <morbo@google.com>,
        Manoj Gupta <manojgupta@google.com>,
        Fangrui Song <maskray@google.com>, stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When CROSS_COMPILE is set (e.g. aarch64-linux-gnu-), if
$(CROSS_COMPILE)elfedit is found at /usr/bin/aarch64-linux-gnu-elfedit,
GCC_TOOLCHAIN_DIR will be set to /usr/bin/.  --prefix= will be set to
/usr/bin/ and Clang as of 11 will search for both
$(prefix)aarch64-linux-gnu-$needle and $(prefix)$needle.

GCC searchs for $(prefix)aarch64-linux-gnu/$version/$needle,
$(prefix)aarch64-linux-gnu/$needle and $(prefix)$needle. In practice,
$(prefix)aarch64-linux-gnu/$needle rarely contains executables.

To better model how GCC's -B/--prefix takes in effect in practice, newer
Clang (since
https://github.com/llvm/llvm-project/commit/3452a0d8c17f7166f479706b293caf6ac76ffd90)
only searches for $(prefix)$needle. Currently it will find /usr/bin/as
instead of /usr/bin/aarch64-linux-gnu-as.

Set --prefix= to $(GCC_TOOLCHAIN_DIR)$(CROSS_COMPILE)
(/usr/bin/aarch64-linux-gnu-) so that newer Clang can find the
appropriate cross compiling GNU as (when -no-integrated-as is in
effect).

Cc: stable@vger.kernel.org
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Fangrui Song <maskray@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1099
---
Changes in v2:
* Updated description to add tags and the llvm-project commit link.
* Fixed a typo.

Changes in v3:
* Add Cc: stable@vger.kernel.org
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 0b5f8538bde5..3ac83e375b61 100644
--- a/Makefile
+++ b/Makefile
@@ -567,7 +567,7 @@ ifneq ($(shell $(CC) --version 2>&1 | head -n 1 | grep clang),)
 ifneq ($(CROSS_COMPILE),)
 CLANG_FLAGS	+= --target=$(notdir $(CROSS_COMPILE:%-=%))
 GCC_TOOLCHAIN_DIR := $(dir $(shell which $(CROSS_COMPILE)elfedit))
-CLANG_FLAGS	+= --prefix=$(GCC_TOOLCHAIN_DIR)
+CLANG_FLAGS	+= --prefix=$(GCC_TOOLCHAIN_DIR)$(CROSS_COMPILE)
 GCC_TOOLCHAIN	:= $(realpath $(GCC_TOOLCHAIN_DIR)/..)
 endif
 ifneq ($(GCC_TOOLCHAIN),)
-- 
2.28.0.rc0.105.gf9edc3c819-goog

