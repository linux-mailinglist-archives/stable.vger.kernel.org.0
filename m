Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8923835441B
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242055AbhDEQE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:04:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241988AbhDEQEW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:04:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87C77613C5;
        Mon,  5 Apr 2021 16:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638656;
        bh=O+/UHaBVwZ0Em9A4LOIifx0V4lI/JkxP/Cl96bfofRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mdumTZMIJUaoQYlE9p3AOOx13/cbiSGLGnDyGDQhwV6x6uUBC8eiUU6Q3+4idQsar
         OoNgePy/8K382g0yXzMXsE/KgbiMgHg2yVO1jEX4Jtf+uMlHg2B7hqILskBn8sVVEH
         2YWjbQ0MKiLTQqwxfYvMAljZRhlmC10OrFbbuNIjcLbB78s6DBI+YzhhfHrGo3A3bI
         dGGS2err0x9lf3CqYSToIlQHlV9p03Fmqk7VUIv/EKvuLCpea6Wo2VWZR48iLZBrLG
         Ehy0ZqT0fJTkWnWNiCZ35aW8XqWT0pEAiMgYkoC6dynDrpeNSC2txG1ooEIexzk8fY
         AMWgw3zsNpzBA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.11 08/22] ftrace: Check if pages were allocated before calling free_pages()
Date:   Mon,  5 Apr 2021 12:03:51 -0400
Message-Id: <20210405160406.268132-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405160406.268132-1-sashal@kernel.org>
References: <20210405160406.268132-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

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

