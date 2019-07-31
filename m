Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 615177D02C
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 23:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbfGaVkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 17:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729117AbfGaVkW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Jul 2019 17:40:22 -0400
Received: from X1 (unknown [76.191.170.112])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 901FD20659;
        Wed, 31 Jul 2019 21:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564609220;
        bh=CH6Fgx/aAmFiWc/o/5e6THhzvTznH7DejXkhPYF+BJY=;
        h=Date:From:To:Subject:From;
        b=jf5C0PSLiZQi0Eo0rY1LLw/HqegSY3+RHq9kDdBEhqQI0IFXy1eRyXXGzYwvKIPoL
         +xwO7hIuemZgtsRYqEckaafx4ULhriYpHAWjJSKhKKSzFvgBshC77HfsRwzZh6Tvgo
         99HRiLG4KX+M8kgStEiWoETTl3P93S0G+JAUVwo4=
Date:   Wed, 31 Jul 2019 14:40:17 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        tsoni@codeaurora.org, stable@vger.kernel.org,
        psodagud@codeaurora.org, keescook@chromium.org,
        gregkh@linuxfoundation.org, isaacm@codeaurora.org
Subject:  +
 mm-usercopy-use-memory-range-to-be-accessed-for-wraparound-check.patch added
 to -mm tree
Message-ID: <20190731214017.XFBOL%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/usercopy: use memory range to be accessed for wraparound check
has been added to the -mm tree.  Its filename is
     mm-usercopy-use-memory-range-to-be-accessed-for-wraparound-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-usercopy-use-memory-range-to-be-accessed-for-wraparound-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-usercopy-use-memory-range-to-be-accessed-for-wraparound-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Isaac J. Manjarres" <isaacm@codeaurora.org>
Subject: mm/usercopy: use memory range to be accessed for wraparound check

Currently, when checking to see if accessing n bytes starting at address
"ptr" will cause a wraparound in the memory addresses, the check in
check_bogus_address() adds an extra byte, which is incorrect, as the range
of addresses that will be accessed is [ptr, ptr + (n - 1)].

This can lead to incorrectly detecting a wraparound in the memory address,
when trying to read 4 KB from memory that is mapped to the the last
possible page in the virtual address space, when in fact, accessing that
range of memory would not cause a wraparound to occur.

Use the memory range that will actually be accessed when considering if
accessing a certain amount of bytes will cause the memory address to wrap
around.

Link: http://lkml.kernel.org/r/1564509253-23287-1-git-send-email-isaacm@codeaurora.org
Fixes: f5509cc18daa ("mm: Hardened usercopy")
Signed-off-by: Prasad Sodagudi <psodagud@codeaurora.org>
Signed-off-by: Isaac J. Manjarres <isaacm@codeaurora.org>
Co-developed-by: Prasad Sodagudi <psodagud@codeaurora.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Trilok Soni <tsoni@codeaurora.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/usercopy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/usercopy.c~mm-usercopy-use-memory-range-to-be-accessed-for-wraparound-check
+++ a/mm/usercopy.c
@@ -147,7 +147,7 @@ static inline void check_bogus_address(c
 				       bool to_user)
 {
 	/* Reject if object wraps past end of memory. */
-	if (ptr + n < ptr)
+	if (ptr + (n - 1) < ptr)
 		usercopy_abort("wrapped address", NULL, to_user, 0, ptr + n);
 
 	/* Reject if NULL or ZERO-allocation. */
_

Patches currently in -mm which might be from isaacm@codeaurora.org are

mm-usercopy-use-memory-range-to-be-accessed-for-wraparound-check.patch

