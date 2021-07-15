Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048CA3C9F1D
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 15:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbhGONLH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 09:11:07 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:35930 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229624AbhGONLH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 09:11:07 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R991e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Ufsz2i6_1626354489;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Ufsz2i6_1626354489)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 15 Jul 2021 21:08:13 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Gao Xiang <hsiangkao@linux.alibaba.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 5.4.y stable only v2] MIPS: fix "mipsel-linux-ld: decompress.c:undefined reference to `memmove'"
Date:   Thu, 15 Jul 2021 21:08:06 +0800
Message-Id: <20210715130806.195223-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is _not_ an upstream commit and just for 5.4.y only.

kernel test robot reported a 5.4.y build issue found by randconfig [1]
after backporting commit 89b158635ad7 ("lib/lz4: explicitly support
in-place decompression"") due to "undefined reference to `memmove'".

However, upstream and 5.10 LTS seem fine. After digging further,
I found commit a510b616131f ("MIPS: Add support for ZSTD-compressed
kernels") introduced memmove() occasionally and it has been included
since v5.10.

This partially cherry-picks the memmove() part of commit a510b616131f
to fix the reported build regression since we don't need the whole
patch for 5.4 LTS at all.

[1] https://lore.kernel.org/r/202107070120.6dOj1kB7-lkp@intel.com/
Fixes: defcc2b5e54a ("lib/lz4: explicitly support in-place decompression") # 5.4.y
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
v2:
 "just submit the fix and say _why_ this is not an upstream
commit, do not attempt to emulate an upstream commit like
your change did." as Greg suggested...

 arch/mips/boot/compressed/string.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/mips/boot/compressed/string.c b/arch/mips/boot/compressed/string.c
index 43beecc3587c..0b593b709228 100644
--- a/arch/mips/boot/compressed/string.c
+++ b/arch/mips/boot/compressed/string.c
@@ -5,6 +5,7 @@
  * Very small subset of simple string routines
  */
 
+#include <linux/compiler_attributes.h>
 #include <linux/types.h>
 
 void *memcpy(void *dest, const void *src, size_t n)
@@ -27,3 +28,19 @@ void *memset(void *s, int c, size_t n)
 		ss[i] = c;
 	return s;
 }
+
+void * __weak memmove(void *dest, const void *src, size_t n)
+{
+	unsigned int i;
+	const char *s = src;
+	char *d = dest;
+
+	if ((uintptr_t)dest < (uintptr_t)src) {
+		for (i = 0; i < n; i++)
+			d[i] = s[i];
+	} else {
+		for (i = n; i > 0; i--)
+			d[i - 1] = s[i - 1];
+	}
+	return dest;
+}
-- 
2.24.4

