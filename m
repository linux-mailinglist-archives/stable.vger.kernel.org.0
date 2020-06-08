Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEA5B1F2737
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387889AbgFHXni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:43:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387667AbgFHXnh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:43:37 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C28012078C;
        Mon,  8 Jun 2020 23:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591659816;
        bh=ggPZuuhjSRGM7zE7zXP/zWIFiCo7SNBnhpwJ3wfZQFU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PpD7Ew+6wXPOLcQ8M58cxscQ0mBKy1LNI/UV23Klf/NVIJmVoF0nkVbefAF1JXF8z
         BEEmH+Y/LyfRGUYzp9ubilSB+VVyGy7HqnntfZFEf+zb6GOYhl1xWqF3UvT+HvAed9
         F/AwJj7hJon99QS4BFMKZKCJYse5IqAptspNU4nI=
Date:   Mon, 08 Jun 2020 16:43:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     acme@redhat.com, agordeev@linux.ibm.com, amritha.nambiar@intel.com,
        andriy.shevchenko@linux.intel.com, chris@chris-wilson.co.uk,
        keescook@chromium.org, linux@rasmusvillemoes.dk,
        mm-commits@vger.kernel.org, mszeredi@redhat.com,
        stable@vger.kernel.org, steffen.klassert@secunet.com,
        tobin@kernel.org, vineet.gupta1@synopsys.com, will.deacon@arm.com,
        willemb@google.com, willy@infradead.org, yury.norov@gmail.com
Subject:  + lib-fix-bitmap_parse-on-64-bit-big-endian-archs.patch
 added to -mm tree
Message-ID: <20200608234335.ip8WJ3NXZ%akpm@linux-foundation.org>
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: lib: fix bitmap_parse() on 64-bit big endian archs
has been added to the -mm tree.  Its filename is
     lib-fix-bitmap_parse-on-64-bit-big-endian-archs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-fix-bitmap_parse-on-64-bit-big-endian-archs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-fix-bitmap_parse-on-64-bit-big-endian-archs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: lib: fix bitmap_parse() on 64-bit big endian archs

Commit 2d6261583be0 ("lib: rework bitmap_parse()") does not take into
account order of halfwords on 64-bit big endian architectures.  As result
(at least) Receive Packet Steering, IRQ affinity masks and runtime kernel
test "test_bitmap" get broken on s390.

Link: http://lkml.kernel.org/r/1591634471-17647-1-git-send-email-agordeev@linux.ibm.com
Fixes: 2d6261583be0 ("lib: rework bitmap_parse()")
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Yury Norov <yury.norov@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Amritha Nambiar <amritha.nambiar@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: "Tobin C . Harding" <tobin@kernel.org>
Cc: Vineet Gupta <vineet.gupta1@synopsys.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/lib/bitmap.c~lib-fix-bitmap_parse-on-64-bit-big-endian-archs
+++ a/lib/bitmap.c
@@ -740,6 +740,7 @@ int bitmap_parse(const char *start, unsi
 	const char *end = strnchrnul(start, buflen, '\n') - 1;
 	int chunks = BITS_TO_U32(nmaskbits);
 	u32 *bitmap = (u32 *)maskp;
+	int chunk = 0;
 	int unset_bit;
 
 	while (1) {
@@ -750,9 +751,14 @@ int bitmap_parse(const char *start, unsi
 		if (!chunks--)
 			return -EOVERFLOW;
 
-		end = bitmap_get_x32_reverse(start, end, bitmap++);
+#if defined(CONFIG_64BIT) && defined(__BIG_ENDIAN)
+		end = bitmap_get_x32_reverse(start, end, &bitmap[chunk ^ 1]);
+#else
+		end = bitmap_get_x32_reverse(start, end, &bitmap[chunk]);
+#endif
 		if (IS_ERR(end))
 			return PTR_ERR(end);
+		chunk++;
 	}
 
 	unset_bit = (BITS_TO_U32(nmaskbits) - chunks) * 32;
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are

lib-fix-bitmap_parse-on-64-bit-big-endian-archs.patch

