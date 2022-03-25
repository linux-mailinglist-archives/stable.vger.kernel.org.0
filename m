Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09C584E6C01
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 02:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357318AbiCYBbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 21:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357331AbiCYBbs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 21:31:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80370338AB;
        Thu, 24 Mar 2022 18:30:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C840617C7;
        Fri, 25 Mar 2022 01:30:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7039DC340EC;
        Fri, 25 Mar 2022 01:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171799;
        bh=+IAwH6SYy9nnLvHVMys1wuieUoBu0W9FZQqfEG4Kubg=;
        h=Date:To:From:Subject:From;
        b=ut8WnP85KtC6wnBUq/E8PB9jqMpyuNBD6RJiu7FQpGBOD0WStg6LhtqJGEB73O4uS
         hb9piUc4IW57plWguCOhcveyXpqcCCivc6cms/I/z5ZLGWle8dbMT0aBcr5GPJsgPr
         1FBAegwWR99qJaIIGATvqgtcUJoeCEwxOONfrtLQ=
Date:   Thu, 24 Mar 2022 18:29:58 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        mtosatti@redhat.com, joaodias@google.com, cgoldswo@codeaurora.org,
        minchan@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-fs-fix-lru_cache_disabled-race-in-bh_lru.patch removed from -mm tree
Message-Id: <20220325012959.7039DC340EC@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: fs: fix lru_cache_disabled race in bh_lru
has been removed from the -mm tree.  Its filename was
     mm-fs-fix-lru_cache_disabled-race-in-bh_lru.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: fs: fix lru_cache_disabled race in bh_lru

Check lru_cache_disabled under bh_lru_lock.  Otherwise, it could introduce
race below and it fails to migrate pages containing buffer_head.

   CPU 0					CPU 1

bh_lru_install
                                       lru_cache_disable
  lru_cache_disabled = false
                                       atomic_inc(&lru_disable_count);
				       invalidate_bh_lrus_cpu of CPU 0
				       bh_lru_lock
				       __invalidate_bh_lrus
				       bh_lru_unlock
  bh_lru_lock
  install the bh
  bh_lru_unlock

WHen this race happens a CMA allocation fails, which is critical for
the workload which depends on CMA.

Link: https://lkml.kernel.org/r/20220308180709.2017638-1-minchan@kernel.org
Fixes: 8cc621d2f45d ("mm: fs: invalidate BH LRU during page migration")
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Chris Goldsworthy <cgoldswo@codeaurora.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: John Dias <joaodias@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/buffer.c~mm-fs-fix-lru_cache_disabled-race-in-bh_lru
+++ a/fs/buffer.c
@@ -1235,16 +1235,18 @@ static void bh_lru_install(struct buffer
 	int i;
 
 	check_irqs_on();
+	bh_lru_lock();
+
 	/*
 	 * the refcount of buffer_head in bh_lru prevents dropping the
 	 * attached page(i.e., try_to_free_buffers) so it could cause
 	 * failing page migration.
 	 * Skip putting upcoming bh into bh_lru until migration is done.
 	 */
-	if (lru_cache_disabled())
+	if (lru_cache_disabled()) {
+		bh_lru_unlock();
 		return;
-
-	bh_lru_lock();
+	}
 
 	b = this_cpu_ptr(&bh_lrus);
 	for (i = 0; i < BH_LRU_SIZE; i++) {
_

Patches currently in -mm which might be from minchan@kernel.org are


