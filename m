Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2565F8F54B
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 22:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733216AbfHOUCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 16:02:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733212AbfHOUCS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Aug 2019 16:02:18 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9ADBA2089E;
        Thu, 15 Aug 2019 20:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565899337;
        bh=171vTKSgyUhgzCjsIKDSlde+b/Jgaour1SIezC9zpek=;
        h=Date:From:To:Subject:From;
        b=QWKGCiNDEdRrMJO2qEeGIIoKqkXdt+sDdCSoRPXQv9kVytrUmh68ZR6jXkA5ua/tw
         xjqXg0RrWRQyzazKK8e4DzJGoVYOhgJak6ob2D9ZUybx9jXfQGgP5BVtQ7q7aNL1nl
         SWPTXYQExz67RwvyeWzC6S58YGRAMMPw1RZD5VIo=
Date:   Thu, 15 Aug 2019 13:02:17 -0700
From:   akpm@linux-foundation.org
To:     gregkh@linuxfoundation.org, isaacm@codeaurora.org,
        keescook@chromium.org, mm-commits@vger.kernel.org,
        psodagud@codeaurora.org, stable@vger.kernel.org,
        tsoni@codeaurora.org, william.kucharski@oracle.com
Subject:  [merged]
 mm-usercopy-use-memory-range-to-be-accessed-for-wraparound-check.patch
 removed from -mm tree
Message-ID: <20190815200217.oZcThIuFS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/usercopy: use memory range to be accessed for wraparound check
has been removed from the -mm tree.  Its filename was
     mm-usercopy-use-memory-range-to-be-accessed-for-wraparound-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


