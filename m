Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 070BD683A34
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 00:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbjAaXFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 18:05:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjAaXFD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 18:05:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1CD46727;
        Tue, 31 Jan 2023 15:05:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 627E1B81D75;
        Tue, 31 Jan 2023 23:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0FADC433D2;
        Tue, 31 Jan 2023 23:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675206300;
        bh=QYQS1A/J1Iclq4udrWsNEzAhunY/lgnhAR71yi4vVhc=;
        h=Date:To:From:Subject:From;
        b=CvKVvXYk/koyYCSoqQKcKzeA8I81XfPlGvPNlSgYYdbwWCglSPTS8dBXx1Xax+d1F
         jI7Z2Ppv3hZRcCrYzUbupXqoeqRL2KpS8n43pjbP7bVQDLKdTSUwJnXteC62Wd/fAI
         lpZZBu9IrOXL6QVXC/zaTPpp2yaXTRKxAvd/t/Og=
Date:   Tue, 31 Jan 2023 15:04:59 -0800
To:     mm-commits@vger.kernel.org, xemul@parallels.com,
        viro@zeniv.linux.org.uk, stable@vger.kernel.org, jannh@google.com,
        bcrl@kvack.org, sethjenkins@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] aio-fix-mremap-after-fork-null-deref.patch removed from -mm tree
Message-Id: <20230131230459.F0FADC433D2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: aio: fix mremap after fork null-deref
has been removed from the -mm tree.  Its filename was
     aio-fix-mremap-after-fork-null-deref.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Seth Jenkins <sethjenkins@google.com>
Subject: aio: fix mremap after fork null-deref
Date: Fri, 4 Nov 2022 17:25:19 -0400

Commit e4a0d3e720e7 ("aio: Make it possible to remap aio ring") introduced
a null-deref if mremap is called on an old aio mapping after fork as
mm->ioctx_table will be set to NULL.

Link: https://lkml.kernel.org/r/20221104212519.538108-1-sethjenkins@google.com
Fixes: e4a0d3e720e7 ("aio: Make it possible to remap aio ring")
Signed-off-by: Seth Jenkins <sethjenkins@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/fs/aio.c~aio-fix-mremap-after-fork-null-deref
+++ a/fs/aio.c
@@ -361,16 +361,18 @@ static int aio_ring_mremap(struct vm_are
 	spin_lock(&mm->ioctx_lock);
 	rcu_read_lock();
 	table = rcu_dereference(mm->ioctx_table);
-	for (i = 0; i < table->nr; i++) {
-		struct kioctx *ctx;
+	if (table) {
+		for (i = 0; i < table->nr; i++) {
+			struct kioctx *ctx;
 
-		ctx = rcu_dereference(table->table[i]);
-		if (ctx && ctx->aio_ring_file == file) {
-			if (!atomic_read(&ctx->dead)) {
-				ctx->user_id = ctx->mmap_base = vma->vm_start;
-				res = 0;
+			ctx = rcu_dereference(table->table[i]);
+			if (ctx && ctx->aio_ring_file == file) {
+				if (!atomic_read(&ctx->dead)) {
+					ctx->user_id = ctx->mmap_base = vma->vm_start;
+					res = 0;
+				}
+				break;
 			}
-			break;
 		}
 	}
 
_

Patches currently in -mm which might be from sethjenkins@google.com are


