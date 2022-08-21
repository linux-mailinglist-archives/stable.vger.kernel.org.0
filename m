Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A89F59B416
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 15:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiHUNqP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 09:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiHUNqO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 09:46:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EAED2314E
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 06:46:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F23ACB80D0D
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 13:46:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327A3C433C1;
        Sun, 21 Aug 2022 13:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661089570;
        bh=bM4dWekcm9l1BSCTG2OydtAbWZoqVoMxzFsZfv79UBw=;
        h=Subject:To:Cc:From:Date:From;
        b=Nuv2lqQ7KQLjlN7ioslUu6ow8rTyQ18eZqcW1u/xptxQ226rwI/xvhWKrp8lXm3Jj
         8Sjv5J7KUmTEToIoQHwP8LAQ6SiTgCtLWM9b0atPgd69RgGcTKLWPo0EqRSkb4/j/O
         uuAxOsg9McdTWUlTaFRV0Kj7efFpdYV2kD3+ClF0=
Subject: FAILED: patch "[PATCH] locking/atomic: Make test_and_*_bit() ordered on failure" failed to apply to 5.10-stable tree
To:     marcan@marcan.st, arnd@arndb.de, torvalds@linux-foundation.org,
        will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 21 Aug 2022 15:46:07 +0200
Message-ID: <1661089567161107@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 415d832497098030241605c52ea83d4e2cfa7879 Mon Sep 17 00:00:00 2001
From: Hector Martin <marcan@marcan.st>
Date: Tue, 16 Aug 2022 16:03:11 +0900
Subject: [PATCH] locking/atomic: Make test_and_*_bit() ordered on failure

These operations are documented as always ordered in
include/asm-generic/bitops/instrumented-atomic.h, and producer-consumer
type use cases where one side needs to ensure a flag is left pending
after some shared data was updated rely on this ordering, even in the
failure case.

This is the case with the workqueue code, which currently suffers from a
reproducible ordering violation on Apple M1 platforms (which are
notoriously out-of-order) that ends up causing the TTY layer to fail to
deliver data to userspace properly under the right conditions.  This
change fixes that bug.

Change the documentation to restrict the "no order on failure" story to
the _lock() variant (for which it makes sense), and remove the
early-exit from the generic implementation, which is what causes the
missing barrier semantics in that case.  Without this, the remaining
atomic op is fully ordered (including on ARM64 LSE, as of recent
versions of the architecture spec).

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@vger.kernel.org
Fixes: e986a0d6cb36 ("locking/atomics, asm-generic/bitops/atomic.h: Rewrite using atomic_*() APIs")
Fixes: 61e02392d3c7 ("locking/atomic/bitops: Document and clarify ordering semantics for failed test_and_{}_bit()")
Signed-off-by: Hector Martin <marcan@marcan.st>
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/Documentation/atomic_bitops.txt b/Documentation/atomic_bitops.txt
index 093cdaefdb37..d8b101c97031 100644
--- a/Documentation/atomic_bitops.txt
+++ b/Documentation/atomic_bitops.txt
@@ -59,7 +59,7 @@ Like with atomic_t, the rule of thumb is:
  - RMW operations that have a return value are fully ordered.
 
  - RMW operations that are conditional are unordered on FAILURE,
-   otherwise the above rules apply. In the case of test_and_{}_bit() operations,
+   otherwise the above rules apply. In the case of test_and_set_bit_lock(),
    if the bit in memory is unchanged by the operation then it is deemed to have
    failed.
 
diff --git a/include/asm-generic/bitops/atomic.h b/include/asm-generic/bitops/atomic.h
index 3096f086b5a3..71ab4ba9c25d 100644
--- a/include/asm-generic/bitops/atomic.h
+++ b/include/asm-generic/bitops/atomic.h
@@ -39,9 +39,6 @@ arch_test_and_set_bit(unsigned int nr, volatile unsigned long *p)
 	unsigned long mask = BIT_MASK(nr);
 
 	p += BIT_WORD(nr);
-	if (READ_ONCE(*p) & mask)
-		return 1;
-
 	old = arch_atomic_long_fetch_or(mask, (atomic_long_t *)p);
 	return !!(old & mask);
 }
@@ -53,9 +50,6 @@ arch_test_and_clear_bit(unsigned int nr, volatile unsigned long *p)
 	unsigned long mask = BIT_MASK(nr);
 
 	p += BIT_WORD(nr);
-	if (!(READ_ONCE(*p) & mask))
-		return 0;
-
 	old = arch_atomic_long_fetch_andnot(mask, (atomic_long_t *)p);
 	return !!(old & mask);
 }

