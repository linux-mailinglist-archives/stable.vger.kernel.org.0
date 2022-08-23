Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D984359D384
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242092AbiHWIMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241830AbiHWIJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:09:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21FC66A65;
        Tue, 23 Aug 2022 01:06:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F08EB81C18;
        Tue, 23 Aug 2022 08:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90AD5C433C1;
        Tue, 23 Aug 2022 08:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661241966;
        bh=n/610ybo0Q8VX/qdPiQAgzKGu5QXTZKOJay/mqFZBEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HjnQn7h6U2A+TJNBzZBsROU1qnEbAQY5qs7KlUTA4zWfNjrTdFj/Rpm1oKeUgj0Au
         eYIhNFuAqQV8h7ZfLNzoVU80QnqSuAvG6zJNnRYhdd80iesfAmYitio2Jx9Sjt01V5
         hEvbSnOAcUTUVD+6Dbe3ynYSOET82/ditMCPOCD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hector Martin <marcan@marcan.st>,
        Will Deacon <will@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.19 008/365] locking/atomic: Make test_and_*_bit() ordered on failure
Date:   Tue, 23 Aug 2022 09:58:29 +0200
Message-Id: <20220823080118.507275261@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Hector Martin <marcan@marcan.st>

commit 415d832497098030241605c52ea83d4e2cfa7879 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/atomic_bitops.txt     |    2 +-
 include/asm-generic/bitops/atomic.h |    6 ------
 2 files changed, 1 insertion(+), 7 deletions(-)

--- a/Documentation/atomic_bitops.txt
+++ b/Documentation/atomic_bitops.txt
@@ -59,7 +59,7 @@ Like with atomic_t, the rule of thumb is
  - RMW operations that have a return value are fully ordered.
 
  - RMW operations that are conditional are unordered on FAILURE,
-   otherwise the above rules apply. In the case of test_and_{}_bit() operations,
+   otherwise the above rules apply. In the case of test_and_set_bit_lock(),
    if the bit in memory is unchanged by the operation then it is deemed to have
    failed.
 
--- a/include/asm-generic/bitops/atomic.h
+++ b/include/asm-generic/bitops/atomic.h
@@ -39,9 +39,6 @@ arch_test_and_set_bit(unsigned int nr, v
 	unsigned long mask = BIT_MASK(nr);
 
 	p += BIT_WORD(nr);
-	if (READ_ONCE(*p) & mask)
-		return 1;
-
 	old = arch_atomic_long_fetch_or(mask, (atomic_long_t *)p);
 	return !!(old & mask);
 }
@@ -53,9 +50,6 @@ arch_test_and_clear_bit(unsigned int nr,
 	unsigned long mask = BIT_MASK(nr);
 
 	p += BIT_WORD(nr);
-	if (!(READ_ONCE(*p) & mask))
-		return 0;
-
 	old = arch_atomic_long_fetch_andnot(mask, (atomic_long_t *)p);
 	return !!(old & mask);
 }


