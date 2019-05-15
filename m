Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC4BD1F3E7
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbfEOLBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:01:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727777AbfEOLBt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:01:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FFEF216FD;
        Wed, 15 May 2019 11:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918107;
        bh=8Bme5CuIVeVhsYQB06m1v7G/HdEA8uFBsr1qPwhGLbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tyDknCVt8BtQtUghfX/s0Qj8cOaPhPSPbhrKRWBOPpKh8zsWCwOaV8rr6LweXad/3
         EFj1okp8ogc5ACvXAxnFiWq7vBj0EkrAyidFTa8JnxQ/a+q/W/MELB0ffQxBIV43yG
         ssztrwOmx3qWq+zq+xCJA5sMzqntwoLNPWqnDpNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH 4.4 001/266] kbuild: simplify ld-option implementation
Date:   Wed, 15 May 2019 12:51:48 +0200
Message-Id: <20190515090722.742861405@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

commit 0294e6f4a0006856e1f36b8cd8fa088d9e499e98 upstream.

Currently, linker options are tested by the coordination of $(CC) and
$(LD) because $(LD) needs some object to link.

As commit 86a9df597cdd ("kbuild: fix linker feature test macros when
cross compiling with Clang") addressed, we need to make sure $(CC)
and $(LD) agree the underlying architecture of the passed object.

This could be a bit complex when we combine tools from different groups.
For example, we can use clang for $(CC), but we still need to rely on
GCC toolchain for $(LD).

So, I was searching for a way of standalone testing of linker options.
A trick I found is to use '-v'; this not only prints the version string,
but also tests if the given option is recognized.

If a given option is supported,

  $ aarch64-linux-gnu-ld -v --fix-cortex-a53-843419
  GNU ld (Linaro_Binutils-2017.11) 2.28.2.20170706
  $ echo $?
  0

If unsupported,

  $ aarch64-linux-gnu-ld -v --fix-cortex-a53-843419
  GNU ld (crosstool-NG linaro-1.13.1-4.7-2013.04-20130415 - Linaro GCC 2013.04) 2.23.1
  aarch64-linux-gnu-ld: unrecognized option '--fix-cortex-a53-843419'
  aarch64-linux-gnu-ld: use the --help option for usage information
  $ echo $?
  1

Gold works likewise.

  $ aarch64-linux-gnu-ld.gold -v --fix-cortex-a53-843419
  GNU gold (Linaro_Binutils-2017.11 2.28.2.20170706) 1.14
  masahiro@pug:~/ref/linux$ echo $?
  0
  $ aarch64-linux-gnu-ld.gold -v --fix-cortex-a53-999999
  GNU gold (Linaro_Binutils-2017.11 2.28.2.20170706) 1.14
  aarch64-linux-gnu-ld.gold: --fix-cortex-a53-999999: unknown option
  aarch64-linux-gnu-ld.gold: use the --help option for usage information
  $ echo $?
  1

LLD too.

  $ ld.lld -v --gc-sections
  LLD 7.0.0 (http://llvm.org/git/lld.git 4a0e4190e74cea19f8a8dc625ccaebdf8b5d1585) (compatible with GNU linkers)
  $ echo $?
  0
  $ ld.lld -v --fix-cortex-a53-843419
  LLD 7.0.0 (http://llvm.org/git/lld.git 4a0e4190e74cea19f8a8dc625ccaebdf8b5d1585) (compatible with GNU linkers)
  $ echo $?
  0
  $ ld.lld -v --fix-cortex-a53-999999
  ld.lld: error: unknown argument: --fix-cortex-a53-999999
  LLD 7.0.0 (http://llvm.org/git/lld.git 4a0e4190e74cea19f8a8dc625ccaebdf8b5d1585) (compatible with GNU linkers)
  $ echo $?
  1

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
[nc: try-run-cached was added later, just use try-run, which is the
     current mainline state]
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/Kbuild.include |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -156,9 +156,7 @@ cc-ldoption = $(call try-run,\
 
 # ld-option
 # Usage: LDFLAGS += $(call ld-option, -X)
-ld-option = $(call try-run,\
-	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -x c /dev/null -c -o "$$TMPO"; \
-	$(LD) $(LDFLAGS) $(1) "$$TMPO" -o "$$TMP",$(1),$(2))
+ld-option = $(call try-run, $(LD) $(LDFLAGS) $(1) -v,$(1),$(2))
 
 # ar-option
 # Usage: KBUILD_ARFLAGS := $(call ar-option,D)


