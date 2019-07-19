Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 933406DA7D
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730088AbfGSECe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:02:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:34502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730074AbfGSECd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:02:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 841E021852;
        Fri, 19 Jul 2019 04:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508953;
        bh=jcUkRjwMhQ/ORG8sZHca2w3d73uThSyyH5niWnxwa2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ew44vIQZSxDbfCGU+ruk3+waCnyK239Uipco9VjE/OAaa8MvLBM1IOi3urtHlUsId
         yoUMHC7gNt+rrJ3jUvQg7gxuSk6fc+RFpPBPhumy4XSuuqCObrTQkrS7j6nh18XcI3
         rL0zQvJDE8IRkCcByvFgWaJZVz1WqvIwNs+eXw38=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
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
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.2 170/171] mm: use down_read_killable for locking mmap_sem in access_remote_vm
Date:   Thu, 18 Jul 2019 23:56:41 -0400
Message-Id: <20190719035643.14300-170-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

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
index ddf20bd0c317..9a4401d21e94 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4349,7 +4349,9 @@ int __access_remote_vm(struct task_struct *tsk, struct mm_struct *mm,
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
index d8c02fbe03b5..b2823519f8cd 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1792,7 +1792,8 @@ int __access_remote_vm(struct task_struct *tsk, struct mm_struct *mm,
 	struct vm_area_struct *vma;
 	int write = gup_flags & FOLL_WRITE;
 
-	down_read(&mm->mmap_sem);
+	if (down_read_killable(&mm->mmap_sem))
+		return 0;
 
 	/* the access must start within one of the target process's mappings */
 	vma = find_vma(mm, addr);
-- 
2.20.1

