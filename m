Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 468308DA8B
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730740AbfHNRMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:12:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:36342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730742AbfHNRMa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:12:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A70F2084D;
        Wed, 14 Aug 2019 17:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802748;
        bh=o4LAQK483Q6DdzmPzHeYVkEq9+wOBvdyI/oGyKuoIJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oWuKlmy9RfohKf+3JD3DRt5DHTmffDBXcMISNjuR2fF+95foCsnGai3xMO7RPpe6p
         mnWYx8GzL56KdOMuNz3t9CUdId/ALExLSiTJtAWU6XGIIPDCTODSs852AaR9b3u3Jf
         YHhrYeMjgiR6uZtca6SfHLEHcsfyqS0OrXj8OwD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Alan Modra <amodra@gmail.com>,
        Jordan Rupprect <rupprecht@google.com>,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 4.14 11/69] lkdtm: support llvm-objcopy
Date:   Wed, 14 Aug 2019 19:01:09 +0200
Message-Id: <20190814165746.249357318@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
References: <20190814165744.822314328@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

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
 drivers/misc/Makefile |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

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


