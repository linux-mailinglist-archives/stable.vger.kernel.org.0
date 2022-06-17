Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D2054EF29
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 04:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379684AbiFQCMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 22:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378914AbiFQCMQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 22:12:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938C864BD9;
        Thu, 16 Jun 2022 19:12:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C05561C0A;
        Fri, 17 Jun 2022 02:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D6BC34114;
        Fri, 17 Jun 2022 02:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655431934;
        bh=XcL6P16IXzo/mFB9hxdBveMcZrtRzVA4hyGe2w07Bw4=;
        h=Date:To:From:Subject:From;
        b=ZZs4E9IA2ipAZrlsFz9Sd1eDbiw+i+tdTiIW+JadxJtg4/HMgv5RcVgLgFd7lzupr
         0dVa3llROyCigizZWM+mL6OHTW5pGOOW25XJctcB/67v/ENcPXrpHcejPqiDzVtLsi
         Tde5gpNRCHBql9h6MSj600293ulfBSrqW7eETRg4=
Date:   Thu, 16 Jun 2022 19:12:13 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tglx@linutronix.de, stefan.wahren@i2se.com, stable@vger.kernel.org,
        phil@raspberrypi.com, paulmck@kernel.org, nsaenzju@redhat.com,
        minchan@kernel.org, Michael@MichaelLarabel.com,
        mgorman@techsingularity.net, juri.lelli@redhat.com, bp@alien8.de,
        bigeasy@linutronix.de, mtosatti@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-lru_cache_disable-use-synchronize_rcu_expedited.patch removed from -mm tree
Message-Id: <20220617021214.78D6BC34114@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm: lru_cache_disable: use synchronize_rcu_expedited
has been removed from the -mm tree.  Its filename was
     mm-lru_cache_disable-use-synchronize_rcu_expedited.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


