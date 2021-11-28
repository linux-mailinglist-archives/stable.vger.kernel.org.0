Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 362A046028D
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 01:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356716AbhK1A2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Nov 2021 19:28:21 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39468 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356744AbhK1A0V (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Nov 2021 19:26:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C953560F62;
        Sun, 28 Nov 2021 00:23:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF340C53FCB;
        Sun, 28 Nov 2021 00:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638058985;
        bh=sOfIQAQu5vS9vuIFtB6QpR83bibmwR2aTH4SMvLosXw=;
        h=Date:From:To:Subject:From;
        b=ia2ecdz/F6U6pS2VFxFQXNC1e/mo1+clOIheexSRE3CkUHQ0FNDIRyAdjKyK1xktH
         hDrqKv1lyiJ8jFOkpU5Lom/QNWPGPww0toWymgHHkuDLNYUcfKK1eQhXJOWqBCXVMZ
         fICLwEbKBoS2GxfP+i/EKK7ycbuGmXxNeSO0pUGk=
Date:   Sat, 27 Nov 2021 16:23:04 -0800
From:   akpm@linux-foundation.org
To:     cl@linux.com, faiyazm@codeaurora.org,
        gerald.schaefer@linux.ibm.com, gregkh@linuxfoundation.org,
        iamjoonsoo.kim@lge.com, maier@linux.ibm.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, stable@vger.kernel.org, vbabka@suse.cz
Subject:  +
 mm-slub-fix-endianness-bug-for-alloc-free_traces-attributes.patch added to
 -mm tree
Message-ID: <20211128002304.Aww0uYjZE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/slub: fix endianness bug for alloc/free_traces attributes
has been added to the -mm tree.  Its filename is
     mm-slub-fix-endianness-bug-for-alloc-free_traces-attributes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-fix-endianness-bug-for-alloc-free_traces-attributes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-fix-endianness-bug-for-alloc-free_traces-attributes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: : Vlastimil Babka <vbabka@suse.cz>
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

Patches currently in -mm which might be from gerald.schaefer@linux.ibm.com are

mm-slub-fix-endianness-bug-for-alloc-free_traces-attributes.patch

