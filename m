Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 358AC411B5F
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245512AbhITQ56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:57:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237226AbhITQz6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:55:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABF916139F;
        Mon, 20 Sep 2021 16:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156665;
        bh=B5Yzeoee29PRAotFD0SAuZNvKzUzhZ9AqeuINJp0T8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dSFycneVLLiE30uadDU6Er1+Lydhhw+pEiSh5372I5yVt+7MZ6g8ZsJyZ+WsaILVi
         o6ZzeZb6bmV8Kxq5dbQXtBdQx7+P4bW+rJ+3KPRL5JXtAghGWPkYmC5sjYZf040gDG
         94Q4hrLcy283J+LX14MNPJ8rnVzNlcoY8b88TehA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fangrui Song <maskray@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.9 029/175] powerpc/boot: Delete unneeded .globl _zimage_start
Date:   Mon, 20 Sep 2021 18:41:18 +0200
Message-Id: <20210920163919.020491465@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fangrui Song <maskray@google.com>

commit 968339fad422a58312f67718691b717dac45c399 upstream.

.globl sets the symbol binding to STB_GLOBAL while .weak sets the
binding to STB_WEAK. GNU as let .weak override .globl since
binutils-gdb 5ca547dc2399a0a5d9f20626d4bf5547c3ccfddd (1996). Clang
integrated assembler let the last win but it may error in the future.

Since it is a convention that only one binding directive is used, just
delete .globl.

Fixes: ee9d21b3b358 ("powerpc/boot: Ensure _zimage_start is a weak symbol")
Signed-off-by: Fangrui Song <maskray@google.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200325164257.170229-1-maskray@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/boot/crt0.S |    3 ---
 1 file changed, 3 deletions(-)

--- a/arch/powerpc/boot/crt0.S
+++ b/arch/powerpc/boot/crt0.S
@@ -49,9 +49,6 @@ p_end:		.long	_end
 p_pstack:	.long	_platform_stack_top
 #endif
 
-	.globl	_zimage_start
-	/* Clang appears to require the .weak directive to be after the symbol
-	 * is defined. See https://bugs.llvm.org/show_bug.cgi?id=38921  */
 	.weak	_zimage_start
 _zimage_start:
 	.globl	_zimage_start_lib


