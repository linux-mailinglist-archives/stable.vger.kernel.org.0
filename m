Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252AD397711
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 17:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234525AbhFAPsm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 11:48:42 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:45152 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234518AbhFAPsm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 11:48:42 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UazFAp6_1622562407;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0UazFAp6_1622562407)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 01 Jun 2021 23:46:57 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@linux.alibaba.com>,
        Yann Collet <yann.collet.73@gmail.com>,
        Miao Xie <miaoxie@huawei.com>, Chao Yu <yuchao0@huawei.com>,
        Li Guifu <bluce.liguifu@huawei.com>,
        Guo Xuenan <guoxuenan@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH for-5.4.y] lib/lz4: explicitly support in-place decompression
Date:   Tue,  1 Jun 2021 23:46:44 +0800
Message-Id: <1622562405-63431-1-git-send-email-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Reviewed-by: Nick Terrell <terrelln@fb.com>
Cc: Yann Collet <yann.collet.73@gmail.com>
Cc: Miao Xie <miaoxie@huawei.com>
Cc: Chao Yu <yuchao0@huawei.com>
Cc: Li Guifu <bluce.liguifu@huawei.com>
Cc: Guo Xuenan <guoxuenan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
Hi,

Please kindly consider these two backports to 5.4.y and 5.10.y LTS
kernels, and the reason shown as above (it could cause lz4 in-place
decompression (mainly EROFS) failure due to the different designed
memcpy overlapped behavior on x86 if ERMS is unsupported.) The lz4
upstream commit itself has been merged for 2 years. And the linux
upstream commit is also merged for months without any other
regression.

And in principle, it won't have any real impact at all, so I think
it's now safe to backport this to LTS kernels for unsupported ERMS
x86s.

Thanks,
Gao Xiang

 lib/lz4/lz4_decompress.c | 6 +++++-
 lib/lz4/lz4defs.h        | 2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/lib/lz4/lz4_decompress.c b/lib/lz4/lz4_decompress.c
index 0c9d3ad17e0f..4d0b59fa5550 100644
--- a/lib/lz4/lz4_decompress.c
+++ b/lib/lz4/lz4_decompress.c
@@ -260,7 +260,11 @@ static FORCE_INLINE int LZ4_decompress_generic(
 				}
 			}
 
-			memcpy(op, ip, length);
+			/*
+			 * supports overlapping memory regions; only matters
+			 * for in-place decompression scenarios
+			 */
+			LZ4_memmove(op, ip, length);
 			ip += length;
 			op += length;
 
diff --git a/lib/lz4/lz4defs.h b/lib/lz4/lz4defs.h
index 1a7fa9d9170f..369eb181d730 100644
--- a/lib/lz4/lz4defs.h
+++ b/lib/lz4/lz4defs.h
@@ -137,6 +137,8 @@ static FORCE_INLINE void LZ4_writeLE16(void *memPtr, U16 value)
 	return put_unaligned_le16(value, memPtr);
 }
 
+#define LZ4_memmove(dst, src, size) __builtin_memmove(dst, src, size)
+
 static FORCE_INLINE void LZ4_copy8(void *dst, const void *src)
 {
 #if LZ4_ARCH64
-- 
1.8.3.1

