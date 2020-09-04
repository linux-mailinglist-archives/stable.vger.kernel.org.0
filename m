Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5F525DB60
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 16:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730767AbgIDOVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 10:21:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730455AbgIDNeX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 09:34:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2F2821582;
        Fri,  4 Sep 2020 13:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599226257;
        bh=wvxtajZLIXfuNmxZJFRiIF+SaRJ8cKhztaeZ5ho8vSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wZHRpDb2i3nlvTU6bfSEM/HUQ/rL7EUZH2+1BJJPU80LdC+5021ICTi/88lJYqoOQ
         BjAQDV/k6z3yXxvdtkkTZfyRANS7Vq/Q6PSSXC3BWXo8dZcIXgUgLzPo0HcKjL01wQ
         nC5L5bhhu86OHxoKSOJsjkkO6gbK2MIgENdzrJxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        John Hubbard <jhubbard@nvidia.com>,
        Andy Lutomirski <luto@kernel.org>, x86@kernel.org,
        Jann Horn <jannh@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.8 04/17] mm: fix pin vs. gup mismatch with gate pages
Date:   Fri,  4 Sep 2020 15:30:03 +0200
Message-Id: <20200904120258.196815367@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200904120257.983551609@linuxfoundation.org>
References: <20200904120257.983551609@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Hansen <dave.hansen@linux.intel.com>

commit 9fa2dd946743ae6f30dc4830da19147bf100a7f2 upstream.

Gate pages were missed when converting from get to pin_user_pages().
This can lead to refcount imbalances.  This is reliably and quickly
reproducible running the x86 selftests when vsyscall=emulate is enabled
(the default).  Fix by using try_grab_page() with appropriate flags
passed.

The long story:

Today, pin_user_pages() and get_user_pages() are similar interfaces for
manipulating page reference counts.  However, "pins" use a "bias" value
and manipulate the actual reference count by 1024 instead of 1 used by
plain "gets".

That means that pin_user_pages() must be matched with unpin_user_pages()
and can't be mixed with a plain put_user_pages() or put_page().

Enter gate pages, like the vsyscall page.  They are pages usually in the
kernel image, but which are mapped to userspace.  Userspace is allowed
access to them, including interfaces using get/pin_user_pages().  The
refcount of these kernel pages is manipulated just like a normal user
page on the get/pin side so that the put/unpin side can work the same
for normal user pages or gate pages.

get_gate_page() uses try_get_page() which only bumps the refcount by
1, not 1024, even if called in the pin_user_pages() path.  If someone
pins a gate page, this happens:

	pin_user_pages()
		get_gate_page()
			try_get_page() // bump refcount +1
	... some time later
	unpin_user_pages()
		page_ref_sub_and_test(page, 1024))

... and boom, we get a refcount off by 1023.  This is reliably and
quickly reproducible running the x86 selftests when booted with
vsyscall=emulate (the default).  The selftests use ptrace(), but I
suspect anything using pin_user_pages() on gate pages could hit this.

To fix it, simply use try_grab_page() instead of try_get_page(), and
pass 'gup_flags' in so that FOLL_PIN can be respected.

This bug traces back to the very beginning of the FOLL_PIN support in
commit 3faa52c03f44 ("mm/gup: track FOLL_PIN pages"), which showed up in
the 5.7 release.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Fixes: 3faa52c03f44 ("mm/gup: track FOLL_PIN pages")
Reported-by: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Andy Lutomirski <luto@kernel.org>
Cc: x86@kernel.org
Cc: Jann Horn <jannh@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c
+++ b/mm/gup.c
@@ -843,7 +843,7 @@ static int get_gate_page(struct mm_struc
 			goto unmap;
 		*page = pte_page(*pte);
 	}
-	if (unlikely(!try_get_page(*page))) {
+	if (unlikely(!try_grab_page(*page, gup_flags))) {
 		ret = -ENOMEM;
 		goto unmap;
 	}


