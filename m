Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B28259311
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729632AbgIAPUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:20:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729630AbgIAPUr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:20:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 271F820767;
        Tue,  1 Sep 2020 15:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973646;
        bh=wQJh5oefg0jJJ1oQVcAo/I9Wd+i3NyiIy03FoMCF264=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qe/asu1jK/6kwg30tZYWWMdaVLxqOMpTH1WcuqhGFQVXU9Siz9JoRED1LFKUkDf/H
         mhLDk1mEJINXcyffdvsXNJnkFGo/S2xabyv7o9wLRBO96hsGa0EjOwWUyBenSkwuiY
         FPgkYw2PpPqRW/N4BcnMolcGojxReibErxL6t56k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Matthew Wilcox <mawilcox@microsoft.com>
Subject: [PATCH 4.14 82/91] overflow.h: Add allocation size calculation helpers
Date:   Tue,  1 Sep 2020 17:10:56 +0200
Message-Id: <20200901150932.248573619@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150928.096174795@linuxfoundation.org>
References: <20200901150928.096174795@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 610b15c50e86eb1e4b77274fabcaea29ac72d6a8 upstream.

In preparation for replacing unchecked overflows for memory allocations,
this creates helpers for the 3 most common calculations:

array_size(a, b): 2-dimensional array
array3_size(a, b, c): 3-dimensional array
struct_size(ptr, member, n): struct followed by n-many trailing members

Each of these return SIZE_MAX on overflow instead of wrapping around.

(Additionally renames a variable named "array_size" to avoid future
collision.)

Co-developed-by: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-table.c    |   10 +++---
 include/linux/overflow.h |   73 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+), 5 deletions(-)

--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -547,14 +547,14 @@ static int adjoin(struct dm_table *table
  * On the other hand, dm-switch needs to process bulk data using messages and
  * excessive use of GFP_NOIO could cause trouble.
  */
-static char **realloc_argv(unsigned *array_size, char **old_argv)
+static char **realloc_argv(unsigned *size, char **old_argv)
 {
 	char **argv;
 	unsigned new_size;
 	gfp_t gfp;
 
-	if (*array_size) {
-		new_size = *array_size * 2;
+	if (*size) {
+		new_size = *size * 2;
 		gfp = GFP_KERNEL;
 	} else {
 		new_size = 8;
@@ -562,8 +562,8 @@ static char **realloc_argv(unsigned *arr
 	}
 	argv = kmalloc(new_size * sizeof(*argv), gfp);
 	if (argv) {
-		memcpy(argv, old_argv, *array_size * sizeof(*argv));
-		*array_size = new_size;
+		memcpy(argv, old_argv, *size * sizeof(*argv));
+		*size = new_size;
 	}
 
 	kfree(old_argv);
--- a/include/linux/overflow.h
+++ b/include/linux/overflow.h
@@ -233,4 +233,77 @@
 		(*_d >> _to_shift) != _a);				\
 })
 
+/**
+ * array_size() - Calculate size of 2-dimensional array.
+ *
+ * @a: dimension one
+ * @b: dimension two
+ *
+ * Calculates size of 2-dimensional array: @a * @b.
+ *
+ * Returns: number of bytes needed to represent the array or SIZE_MAX on
+ * overflow.
+ */
+static inline __must_check size_t array_size(size_t a, size_t b)
+{
+	size_t bytes;
+
+	if (check_mul_overflow(a, b, &bytes))
+		return SIZE_MAX;
+
+	return bytes;
+}
+
+/**
+ * array3_size() - Calculate size of 3-dimensional array.
+ *
+ * @a: dimension one
+ * @b: dimension two
+ * @c: dimension three
+ *
+ * Calculates size of 3-dimensional array: @a * @b * @c.
+ *
+ * Returns: number of bytes needed to represent the array or SIZE_MAX on
+ * overflow.
+ */
+static inline __must_check size_t array3_size(size_t a, size_t b, size_t c)
+{
+	size_t bytes;
+
+	if (check_mul_overflow(a, b, &bytes))
+		return SIZE_MAX;
+	if (check_mul_overflow(bytes, c, &bytes))
+		return SIZE_MAX;
+
+	return bytes;
+}
+
+static inline __must_check size_t __ab_c_size(size_t n, size_t size, size_t c)
+{
+	size_t bytes;
+
+	if (check_mul_overflow(n, size, &bytes))
+		return SIZE_MAX;
+	if (check_add_overflow(bytes, c, &bytes))
+		return SIZE_MAX;
+
+	return bytes;
+}
+
+/**
+ * struct_size() - Calculate size of structure with trailing array.
+ * @p: Pointer to the structure.
+ * @member: Name of the array member.
+ * @n: Number of elements in the array.
+ *
+ * Calculates size of memory needed for structure @p followed by an
+ * array of @n @member elements.
+ *
+ * Return: number of bytes needed or SIZE_MAX on overflow.
+ */
+#define struct_size(p, member, n)					\
+	__ab_c_size(n,							\
+		    sizeof(*(p)->member) + __must_be_array((p)->member),\
+		    sizeof(*(p)))
+
 #endif /* __LINUX_OVERFLOW_H */


