Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDAE360DDC
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234437AbhDOPGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:06:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234966AbhDOPFA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:05:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E9BA613F4;
        Thu, 15 Apr 2021 14:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498737;
        bh=Z7ONs6k3qz0xAjbZTTMpbM8sdi5E0lflFikD+9s8dmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MYVyvVReAN0asRxsRwplYeObbwzGEXxf0q/2eME4VvbmhtRvfXrdgx4y+DTw2ZOPn
         cLsi6sZWll7A6de39ak0C6aJ6U+NTfaZ9nMCx6k9vQ2uTAk4Dq3qC50zQ9uu0pMMXh
         JK1i0MKwEJ32Gvtjq0Gcrex03/qxoj+7Fq02N6Gk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 07/23] ftrace: Check if pages were allocated before calling free_pages()
Date:   Thu, 15 Apr 2021 16:48:14 +0200
Message-Id: <20210415144413.386579712@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.146131392@linuxfoundation.org>
References: <20210415144413.146131392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

[ Upstream commit 59300b36f85f254260c81d9dd09195fa49eb0f98 ]

It is possible that on error pg->size can be zero when getting its order,
which would return a -1 value. It is dangerous to pass in an order of -1
to free_pages(). Check if order is greater than or equal to zero before
calling free_pages().

Link: https://lore.kernel.org/lkml/20210330093916.432697c7@gandalf.local.home/

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ftrace.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index b7e29db127fa..3ba52d4e1314 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3231,7 +3231,8 @@ ftrace_allocate_pages(unsigned long num_to_init)
 	pg = start_pg;
 	while (pg) {
 		order = get_count_order(pg->size / ENTRIES_PER_PAGE);
-		free_pages((unsigned long)pg->records, order);
+		if (order >= 0)
+			free_pages((unsigned long)pg->records, order);
 		start_pg = pg->next;
 		kfree(pg);
 		pg = start_pg;
@@ -6451,7 +6452,8 @@ void ftrace_release_mod(struct module *mod)
 		clear_mod_from_hashes(pg);
 
 		order = get_count_order(pg->size / ENTRIES_PER_PAGE);
-		free_pages((unsigned long)pg->records, order);
+		if (order >= 0)
+			free_pages((unsigned long)pg->records, order);
 		tmp_page = pg->next;
 		kfree(pg);
 		ftrace_number_of_pages -= 1 << order;
@@ -6811,7 +6813,8 @@ void ftrace_free_mem(struct module *mod, void *start_ptr, void *end_ptr)
 		if (!pg->index) {
 			*last_pg = pg->next;
 			order = get_count_order(pg->size / ENTRIES_PER_PAGE);
-			free_pages((unsigned long)pg->records, order);
+			if (order >= 0)
+				free_pages((unsigned long)pg->records, order);
 			ftrace_number_of_pages -= 1 << order;
 			ftrace_number_of_groups--;
 			kfree(pg);
-- 
2.30.2



