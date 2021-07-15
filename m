Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B643CA657
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236834AbhGOSrT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:47:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238645AbhGOSrN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:47:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3D7F613D1;
        Thu, 15 Jul 2021 18:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374659;
        bh=YsgUxFkAQIZU3ZVISzNLMdUo6s3I6zNTSY1lPTFkK+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ruPZuhjALrCxXo3JItpNp/gXaI0eRjASuWbOPnv77WxIJ5VrC5xHoT10VN92tZzuQ
         yElWmLjNeDQvRm2bWcTQjoJjPecKP1/We2loHkgo52cqdr89V+XhGNuRcke+ELCF5P
         GiWEfiKzWvN9hVhiUyr3q2pd7d1TIc2VifAutYAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 5.4 093/122] MIPS: fix "mipsel-linux-ld: decompress.c:undefined reference to `memmove"
Date:   Thu, 15 Jul 2021 20:39:00 +0200
Message-Id: <20210715182515.933919315@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@linux.alibaba.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/boot/compressed/string.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

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


