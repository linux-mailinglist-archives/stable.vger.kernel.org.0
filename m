Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88C144A34C
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243001AbhKIB0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:26:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:50112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243203AbhKIBXO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:23:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DB2A61B1C;
        Tue,  9 Nov 2021 01:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420133;
        bh=G136d21XpvbpRb519IU8YlS4MWDpNLHMbA3sA7LK1ao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hef9fhaGHdIdI4aUyvT0mcDnk9xOVUt0+ZOvhUoZH4zxQu8JnfachEJz3GIeFRNa1
         XwQQVvuOZcEsRz8GvuhDV4JgV+FWmdDMyJyJ3JkeXZrnN+UHbj5TEqXLssz6bsQ+uE
         uK4XPExqJRS5AUFPVL1DjX6MePiU8ui69/ZNe+Y1OqKWEGhC8W5EEBwlZQfoqSG/CA
         QSJ474Qt8bX4rIIp+M45KvYKGzZZle1lLNnjRb8R/lJGNbgiLgbX8ALwpSNeMwO3z+
         56uSGAMS4ubZIRAq3vBWGV6CQtTVv33UFbAMagVbnCcUJul2hr+WvN0GytNt6c5hBk
         P2gq5/U5c6cuA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kalesh Singh <kaleshsingh@google.com>,
        kernel test robot <lkp@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com
Subject: [PATCH AUTOSEL 4.9 24/33] tracing/cfi: Fix cmp_entries_* functions signature mismatch
Date:   Mon,  8 Nov 2021 20:07:58 -0500
Message-Id: <20211109010807.1191567-24-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010807.1191567-1-sashal@kernel.org>
References: <20211109010807.1191567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kalesh Singh <kaleshsingh@google.com>

[ Upstream commit 7ce1bb83a14019f8c396d57ec704d19478747716 ]

If CONFIG_CFI_CLANG=y, attempting to read an event histogram will cause
the kernel to panic due to failed CFI check.

    1. echo 'hist:keys=common_pid' >> events/sched/sched_switch/trigger
    2. cat events/sched/sched_switch/hist
    3. kernel panics on attempting to read hist

This happens because the sort() function expects a generic
int (*)(const void *, const void *) pointer for the compare function.
To prevent this CFI failure, change tracing map cmp_entries_* function
signatures to match this.

Also, fix the build error reported by the kernel test robot [1].

[1] https://lore.kernel.org/r/202110141140.zzi4dRh4-lkp@intel.com/

Link: https://lkml.kernel.org/r/20211014045217.3265162-1-kaleshsingh@google.com

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/tracing_map.c | 40 ++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/kernel/trace/tracing_map.c b/kernel/trace/tracing_map.c
index 35b2ba07f3c6f..379db35838b64 100644
--- a/kernel/trace/tracing_map.c
+++ b/kernel/trace/tracing_map.c
@@ -703,29 +703,35 @@ int tracing_map_init(struct tracing_map *map)
 	return err;
 }
 
-static int cmp_entries_dup(const struct tracing_map_sort_entry **a,
-			   const struct tracing_map_sort_entry **b)
+static int cmp_entries_dup(const void *A, const void *B)
 {
+	const struct tracing_map_sort_entry *a, *b;
 	int ret = 0;
 
-	if (memcmp((*a)->key, (*b)->key, (*a)->elt->map->key_size))
+	a = *(const struct tracing_map_sort_entry **)A;
+	b = *(const struct tracing_map_sort_entry **)B;
+
+	if (memcmp(a->key, b->key, a->elt->map->key_size))
 		ret = 1;
 
 	return ret;
 }
 
-static int cmp_entries_sum(const struct tracing_map_sort_entry **a,
-			   const struct tracing_map_sort_entry **b)
+static int cmp_entries_sum(const void *A, const void *B)
 {
 	const struct tracing_map_elt *elt_a, *elt_b;
+	const struct tracing_map_sort_entry *a, *b;
 	struct tracing_map_sort_key *sort_key;
 	struct tracing_map_field *field;
 	tracing_map_cmp_fn_t cmp_fn;
 	void *val_a, *val_b;
 	int ret = 0;
 
-	elt_a = (*a)->elt;
-	elt_b = (*b)->elt;
+	a = *(const struct tracing_map_sort_entry **)A;
+	b = *(const struct tracing_map_sort_entry **)B;
+
+	elt_a = a->elt;
+	elt_b = b->elt;
 
 	sort_key = &elt_a->map->sort_key;
 
@@ -742,18 +748,21 @@ static int cmp_entries_sum(const struct tracing_map_sort_entry **a,
 	return ret;
 }
 
-static int cmp_entries_key(const struct tracing_map_sort_entry **a,
-			   const struct tracing_map_sort_entry **b)
+static int cmp_entries_key(const void *A, const void *B)
 {
 	const struct tracing_map_elt *elt_a, *elt_b;
+	const struct tracing_map_sort_entry *a, *b;
 	struct tracing_map_sort_key *sort_key;
 	struct tracing_map_field *field;
 	tracing_map_cmp_fn_t cmp_fn;
 	void *val_a, *val_b;
 	int ret = 0;
 
-	elt_a = (*a)->elt;
-	elt_b = (*b)->elt;
+	a = *(const struct tracing_map_sort_entry **)A;
+	b = *(const struct tracing_map_sort_entry **)B;
+
+	elt_a = a->elt;
+	elt_b = b->elt;
 
 	sort_key = &elt_a->map->sort_key;
 
@@ -926,10 +935,8 @@ static void sort_secondary(struct tracing_map *map,
 			   struct tracing_map_sort_key *primary_key,
 			   struct tracing_map_sort_key *secondary_key)
 {
-	int (*primary_fn)(const struct tracing_map_sort_entry **,
-			  const struct tracing_map_sort_entry **);
-	int (*secondary_fn)(const struct tracing_map_sort_entry **,
-			    const struct tracing_map_sort_entry **);
+	int (*primary_fn)(const void *, const void *);
+	int (*secondary_fn)(const void *, const void *);
 	unsigned i, start = 0, n_sub = 1;
 
 	if (is_key(map, primary_key->field_idx))
@@ -998,8 +1005,7 @@ int tracing_map_sort_entries(struct tracing_map *map,
 			     unsigned int n_sort_keys,
 			     struct tracing_map_sort_entry ***sort_entries)
 {
-	int (*cmp_entries_fn)(const struct tracing_map_sort_entry **,
-			      const struct tracing_map_sort_entry **);
+	int (*cmp_entries_fn)(const void *, const void *);
 	struct tracing_map_sort_entry *sort_entry, **entries;
 	int i, n_entries, ret;
 
-- 
2.33.0

