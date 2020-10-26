Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026AA299B6E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 00:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409196AbgJZXvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:51:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409370AbgJZXvS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:51:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A2822075B;
        Mon, 26 Oct 2020 23:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756277;
        bh=s6BpDc92vwIIqyKivdzAUxKkYDhM+Pq/e4ELnmq5AmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ILWenKOdC+HQyKbTWoiYka+lmZImFhdZY4wdLbWAbJff+AUC3glUJpxwcNHVTiYnX
         kZSeOuHnp7ySXT6CMv4SnFCoSifPjpqLJlB9r8rNsDtHa8h834obF0KgJWLNC+ysJ3
         8irpSU4bKjuxCf+y7d+ktrWlcy8a+81IS+8SVBd8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jann Horn <jannh@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 108/147] binfmt_elf: take the mmap lock around find_extend_vma()
Date:   Mon, 26 Oct 2020 19:48:26 -0400
Message-Id: <20201026234905.1022767-108-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

[ Upstream commit b2767d97f5ff758250cf28684aaa48bbfd34145f ]

create_elf_tables() runs after setup_new_exec(), so other tasks can
already access our new mm and do things like process_madvise() on it.  (At
the time I'm writing this commit, process_madvise() is not in mainline
yet, but has been in akpm's tree for some time.)

While I believe that there are currently no APIs that would actually allow
another process to mess up our VMA tree (process_madvise() is limited to
MADV_COLD and MADV_PAGEOUT, and uring and userfaultfd cannot reach an mm
under which no syscalls have been executed yet), this seems like an
accident waiting to happen.

Let's make sure that we always take the mmap lock around GUP paths as long
as another process might be able to see the mm.

(Yes, this diff looks suspicious because we drop the lock before doing
anything with `vma`, but that's because we actually don't do anything with
it apart from the NULL check.)

Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Michel Lespinasse <walken@google.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Link: https://lkml.kernel.org/r/CAG48ez1-PBCdv3y8pn-Ty-b+FmBSLwDuVKFSt8h7wARLy0dF-Q@mail.gmail.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/binfmt_elf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 13d053982dd73..02ad1a1e3781f 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -309,7 +309,10 @@ create_elf_tables(struct linux_binprm *bprm, const struct elfhdr *exec,
 	 * Grow the stack manually; some architectures have a limit on how
 	 * far ahead a user-space access may be in order to grow the stack.
 	 */
+	if (mmap_read_lock_killable(mm))
+		return -EINTR;
 	vma = find_extend_vma(mm, bprm->p);
+	mmap_read_unlock(mm);
 	if (!vma)
 		return -EFAULT;
 
-- 
2.25.1

