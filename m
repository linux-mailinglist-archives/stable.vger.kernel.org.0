Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D949D35BE21
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238717AbhDLI5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238881AbhDLIzJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:55:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87CBC6137B;
        Mon, 12 Apr 2021 08:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217614;
        bh=/JcazcCzHo730u3J7iiQT6+DSlFqUEOkxez7IsSL9IY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nH5pJiYvbQGYGXjOZGblVRhZz0C/f0no7wZP4Nv9QfoXaqDTEBlcdG1vZUjhxeoj/
         Pe8WJyPm+OLQq1bUU5pi3+P9EcN9/OB6FPS01Tnnccxc2Pir4GszkVd3qYS8bn8zZM
         mquJsY4ysGF7Qzy0MpMvZahR/ZK463BuEHm8OdTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Gushchin <guro@fb.com>,
        Filipe Manana <fdmanana@suse.com>,
        Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 5.10 080/188] percpu: make pcpu_nr_empty_pop_pages per chunk type
Date:   Mon, 12 Apr 2021 10:39:54 +0200
Message-Id: <20210412084016.307117970@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Gushchin <guro@fb.com>

commit 0760fa3d8f7fceeea508b98899f1c826e10ffe78 upstream.

nr_empty_pop_pages is used to guarantee that there are some free
populated pages to satisfy atomic allocations. Accounted and
non-accounted allocations are using separate sets of chunks,
so both need to have a surplus of empty pages.

This commit makes pcpu_nr_empty_pop_pages and the corresponding logic
per chunk type.

[Dennis]
This issue came up as I was reviewing [1] and realized I missed this.
Simultaneously, it was reported btrfs was seeing failed atomic
allocations in fsstress tests [2] and [3].

[1] https://lore.kernel.org/linux-mm/20210324190626.564297-1-guro@fb.com/
[2] https://lore.kernel.org/linux-mm/20210401185158.3275.409509F4@e16-tech.com/
[3] https://lore.kernel.org/linux-mm/CAL3q7H5RNBjCi708GH7jnczAOe0BLnacT9C+OBgA-Dx9jhB6SQ@mail.gmail.com/

Fixes: 3c7be18ac9a0 ("mm: memcg/percpu: account percpu memory to memory cgroups")
Cc: stable@vger.kernel.org # 5.9+
Signed-off-by: Roman Gushchin <guro@fb.com>
Tested-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Dennis Zhou <dennis@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/percpu-internal.h |    2 +-
 mm/percpu-stats.c    |    9 +++++++--
 mm/percpu.c          |   14 +++++++-------
 3 files changed, 15 insertions(+), 10 deletions(-)

--- a/mm/percpu-internal.h
+++ b/mm/percpu-internal.h
@@ -87,7 +87,7 @@ extern spinlock_t pcpu_lock;
 
 extern struct list_head *pcpu_chunk_lists;
 extern int pcpu_nr_slots;
-extern int pcpu_nr_empty_pop_pages;
+extern int pcpu_nr_empty_pop_pages[];
 
 extern struct pcpu_chunk *pcpu_first_chunk;
 extern struct pcpu_chunk *pcpu_reserved_chunk;
--- a/mm/percpu-stats.c
+++ b/mm/percpu-stats.c
@@ -145,6 +145,7 @@ static int percpu_stats_show(struct seq_
 	int slot, max_nr_alloc;
 	int *buffer;
 	enum pcpu_chunk_type type;
+	int nr_empty_pop_pages;
 
 alloc_buffer:
 	spin_lock_irq(&pcpu_lock);
@@ -165,7 +166,11 @@ alloc_buffer:
 		goto alloc_buffer;
 	}
 
-#define PL(X) \
+	nr_empty_pop_pages = 0;
+	for (type = 0; type < PCPU_NR_CHUNK_TYPES; type++)
+		nr_empty_pop_pages += pcpu_nr_empty_pop_pages[type];
+
+#define PL(X)								\
 	seq_printf(m, "  %-20s: %12lld\n", #X, (long long int)pcpu_stats_ai.X)
 
 	seq_printf(m,
@@ -196,7 +201,7 @@ alloc_buffer:
 	PU(nr_max_chunks);
 	PU(min_alloc_size);
 	PU(max_alloc_size);
-	P("empty_pop_pages", pcpu_nr_empty_pop_pages);
+	P("empty_pop_pages", nr_empty_pop_pages);
 	seq_putc(m, '\n');
 
 #undef PU
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -172,10 +172,10 @@ struct list_head *pcpu_chunk_lists __ro_
 static LIST_HEAD(pcpu_map_extend_chunks);
 
 /*
- * The number of empty populated pages, protected by pcpu_lock.  The
- * reserved chunk doesn't contribute to the count.
+ * The number of empty populated pages by chunk type, protected by pcpu_lock.
+ * The reserved chunk doesn't contribute to the count.
  */
-int pcpu_nr_empty_pop_pages;
+int pcpu_nr_empty_pop_pages[PCPU_NR_CHUNK_TYPES];
 
 /*
  * The number of populated pages in use by the allocator, protected by
@@ -555,7 +555,7 @@ static inline void pcpu_update_empty_pag
 {
 	chunk->nr_empty_pop_pages += nr;
 	if (chunk != pcpu_reserved_chunk)
-		pcpu_nr_empty_pop_pages += nr;
+		pcpu_nr_empty_pop_pages[pcpu_chunk_type(chunk)] += nr;
 }
 
 /*
@@ -1831,7 +1831,7 @@ area_found:
 		mutex_unlock(&pcpu_alloc_mutex);
 	}
 
-	if (pcpu_nr_empty_pop_pages < PCPU_EMPTY_POP_PAGES_LOW)
+	if (pcpu_nr_empty_pop_pages[type] < PCPU_EMPTY_POP_PAGES_LOW)
 		pcpu_schedule_balance_work();
 
 	/* clear the areas and return address relative to base address */
@@ -1999,7 +1999,7 @@ retry_pop:
 		pcpu_atomic_alloc_failed = false;
 	} else {
 		nr_to_pop = clamp(PCPU_EMPTY_POP_PAGES_HIGH -
-				  pcpu_nr_empty_pop_pages,
+				  pcpu_nr_empty_pop_pages[type],
 				  0, PCPU_EMPTY_POP_PAGES_HIGH);
 	}
 
@@ -2579,7 +2579,7 @@ void __init pcpu_setup_first_chunk(const
 
 	/* link the first chunk in */
 	pcpu_first_chunk = chunk;
-	pcpu_nr_empty_pop_pages = pcpu_first_chunk->nr_empty_pop_pages;
+	pcpu_nr_empty_pop_pages[PCPU_CHUNK_ROOT] = pcpu_first_chunk->nr_empty_pop_pages;
 	pcpu_chunk_relocate(pcpu_first_chunk, -1);
 
 	/* include all regions of the first chunk */


