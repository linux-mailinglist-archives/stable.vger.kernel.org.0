Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB1E8C45B
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 00:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbfHMWhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 18:37:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbfHMWhj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 18:37:39 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 538B120840;
        Tue, 13 Aug 2019 22:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565735858;
        bh=lrOZASxu/z0pdhBkfBWynYYBnN9chRPR1Jd4/Y5Nq0I=;
        h=Date:From:To:Subject:From;
        b=fr3c7e9XCyrxG4ubpzNyrlL6Eu86lnJG5M2K0W65HGZTMpDSriAIGdBulpBWDiljL
         Wmcd5UTHHNw7BV3c8PoKZ6kLBGBCqx9kGFZKErUm2k21VQODvoAF9ZdOxhxN0cwaD+
         IjRWDGrYEP3EoeyENIQ9tYiAN2PfER7eRZ9DPH5o=
Date:   Tue, 13 Aug 2019 15:37:37 -0700
From:   akpm@linux-foundation.org
To:     william.kucharski@oracle.com, tsoni@codeaurora.org,
        stable@vger.kernel.org, psodagud@codeaurora.org,
        keescook@chromium.org, gregkh@linuxfoundation.org,
        isaacm@codeaurora.org, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 11/18] mm/usercopy: use memory range to be accessed
 for wraparound check
Message-ID: <20190813223737.DHDZP%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
