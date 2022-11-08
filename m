Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 545BB6212F4
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234513AbiKHNop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234511AbiKHNoo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:44:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0275801F
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:44:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB1AA61528
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:44:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A8DC4314E;
        Tue,  8 Nov 2022 13:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915080;
        bh=bj+OOQ3UaUtCL/dVmZ+CEuvAHINiM7j5gmNUqhguEBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n7ncBw9FFWKBaQIIqIpd+D3whlMLeyfZ7g0GBz8Zd49I9ETVK/lQzMCUhcv6h3+1L
         GXOl1UUcDIjv3v+JwhjRUydytH/GM0y/i7wEN0Jkrzb6CFYlXyPsaxoyAWh9KeAWSD
         q4NFuFf0ykLmpLwaJ5s/1L64IprYLwdXplyLLvmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        David Howells <dhowells@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 4.14 37/40] linux/const.h: prefix include guard of uapi/linux/const.h with _UAPI
Date:   Tue,  8 Nov 2022 14:39:22 +0100
Message-Id: <20221108133329.719599309@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133328.351887714@linuxfoundation.org>
References: <20221108133328.351887714@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

commit 2a6cc8a6c0cb44baf7df2f64e5090aaf726002c3 upstream.

Patch series "linux/const.h: cleanups of macros such as UL(), _BITUL(),
BIT() etc", v3.

ARM, ARM64, UniCore32 define UL() as a shorthand of _AC(..., UL).  More
architectures may introduce it in the future.

UL() is arch-agnostic, and useful. So let's move it to
include/linux/const.h

Currently, <asm/memory.h> must be included to use UL().  It pulls in more
bloats just for defining some bit macros.

I posted V2 one year ago.

The previous posts are:
https://patchwork.kernel.org/patch/9498273/
https://patchwork.kernel.org/patch/9498275/
https://patchwork.kernel.org/patch/9498269/
https://patchwork.kernel.org/patch/9498271/

At that time, what blocked this series was a comment from
David Howells:
  You need to be very careful doing this.  Some userspace stuff
  depends on the guard macro names on the kernel header files.

(https://patchwork.kernel.org/patch/9498275/)

Looking at the code closer, I noticed this is not a problem.

See the following line.
https://github.com/torvalds/linux/blob/v4.16-rc2/scripts/headers_install.sh#L40

scripts/headers_install.sh rips off _UAPI prefix from guard macro names.

I ran "make headers_install" and confirmed the result is what I expect.

So, we can prefix the include guard of include/uapi/linux/const.h,
and add a new include/linux/const.h.

This patch (of 4):

I am going to add include/linux/const.h for the kernel space.

Add _UAPI to the include guard of include/uapi/linux/const.h to
prepare for that.

Please notice the guard name of the exported one will be kept as-is.
So, this commit has no impact to the userspace even if some userspace
stuff depends on the guard macro names.

scripts/headers_install.sh processes exported headers by SED, and
rips off "_UAPI" from guard macro names.

  #ifndef _UAPI_LINUX_CONST_H
  #define _UAPI_LINUX_CONST_H

will be turned into

  #ifndef _LINUX_CONST_H
  #define _LINUX_CONST_H

Link: http://lkml.kernel.org/r/1519301715-31798-2-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[nd: resolve trivial conflict due to b732e14e6218b being backported before this]
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/const.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/uapi/linux/const.h
+++ b/include/uapi/linux/const.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 /* const.h: Macros for dealing with constants.  */
 
-#ifndef _LINUX_CONST_H
-#define _LINUX_CONST_H
+#ifndef _UAPI_LINUX_CONST_H
+#define _UAPI_LINUX_CONST_H
 
 /* Some constant macros are used in both assembler and
  * C code.  Therefore we cannot annotate them always with
@@ -30,4 +30,4 @@
 
 #define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
 
-#endif /* !(_LINUX_CONST_H) */
+#endif /* _UAPI_LINUX_CONST_H */


