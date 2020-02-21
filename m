Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2A611671F8
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729797AbgBUH66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:58:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:58870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730694AbgBUH64 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:58:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A6F72073A;
        Fri, 21 Feb 2020 07:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271935;
        bh=xR3TCnZhgPJN93bqdEvo5BwP1dB3RHfGLzJ+ceAVSPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1emjY1Bw7EC4L7zXsgaGtCEoXj9KtsD5GjtIPLkvqy1pEEPKwVK37Rt4CO3Va3A03
         lHmwkiKO684uo0jr3Y9mRhGZeqJ/VGThLgivZY5PtcEJBawgANPSpt9ltVd7MGwu7W
         aFt6Mb9JWPdOW9PhCtzhnVQFaygHLjCwf3UO8BGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shile Zhang <shile.zhang@linux.alibaba.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 317/399] objtool: Fix ARCH=x86_64 build error
Date:   Fri, 21 Feb 2020 08:40:42 +0100
Message-Id: <20200221072432.218300175@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shile Zhang <shile.zhang@linux.alibaba.com>

[ Upstream commit 8580bed7e751e6d4f17881e059daf3cb37ba4717 ]

Building objtool with ARCH=x86_64 fails with:

   $make ARCH=x86_64 -C tools/objtool
   ...
     CC       arch/x86/decode.o
   arch/x86/decode.c:10:22: fatal error: asm/insn.h: No such file or directory
    #include <asm/insn.h>
                         ^
   compilation terminated.
   mv: cannot stat ‘arch/x86/.decode.o.tmp’: No such file or directory
   make[2]: *** [arch/x86/decode.o] Error 1
   ...

The root cause is that the command-line variable 'ARCH' cannot be
overridden.  It can be replaced by 'SRCARCH', which is defined in
'tools/scripts/Makefile.arch'.

Signed-off-by: Shile Zhang <shile.zhang@linux.alibaba.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Link: https://lore.kernel.org/r/d5d11370ae116df6c653493acd300ec3d7f5e925.1579543924.git.jpoimboe@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/Makefile | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
index d2a19b0bc05aa..ee08aeff30a19 100644
--- a/tools/objtool/Makefile
+++ b/tools/objtool/Makefile
@@ -2,10 +2,6 @@
 include ../scripts/Makefile.include
 include ../scripts/Makefile.arch
 
-ifeq ($(ARCH),x86_64)
-ARCH := x86
-endif
-
 # always use the host compiler
 HOSTAR	?= ar
 HOSTCC	?= gcc
@@ -33,7 +29,7 @@ all: $(OBJTOOL)
 
 INCLUDES := -I$(srctree)/tools/include \
 	    -I$(srctree)/tools/arch/$(HOSTARCH)/include/uapi \
-	    -I$(srctree)/tools/arch/$(ARCH)/include
+	    -I$(srctree)/tools/arch/$(SRCARCH)/include
 WARNINGS := $(EXTRA_WARNINGS) -Wno-switch-default -Wno-switch-enum -Wno-packed
 CFLAGS   := -Werror $(WARNINGS) $(KBUILD_HOSTCFLAGS) -g $(INCLUDES) $(LIBELF_FLAGS)
 LDFLAGS  += $(LIBELF_LIBS) $(LIBSUBCMD) $(KBUILD_HOSTLDFLAGS)
-- 
2.20.1



