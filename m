Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC3068A926
	for <lists+stable@lfdr.de>; Mon, 12 Aug 2019 23:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbfHLVR4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Aug 2019 17:17:56 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:42483 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbfHLVR4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Aug 2019 17:17:56 -0400
Received: by mail-pl1-f201.google.com with SMTP id x1so19314086plm.9
        for <stable@vger.kernel.org>; Mon, 12 Aug 2019 14:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=YTDGC6oAA/dTzgXBrTYj01WvG2SerqNpZqjkel+Et1E=;
        b=kJiV4Lw4QO9Q0JpAHWuuiG5fSTYnUMJQjMqJpMivZ+TP/kX/tpuILtZzbdDxWpFMTc
         BNwr7B5+0E36xZgzrS7yBmwWf1AMf0LCIynPY/GT25YIAKE7BReWsAQ7wT7r+FqUYUVa
         JkUArmrL5O5cHp9hjEVxcHsrYlefJmlO9Qxp6vKyJ73XqrgUW4MoSi3zUw4HpNUhS89m
         6eeyGbNCZpOOLYC+M3U0seHB3Yk8hD4k12X+8O3IUaYPeOApzQccRT0N/2Ub2A4xdWNl
         n0fSfYFILO/5bAwW/o1KPzBBGn7Bmuhgb5+BVLvuWgPZDhjw6JrbBCvA/X12VHE7BcuX
         sqXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=YTDGC6oAA/dTzgXBrTYj01WvG2SerqNpZqjkel+Et1E=;
        b=J8gU4uL78Pen9t06YaEwqdmFUwJAPliyFgf8pPbOEbWv62KNll/jodqFokjpPkGeOW
         UFdA7xZw606QPc3LVnPXrCkTDsx3jzYFcWYgsSiLVMXdoyNL1Y6zfUFBxhC9U9gswuE5
         2To5Zc3fp/5femsVW2fsz3Xk9hp5VnLJODxz+F0O2EFMgTlTmED2JKpuz+ZX/92rFfT8
         Iz/z786knknNp+Nn0Fe9YTa0mqYmcq++QMIeqC7UR6fF6CwK6OU/InRDsweFWBwwbxRG
         WBPBUb2Ty6HFJGaSx86s8fMjZ4qqD54Z5A1mH/c60WAoW7CNL2+PfnLlPOLlR3YQfdbM
         2BEA==
X-Gm-Message-State: APjAAAWS06mZaUd6HERiXS/6KwNmJfaERw5ghHgnCSCX40kzrXnkoXnw
        dZBeNOVPQyaQfM4a2SrVw8BWcC1HaJ2hEoPVdeM0yWBDYc9WLdR9diX3Y3UoSHgtU4SgxiBQYca
        CD+CEyej6EegbrwhmaDZcSlwBl4CTv9PGW1hwnHzj2W54e2GYtsKZ+v13aLBzmZbS7iyT1v/6AV
        I2CA==
X-Google-Smtp-Source: APXvYqzXsbEq5Hpn58bGBgMM1wbNU8eVbWXoRWZ/H6v5OtO2CJlBBg7swUvb6uOExop/BkXI0wxhsqfZyxNh4uVFtjM=
X-Received: by 2002:a65:4808:: with SMTP id h8mr14748082pgs.22.1565644675027;
 Mon, 12 Aug 2019 14:17:55 -0700 (PDT)
Date:   Mon, 12 Aug 2019 14:17:50 -0700
Message-Id: <20190812211750.61025-1-ndesaulniers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [4.14 PATCH] lkdtm: support llvm-objcopy
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     stable@vger.kernel.org
Cc:     pcc@google.com, Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Alan Modra <amodra@gmail.com>,
        Jordan Rupprect <rupprecht@google.com>,
        Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit e9e08a07385e08f1a7f85c5d1e345c21c9564963 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
This backport is for 4.14.  It should allow us to use llvm-objcopy for
RELR relocations on arm64 in Android.

 drivers/misc/Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index ad0e64fdba34..76f6a4f628b3 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -69,8 +69,7 @@ KCOV_INSTRUMENT_lkdtm_rodata.o	:= n
 
 OBJCOPYFLAGS :=
 OBJCOPYFLAGS_lkdtm_rodata_objcopy.o := \
-			--set-section-flags .text=alloc,readonly \
-			--rename-section .text=.rodata
+	--rename-section .text=.rodata,alloc,readonly,load
 targets += lkdtm_rodata.o lkdtm_rodata_objcopy.o
 $(obj)/lkdtm_rodata_objcopy.o: $(obj)/lkdtm_rodata.o FORCE
 	$(call if_changed,objcopy)
-- 
2.23.0.rc1.153.gdeed80330f-goog

