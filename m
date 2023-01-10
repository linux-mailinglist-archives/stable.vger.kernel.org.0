Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3865664EDC
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 23:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232467AbjAJWig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 17:38:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234020AbjAJWi2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 17:38:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4415C1E7;
        Tue, 10 Jan 2023 14:38:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68928B8188D;
        Tue, 10 Jan 2023 22:38:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11566C433EF;
        Tue, 10 Jan 2023 22:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673390305;
        bh=6YSlAdGjdMW6h+K6sMPDCLp9pjM54lwbCZ0I219KRMM=;
        h=Date:To:From:Subject:From;
        b=qgc16gBVakkXi/eqOJxl3mPuZ0XfUyLIYUzKZi0wyhqmkBVe/B6CekNRzywZbfhBR
         lvbAasD0BeLpQe1+D8mkYGfTp9HKTFh7HqKZXnydRXva3n87oM7RrRxZSNUjYoUWr5
         bmHg9B8mPrZMB3O0STEBOj59yfAUWJUvUpHDFWZg=
Date:   Tue, 10 Jan 2023 14:38:24 -0800
To:     mm-commits@vger.kernel.org, xemul@parallels.com,
        viro@zeniv.linux.org.uk, stable@vger.kernel.org, jannh@google.com,
        bcrl@kvack.org, sethjenkins@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + aio-fix-mremap-after-fork-null-deref.patch added to mm-hotfixes-unstable branch
Message-Id: <20230110223825.11566C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: aio: fix mremap after fork null-deref
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     aio-fix-mremap-after-fork-null-deref.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/aio-fix-mremap-after-fork-null-deref.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

aio-fix-mremap-after-fork-null-deref.patch

