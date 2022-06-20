Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A08551E2C
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348697AbiFTOCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350194AbiFTNxH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:53:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7138B262E;
        Mon, 20 Jun 2022 06:19:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 585B860C98;
        Mon, 20 Jun 2022 13:18:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B5FC3411B;
        Mon, 20 Jun 2022 13:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655731134;
        bh=PlquIHmEkLUenrV0b8mftduqSX2W2iNXx8TVoXvh7V8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K9cp1QiT90CgREapiteN/HgV6Qt+p/ddzIMphKY9h9ZL0ZHcvmxX8lOX4Z4uiVYZ7
         BRll6NM4IaJucTIDjqFGbCsDz4dXcMEYubmkmj5GLxilOs9NHCw/mrtBiHErau1dPS
         Qbx6DR8xJfVmUur1evqJ06+chPpJ8Y/PFJ0j/JGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 165/240] random: move randomize_page() into mm where it belongs
Date:   Mon, 20 Jun 2022 14:51:06 +0200
Message-Id: <20220620124743.785623693@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
@@ -619,38 +619,6 @@ int __cold random_prepare_cpu(unsigned i
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
@@ -2354,6 +2354,7 @@ extern int install_special_mapping(struc
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
@@ -320,6 +320,38 @@ unsigned long randomize_stack_top(unsign
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


