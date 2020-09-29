Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF2ED27C508
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729266AbgI2L3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:29:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729362AbgI2L3J (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:29:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5777208B8;
        Tue, 29 Sep 2020 11:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378588;
        bh=v1ywKTL+i+a9hYdP9thlSZcryxbdVaiCgD/tpqVL3/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hq2J8AHZQa5Kc/8SHgybrVpeLvOckIOmvNkD0s6U7hub8v5KlVz27EcENpz2QWv7S
         FX3E7cuOj3YfIW5wUKh5dru6Rp8lyIqmkJJR+5nDaOySBTefv0jEnMcEjckFiA18IB
         OHnn9FoxfUk7i93O+zoAqfjNkdBeMex/Id9VRW+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jann Horn <jannh@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 067/245] mm/swapfile.c: swap_next should increase position index
Date:   Tue, 29 Sep 2020 12:58:38 +0200
Message-Id: <20200929105950.250126963@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



