Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAC184A404
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 16:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729078AbfFRO3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 10:29:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50488 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729383AbfFRO3G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jun 2019 10:29:06 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hdF6e-0007nI-Cm; Tue, 18 Jun 2019 15:29:04 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hdF6d-0000HJ-Ce; Tue, 18 Jun 2019 15:29:03 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Hugh Dickins" <hughd@google.com>,
        "Oleg Nesterov" <oleg@redhat.com>,
        "Andy Lutomirski" <luto@kernel.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Pavel Emelyanov" <xemul@parallels.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date:   Tue, 18 Jun 2019 15:28:02 +0100
Message-ID: <lsq.1560868082.752973508@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 01/10] mm: introduce vma_is_anonymous(vma) helper
In-Reply-To: <lsq.1560868079.359853905@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.69-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit b5330628546616af14ff23075fbf8d4ad91f6e25 upstream.

special_mapping_fault() is absolutely broken.  It seems it was always
wrong, but this didn't matter until vdso/vvar started to use more than
one page.

And after this change vma_is_anonymous() becomes really trivial, it
simply checks vm_ops == NULL.  However, I do think the helper makes
sense.  There are a lot of ->vm_ops != NULL checks, the helper makes the
caller's code more understandable (self-documented) and this is more
grep-friendly.

This patch (of 3):

Preparation.  Add the new simple helper, vma_is_anonymous(vma), and change
handle_pte_fault() to use it.  It will have more users.

The name is not accurate, say a hpet_mmap()'ed vma is not anonymous.
Perhaps it should be named vma_has_fault() instead.  But it matches the
logic in mmap.c/memory.c (see next changes).  "True" just means that a
page fault will use do_anonymous_page().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.16 as dependency of "mm/mincore.c: make mincore() more
 conservative"; adjusted context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/mm.h | 5 +++++
 mm/memory.c        | 8 ++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1241,6 +1241,11 @@ int get_cmdline(struct task_struct *task
 
 int vma_is_stack_for_task(struct vm_area_struct *vma, struct task_struct *t);
 
+static inline bool vma_is_anonymous(struct vm_area_struct *vma)
+{
+	return !vma->vm_ops;
+}
+
 extern unsigned long move_page_tables(struct vm_area_struct *vma,
 		unsigned long old_addr, struct vm_area_struct *new_vma,
 		unsigned long new_addr, unsigned long len,
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3105,12 +3105,12 @@ static int handle_pte_fault(struct mm_st
 	entry = *pte;
 	if (!pte_present(entry)) {
 		if (pte_none(entry)) {
-			if (vma->vm_ops)
+			if (vma_is_anonymous(vma))
+				return do_anonymous_page(mm, vma, address,
+							 pte, pmd, flags);
+			else
 				return do_fault(mm, vma, address, pte,
 						pmd, flags, entry);
-
-			return do_anonymous_page(mm, vma, address,
-						 pte, pmd, flags);
 		}
 		return do_swap_page(mm, vma, address,
 					pte, pmd, flags, entry);

