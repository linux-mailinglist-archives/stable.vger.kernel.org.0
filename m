Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 518B3A0390
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 15:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfH1NoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 09:44:11 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:42121 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726614AbfH1NoL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 09:44:11 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46JRmQ3ct3z9sNm;
        Wed, 28 Aug 2019 23:44:04 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Nathan Chancellor <natechancellor@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] powerpc: Avoid clang warnings around setjmp and longjmp
In-Reply-To: <20190812023214.107817-1-natechancellor@gmail.com>
References: <20190812023214.107817-1-natechancellor@gmail.com>
Date:   Wed, 28 Aug 2019 23:43:53 +1000
Message-ID: <878srdv206.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Nathan Chancellor <natechancellor@gmail.com> writes:

> Commit aea447141c7e ("powerpc: Disable -Wbuiltin-requires-header when
> setjmp is used") disabled -Wbuiltin-requires-header because of a warning
> about the setjmp and longjmp declarations.
>
> r367387 in clang added another diagnostic around this, complaining that
> there is no jmp_buf declaration.
>
> In file included from ../arch/powerpc/xmon/xmon.c:47:
> ../arch/powerpc/include/asm/setjmp.h:10:13: error: declaration of
> built-in function 'setjmp' requires the declaration of the 'jmp_buf'
> type, commonly provided in the header <setjmp.h>.
> [-Werror,-Wincomplete-setjmp-declaration]
> extern long setjmp(long *);
>             ^
> ../arch/powerpc/include/asm/setjmp.h:11:13: error: declaration of
> built-in function 'longjmp' requires the declaration of the 'jmp_buf'
> type, commonly provided in the header <setjmp.h>.
> [-Werror,-Wincomplete-setjmp-declaration]
> extern void longjmp(long *, long);
>             ^
> 2 errors generated.
>
> Take the same approach as the above commit by disabling the warning for
> the same reason, we provide our own longjmp/setjmp function.
>
> Cc: stable@vger.kernel.org # 4.19+
> Link: https://github.com/ClangBuiltLinux/linux/issues/625
> Link: https://github.com/llvm/llvm-project/commit/3be25e79477db2d31ac46493d97eca8c20592b07
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>
> It may be worth using -fno-builtin-setjmp and -fno-builtin-longjmp
> instead as it makes it clear to clang that we are not using the builtin
> longjmp and setjmp functions, which I think is why these warnings are
> appearing (at least according to the commit that introduced this waring).
>
> Sample patch:
> https://github.com/ClangBuiltLinux/linux/issues/625#issuecomment-519251372

Couldn't we just add those flags to CFLAGS for the whole kernel? Rather
than making them per-file.

I mean there's no kernel code that wants to use clang's builtin
setjmp/longjmp implementation at all right?

cheers
