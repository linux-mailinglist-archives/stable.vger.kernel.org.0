Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68FE026F107
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgIRCsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:48:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:32938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727322AbgIRCJV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:09:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B2FD235F9;
        Fri, 18 Sep 2020 02:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394960;
        bh=v1ywKTL+i+a9hYdP9thlSZcryxbdVaiCgD/tpqVL3/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tZx48ntY1nd+7gkqSOEbYir5UafqSuVAN3MAFwSy+LBKMPb8ox6q4DUsRASu8dhV6
         AEGoq3NtNGD6HSyUSXUyFCgUIX7xIQfANgXOTmDodzHDDzxaFlk9+iisCQCFS5OSxe
         ESUI6B/GiK7tfs5qYZBGPMGFEgwjuylkFM/guoXc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Averin <vvs@virtuozzo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jann Horn <jannh@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 4.19 066/206] mm/swapfile.c: swap_next should increase position index
Date:   Thu, 17 Sep 2020 22:05:42 -0400
Message-Id: <20200918020802.2065198-66-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit 10c8d69f314d557d94d74ec492575ae6a4f1eb1c ]

If seq_file .next fuction does not change position index, read after
some lseek can generate unexpected output.

In Aug 2018 NeilBrown noticed commit 1f4aace60b0e ("fs/seq_file.c:
simplify seq_file iteration code and interface") "Some ->next functions
do not increment *pos when they return NULL...  Note that such ->next
functions are buggy and should be fixed.  A simple demonstration is

  dd if=/proc/swaps bs=1000 skip=1

Choose any block size larger than the size of /proc/swaps.  This will
always show the whole last line of /proc/swaps"

Described problem is still actual.  If you make lseek into middle of
last output line following read will output end of last line and whole
last line once again.

  $ dd if=/proc/swaps bs=1  # usual output
  Filename				Type		Size	Used	Priority
  /dev/dm-0                               partition	4194812	97536	-2
  104+0 records in
  104+0 records out
  104 bytes copied

  $ dd if=/proc/swaps bs=40 skip=1    # last line was generated twice
  dd: /proc/swaps: cannot skip to specified offset
  v/dm-0                               partition	4194812	97536	-2
  /dev/dm-0                               partition	4194812	97536	-2
  3+1 records in
  3+1 records out
  131 bytes copied

https://bugzilla.kernel.org/show_bug.cgi?id=206283

Link: http://lkml.kernel.org/r/bd8cfd7b-ac95-9b91-f9e7-e8438bd5047d@virtuozzo.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jann Horn <jannh@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/swapfile.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 0047dcaf93697..c3684cfa9534e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2738,10 +2738,10 @@ static void *swap_next(struct seq_file *swap, void *v, loff_t *pos)
 	else
 		type = si->type + 1;
 
+	++(*pos);
 	for (; (si = swap_type_to_swap_info(type)); type++) {
 		if (!(si->flags & SWP_USED) || !si->swap_map)
 			continue;
-		++*pos;
 		return si;
 	}
 
-- 
2.25.1

