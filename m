Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9EE1AEE87
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 16:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgDRONN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 10:13:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726684AbgDROJr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 10:09:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A1E222202;
        Sat, 18 Apr 2020 14:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587218987;
        bh=hKu1vyMhVps1OAxX7R7Qf9/Zz7vCtRx4wUv23ATE3PU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XF7/aIlz3HB3AwNiH1Jo1ZjibgbDZGa4gDOaZFI+dZKUV4h+Tg45M6PnByfOqSXlP
         4ZLaXpSpDez8lsfaD2bVKpwwZGpoQN8PxCoKf4mD63FavLDa/AL+2wm44gbTQvwUxe
         NgpUUuIgdigAvGkM0txU1DvWKfXjLrtXrLw0/sEM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Ingo Molnar <mingo@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 29/75] lib/raid6/test: fix build on distros whose /bin/sh is not bash
Date:   Sat, 18 Apr 2020 10:08:24 -0400
Message-Id: <20200418140910.8280-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418140910.8280-1-sashal@kernel.org>
References: <20200418140910.8280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 06bd48b6cd97ef3889b68c8e09014d81dbc463f1 ]

You can build a user-space test program for the raid6 library code,
like this:

  $ cd lib/raid6/test
  $ make

The command in $(shell ...) function is evaluated by /bin/sh by default.
(or, you can specify the shell by passing SHELL=<shell> from command line)

Currently '>&/dev/null' is used to sink both stdout and stderr. Because
this code is bash-ism, it only works when /bin/sh is a symbolic link to
bash (this is the case on RHEL etc.)

This does not work on Ubuntu where /bin/sh is a symbolic link to dash.

I see lots of

  /bin/sh: 1: Syntax error: Bad fd number

and

  warning "your version of binutils lacks ... support"

Replace it with portable '>/dev/null 2>&1'.

Fixes: 4f8c55c5ad49 ("lib/raid6: build proper files on corresponding arch")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/raid6/test/Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/raid6/test/Makefile b/lib/raid6/test/Makefile
index 3ab8720aa2f84..b9e6c3648be1a 100644
--- a/lib/raid6/test/Makefile
+++ b/lib/raid6/test/Makefile
@@ -35,13 +35,13 @@ endif
 ifeq ($(IS_X86),yes)
         OBJS   += mmx.o sse1.o sse2.o avx2.o recov_ssse3.o recov_avx2.o avx512.o recov_avx512.o
         CFLAGS += $(shell echo "pshufb %xmm0, %xmm0" |		\
-                    gcc -c -x assembler - >&/dev/null &&	\
+                    gcc -c -x assembler - >/dev/null 2>&1 &&	\
                     rm ./-.o && echo -DCONFIG_AS_SSSE3=1)
         CFLAGS += $(shell echo "vpbroadcastb %xmm0, %ymm1" |	\
-                    gcc -c -x assembler - >&/dev/null &&	\
+                    gcc -c -x assembler - >/dev/null 2>&1 &&	\
                     rm ./-.o && echo -DCONFIG_AS_AVX2=1)
 	CFLAGS += $(shell echo "vpmovm2b %k1, %zmm5" |          \
-		    gcc -c -x assembler - >&/dev/null &&        \
+		    gcc -c -x assembler - >/dev/null 2>&1 &&	\
 		    rm ./-.o && echo -DCONFIG_AS_AVX512=1)
 else ifeq ($(HAS_NEON),yes)
         OBJS   += neon.o neon1.o neon2.o neon4.o neon8.o recov_neon.o recov_neon_inner.o
-- 
2.20.1

