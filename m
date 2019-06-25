Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 142CF55644
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 19:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730884AbfFYRsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 13:48:24 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:42922 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732681AbfFYRsY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 13:48:24 -0400
Received: by mail-ed1-f67.google.com with SMTP id z25so28340078edq.9
        for <stable@vger.kernel.org>; Tue, 25 Jun 2019 10:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VCVcHSR4atmpqHJM5ACHhJUqIbZv+lRbv1agzqzhhqo=;
        b=iT8Ck+R95NyNhM27UXJRdQmCLDcoXUZGoSpVdfLnhEeJx9mmq4eR5eynmacrsd4XEh
         swzvM4JbltB+VOCWZx0RAQM8pKJjuj0vs3QC1XBTRiTgShWlkhgp1q2rJR9OppxEKiPC
         sB471ohNZnsm4b73+btIXCxqRJOwy/P4QK1pkcg7N6evUm4A8dpjQd3aTVWXnLS6N+A2
         l5Y2BSXCwMh41tfbIl1bHxf2Bd+HINT+NmhI6LWO36qdwkxMOlZl9xZwyXAOPitjjYkS
         BewgnaNY/8zEP3w7BYcShHSu1ONrw45xfYlrEWPpaeusk/uoq5Rv8iCoGlm/GRYMxkif
         WKEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VCVcHSR4atmpqHJM5ACHhJUqIbZv+lRbv1agzqzhhqo=;
        b=EkPEoBGWEuyNxmD4iawvICgcg2qbunUexHe/qmMyPtI9OrioGTEAKSgfa/NW05zRHq
         xRNpt/czo6H20ia9/c9ayWyZo2t1istOUgpJfzJqMdioUJaaAZDxuR+N3AwPMMjpNxvj
         rKp+VLYxrejY/0tqf/Kk2ZeS+WasoxFAYTqfv/pbVLr4JyJjLUo7odtjy6cgHnjBOues
         35oH2/vzpI4gyhC/KppU1I9XTz3cJjViahhjFzLb8dun55RIsB4Je/Q/KOG8/bCiAY8a
         /CVNMygdJaSirt+XAdg+/72RoYJhuKnAJeW6ebfMg7tQo5dOG5t4PLBUu8TdwrXjE8U8
         8oMQ==
X-Gm-Message-State: APjAAAX9eJ0ctwtTe/fREDQ57FU9X1Li9YDaMdthbTGMNaRNk5lCImxi
        gI9LbcueILk06VFH3JhauDU=
X-Google-Smtp-Source: APXvYqzkVsBWUlO6OQPVblkZfpK4FGJHEfOlOK5bhvPp0zDL6jyj4dkjIfm/K/T9BLrzSg6zag4tfA==
X-Received: by 2002:a50:9729:: with SMTP id c38mr150463777edb.283.1561484901981;
        Tue, 25 Jun 2019 10:48:21 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f9:2b:2b15::2])
        by smtp.gmail.com with ESMTPSA id s27sm5006453eda.36.2019.06.25.10.48.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 10:48:21 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>,
        Qian Cai <cai@lca.pw>, Dave Martin <Dave.Martin@arm.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 4.19 and 5.1] arm64: Don't unconditionally add -Wno-psabi to KBUILD_CFLAGS
Date:   Tue, 25 Jun 2019 10:45:13 -0700
Message-Id: <20190625174512.117846-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit fa63da2ab046b885a7f70291aafc4e8ce015429b upstream.

This is a GCC only option, which warns about ABI changes within GCC, so
unconditionally adding it breaks Clang with tons of:

warning: unknown warning option '-Wno-psabi' [-Wunknown-warning-option]

and link time failures:

ld.lld: error: undefined symbol: __efistub___stack_chk_guard
>>> referenced by arm-stub.c:73
(/home/nathan/cbl/linux/drivers/firmware/efi/libstub/arm-stub.c:73)
>>>               arm-stub.stub.o:(__efistub_install_memreserve_table)
in archive ./drivers/firmware/efi/libstub/lib.a

These failures come from the lack of -fno-stack-protector, which is
added via cc-option in drivers/firmware/efi/libstub/Makefile. When an
unknown flag is added to KBUILD_CFLAGS, clang will noisily warn that it
is ignoring the option like above, unlike gcc, who will just error.

$ echo "int main() { return 0; }" > tmp.c

$ clang -Wno-psabi tmp.c; echo $?
warning: unknown warning option '-Wno-psabi' [-Wunknown-warning-option]
1 warning generated.
0

$ gcc -Wsometimes-uninitialized tmp.c; echo $?
gcc: error: unrecognized command line option
‘-Wsometimes-uninitialized’; did you mean ‘-Wmaybe-uninitialized’?
1

For cc-option to work properly with clang and behave like gcc, -Werror
is needed, which was done in commit c3f0d0bc5b01 ("kbuild, LLVMLinux:
Add -Werror to cc-option to support clang").

$ clang -Werror -Wno-psabi tmp.c; echo $?
error: unknown warning option '-Wno-psabi'
[-Werror,-Wunknown-warning-option]
1

As a consequence of this, when an unknown flag is unconditionally added
to KBUILD_CFLAGS, it will cause cc-option to always fail and those flags
will never get added:

$ clang -Werror -Wno-psabi -fno-stack-protector tmp.c; echo $?
error: unknown warning option '-Wno-psabi'
[-Werror,-Wunknown-warning-option]
1

This can be seen when compiling the whole kernel as some warnings that
are normally disabled (see below) show up. The full list of flags
missing from drivers/firmware/efi/libstub are the following (gathered
from diffing .arm64-stub.o.cmd):

-fno-delete-null-pointer-checks
-Wno-address-of-packed-member
-Wframe-larger-than=2048
-Wno-unused-const-variable
-fno-strict-overflow
-fno-merge-all-constants
-fno-stack-check
-Werror=date-time
-Werror=incompatible-pointer-types
-ffreestanding
-fno-stack-protector

Use cc-disable-warning so that it gets disabled for GCC and does nothing
for Clang.

Fixes: ebcc5928c5d9 ("arm64: Silence gcc warnings about arch ABI drift")
Link: https://github.com/ClangBuiltLinux/linux/issues/511
Reported-by: Qian Cai <cai@lca.pw>
Acked-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---

Hi Greg and Sasha,

Please apply this to 4.19 and 5.1, as the Fixes commit breaks clang on arm64.

https://travis-ci.com/ClangBuiltLinux/continuous-integration/jobs/210718446

Sorry for not catching the review email with the patch that this fixes,
I had hoped that the fixes tag would be enough since the other patch
wasn't marked for stable.

 arch/arm64/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index c12ff63265a9..5d8787f0ca5f 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -51,7 +51,7 @@ endif
 
 KBUILD_CFLAGS	+= -mgeneral-regs-only $(lseinstr) $(brokengasinst)
 KBUILD_CFLAGS	+= -fno-asynchronous-unwind-tables
-KBUILD_CFLAGS	+= -Wno-psabi
+KBUILD_CFLAGS	+= $(call cc-disable-warning, psabi)
 KBUILD_AFLAGS	+= $(lseinstr) $(brokengasinst)
 
 KBUILD_CFLAGS	+= $(call cc-option,-mabi=lp64)
-- 
2.22.0

