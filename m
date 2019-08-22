Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6852899CA5
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390013AbfHVRf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:35:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391783AbfHVRY5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:24:57 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BDAC2341C;
        Thu, 22 Aug 2019 17:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494696;
        bh=tCn+yBMdeNEJkOqrVkSmW+4rs9IZI/a8BsEGVLrqZac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VReyHMTQnV1oDAApR8YYXJHuZtCtePCQbCQz7ujVKkEfGEPrR9V1jgWKuZCJFzAuz
         dBXNs9ZvqE8QTbuw/XDmyzEiXS6oNGfbkcwZQ0BRSYOJ8lt/DzaRVcb16pgHiHWdCO
         qqNR4GBNysMXvoW/1z96Ny8lvLo/oVT4whwpbIoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prasad Sodagudi <psodagud@codeaurora.org>,
        "Isaac J. Manjarres" <isaacm@codeaurora.org>,
        William Kucharski <william.kucharski@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        Trilok Soni <tsoni@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 03/71] mm/usercopy: use memory range to be accessed for wraparound check
Date:   Thu, 22 Aug 2019 10:18:38 -0700
Message-Id: <20190822171726.369782143@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171726.131957995@linuxfoundation.org>
References: <20190822171726.131957995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Isaac J. Manjarres <isaacm@codeaurora.org>

commit 951531691c4bcaa59f56a316e018bc2ff1ddf855 upstream.

Currently, when checking to see if accessing n bytes starting at address
"ptr" will cause a wraparound in the memory addresses, the check in
check_bogus_address() adds an extra byte, which is incorrect, as the
range of addresses that will be accessed is [ptr, ptr + (n - 1)].

This can lead to incorrectly detecting a wraparound in the memory
address, when trying to read 4 KB from memory that is mapped to the the
last possible page in the virtual address space, when in fact, accessing
that range of memory would not cause a wraparound to occur.

Use the memory range that will actually be accessed when considering if
accessing a certain amount of bytes will cause the memory address to
wrap around.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[kees: backport to v4.14]
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/usercopy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/usercopy.c
+++ b/mm/usercopy.c
@@ -121,7 +121,7 @@ static inline const char *check_kernel_t
 static inline const char *check_bogus_address(const void *ptr, unsigned long n)
 {
 	/* Reject if object wraps past end of memory. */
-	if ((unsigned long)ptr + n < (unsigned long)ptr)
+	if ((unsigned long)ptr + (n - 1) < (unsigned long)ptr)
 		return "<wrapped address>";
 
 	/* Reject if NULL or ZERO-allocation. */


