Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1956645BD39
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344403AbhKXMgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:36:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:49352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343608AbhKXMea (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:34:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E9A36137D;
        Wed, 24 Nov 2021 12:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756457;
        bh=G136d21XpvbpRb519IU8YlS4MWDpNLHMbA3sA7LK1ao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vw+Aep4/S06OUENbdjXcA0VnkOxBfwnTxlPBKNo5ldxh+svuqehK4IABfcgggMtZ+
         L+nDhO8UMcuJir7B2RH6RlwPGckhUX+lX9gbq90SihZgZbW0zdOyYWivZhwxjCzjIb
         Z3hcBWXMDXTt++LsHweiBfNdkrmY1PcAXGs3DMKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kalesh Singh <kaleshsingh@google.com>,
        kernel test robot <lkp@intel.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 094/251] tracing/cfi: Fix cmp_entries_* functions signature mismatch
Date:   Wed, 24 Nov 2021 12:55:36 +0100
Message-Id: <20211124115713.512611707@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



