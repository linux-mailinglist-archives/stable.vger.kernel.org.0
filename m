Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C834729AE
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343959AbhLMKXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:23:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244982AbhLMKTA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:19:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BE9C06115E;
        Mon, 13 Dec 2021 01:57:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 95E13CE0EBE;
        Mon, 13 Dec 2021 09:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D22C34600;
        Mon, 13 Dec 2021 09:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389435;
        bh=2TGvWSkkKLptobPI9RE2WsuizoW+s0YnvyS0QNY3rXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=magoGFXHWX5xS+8auSQ1ufnlBfxoJBK90p/L0K4WnBLz5wXuWtt/MdK4lTDBy81Nr
         wWaiD1nuu9IHcSXYqNI/ExVb7j4cIoztnMue30kA3J9tA5wNAZJTwo81xVjBuOc/ua
         E52EIXoRgRRrZhv6/mx10Prnm/33hcGXYPFmsytU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Faiyaz Mohammed <faiyazm@codeaurora.org>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 062/171] mm/slub: fix endianness bug for alloc/free_traces attributes
Date:   Mon, 13 Dec 2021 10:29:37 +0100
Message-Id: <20211213092947.168513763@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>

commit 005a79e5c254c3f60ec269a459cc41b55028c798 upstream.

On big-endian s390, the alloc/free_traces attributes produce endless
output, because of always 0 idx in slab_debugfs_show().

idx is de-referenced from *v, which points to a loff_t value, with

    unsigned int idx = *(unsigned int *)v;

This will only give the upper 32 bits on big-endian, which remain 0.

Instead of only fixing this de-reference, during discussion it seemed
more appropriate to change the seq_ops so that they use an explicit
iterator in private loc_track struct.

This patch adds idx to loc_track, which will also fix the endianness
bug.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5072,6 +5072,7 @@ struct loc_track {
 	unsigned long max;
 	unsigned long count;
 	struct location *loc;
+	loff_t idx;
 };
 
 static struct dentry *slab_debugfs_root;
@@ -6035,11 +6036,11 @@ __initcall(slab_sysfs_init);
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
 
@@ -6088,16 +6089,18 @@ static void *slab_debugfs_next(struct se
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
 


