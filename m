Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 061FE5387F9
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 22:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242547AbiE3UAu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 16:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239600AbiE3UAs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 16:00:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E804095DDB;
        Mon, 30 May 2022 13:00:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 854AB60F15;
        Mon, 30 May 2022 20:00:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF490C385B8;
        Mon, 30 May 2022 20:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653940846;
        bh=sLGwvYn6Tq1PA60gp+5cqvjEY09S8DGzcvboC/1PbB0=;
        h=Date:To:From:Subject:From;
        b=EtnwYMeujAFfsYTz4Hc+EGe66rGZuzznAY7WKoA9YvCu0lG12Z1qnvqKVv+DPsRcy
         582/K7lHdfzD6jlV8CIHaH4bpJNvrXjEnTS/aLbZTQCZ2ycgaH8wYi0yRqQLF81K8P
         qmFgkX99R2fyIsKp86Mlf1vyeUWcR3etS2db8os4=
Date:   Mon, 30 May 2022 13:00:46 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tglx@linutronix.de, stefan.wahren@i2se.com, stable@vger.kernel.org,
        phil@raspberrypi.com, paulmck@kernel.org, nsaenzju@redhat.com,
        minchan@kernel.org, Michael@MichaelLarabel.com,
        mgorman@techsingularity.net, juri.lelli@redhat.com, bp@alien8.de,
        bigeasy@linutronix.de, mtosatti@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-lru_cache_disable-use-synchronize_rcu_expedited.patch added to mm-hotfixes-unstable branch
Message-Id: <20220530200046.CF490C385B8@smtp.kernel.org>
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
     Subject: mm: lru_cache_disable: use synchronize_rcu_expedited
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-lru_cache_disable-use-synchronize_rcu_expedited.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-lru_cache_disable-use-synchronize_rcu_expedited.patch

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
From: Marcelo Tosatti <mtosatti@redhat.com>
Subject: mm: lru_cache_disable: use synchronize_rcu_expedited
Date: Mon, 30 May 2022 12:51:56 -0300

commit ff042f4a9b050 ("mm: lru_cache_disable: replace work queue
synchronization with synchronize_rcu") replaced lru_cache_disable's usage
of work queues with synchronize_rcu.

Some users reported large performance regressions due to this commit, for
example:
https://lore.kernel.org/all/20220521234616.GO1790663@paulmck-ThinkPad-P17-Gen-1/T/

Switching to synchronize_rcu_expedited fixes the problem.

Link: https://lkml.kernel.org/r/YpToHCmnx/HEcVyR@fuller.cnet
Fixes: ff042f4a9b050 ("mm: lru_cache_disable: replace work queue synchronization with synchronize_rcu")
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Tested-by: Michael Larabel <Michael@MichaelLarabel.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Phil Elwell <phil@raspberrypi.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap.c~mm-lru_cache_disable-use-synchronize_rcu_expedited
+++ a/mm/swap.c
@@ -881,7 +881,7 @@ void lru_cache_disable(void)
 	 * lru_disable_count = 0 will have exited the critical
 	 * section when synchronize_rcu() returns.
 	 */
-	synchronize_rcu();
+	synchronize_rcu_expedited();
 #ifdef CONFIG_SMP
 	__lru_add_drain_all(true);
 #else
_

Patches currently in -mm which might be from mtosatti@redhat.com are

mm-lru_cache_disable-use-synchronize_rcu_expedited.patch

