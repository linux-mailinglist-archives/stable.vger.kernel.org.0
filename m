Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 528354A3F3
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 16:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729636AbfFRO3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 10:29:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50566 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729550AbfFRO3I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jun 2019 10:29:08 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hdF6e-0007nK-Cl; Tue, 18 Jun 2019 15:29:04 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hdF6d-0000HN-DL; Tue, 18 Jun 2019 15:29:03 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Matthew Wilcox" <willy@infradead.org>,
        "Michal Hocko" <mhocko@suse.com>,
        "Dave Chinner" <david@fromorbit.com>,
        "Kevin Easton" <kevin@guarana.org>,
        "Josh Snyder" <joshs@netflix.com>,
        "Andy Lutomirski" <luto@amacapital.net>,
        "Tejun Heo" <tj@kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Vlastimil Babka" <vbabka@suse.cz>,
        "Daniel Gruss" <daniel@gruss.cc>, "Cyril Hrubis" <chrubis@suse.cz>,
        "Jiri Kosina" <jkosina@suse.cz>
Date:   Tue, 18 Jun 2019 15:28:02 +0100
Message-ID: <lsq.1560868082.552948978@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 02/10] mm/mincore.c: make mincore() more conservative
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

From: Jiri Kosina <jkosina@suse.cz>

commit 134fca9063ad4851de767d1768180e5dede9a881 upstream.

The semantics of what mincore() considers to be resident is not
completely clear, but Linux has always (since 2.3.52, which is when
mincore() was initially done) treated it as "page is available in page
cache".

That's potentially a problem, as that [in]directly exposes
meta-information about pagecache / memory mapping state even about
memory not strictly belonging to the process executing the syscall,
opening possibilities for sidechannel attacks.

Change the semantics of mincore() so that it only reveals pagecache
information for non-anonymous mappings that belog to files that the
calling process could (if it tried to) successfully open for writing;
otherwise we'd be including shared non-exclusive mappings, which

 - is the sidechannel

 - is not the usecase for mincore(), as that's primarily used for data,
   not (shared) text

[jkosina@suse.cz: v2]
  Link: http://lkml.kernel.org/r/20190312141708.6652-2-vbabka@suse.cz
[mhocko@suse.com: restructure can_do_mincore() conditions]
Link: http://lkml.kernel.org/r/nycvar.YFH.7.76.1903062342020.19912@cbobk.fhfr.pm
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Josh Snyder <joshs@netflix.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Originally-by: Linus Torvalds <torvalds@linux-foundation.org>
Originally-by: Dominique Martinet <asmadeus@codewreck.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Kevin Easton <kevin@guarana.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Cyril Hrubis <chrubis@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Daniel Gruss <daniel@gruss.cc>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -212,6 +212,22 @@ static void mincore_page_range(struct vm
 	} while (pgd++, addr = next, addr != end);
 }
 
+static inline bool can_do_mincore(struct vm_area_struct *vma)
+{
+	if (vma_is_anonymous(vma))
+		return true;
+	if (!vma->vm_file)
+		return false;
+	/*
+	 * Reveal pagecache information only for non-anonymous mappings that
+	 * correspond to the files the calling process could (if tried) open
+	 * for writing; otherwise we'd be including shared non-exclusive
+	 * mappings, which opens a side channel.
+	 */
+	return inode_owner_or_capable(file_inode(vma->vm_file)) ||
+		inode_permission(file_inode(vma->vm_file), MAY_WRITE) == 0;
+}
+
 /*
  * Do a chunk of "sys_mincore()". We've already checked
  * all the arguments, we hold the mmap semaphore: we should
@@ -227,6 +243,11 @@ static long do_mincore(unsigned long add
 		return -ENOMEM;
 
 	end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
+	if (!can_do_mincore(vma)) {
+		unsigned long pages = DIV_ROUND_UP(end - addr, PAGE_SIZE);
+		memset(vec, 1, pages);
+		return pages;
+	}
 
 	if (is_vm_hugetlb_page(vma))
 		mincore_hugetlb_page_range(vma, addr, end, vec);

