Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9AF62F14A3
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731609AbhAKN1i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:27:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:35060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732410AbhAKNQ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:16:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40662229C4;
        Mon, 11 Jan 2021 13:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370948;
        bh=RfLQlTyNULtRNfApWZNyMWopevm4HQQaPo9K0UqTnXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P7gZrc+xqwqnLiObbohGwVD7MHfADtEOLUgLZc3klDtrXzABpTQrv7htW65l5rmJx
         mcR6ZOZniXFYPHajMEflLkvYd1wTiNK7Xy6eQAu6+EOuycnHW9Sn7sIzObwnZ80QjH
         Sf5IFey9k6RbDtW3K/XQEzDv2HCA0k8rXUMOLFuU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 075/145] powerpc: Handle .text.{hot,unlikely}.* in linker script
Date:   Mon, 11 Jan 2021 14:01:39 +0100
Message-Id: <20210111130052.133907316@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

commit 3ce47d95b7346dcafd9bed3556a8d072cb2b8571 upstream.

Commit eff8728fe698 ("vmlinux.lds.h: Add PGO and AutoFDO input
sections") added ".text.unlikely.*" and ".text.hot.*" due to an LLVM
change [1].

After another LLVM change [2], these sections are seen in some PowerPC
builds, where there is a orphan section warning then build failure:

$ make -skj"$(nproc)" \
       ARCH=powerpc CROSS_COMPILE=powerpc64le-linux-gnu- LLVM=1 O=out \
       distclean powernv_defconfig zImage.epapr
ld.lld: warning: kernel/built-in.a(panic.o):(.text.unlikely.) is being placed in '.text.unlikely.'
...
ld.lld: warning: address (0xc000000000009314) of section .text is not a multiple of alignment (256)
...
ERROR: start_text address is c000000000009400, should be c000000000008000
ERROR: try to enable LD_HEAD_STUB_CATCH config option
ERROR: see comments in arch/powerpc/tools/head_check.sh
...

Explicitly handle these sections like in the main linker script so
there is no more build failure.

[1]: https://reviews.llvm.org/D79600
[2]: https://reviews.llvm.org/D92493

Fixes: 83a092cf95f2 ("powerpc: Link warning for orphan sections")
Cc: stable@vger.kernel.org
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://github.com/ClangBuiltLinux/linux/issues/1218
Link: https://lore.kernel.org/r/20210104205952.1399409-1-natechancellor@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/vmlinux.lds.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -85,7 +85,7 @@ SECTIONS
 		ALIGN_FUNCTION();
 #endif
 		/* careful! __ftr_alt_* sections need to be close to .text */
-		*(.text.hot TEXT_MAIN .text.fixup .text.unlikely .fixup __ftr_alt_* .ref.text);
+		*(.text.hot .text.hot.* TEXT_MAIN .text.fixup .text.unlikely .text.unlikely.* .fixup __ftr_alt_* .ref.text);
 #ifdef CONFIG_PPC64
 		*(.tramp.ftrace.text);
 #endif


