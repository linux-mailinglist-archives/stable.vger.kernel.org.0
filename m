Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29825227760
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 06:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgGUEUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 00:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgGUEUF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 00:20:05 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C33AC0619D5
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 21:20:05 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id em19so11590068qvb.14
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 21:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=BihrwH3YWr7bTCjry1NXThJajsBWv/A/wcqD0l396O4=;
        b=Gkxs/4L9w2KYJeqo1YzrritKtKVPQXS0nv3cFc1jhGooz2i2RqPdhiqYoQnp1qX6Fy
         v0erMgNID5uKlh2JzkyqRUT3P2dNJPgGSUmyE/T5ReFLtmy2MGmujoy8D+zW9wi/mNkp
         rOVTsvULqQVx9jc4HxHbW8MaJS/1Tgjjza0iSFEIf3TswCxVOm4j8tuNunvWr+cxf1Ts
         hZYjAoCTG/p/3fEt/AbyH4JtklfW7Es9V6gVD8dewOgW2vhglnCtms5VhrnhEVBBrkbx
         HsHa51amlowN1sfv6HI5H1SbmFc//YgFuisS3nLFiSmSjpetTSEK0L5bn028gUR8C5rs
         T+uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=BihrwH3YWr7bTCjry1NXThJajsBWv/A/wcqD0l396O4=;
        b=Z7s3EnkdTUg8imfSNuyA+TbLdaPdgmx0G1uutahfApBBAXOIfMHOnorw/h4Z6xho0+
         F69/TORjQkGhDl3rPkFZULHSqcCdJ477mWQ10PVuBK9nwF6jY7C1cVjOkxOcbypMIS41
         bcWDtYZIgKjeZ2tBtMHDh205VIOQo2l6ahjz8uoLNc9bsoNSv3zGSDdA1CLTWq/YWqW3
         xVT+1jyL9ymU8e1m2w3ofm1CZnpclXrhJi+REnHPoll/SjF+BGk2Qx1ENj7uyU4qY35R
         a8M7lpSYR9rzQvnLc4Ne1yrPdKNLDqj+9w1MX2roNco9AT1lR5MTf0RA4rkiLSSS6yGD
         Zx/Q==
X-Gm-Message-State: AOAM532drk2AACh0C6W2p1rvYiF/BnEtQsuh5BI0luWcoMDxUSC64W8M
        vZga+ZA5IawNraNPf65x3+wN8/5k7FTt
X-Google-Smtp-Source: ABdhPJyws38D0FLgRfDbVjjMTi43YQTPV6lXnjuE3rDLoFlOp9lJ5MDKjHMYRc9vl3OPwcPnhjiqPGbn9gBf
X-Received: by 2002:a05:6214:927:: with SMTP id dk7mr24912062qvb.26.1595305204150;
 Mon, 20 Jul 2020 21:20:04 -0700 (PDT)
Date:   Mon, 20 Jul 2020 21:19:38 -0700
Message-Id: <20200721041940.4029552-1-maskray@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
Subject: [PATCH v2] Makefile: Fix GCC_TOOLCHAIN_DIR prefix for Clang cross compilation
From:   Fangrui Song <maskray@google.com>
To:     Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Cc:     stable@vger.kernel.org, Jian Cai <jiancai@google.com>,
        Bill Wendling <morbo@google.com>,
        Manoj Gupta <manojgupta@google.com>,
        Fangrui Song <maskray@google.com>,
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

