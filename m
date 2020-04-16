Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974221AC2A9
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896353AbgDPNbD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:31:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896341AbgDPNbA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:31:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CCCF206E9;
        Thu, 16 Apr 2020 13:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043859;
        bh=K+uM9txe6RidWvLhVcS9tv/Lh4YLAQQ5NMzlaOE6ScA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2q9eH2Zx+6fXmtRiSHscY0mP79Uv3vBqvloetqb/KMEy9ZGnVzpT5I3obwgWtrqyX
         3nZilUpgR9uny2DXCycY/qNaIX/3zwqwqoFUlRvyPO0u2B97xW/b6YZqc69w5jf/ld
         lfOBoXnqoJ5MGVkX0pN7yyyZZ3nWQu0ijEl5KGf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH 4.19 130/146] powerpc: Add attributes for setjmp/longjmp
Date:   Thu, 16 Apr 2020 15:24:31 +0200
Message-Id: <20200416131300.249950161@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Segher Boessenkool <segher@kernel.crashing.org>

commit aa497d4352414aad22e792b35d0aaaa12bbc37c5 upstream.

The setjmp function should be declared as "returns_twice", or bad
things can happen[1]. This does not actually change generated code in
my testing.

The longjmp function should be declared as "noreturn", so that the
compiler can optimise calls to it better. This makes the generated
code a little shorter.

1: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-returns_005ftwice-function-attribute

Signed-off-by: Segher Boessenkool <segher@kernel.crashing.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/c02ce4a573f3bac907e2c70957a2d1275f910013.1567605586.git.segher@kernel.crashing.org
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/setjmp.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/include/asm/setjmp.h
+++ b/arch/powerpc/include/asm/setjmp.h
@@ -12,7 +12,7 @@
 
 #define JMP_BUF_LEN    23
 
-extern long setjmp(long *);
-extern void longjmp(long *, long);
+extern long setjmp(long *) __attribute__((returns_twice));
+extern void longjmp(long *, long) __attribute__((noreturn));
 
 #endif /* _ASM_POWERPC_SETJMP_H */


