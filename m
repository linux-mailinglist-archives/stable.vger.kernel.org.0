Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8AD7981A
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389716AbfG2Tnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:43:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389703AbfG2Tnt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:43:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CB6B2054F;
        Mon, 29 Jul 2019 19:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429428;
        bh=a6lC2IY5cl8rBIt09mHAn0ZYddmAartBKkgpZCHNYjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oq/EV3SYPZquawfSP023vTXBz205a0NtCPlH1vrIet6ukhotzYjttMWAThJvJsv/p
         6zhjz7khuv8VGOGV5xUdkt6uPG1plLHngakW3vn0gjnjNIgmYJhTMuFTb/67G9KEon
         1kTPWuFJPbc7ZFezH75A+4VcUckEMUWxK3QZuluc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
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
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 094/113] proc: use down_read_killable mmap_sem for /proc/pid/maps
Date:   Mon, 29 Jul 2019 21:23:01 +0200
Message-Id: <20190729190717.991622786@linuxfoundation.org>
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

[ Upstream commit 8a713e7df3352b8d9392476e9cf29e4e185dac32 ]

Do not remain stuck forever if something goes wrong.  Using a killable
lock permits cleanup of stuck tasks and simplifies investigation.

This function is also used for /proc/pid/smaps.

Link: http://lkml.kernel.org/r/156007493160.3335.14447544314127417266.stgit@buzz
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
 fs/proc/task_mmu.c   | 6 +++++-
 fs/proc/task_nommu.c | 6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 195fbbaf77d4..71aba44c4fa6 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -166,7 +166,11 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
 	if (!mm || !mmget_not_zero(mm))
 		return NULL;
 
-	down_read(&mm->mmap_sem);
+	if (down_read_killable(&mm->mmap_sem)) {
+		mmput(mm);
+		return ERR_PTR(-EINTR);
+	}
+
 	hold_task_mempolicy(priv);
 	priv->tail_vma = get_gate_vma(mm);
 
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 0b63d68dedb2..5161894a6d62 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -211,7 +211,11 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 	if (!mm || !mmget_not_zero(mm))
 		return NULL;
 
-	down_read(&mm->mmap_sem);
+	if (down_read_killable(&mm->mmap_sem)) {
+		mmput(mm);
+		return ERR_PTR(-EINTR);
+	}
+
 	/* start from the Nth VMA */
 	for (p = rb_first(&mm->mm_rb); p; p = rb_next(p))
 		if (n-- == 0)
-- 
2.20.1



