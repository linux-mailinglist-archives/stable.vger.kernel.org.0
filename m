Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 062374FDAD4
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352474AbiDLHgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354854AbiDLH0y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:26:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237EF4707D;
        Tue, 12 Apr 2022 00:06:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD23CB81B5D;
        Tue, 12 Apr 2022 07:06:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C287C385AA;
        Tue, 12 Apr 2022 07:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747203;
        bh=xK9aBgLPlErIwY2zMUviSPeFrgaKWLXQc2TXbE/5NmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F5xbrDywbXaCBCmiJhbze2g0epKcSQCh35dgevHQ0TyDNUwcvoW27WqWgUsxoCS2m
         hCG7SmL3U3c9gFD/D5pUU8JUDT+MZ8/dWPZtyCzAE+bc7ypSpLQlQXyTNs4wXtAC9v
         BOLqbm/LSZeRn6NKIXfjxrHgwxgbtsVM/+d9r1og=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.16 279/285] sched: Teach the forced-newidle balancer about CPU affinity limitation.
Date:   Tue, 12 Apr 2022 08:32:16 +0200
Message-Id: <20220412062951.705830343@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 386ef214c3c6ab111d05e1790e79475363abaa05 upstream.

try_steal_cookie() looks at task_struct::cpus_mask to decide if the
task could be moved to `this' CPU. It ignores that the task might be in
a migration disabled section while not on the CPU. In this case the task
must not be moved otherwise per-CPU assumption are broken.

Use is_cpu_allowed(), as suggested by Peter Zijlstra, to decide if the a
task can be moved.

Fixes: d2dfa17bc7de6 ("sched: Trivial forced-newidle balancer")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/YjNK9El+3fzGmswf@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5889,7 +5889,7 @@ static bool try_steal_cookie(int this, i
 		if (p == src->core_pick || p == src->curr)
 			goto next;
 
-		if (!cpumask_test_cpu(this, &p->cpus_mask))
+		if (!is_cpu_allowed(p, this))
 			goto next;
 
 		if (p->core_occupation > dst->idle->core_occupation)


