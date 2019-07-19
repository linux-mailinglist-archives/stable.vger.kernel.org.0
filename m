Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94EB76DE3B
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732513AbfGSEHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:07:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731433AbfGSEHI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:07:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7557C2189F;
        Fri, 19 Jul 2019 04:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509227;
        bh=NyuydwBSzOfwRJhUsYp/J3h4loV47/KBC5aTmt63J2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bIYDr8RRt4ZJXgo758QhOly1m6iiE9lTKGs6a4ZmfZ9VvIZ5ZeubOW/ABGFkr8E5H
         fc4Zr7tdWphPVdzSYJ6IEwKo/O3bg3+l13JeYODgN7D2R/oH8s7ygGqUOttsjMzOJE
         3ZGVyZXdhFhGImqeH7J4ral0iztwysJnEEcwsAzQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Roman Gushchin <guro@fb.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Michal Hocko <mhocko@suse.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 135/141] proc: use down_read_killable mmap_sem for /proc/pid/clear_refs
Date:   Fri, 19 Jul 2019 00:02:40 -0400
Message-Id: <20190719040246.15945-135-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040246.15945-1-sashal@kernel.org>
References: <20190719040246.15945-1-sashal@kernel.org>
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

[ Upstream commit c46038017fbdcac627b670c9d4176f1d0c2f5fa3 ]

Do not remain stuck forever if something goes wrong.  Using a killable
lock permits cleanup of stuck tasks and simplifies investigation.

Replace the only unkillable mmap_sem lock in clear_refs_write().

Link: http://lkml.kernel.org/r/156007493826.3335.5424884725467456239.stgit@buzz
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Reviewed-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/task_mmu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 8b1376c42647..d544ab2e4210 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1136,7 +1136,10 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 			goto out_mm;
 		}
 
-		down_read(&mm->mmap_sem);
+		if (down_read_killable(&mm->mmap_sem)) {
+			count = -EINTR;
+			goto out_mm;
+		}
 		tlb_gather_mmu(&tlb, mm, 0, -1);
 		if (type == CLEAR_REFS_SOFT_DIRTY) {
 			for (vma = mm->mmap; vma; vma = vma->vm_next) {
-- 
2.20.1

