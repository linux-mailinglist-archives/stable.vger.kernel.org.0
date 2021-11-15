Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52C0450E3B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240789AbhKOSNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:13:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:49938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240189AbhKOSHS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:07:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 244716338D;
        Mon, 15 Nov 2021 17:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636998199;
        bh=Lf8c+ExQclHKup9kh5u68kqmXtZFDq2ohGl5dwpHK8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SX8NFQsfwMj77UdmPV0FZvlPfqsnacOhpVQOiQJF4FerrvpR2RvY2ihZzuyiXEMj+
         RfSm+rkBhrCVMSALwLgkmlJGIIoaycsOn4wq7c9Gl8/eT4gAX7PiOo5POHqaJhDvc9
         +hKVu7zE0AovJm7/33SqKPTBnKn4YFbhjzB9RFAaRyDcwcscb9Qsc5YXnU23tHxbhe
         x1ij4aEf4o3nTcsTSbzGdN++6FFT7m5ahHEk/HtTpsG4irsNMBD3K0zGllDNwJnDVs
         4C9h+lqDsREqul3z4kGGQhhFDTQz3MKqmj+wz8hGjAK/KClnaTng8jlYwDuj8RigCE
         NFoWeY4m35BLQ==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Brian Cain <bcain@codeaurora.org>
Cc:     linux-hexagon@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2 1/3] hexagon: Export raw I/O routines for modules
Date:   Mon, 15 Nov 2021 10:42:49 -0700
Message-Id: <20211115174250.1994179-2-nathan@kernel.org>
X-Mailer: git-send-email 2.34.0.rc0
In-Reply-To: <20211115174250.1994179-1-nathan@kernel.org>
References: <20211115174250.1994179-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When building ARCH=hexagon allmodconfig, the following errors occur:

ERROR: modpost: "__raw_readsl" [drivers/i3c/master/svc-i3c-master.ko] undefined!
ERROR: modpost: "__raw_writesl" [drivers/i3c/master/dw-i3c-master.ko] undefined!
ERROR: modpost: "__raw_readsl" [drivers/i3c/master/dw-i3c-master.ko] undefined!
ERROR: modpost: "__raw_writesl" [drivers/i3c/master/i3c-master-cdns.ko] undefined!
ERROR: modpost: "__raw_readsl" [drivers/i3c/master/i3c-master-cdns.ko] undefined!

Export these symbols so that modules can use them without any errors.

Cc: stable@vger.kernel.org
Fixes: 013bf24c3829 ("Hexagon: Provide basic implementation and/or stubs for I/O routines.")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Brian Cain <bcain@codeaurora.org>
---
 arch/hexagon/lib/io.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/hexagon/lib/io.c b/arch/hexagon/lib/io.c
index d35d69d6588c..55f75392857b 100644
--- a/arch/hexagon/lib/io.c
+++ b/arch/hexagon/lib/io.c
@@ -27,6 +27,7 @@ void __raw_readsw(const void __iomem *addr, void *data, int len)
 		*dst++ = *src;
 
 }
+EXPORT_SYMBOL(__raw_readsw);
 
 /*
  * __raw_writesw - read words a short at a time
@@ -47,6 +48,7 @@ void __raw_writesw(void __iomem *addr, const void *data, int len)
 
 
 }
+EXPORT_SYMBOL(__raw_writesw);
 
 /*  Pretty sure len is pre-adjusted for the length of the access already */
 void __raw_readsl(const void __iomem *addr, void *data, int len)
@@ -62,6 +64,7 @@ void __raw_readsl(const void __iomem *addr, void *data, int len)
 
 
 }
+EXPORT_SYMBOL(__raw_readsl);
 
 void __raw_writesl(void __iomem *addr, const void *data, int len)
 {
@@ -76,3 +79,4 @@ void __raw_writesl(void __iomem *addr, const void *data, int len)
 
 
 }
+EXPORT_SYMBOL(__raw_writesl);
-- 
2.34.0.rc0

