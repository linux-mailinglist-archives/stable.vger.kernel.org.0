Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE07FED8C
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbfKPPo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:44:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:50116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729095AbfKPPo4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:44:56 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D8B92075B;
        Sat, 16 Nov 2019 15:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919095;
        bh=qgKnA8ercINp8dTih9WIGTCvC7aWFs7CarrmJcobrQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i7CfAuj02QQ3h2/y7m6KvD3okRqSm7qkDBtidWjxlP7S2XdsXIUxZet5xOL8deu23
         PnBaO3kCCZinzvAZSi20AFwO0mHzYMKDX57T6Ga6MKa8wSvXYrEkpAPvblOqaaC8AB
         lJE3NHoQweF8EBDj5NogAf5PjnqRA7CGrkIaBUEk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Yury Norov <ynorov@caviumnetworks.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 152/237] lib/bitmap.c: fix remaining space computation in bitmap_print_to_pagebuf
Date:   Sat, 16 Nov 2019 10:39:47 -0500
Message-Id: <20191116154113.7417-152-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

[ Upstream commit ce1091d471107dbf6f91db66a480a25950c9b9ff ]

For various alignments of buf, the current expression computes

4096 ok
4095 ok
8190
8189
...
4097

i.e., if the caller has already written two bytes into the page buffer,
len is 8190 rather than 4094, because PTR_ALIGN aligns up to the next
boundary.  So if the printed version of the bitmap is huge, scnprintf()
ends up writing beyond the page boundary.

I don't think any current callers actually write anything before
bitmap_print_to_pagebuf, but the API seems to be designed to allow it.

[akpm@linux-foundation.org: use offset_in_page(), per Andy]
[akpm@linux-foundation.org: include mm.h for offset_in_page()]
Link: http://lkml.kernel.org/r/20180818131623.8755-7-linux@rasmusvillemoes.dk
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Yury Norov <ynorov@caviumnetworks.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/bitmap.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index 2fd07f6df0b85..c4ca9ceb09fe3 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -13,6 +13,7 @@
 #include <linux/bitops.h>
 #include <linux/bug.h>
 #include <linux/kernel.h>
+#include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/uaccess.h>
@@ -466,14 +467,15 @@ EXPORT_SYMBOL(bitmap_parse_user);
  * ranges if list is specified or hex digits grouped into comma-separated
  * sets of 8 digits/set. Returns the number of characters written to buf.
  *
- * It is assumed that @buf is a pointer into a PAGE_SIZE area and that
- * sufficient storage remains at @buf to accommodate the
- * bitmap_print_to_pagebuf() output.
+ * It is assumed that @buf is a pointer into a PAGE_SIZE, page-aligned
+ * area and that sufficient storage remains at @buf to accommodate the
+ * bitmap_print_to_pagebuf() output. Returns the number of characters
+ * actually printed to @buf, excluding terminating '\0'.
  */
 int bitmap_print_to_pagebuf(bool list, char *buf, const unsigned long *maskp,
 			    int nmaskbits)
 {
-	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf;
+	ptrdiff_t len = PAGE_SIZE - offset_in_page(buf);
 	int n = 0;
 
 	if (len > 1)
-- 
2.20.1

