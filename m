Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32F471F9DF
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 20:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfEOSYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 14:24:50 -0400
Received: from mail-oi1-f201.google.com ([209.85.167.201]:49058 "EHLO
        mail-oi1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbfEOSYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 14:24:49 -0400
Received: by mail-oi1-f201.google.com with SMTP id s64so315972oia.15
        for <stable@vger.kernel.org>; Wed, 15 May 2019 11:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=N9RlwjMz1QRxFz5UTAAidlBnW72fnnEfpH4I5MZT8Og=;
        b=beu4yzHgM7U8hFeDMQJamSrdbx1zUTG5hJrkF907gvHOYtlddPWagaHORRo5BQcIbF
         N1O7KMsT1r2E8OQOMOcJcYx8L8AcMSdwZwQ9+KloSX7k5jCKb/pku9WsFNsvmk2MEeYc
         r/PuIKe5owg9FdySwwVbe+bn2d9UuAk/V3NezPDcy1I+hz7g9AwaKm6LLEFhWnuvJ2/a
         WeD5zr+wtyCr/Ly+5pgTzcCvKa4gV1ckcb84hNhvOrsPEdXxMbBg/cjtJoef07uhtfuc
         3iRI/t33KuRunBcvRaOt+SWxtRPxUdcF0H3jEEPuW0wAn4ru0Th+2ALBnBE3wEdnF3+B
         MXMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=N9RlwjMz1QRxFz5UTAAidlBnW72fnnEfpH4I5MZT8Og=;
        b=kuZ5Sa6vlnkdtbe0K/DwvaWzMYfVtmv9fPiw7Ojc3V23LruvNncl+dwrHEmN16ZRoF
         /uhpjyPhCJJ/R41lSvkRNoIpE6zy+flqyw4rJGbiAnJ9aQUEXVMKcwFmaWZhV3sHdSfl
         rkvxPQWPF+tgD8JIFMwbaXwWH+5FCnkhdcM7QPGxQeH21sXuQHBRaY0SVqv0usWiDpF4
         xubuMsPUZuB/4v1UAfevU6FA4O4jUZx0CCiipU5pj/oBk6+lrLRYPVmgqi96LdVcxIEo
         /jYE3NfN4jNduNn6bIucocqIt3bq5Tc7zPR86ZjfM5TwDxgcryz05fyswvquqtS9uZ7w
         jojg==
X-Gm-Message-State: APjAAAW1NwJdyXUIInvk6XvH03HSbE7U+rkuRgbyaL6/AtnhS26wtK05
        V7P/SMN5B3eaVl9oy+g+taZ9nUEcpdkJ+Z890w8=
X-Google-Smtp-Source: APXvYqzVQclzyTRtP1W9tjHn71J0Mfp3eIqkMMAnpSq2WT679SFy1dEQsgRSRmQFcVOmkd46xnCenxCtHMxj+6jRvaI=
X-Received: by 2002:aca:c5d7:: with SMTP id v206mr7708350oif.20.1557944689033;
 Wed, 15 May 2019 11:24:49 -0700 (PDT)
Date:   Wed, 15 May 2019 11:24:41 -0700
In-Reply-To: <20190515181909.GA11401@archlinux-i9>
Message-Id: <20190515182441.30990-1-ndesaulniers@google.com>
Mime-Version: 1.0
References: <20190515181909.GA11401@archlinux-i9>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH v3] lkdtm: support llvm-objcopy
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     gregkh@linuxfoundation.org
Cc:     clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
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
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Suggested-by: Alan Modra <amodra@gmail.com>
Suggested-by: Jordan Rupprect <rupprecht@google.com>
Suggested-by: Kees Cook <keescook@chromium.org>
Acked-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
Changes from v2 -> v3:
* correct Nathan's email address and collect his reviewed by.
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

