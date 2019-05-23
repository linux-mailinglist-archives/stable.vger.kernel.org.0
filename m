Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E896A288FD
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392060AbfEWTaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:30:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392055AbfEWTaH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:30:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71B8D21851;
        Thu, 23 May 2019 19:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639806;
        bh=GoC1OIA003h0+CxziUkA4dOZlYYlol8sXKPimKJOX4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=psNzxiYDFSBT2+MSOpUk9V5jMHtkNmMOTANTTingvpE5EO/2hT35ifEk5hSmPDTTf
         R2QMcaPL6+SUJyNMy3UAOxP7isOfuHQCcwqS9r4Suu+MmfK438z+R8YfqhdBSpLsRO
         AdpkBxCRrm1fdaBHRRXsMMJh/JX3f6J5fJdJX7+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Mukesh Ojha <mojha@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.1 083/122] objtool: Allow AR to be overridden with HOSTAR
Date:   Thu, 23 May 2019 21:06:45 +0200
Message-Id: <20190523181715.854897254@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

commit 8ea58f1e8b11cca3087b294779bf5959bf89cc10 upstream.

Currently, this Makefile hardcodes GNU ar, meaning that if it is not
available, there is no way to supply a different one and the build will
fail.

  $ make AR=llvm-ar CC=clang LD=ld.lld HOSTAR=llvm-ar HOSTCC=clang \
         HOSTLD=ld.lld HOSTLDFLAGS=-fuse-ld=lld defconfig modules_prepare
  ...
    AR       /out/tools/objtool/libsubcmd.a
  /bin/sh: 1: ar: not found
  ...

Follow the logic of HOST{CC,LD} and allow the user to specify a
different ar tool via HOSTAR (which is used elsewhere in other
tools/ Makefiles).

Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
Cc: <stable@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/80822a9353926c38fd7a152991c6292491a9d0e8.1558028966.git.jpoimboe@redhat.com
Link: https://github.com/ClangBuiltLinux/linux/issues/481
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/objtool/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/objtool/Makefile
+++ b/tools/objtool/Makefile
@@ -7,11 +7,12 @@ ARCH := x86
 endif
 
 # always use the host compiler
+HOSTAR	?= ar
 HOSTCC	?= gcc
 HOSTLD	?= ld
+AR	 = $(HOSTAR)
 CC	 = $(HOSTCC)
 LD	 = $(HOSTLD)
-AR	 = ar
 
 ifeq ($(srctree),)
 srctree := $(patsubst %/,%,$(dir $(CURDIR)))


