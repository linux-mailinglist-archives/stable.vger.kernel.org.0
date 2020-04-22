Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB331B412D
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbgDVKuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:50:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729249AbgDVKLu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:11:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97A4E20575;
        Wed, 22 Apr 2020 10:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550310;
        bh=K+uM9txe6RidWvLhVcS9tv/Lh4YLAQQ5NMzlaOE6ScA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KQ8fAOJg6QvB6URFijN+bAzNmBbL5gXxqRsXhE32CHuwIjVNwahFCDw/apWYsxpIj
         iAVrmQDGGLWibJXqM8+fx40N8/sO5za+0HwqWmiJUC6P50xdTVTV7QAGnqqYa0778E
         glcov3ToddPTntd5L2F92+rWaw75Awd8t1nNfFhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH 4.14 093/199] powerpc: Add attributes for setjmp/longjmp
Date:   Wed, 22 Apr 2020 11:56:59 +0200
Message-Id: <20200422095107.377311816@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095057.806111593@linuxfoundation.org>
References: <20200422095057.806111593@linuxfoundation.org>
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


