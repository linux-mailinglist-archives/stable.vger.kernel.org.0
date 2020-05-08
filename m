Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005621CAD97
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbgEHMt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:49:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729733AbgEHMt0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:49:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6229421582;
        Fri,  8 May 2020 12:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942165;
        bh=d4tZJ1lNOOitCep9qPpvmUw7f2lXt1ujH7SYD/ecmjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fEspxyk5CLzywM8qpB571+C8elUvLSnLy4RnbHmVIaSsN6XJ17xCDbWUgc66Bfv7A
         Q6ZdPltxFj0uEQuZyZN5/eST07V3qItW+BX7ArYxltbyn6thJ/jZ8xXKIZ3IrlyK8r
         DxyOcS9jriXpvu5QNdPBKtl7m317fMtAqECjmdyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 11/18] lib/mpi: Fix building for powerpc with clang
Date:   Fri,  8 May 2020 14:35:14 +0200
Message-Id: <20200508123033.324538586@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123030.497793118@linuxfoundation.org>
References: <20200508123030.497793118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 5990cdee689c6885b27c6d969a3d58b09002b0bc ]

0day reports over and over on an powerpc randconfig with clang:

lib/mpi/generic_mpih-mul1.c:37:13: error: invalid use of a cast in a
inline asm context requiring an l-value: remove the cast or build with
-fheinous-gnu-extensions

Remove the superfluous casts, which have been done previously for x86
and arm32 in commit dea632cadd12 ("lib/mpi: fix build with clang") and
commit 7b7c1df2883d ("lib/mpi/longlong.h: fix building with 32-bit
x86").

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://github.com/ClangBuiltLinux/linux/issues/991
Link: https://lore.kernel.org/r/20200413195041.24064-1-natechancellor@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/mpi/longlong.h | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/lib/mpi/longlong.h b/lib/mpi/longlong.h
index 0f64fcee4ccd1..8f383cca6bb1f 100644
--- a/lib/mpi/longlong.h
+++ b/lib/mpi/longlong.h
@@ -756,22 +756,22 @@ do {									\
 do { \
 	if (__builtin_constant_p(bh) && (bh) == 0) \
 		__asm__ ("{a%I4|add%I4c} %1,%3,%4\n\t{aze|addze} %0,%2" \
-		: "=r" ((USItype)(sh)), \
-		"=&r" ((USItype)(sl)) \
+		: "=r" (sh), \
+		"=&r" (sl) \
 		: "%r" ((USItype)(ah)), \
 		"%r" ((USItype)(al)), \
 		"rI" ((USItype)(bl))); \
 	else if (__builtin_constant_p(bh) && (bh) == ~(USItype) 0) \
 		__asm__ ("{a%I4|add%I4c} %1,%3,%4\n\t{ame|addme} %0,%2" \
-		: "=r" ((USItype)(sh)), \
-		"=&r" ((USItype)(sl)) \
+		: "=r" (sh), \
+		"=&r" (sl) \
 		: "%r" ((USItype)(ah)), \
 		"%r" ((USItype)(al)), \
 		"rI" ((USItype)(bl))); \
 	else \
 		__asm__ ("{a%I5|add%I5c} %1,%4,%5\n\t{ae|adde} %0,%2,%3" \
-		: "=r" ((USItype)(sh)), \
-		"=&r" ((USItype)(sl)) \
+		: "=r" (sh), \
+		"=&r" (sl) \
 		: "%r" ((USItype)(ah)), \
 		"r" ((USItype)(bh)), \
 		"%r" ((USItype)(al)), \
@@ -781,36 +781,36 @@ do { \
 do { \
 	if (__builtin_constant_p(ah) && (ah) == 0) \
 		__asm__ ("{sf%I3|subf%I3c} %1,%4,%3\n\t{sfze|subfze} %0,%2" \
-		: "=r" ((USItype)(sh)), \
-		"=&r" ((USItype)(sl)) \
+		: "=r" (sh), \
+		"=&r" (sl) \
 		: "r" ((USItype)(bh)), \
 		"rI" ((USItype)(al)), \
 		"r" ((USItype)(bl))); \
 	else if (__builtin_constant_p(ah) && (ah) == ~(USItype) 0) \
 		__asm__ ("{sf%I3|subf%I3c} %1,%4,%3\n\t{sfme|subfme} %0,%2" \
-		: "=r" ((USItype)(sh)), \
-		"=&r" ((USItype)(sl)) \
+		: "=r" (sh), \
+		"=&r" (sl) \
 		: "r" ((USItype)(bh)), \
 		"rI" ((USItype)(al)), \
 		"r" ((USItype)(bl))); \
 	else if (__builtin_constant_p(bh) && (bh) == 0) \
 		__asm__ ("{sf%I3|subf%I3c} %1,%4,%3\n\t{ame|addme} %0,%2" \
-		: "=r" ((USItype)(sh)), \
-		"=&r" ((USItype)(sl)) \
+		: "=r" (sh), \
+		"=&r" (sl) \
 		: "r" ((USItype)(ah)), \
 		"rI" ((USItype)(al)), \
 		"r" ((USItype)(bl))); \
 	else if (__builtin_constant_p(bh) && (bh) == ~(USItype) 0) \
 		__asm__ ("{sf%I3|subf%I3c} %1,%4,%3\n\t{aze|addze} %0,%2" \
-		: "=r" ((USItype)(sh)), \
-		"=&r" ((USItype)(sl)) \
+		: "=r" (sh), \
+		"=&r" (sl) \
 		: "r" ((USItype)(ah)), \
 		"rI" ((USItype)(al)), \
 		"r" ((USItype)(bl))); \
 	else \
 		__asm__ ("{sf%I4|subf%I4c} %1,%5,%4\n\t{sfe|subfe} %0,%3,%2" \
-		: "=r" ((USItype)(sh)), \
-		"=&r" ((USItype)(sl)) \
+		: "=r" (sh), \
+		"=&r" (sl) \
 		: "r" ((USItype)(ah)), \
 		"r" ((USItype)(bh)), \
 		"rI" ((USItype)(al)), \
@@ -821,7 +821,7 @@ do { \
 do { \
 	USItype __m0 = (m0), __m1 = (m1); \
 	__asm__ ("mulhwu %0,%1,%2" \
-	: "=r" ((USItype) ph) \
+	: "=r" (ph) \
 	: "%r" (__m0), \
 	"r" (__m1)); \
 	(pl) = __m0 * __m1; \
-- 
2.20.1



