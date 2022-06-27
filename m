Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3363355DE99
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238250AbiF0Lxd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238773AbiF0Lwg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:52:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D773DE82;
        Mon, 27 Jun 2022 04:45:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECA86610A0;
        Mon, 27 Jun 2022 11:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03F4C341C7;
        Mon, 27 Jun 2022 11:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330335;
        bh=qQsK/KFw7+vQ8Q7idBFmYFRhYdTXO8Kc12ms4xSFZYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2EYLagDGa7OH7gUFFFY5N0jba1VjObtIORYr2o6l4ZrsSYZDM/drbW0D7wbF8wXuc
         wf7EleAYKz/f+RoxfBaJYrED77OHzCkyVoNLVuTR/7aBtPOeKqMhQanj4TryxsCjKi
         REKlAUKqeWBKGxLGHwDTmCs6Qoq2/MzjN848cgIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Michael Larabel <Michael@MichaelLarabel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Minchan Kim <minchan@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Juri Lelli <juri.lelli@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Phil Elwell <phil@raspberrypi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.18 162/181] mm: lru_cache_disable: use synchronize_rcu_expedited
Date:   Mon, 27 Jun 2022 13:22:15 +0200
Message-Id: <20220627111949.383620931@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

commit 31733463372e8d88ea54bfa1e35178aad9b2ffd2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/swap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/swap.c b/mm/swap.c
index f3922a96b2e9..034bb24879a3 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -881,7 +881,7 @@ void lru_cache_disable(void)
 	 * lru_disable_count = 0 will have exited the critical
 	 * section when synchronize_rcu() returns.
 	 */
-	synchronize_rcu();
+	synchronize_rcu_expedited();
 #ifdef CONFIG_SMP
 	__lru_add_drain_all(true);
 #else
-- 
2.36.1



