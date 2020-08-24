Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B516324F8FF
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbgHXIq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:46:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729343AbgHXIq0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:46:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7270206F0;
        Mon, 24 Aug 2020 08:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258786;
        bh=1RUvlJj4UOjBfLIGHgxFknh/nqgcIeP7tjGttnAp8Oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z0iuatpNFbQ6+p7OixpymmSQTZYYwcc+inqXkPgJghqEeAudQYro6vZOMyghANyAk
         3Q8GMOadiS7BkUcZHMOyprMIl3bVJk66nc5pNZksDRJoZm6oq9OSuOALRthgAoACmZ
         rj6JDGG5Q0h0w955WVCcHhADHW7j5o8hdJ5YHixg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yang Shi <shy828301@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Song Liu <songliubraving@fb.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Eric Dumazet <edumazet@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 015/107] khugepaged: adjust VM_BUG_ON_MM() in __khugepaged_enter()
Date:   Mon, 24 Aug 2020 10:29:41 +0200
Message-Id: <20200824082405.826004689@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082405.020301642@linuxfoundation.org>
References: <20200824082405.020301642@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

[ Upstream commit f3f99d63a8156c7a4a6b20aac22b53c5579c7dc1 ]

syzbot crashes on the VM_BUG_ON_MM(khugepaged_test_exit(mm), mm) in
__khugepaged_enter(): yes, when one thread is about to dump core, has set
core_state, and is waiting for others, another might do something calling
__khugepaged_enter(), which now crashes because I lumped the core_state
test (known as "mmget_still_valid") into khugepaged_test_exit().  I still
think it's best to lump them together, so just in this exceptional case,
check mm->mm_users directly instead of khugepaged_test_exit().

Fixes: bbe98f9cadff ("khugepaged: khugepaged_test_exit() check mmget_still_valid()")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Yang Shi <shy828301@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: <stable@vger.kernel.org>	[4.8+]
Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2008141503370.18085@eggly.anvils
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/khugepaged.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 76e3e90dbc16e..3623d1c5343f2 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -438,7 +438,7 @@ int __khugepaged_enter(struct mm_struct *mm)
 		return -ENOMEM;
 
 	/* __khugepaged_exit() must not run from under us */
-	VM_BUG_ON_MM(khugepaged_test_exit(mm), mm);
+	VM_BUG_ON_MM(atomic_read(&mm->mm_users) == 0, mm);
 	if (unlikely(test_and_set_bit(MMF_VM_HUGEPAGE, &mm->flags))) {
 		free_mm_slot(mm_slot);
 		return 0;
-- 
2.25.1



