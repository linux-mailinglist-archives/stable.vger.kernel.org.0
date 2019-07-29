Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 837967982D
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389855AbfG2UFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 16:05:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389203AbfG2Tn4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:43:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 591A520C01;
        Mon, 29 Jul 2019 19:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429435;
        bh=QlRxDaIWmUxVA6DHWBBI528oV9qu+xRdOM6oOA2tRzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g4KsCGiRJHyBUSKzY5jGo6+j0TM5ybmuBe/3qvhWHaONbRag3tSylvavJrLonk/Yo
         3Gt+5R/sS89DhaPi202AmS8hg4l8cttmIaEnSywToCVLwuDFOageQgbdNPmUbkLG2K
         iHA2uvqB048i1T9Aj30H4Le1YACZQjMwXl5SfTkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Roman Gushchin <guro@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 096/113] mm: use down_read_killable for locking mmap_sem in access_remote_vm
Date:   Mon, 29 Jul 2019 21:23:03 +0200
Message-Id: <20190729190718.502020243@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190655.455345569@linuxfoundation.org>
References: <20190729190655.455345569@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1e426fe28261b03f297992e89da3320b42816f4e ]

This function is used by ptrace and proc files like /proc/pid/cmdline and
/proc/pid/environ.

Access_remote_vm never returns error codes, all errors are ignored and
only size of successfully read data is returned.  So, if current task was
killed we'll simply return 0 (bytes read).

Mmap_sem could be locked for a long time or forever if something goes
wrong.  Using a killable lock permits cleanup of stuck tasks and
simplifies investigation.

Link: http://lkml.kernel.org/r/156007494202.3335.16782303099589302087.stgit@buzz
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory.c | 4 +++-
 mm/nommu.c  | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index e0010cb870e0..fb5655b518c9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4491,7 +4491,9 @@ int __access_remote_vm(struct task_struct *tsk, struct mm_struct *mm,
 	void *old_buf = buf;
 	int write = gup_flags & FOLL_WRITE;
 
-	down_read(&mm->mmap_sem);
+	if (down_read_killable(&mm->mmap_sem))
+		return 0;
+
 	/* ignore errors, just check how much was successfully transferred */
 	while (len) {
 		int bytes, ret, offset;
diff --git a/mm/nommu.c b/mm/nommu.c
index e4aac33216ae..1d63ecfc98c5 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1779,7 +1779,8 @@ int __access_remote_vm(struct task_struct *tsk, struct mm_struct *mm,
 	struct vm_area_struct *vma;
 	int write = gup_flags & FOLL_WRITE;
 
-	down_read(&mm->mmap_sem);
+	if (down_read_killable(&mm->mmap_sem))
+		return 0;
 
 	/* the access must start within one of the target process's mappings */
 	vma = find_vma(mm, addr);
-- 
2.20.1



