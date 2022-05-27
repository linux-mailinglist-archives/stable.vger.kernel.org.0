Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774A85361B1
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352670AbiE0MH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 08:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353211AbiE0MFp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 08:05:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F30163F40;
        Fri, 27 May 2022 04:54:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFD4361E08;
        Fri, 27 May 2022 11:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09381C385A9;
        Fri, 27 May 2022 11:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652453;
        bh=h6tHaseSKPHR3iiHid5vzDDODIHHO66skG/H2jWSo6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ea/5klA9mxlWmXxOTzGK3hDSrXIqDoFARWPUVfonhS5yMW6/zu8g0MaODb9euUHB8
         3RxH7GOub/9XzMT7q4Mo2mIhFKL2L8sw+cm57pIasH3HUn4VHWDj1RZn9lpyxsuBly
         KgQ5EmXYPHMdEsi+Nuz1rgt8P3pwIIZvj9pPKE3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 157/163] random: move randomize_page() into mm where it belongs
Date:   Fri, 27 May 2022 10:50:37 +0200
Message-Id: <20220527084850.061937691@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 5ad7dd882e45d7fe432c32e896e2aaa0b21746ea upstream.

randomize_page is an mm function. It is documented like one. It contains
the history of one. It has the naming convention of one. It looks
just like another very similar function in mm, randomize_stack_top().
And it has always been maintained and updated by mm people. There is no
need for it to be in random.c. In the "which shape does not look like
the other ones" test, pointing to randomize_page() is correct.

So move randomize_page() into mm/util.c, right next to the similar
randomize_stack_top() function.

This commit contains no actual code changes.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c  |   32 --------------------------------
 include/linux/mm.h     |    1 +
 include/linux/random.h |    2 --
 mm/util.c              |   32 ++++++++++++++++++++++++++++++++
 4 files changed, 33 insertions(+), 34 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -624,38 +624,6 @@ int __cold random_prepare_cpu(unsigned i
 }
 #endif
 
-/**
- * randomize_page - Generate a random, page aligned address
- * @start:	The smallest acceptable address the caller will take.
- * @range:	The size of the area, starting at @start, within which the
- *		random address must fall.
- *
- * If @start + @range would overflow, @range is capped.
- *
- * NOTE: Historical use of randomize_range, which this replaces, presumed that
- * @start was already page aligned.  We now align it regardless.
- *
- * Return: A page aligned address within [start, start + range).  On error,
- * @start is returned.
- */
-unsigned long randomize_page(unsigned long start, unsigned long range)
-{
-	if (!PAGE_ALIGNED(start)) {
-		range -= PAGE_ALIGN(start) - start;
-		start = PAGE_ALIGN(start);
-	}
-
-	if (start > ULONG_MAX - range)
-		range = ULONG_MAX - start;
-
-	range >>= PAGE_SHIFT;
-
-	if (range == 0)
-		return start;
-
-	return start + (get_random_long() % range << PAGE_SHIFT);
-}
-
 /*
  * This function will use the architecture-specific hardware random
  * number generator if it is available. It is not recommended for
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2585,6 +2585,7 @@ extern int install_special_mapping(struc
 				   unsigned long flags, struct page **pages);
 
 unsigned long randomize_stack_top(unsigned long stack_top);
+unsigned long randomize_page(unsigned long start, unsigned long range);
 
 extern unsigned long get_unmapped_area(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
 
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -64,8 +64,6 @@ static inline unsigned long get_random_c
 	return get_random_long() & CANARY_MASK;
 }
 
-unsigned long randomize_page(unsigned long start, unsigned long range);
-
 int __init random_init(const char *command_line);
 bool rng_is_initialized(void);
 int wait_for_random_bytes(void);
--- a/mm/util.c
+++ b/mm/util.c
@@ -331,6 +331,38 @@ unsigned long randomize_stack_top(unsign
 #endif
 }
 
+/**
+ * randomize_page - Generate a random, page aligned address
+ * @start:	The smallest acceptable address the caller will take.
+ * @range:	The size of the area, starting at @start, within which the
+ *		random address must fall.
+ *
+ * If @start + @range would overflow, @range is capped.
+ *
+ * NOTE: Historical use of randomize_range, which this replaces, presumed that
+ * @start was already page aligned.  We now align it regardless.
+ *
+ * Return: A page aligned address within [start, start + range).  On error,
+ * @start is returned.
+ */
+unsigned long randomize_page(unsigned long start, unsigned long range)
+{
+	if (!PAGE_ALIGNED(start)) {
+		range -= PAGE_ALIGN(start) - start;
+		start = PAGE_ALIGN(start);
+	}
+
+	if (start > ULONG_MAX - range)
+		range = ULONG_MAX - start;
+
+	range >>= PAGE_SHIFT;
+
+	if (range == 0)
+		return start;
+
+	return start + (get_random_long() % range << PAGE_SHIFT);
+}
+
 #ifdef CONFIG_ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT
 unsigned long arch_randomize_brk(struct mm_struct *mm)
 {


