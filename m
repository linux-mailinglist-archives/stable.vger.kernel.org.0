Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7010824A6B2
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 21:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgHSTRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 15:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726991AbgHSTRK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 15:17:10 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1A4C061342
        for <stable@vger.kernel.org>; Wed, 19 Aug 2020 12:17:09 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id g127so26790878ybf.11
        for <stable@vger.kernel.org>; Wed, 19 Aug 2020 12:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=AYTx8OTXrfy1fkjiQ/QJZUTx1nYyS440PAIctrO8h/4=;
        b=hU5/8DJYdBVIul76iBEmEZ0CUUQxYYOOHdwBe4d4zyPtB5gIZh8vrm6Ccwlw+L7mfG
         jT4Y2xyv2gvx6x+GF1XuIP6lvuA20HdADAoN96ldTrsTtbKn1/+bcvafV0ipxVGPvx5T
         OVGD/OW/Rm/RcYoUIfpfQAlOuAUQ5mPdB6lE+Pq/kfD1VWh7KsAWKxXxroLPwLw40+1i
         kvI45eNE7kkOgbXRICBXBMXLPlBDZYoiRoJLP51z6Bh+cy81LCawEG//TZN3rxPJtz6E
         aLLhREs3LcMxpShnPm0ZN5pRx9wDMtIvvkd7xgXg9RTXshqTL+GmUQ2DHv1Dd734CK3p
         ZQEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=AYTx8OTXrfy1fkjiQ/QJZUTx1nYyS440PAIctrO8h/4=;
        b=b4GGEAoqbFBwfZwzsRC0AFUqj/dnaIy07IBcJ7mpfQro3QBgvRXPaAE/oH7QcNadN/
         kQqQTw3q4pImmgaiK2/VVZqaZAHu19m3zbA12Vc5+IPW8hqDCtLh4GlMxt/dAvjNpTRa
         bisPMzLofvRRCgpBo0Z0BijyNIMKVO95AA8HkiiWowLSvoTlFSeA+zFsgYO6FnjHd2/R
         9iS3TwiMCxvgg6H55FlN3AhhjJmeCWOK+G9E3sG8XCbht7eRa1714pGeJlK+fYifpk23
         lJep/wwbmwiGHbS7BoiCKPYv2DPfLBFPF9hR2tY3sdqSNLZ7BRpfF5J6mz1cFe66LW7H
         wYow==
X-Gm-Message-State: AOAM53339I9XWMguTak+82TOp0TaOi/ITSkdAlecQ74yOqkUmwaZxgXx
        fuJ9KObbp9KOkO7TuUAdyCE0/nGQIthPzkXDfSM=
X-Google-Smtp-Source: ABdhPJxETf8t+SYq21D8M+YylDYX3q4MAl4M/CU8Tsm+guyliSGVos5yJOYpig0Mf0L2E13QKLQC7j9HxW70uBCx9fg=
X-Received: by 2002:a5b:c08:: with SMTP id f8mr34030464ybq.198.1597864628624;
 Wed, 19 Aug 2020 12:17:08 -0700 (PDT)
Date:   Wed, 19 Aug 2020 12:16:50 -0700
In-Reply-To: <20200819191654.1130563-1-ndesaulniers@google.com>
Message-Id: <20200819191654.1130563-2-ndesaulniers@google.com>
Mime-Version: 1.0
References: <20200819191654.1130563-1-ndesaulniers@google.com>
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
Subject: [PATCH v2 1/5] Makefile: add -fno-builtin-stpcpy
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Masahiro Yamada <masahiroy@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Cc:     Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Tony Luck <tony.luck@intel.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Joe Perches <joe@perches.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Daniel Axtens <dja@axtens.net>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Yury Norov <yury.norov@gmail.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        Bruce Ashfield <bruce.ashfield@gmail.com>,
        Marco Elver <elver@google.com>,
        Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>,
        Andi Kleen <ak@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "=?UTF-8?q?D=C3=A1vid=20Bolvansk=C3=BD?=" <david.bolvansky@gmail.com>,
        Eli Friedman <efriedma@quicinc.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

LLVM implemented a recent "libcall optimization" that lowers calls to
`sprintf(dest, "%s", str)` where the return value is used to
`stpcpy(dest, str) - dest`. This generally avoids the machinery involved
in parsing format strings. This optimization was introduced into
clang-12. Because the kernel does not provide an implementation of
stpcpy, we observe linkage failures for almost all targets when building
with ToT clang.

The interface is unsafe as it does not perform any bounds checking.
Disable this "libcall optimization" via `-fno-builtin-stpcpy`.

Cc: stable@vger.kernel.org # 4.4
Link: https://bugs.llvm.org/show_bug.cgi?id=3D47162
Link: https://github.com/ClangBuiltLinux/linux/issues/1126
Link: https://reviews.llvm.org/D85963
Reported-by: Sami Tolvanen <samitolvanen@google.com>
Suggested-by: D=C3=A1vid Bolvansk=C3=BD <david.bolvansky@gmail.com>
Suggested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index 9cac6fde3479..e523dc8d30e0 100644
--- a/Makefile
+++ b/Makefile
@@ -578,6 +578,7 @@ ifneq ($(LLVM_IAS),1)
 CLANG_FLAGS	+=3D -no-integrated-as
 endif
 CLANG_FLAGS	+=3D -Werror=3Dunknown-warning-option
+CLANG_FLAGS	+=3D -fno-builtin-stpcpy
 KBUILD_CFLAGS	+=3D $(CLANG_FLAGS)
 KBUILD_AFLAGS	+=3D $(CLANG_FLAGS)
 export CLANG_FLAGS
--=20
2.28.0.297.g1956fa8f8d-goog

