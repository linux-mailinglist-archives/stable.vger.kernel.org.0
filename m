Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4E83A0268
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236928AbhFHTDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:03:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236226AbhFHTBZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:01:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B8116191B;
        Tue,  8 Jun 2021 18:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177879;
        bh=/JvAONqyA66hhoYpZQiVNqwbAw6VUa0IyNRHjMCvyVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eEkp9pCpB8O2C/x2fzybBpBft8Vo/SLQxFystmEJPttPd89M//aozJt3jDCKHXOFr
         9ckAPWtf6fd+as7VIkjd7O3zgcgfrGXXjbZVkjToKJ93kRgVay5K7rIvowEEQjvWY0
         //kfr4aLj8qCzDeInXp8t7ojKqDk85qHFhe6gNT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gao Xiang <hsiangkao@redhat.com>,
        Nick Terrell <terrelln@fb.com>,
        Yann Collet <yann.collet.73@gmail.com>,
        Miao Xie <miaoxie@huawei.com>, Chao Yu <yuchao0@huawei.com>,
        Li Guifu <bluce.liguifu@huawei.com>,
        Guo Xuenan <guoxuenan@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 5.10 133/137] lib/lz4: explicitly support in-place decompression
Date:   Tue,  8 Jun 2021 20:27:53 +0200
Message-Id: <20210608175946.881796219@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

commit 89b158635ad79574bde8e94d45dad33f8cf09549 upstream.

LZ4 final literal copy could be overlapped when doing
in-place decompression, so it's unsafe to just use memcpy()
on an optimized memcpy approach but memmove() instead.

Upstream LZ4 has updated this years ago [1] (and the impact
is non-sensible [2] plus only a few bytes remain), this commit
just synchronizes LZ4 upstream code to the kernel side as well.

It can be observed as EROFS in-place decompression failure
on specific files when X86_FEATURE_ERMS is unsupported,
memcpy() optimization of commit 59daa706fbec ("x86, mem:
Optimize memcpy by avoiding memory false dependece") will
be enabled then.

Currently most modern x86-CPUs support ERMS, these CPUs just
use "rep movsb" approach so no problem at all. However, it can
still be verified with forcely disabling ERMS feature...

arch/x86/lib/memcpy_64.S:
        ALTERNATIVE_2 "jmp memcpy_orig", "", X86_FEATURE_REP_GOOD, \
-                     "jmp memcpy_erms", X86_FEATURE_ERMS
+                     "jmp memcpy_orig", X86_FEATURE_ERMS

We didn't observe any strange on arm64/arm/x86 platform before
since most memcpy() would behave in an increasing address order
("copy upwards" [3]) and it's the correct order of in-place
decompression but it really needs an update to memmove() for sure
considering it's an undefined behavior according to the standard
and some unique optimization already exists in the kernel.

[1] https://github.com/lz4/lz4/commit/33cb8518ac385835cc17be9a770b27b40cd0e15b
[2] https://github.com/lz4/lz4/pull/717#issuecomment-497818921
[3] https://sourceware.org/bugzilla/show_bug.cgi?id=12518

Link: https://lkml.kernel.org/r/20201122030749.2698994-1-hsiangkao@redhat.com
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
Reviewed-by: Nick Terrell <terrelln@fb.com>
Cc: Yann Collet <yann.collet.73@gmail.com>
Cc: Miao Xie <miaoxie@huawei.com>
Cc: Chao Yu <yuchao0@huawei.com>
Cc: Li Guifu <bluce.liguifu@huawei.com>
Cc: Guo Xuenan <guoxuenan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/lz4/lz4_decompress.c |    6 +++++-
 lib/lz4/lz4defs.h        |    1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/lib/lz4/lz4_decompress.c
+++ b/lib/lz4/lz4_decompress.c
@@ -263,7 +263,11 @@ static FORCE_INLINE int LZ4_decompress_g
 				}
 			}
 
-			LZ4_memcpy(op, ip, length);
+			/*
+			 * supports overlapping memory regions; only matters
+			 * for in-place decompression scenarios
+			 */
+			LZ4_memmove(op, ip, length);
 			ip += length;
 			op += length;
 
--- a/lib/lz4/lz4defs.h
+++ b/lib/lz4/lz4defs.h
@@ -146,6 +146,7 @@ static FORCE_INLINE void LZ4_writeLE16(v
  * environments. This is needed when decompressing the Linux Kernel, for example.
  */
 #define LZ4_memcpy(dst, src, size) __builtin_memcpy(dst, src, size)
+#define LZ4_memmove(dst, src, size) __builtin_memmove(dst, src, size)
 
 static FORCE_INLINE void LZ4_copy8(void *dst, const void *src)
 {


