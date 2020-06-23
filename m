Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 583BF205D16
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388135AbgFWUIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:08:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388267AbgFWUIq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:08:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2459A2078A;
        Tue, 23 Jun 2020 20:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942925;
        bh=L1KFZWaISOlQ5fqjJgTtxsiJupoKob/Q/99kIsaoPI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ImOcdUfkyFFW5omgglbEz59xjPdwOHTiwUHh/jWo7tsnK3RX2dsmnXl0peONrnpk
         maWenPTNJ8zfymJ5meQBzD8aZmUUKLhbGrsGcwT2EKMdPnHI8H8Uyp8BRo/sonvVvt
         PrlvbLqEsnENjq+uPGR+xB5TlpDXuiCO7u2ztpTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 189/477] unicore32: do not evaluate compilers library path when cleaning
Date:   Tue, 23 Jun 2020 21:53:06 +0200
Message-Id: <20200623195416.525758805@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 081b4b54ff6c58be2ffcf09d42e5df8f031eacd0 ]

Since commit a83e4ca26af8 ("kbuild: remove cc-option switch from
-Wframe-larger-than="), 'make ARCH=unicore32 clean' emits error
messages as follows:

  $ make ARCH=unicore32 clean
  gcc: error: missing argument to '-Wframe-larger-than='
  gcc: error: missing argument to '-Wframe-larger-than='

We do not care compiler flags when cleaning.

Use the '=' operator for lazy expansion because we do not use
GNU_LIBC_A or GNU_LIBGCC_A when cleaning.

Fixes: a83e4ca26af8 ("kbuild: remove cc-option switch from -Wframe-larger-than=")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/unicore32/lib/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/unicore32/lib/Makefile b/arch/unicore32/lib/Makefile
index 098981a01841b..5af06645b8f01 100644
--- a/arch/unicore32/lib/Makefile
+++ b/arch/unicore32/lib/Makefile
@@ -10,12 +10,12 @@ lib-y	+= strncpy_from_user.o strnlen_user.o
 lib-y	+= clear_user.o copy_page.o
 lib-y	+= copy_from_user.o copy_to_user.o
 
-GNU_LIBC_A		:= $(shell $(CC) $(KBUILD_CFLAGS) -print-file-name=libc.a)
+GNU_LIBC_A		= $(shell $(CC) $(KBUILD_CFLAGS) -print-file-name=libc.a)
 GNU_LIBC_A_OBJS		:= memchr.o memcpy.o memmove.o memset.o
 GNU_LIBC_A_OBJS		+= strchr.o strrchr.o
 GNU_LIBC_A_OBJS		+= rawmemchr.o			# needed by strrchr.o
 
-GNU_LIBGCC_A		:= $(shell $(CC) $(KBUILD_CFLAGS) -print-file-name=libgcc.a)
+GNU_LIBGCC_A		= $(shell $(CC) $(KBUILD_CFLAGS) -print-file-name=libgcc.a)
 GNU_LIBGCC_A_OBJS	:= _ashldi3.o _ashrdi3.o _lshrdi3.o
 GNU_LIBGCC_A_OBJS	+= _divsi3.o _modsi3.o _ucmpdi2.o _umodsi3.o _udivsi3.o
 
-- 
2.25.1



