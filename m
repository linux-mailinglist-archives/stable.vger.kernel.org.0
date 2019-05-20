Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDB0D236FB
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387808AbfETMTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:19:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387799AbfETMTU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:19:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95079208C3;
        Mon, 20 May 2019 12:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354759;
        bh=FnOiAWCxbxKZVe4E+ZcIN19Am0EYnQ0noptC7Y+yIqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VPbZY09TVnSmrhc6aH244GWjaUKQ2Myib2Yn3zRIs+OphyhpgcWon43tpK5DzSnw9
         yrCXeJ2O/dQCG0AqSdBu5TIpbYm+MY14NsLpSyswdHcEozv7GY1AMVHrSalJ3zYvHr
         6zwp8YriDCeRI1hZB0i5dK0usxg2Ao+Ll3e4h6gY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Vlastimil Babka <vbabka@suse.cz>,
        Josh Snyder <joshs@netflix.com>,
        Michal Hocko <mhocko@suse.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Dave Chinner <david@fromorbit.com>,
        Kevin Easton <kevin@guarana.org>,
        Matthew Wilcox <willy@infradead.org>,
        Cyril Hrubis <chrubis@suse.cz>, Tejun Heo <tj@kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Daniel Gruss <daniel@gruss.cc>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 4.14 32/63] mm/mincore.c: make mincore() more conservative
Date:   Mon, 20 May 2019 14:14:11 +0200
Message-Id: <20190520115234.872323738@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115231.137981521@linuxfoundation.org>
References: <20190520115231.137981521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/mincore.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -169,6 +169,22 @@ out:
 	return 0;
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
@@ -189,8 +205,13 @@ static long do_mincore(unsigned long add
 	vma = find_vma(current->mm, addr);
 	if (!vma || addr < vma->vm_start)
 		return -ENOMEM;
-	mincore_walk.mm = vma->vm_mm;
 	end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
+	if (!can_do_mincore(vma)) {
+		unsigned long pages = DIV_ROUND_UP(end - addr, PAGE_SIZE);
+		memset(vec, 1, pages);
+		return pages;
+	}
+	mincore_walk.mm = vma->vm_mm;
 	err = walk_page_range(addr, end, &mincore_walk);
 	if (err < 0)
 		return err;


