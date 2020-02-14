Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C98315F056
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388487AbgBNP6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:58:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:41764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388482AbgBNP6I (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:58:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E07B92067D;
        Fri, 14 Feb 2020 15:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695887;
        bh=xR3TCnZhgPJN93bqdEvo5BwP1dB3RHfGLzJ+ceAVSPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QdGbRARwlHd1jlWBS01D3BIaqFEoptpoZJfMdbdVrj5KtQMSHCF7rtHQRH5MEJlpB
         6F7YUmm27ENt9/qdN1CR/ESVJRRnbx6iD2rPEG8gnbw5u3Go0JfPb4ZCSblhoKRKad
         iAPIEWSUVBmjGeISIRmG3l8pZJlXsDReUrZTTqYU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shile Zhang <shile.zhang@linux.alibaba.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 431/542] objtool: Fix ARCH=x86_64 build error
Date:   Fri, 14 Feb 2020 10:47:03 -0500
Message-Id: <20200214154854.6746-431-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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

