Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABF1699B05
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbfHVRSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:18:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390269AbfHVRIU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:20 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D89F823404;
        Thu, 22 Aug 2019 17:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493700;
        bh=VsA1tRE7LS3MYwuj23vcDHayJKy/yZnl8/Iot3W2XJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UHAlcFdSi6ydMBSIkDFrXsfAftRxZkwF+uERuKLzOXWBaKRqoC11Ii4AqbbYp9hhE
         OiuF+ptu+tEBMeKLJrQbv31WAPJ0s+KbV0tOR0l5dAiRyKMIiYSBfmU0IOYisTT5dm
         RgJwKGhTmpdq+KcVvvqfpr+3Q+OzeUZ2usuzR6y0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Isaac J. Manjarres" <isaacm@codeaurora.org>,
        Prasad Sodagudi <psodagud@codeaurora.org>,
        William Kucharski <william.kucharski@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Trilok Soni <tsoni@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.2 010/135] mm/usercopy: use memory range to be accessed for wraparound check
Date:   Thu, 22 Aug 2019 13:06:06 -0400
Message-Id: <20190822170811.13303-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Isaac J. Manjarres" <isaacm@codeaurora.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/usercopy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/usercopy.c b/mm/usercopy.c
index 2a09796edef8d..98e924864554c 100644
--- a/mm/usercopy.c
+++ b/mm/usercopy.c
@@ -147,7 +147,7 @@ static inline void check_bogus_address(const unsigned long ptr, unsigned long n,
 				       bool to_user)
 {
 	/* Reject if object wraps past end of memory. */
-	if (ptr + n < ptr)
+	if (ptr + (n - 1) < ptr)
 		usercopy_abort("wrapped address", NULL, to_user, 0, ptr + n);
 
 	/* Reject if NULL or ZERO-allocation. */
-- 
2.20.1

