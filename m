Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F6D470E35
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 23:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345000AbhLJWup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 17:50:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345010AbhLJWun (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 17:50:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC8D8C061D60;
        Fri, 10 Dec 2021 14:47:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56D6FB82A22;
        Fri, 10 Dec 2021 22:47:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C38DC00446;
        Fri, 10 Dec 2021 22:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639176423;
        bh=e371BC48yi+1zkcqf7J8rWC7iV2JeIwQviTRnB13Kls=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qpY/s0wadtl/IEGFGEEkLlISN9uKcIInlTINk0m2DjQs5BGhAuKhd8kgRCr/Q5Kzt
         ExOFW5fXLpg4sEkumGTwfamiV/ioV46/NLt1vgiy8drY7LIbTamCPgCU7N22BlR1pV
         NKbqorpTmn54M2J3Sjpv63prhg7JMlUTJA4khRg0=
Date:   Fri, 10 Dec 2021 14:47:02 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, faiyazm@codeaurora.org,
        gerald.schaefer@linux.ibm.com, gregkh@linuxfoundation.org,
        iamjoonsoo.kim@lge.com, linux-mm@kvack.org, maier@linux.ibm.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 18/21] mm/slub: fix endianness bug for
 alloc/free_traces attributes
Message-ID: <20211210224702.RW6YwnTh2%akpm@linux-foundation.org>
In-Reply-To: <20211210144539.663efee2c80d8450e6180230@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Subject: mm/slub: fix endianness bug for alloc/free_traces attributes

On big-endian s390, the alloc/free_traces attributes produce endless
output, because of always 0 idx in slab_debugfs_show().

idx is de-referenced from *v, which points to a loff_t value, with

unsigned int idx = *(unsigned int *)v;

This will only give the upper 32 bits on big-endian, which remain 0.

Instead of only fixing this de-reference, during discussion it seemed more
appropriate to change the seq_ops so that they use an explicit iterator in
private loc_track struct.

This patch adds idx to loc_track, which will also fix the endianness bug.

Link: https://lore.kernel.org/r/20211117193932.4049412-1-gerald.schaefer@linux.ibm.com
Link: https://lkml.kernel.org/r/20211126171848.17534-1-gerald.schaefer@linux.ibm.com
Fixes: 64dd68497be7 ("mm: slub: move sysfs slab alloc/free interfaces to debugfs")
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Reported-by: Steffen Maier <maier@linux.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Faiyaz Mohammed <faiyazm@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/slub.c~mm-slub-fix-endianness-bug-for-alloc-free_traces-attributes
+++ a/mm/slub.c
@@ -5081,6 +5081,7 @@ struct loc_track {
 	unsigned long max;
 	unsigned long count;
 	struct location *loc;
+	loff_t idx;
 };
 
 static struct dentry *slab_debugfs_root;
@@ -6052,11 +6053,11 @@ __initcall(slab_sysfs_init);
 #if defined(CONFIG_SLUB_DEBUG) && defined(CONFIG_DEBUG_FS)
 static int slab_debugfs_show(struct seq_file *seq, void *v)
 {
-
-	struct location *l;
-	unsigned int idx = *(unsigned int *)v;
 	struct loc_track *t = seq->private;
+	struct location *l;
+	unsigned long idx;
 
+	idx = (unsigned long) t->idx;
 	if (idx < t->count) {
 		l = &t->loc[idx];
 
@@ -6105,16 +6106,18 @@ static void *slab_debugfs_next(struct se
 {
 	struct loc_track *t = seq->private;
 
-	v = ppos;
-	++*ppos;
+	t->idx = ++(*ppos);
 	if (*ppos <= t->count)
-		return v;
+		return ppos;
 
 	return NULL;
 }
 
 static void *slab_debugfs_start(struct seq_file *seq, loff_t *ppos)
 {
+	struct loc_track *t = seq->private;
+
+	t->idx = *ppos;
 	return ppos;
 }
 
_
