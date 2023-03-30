Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12E26D0F1C
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 21:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbjC3Tna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 15:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbjC3Tn3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 15:43:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7833EFAB;
        Thu, 30 Mar 2023 12:43:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 596F9B829FE;
        Thu, 30 Mar 2023 19:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3E9C433EF;
        Thu, 30 Mar 2023 19:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680205406;
        bh=Tm4DmWkLsOIsXporMtB6GG/k2awA9C12QmyfPZZLAoo=;
        h=Date:To:From:Subject:From;
        b=eAcq5SIXOe/xKfvHx1juF76AQdVhQi230eyCkgTy5NGSFoaqJ8FlcU18jn5fzh/vo
         S+SIDfGsfbHHG0IMAKrnb3YpbBJkIkGsZvXAKBiQ9nIUvMQ7kxCGyLwGXysB3JuBXC
         S2mKDyryXZZfXqHD9lEaq9Swok0RNObFAad4QDDY=
Date:   Thu, 30 Mar 2023 12:43:25 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        shakeelb@google.com, m.szyprowski@samsung.com,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-memory-leak-on-mm_init-error-handling.patch added to mm-hotfixes-unstable branch
Message-Id: <20230330194325.ED3E9C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: fix memory leak on mm_init error handling
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-memory-leak-on-mm_init-error-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-memory-leak-on-mm_init-error-handling.patch

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
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: mm: fix memory leak on mm_init error handling
Date: Thu, 30 Mar 2023 09:38:22 -0400

commit f1a7941243c1 ("mm: convert mm's rss stats into percpu_counter")
introduces a memory leak by missing a call to destroy_context() when a
percpu_counter fails to allocate.

Before introducing the per-cpu counter allocations, init_new_context() was
the last call that could fail in mm_init(), and thus there was no need to
ever invoke destroy_context() in the error paths.  Adding the following
percpu counter allocations adds error paths after init_new_context(),
which means its associated destroy_context() needs to be called when
percpu counters fail to allocate.

Link: https://lkml.kernel.org/r/20230330133822.66271-1-mathieu.desnoyers@efficios.com
Fixes: f1a7941243c1 ("mm: convert mm's rss stats into percpu_counter")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/fork.c~mm-fix-memory-leak-on-mm_init-error-handling
+++ a/kernel/fork.c
@@ -1174,6 +1174,7 @@ static struct mm_struct *mm_init(struct
 fail_pcpu:
 	while (i > 0)
 		percpu_counter_destroy(&mm->rss_stat[--i]);
+	destroy_context(mm);
 fail_nocontext:
 	mm_free_pgd(mm);
 fail_nopgd:
_

Patches currently in -mm which might be from mathieu.desnoyers@efficios.com are

mm-fix-memory-leak-on-mm_init-error-handling.patch

