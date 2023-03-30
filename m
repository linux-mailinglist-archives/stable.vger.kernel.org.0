Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A08FF6D0706
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 15:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbjC3Nim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 09:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbjC3Nil (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 09:38:41 -0400
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ECCDB44C;
        Thu, 30 Mar 2023 06:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1680183504;
        bh=24hs/GAOgBlVSR4B3MD3Qa1OeM+tlMUGandZTll4v9o=;
        h=From:To:Cc:Subject:Date:From;
        b=P4hVo2EZZRdByxjRo59jz0QLN9PDmvFRp1opXBJvMaYkvg2EASQ9fPugdPpcXsu2g
         LOhcUyR2joIXhVYMOdYsHnPIav9cWlqmrlCblMZsHRbJYibESdYmYRvnaRjADKiqm5
         j0zdo2Dfqi06FIVg6EH6dYNbEuAj2JMMbpnSVlA+RdMWr8f/BudEMQvMNsMMSwnwZA
         CPQFJNB/IBo7aYkNiOJskGnM2Vqdqdvd3IjhFyE5TRZ0pKI0KBZhKf2zlNkXwpr/3E
         UEb7ynurlSL8qN/y3zJcu43QACN215cPl2d/UcsZfRnBrhjoR3E7rV7enw90eVURDy
         ISZ5k5GBWUw0Q==
Received: from localhost.localdomain (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4PnPdD01kRztMX;
        Thu, 30 Mar 2023 09:38:23 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Shakeel Butt <shakeelb@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-mm@kvack.org, stable@vger.kernel.org
Subject: [PATCH 1/1] mm: Fix memory leak on mm_init error handling
Date:   Thu, 30 Mar 2023 09:38:22 -0400
Message-Id: <20230330133822.66271-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit f1a7941243c1 ("mm: convert mm's rss stats into percpu_counter")
introduces a memory leak by missing a call to destroy_context() when a
percpu_counter fails to allocate.

Before introducing the per-cpu counter allocations, init_new_context()
was the last call that could fail in mm_init(), and thus there was no
need to ever invoke destroy_context() in the error paths. Adding the
following percpu counter allocations adds error paths after
init_new_context(), which means its associated destroy_context() needs
to be called when percpu counters fail to allocate.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-mm@kvack.org
Cc: stable@vger.kernel.org # 6.2
---
 kernel/fork.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index c0257cbee093..c983c4fe3090 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1171,6 +1171,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 fail_pcpu:
 	while (i > 0)
 		percpu_counter_destroy(&mm->rss_stat[--i]);
+	destroy_context(mm);
 fail_nocontext:
 	mm_free_pgd(mm);
 fail_nopgd:
-- 
2.25.1

