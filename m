Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03BBC1F9BF
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 20:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbfEOSMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 14:12:09 -0400
Received: from mail-ua1-f73.google.com ([209.85.222.73]:40281 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726542AbfEOSMJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 14:12:09 -0400
Received: by mail-ua1-f73.google.com with SMTP id y11so111223uao.7
        for <stable@vger.kernel.org>; Wed, 15 May 2019 11:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=TsrtDCxLgBw9RKBxYE41J6q+FXg1qTdj4Dyi9lHEXsk=;
        b=dYlMMzmtn5zBZcth8om9HrNEbq8riNFTIgSkmU8LOzggMd5YqOlHgQHgGi0vt7W3eE
         Xo2wfwSvoyCP+pgTIKmI07gke+DxeODeXJR5u8FuZOlneblT2ynBXj0FVHAv/U0KPUQI
         utdnHZHLA2AzYCQAxC+x5fRnbhCxqxWEI8AaL/xbLUx53+Dbq2peX0Pn2DVfUbmCY0J1
         iOOBCrM6Fq4FkQtA1xWJuvpcHb8UQ2Tb/sz/WTuqiRfncpaNhUC62K6+58bXvSSXp3oP
         obIDjNuer380gyYopqYPqooTDvTnZAVV7FGdohHR5jSF+7j6eZVV9825oXakK+B5rLnY
         i/ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TsrtDCxLgBw9RKBxYE41J6q+FXg1qTdj4Dyi9lHEXsk=;
        b=pY67YwNsjPkUNuEdnFVaF4mZKnmhBKapOx+SeMOtpIAhKZP693jlpRv+5n6rxEmBxs
         PJHDrCyuqObqipP9iwHRwU/PVFydKadPi+p+oXFjUxZiaCL5IYY1Y5peo6IlMKIbaDl7
         mSBJaUv2YVRM+biuGsSKB/Bq3tn2r/bO5/3lUyHmcqqHCIAItn3Qnp6fEppvVXEEjWN3
         n55laTBEk7Dgrximc/rhWm1h7HqtnS0qIC/DPb9SV0xqHKsF7OeKHArgnMQheLJiGPUm
         xDRlH6Cnbg5tkHi3avug0NGQtrPo2EbhOh8sBwZBBK7PAvnvS8S2ZuaTBAflX0uigSJC
         JdZg==
X-Gm-Message-State: APjAAAVhHaHa19jTDT+jBXS3dEXm6KYU+yTadURy7raxyMkEBjUeDdA2
        E+Orqx/eiGCIJAZbQnE4Xdzz1rAIX5m83v19en0=
X-Google-Smtp-Source: APXvYqxmOc14hOvDMcIjowy8IIjpvMfGWzNKzXs81+MpLnt343bNQ7S+fSLKYLdqpBa9npEvKE6SP5rwXzP/IYjKR50=
X-Received: by 2002:a1f:2915:: with SMTP id p21mr19824190vkp.52.1557943928564;
 Wed, 15 May 2019 11:12:08 -0700 (PDT)
Date:   Wed, 15 May 2019 11:12:04 -0700
In-Reply-To: <CAKwvOdk_KmyT4yZOz8iczxeP7mYq-h5LmjzkE5yhsodupRLxEQ@mail.gmail.com>
Message-Id: <20190515181204.20859-1-ndesaulniers@google.com>
Mime-Version: 1.0
References: <CAKwvOdk_KmyT4yZOz8iczxeP7mYq-h5LmjzkE5yhsodupRLxEQ@mail.gmail.com>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH v2] lkdtm: support llvm-objcopy
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     gregkh@linuxfoundation.org
Cc:     clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org, Nathan Chancellor <nathanchance@gmail.com>,
        Alan Modra <amodra@gmail.com>,
        Jordan Rupprect <rupprecht@google.com>,
        Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With CONFIG_LKDTM=y and make OBJCOPY=llvm-objcopy, llvm-objcopy errors:
llvm-objcopy: error: --set-section-flags=.text conflicts with
--rename-section=.text=.rodata

Rather than support setting flags then renaming sections vs renaming
then setting flags, it's simpler to just change both at the same time
via --rename-section. Adding the load flag is required for GNU objcopy
to mark .rodata Type as PROGBITS after the rename.

This can be verified with:
$ readelf -S drivers/misc/lkdtm/rodata_objcopy.o
...
Section Headers:
  [Nr] Name              Type             Address           Offset
       Size              EntSize          Flags  Link  Info  Align
...
  [ 1] .rodata           PROGBITS         0000000000000000  00000040
       0000000000000004  0000000000000000   A       0     0     4
...

Which shows that .text is now renamed .rodata, the alloc flag A is set,
the type is PROGBITS, and the section is not flagged as writeable W.

Cc: stable@vger.kernel.org
Link: https://sourceware.org/bugzilla/show_bug.cgi?id=24554
Link: https://github.com/ClangBuiltLinux/linux/issues/448
Reported-by: Nathan Chancellor <nathanchance@gmail.com>
Suggested-by: Alan Modra <amodra@gmail.com>
Suggested-by: Jordan Rupprect <rupprecht@google.com>
Suggested-by: Kees Cook <keescook@chromium.org>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
Changes from v1 -> v2:
* add load flag, as per Kees and Alan.
* update commit message to mention reason for load flag.
* add Kees' and Alan's suggested by.
* carry Kees' Ack.
* cc stable.

 drivers/misc/lkdtm/Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/misc/lkdtm/Makefile b/drivers/misc/lkdtm/Makefile
index 951c984de61a..fb10eafe9bde 100644
--- a/drivers/misc/lkdtm/Makefile
+++ b/drivers/misc/lkdtm/Makefile
@@ -15,8 +15,7 @@ KCOV_INSTRUMENT_rodata.o	:= n
 
 OBJCOPYFLAGS :=
 OBJCOPYFLAGS_rodata_objcopy.o	:= \
-			--set-section-flags .text=alloc,readonly \
-			--rename-section .text=.rodata
+			--rename-section .text=.rodata,alloc,readonly,load
 targets += rodata.o rodata_objcopy.o
 $(obj)/rodata_objcopy.o: $(obj)/rodata.o FORCE
 	$(call if_changed,objcopy)
-- 
2.21.0.1020.gf2820cf01a-goog

