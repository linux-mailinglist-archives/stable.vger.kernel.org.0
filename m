Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF1F5904A1
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238749AbiHKQh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239325AbiHKQgy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:36:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C832C7C19E;
        Thu, 11 Aug 2022 09:12:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F9CCB821AD;
        Thu, 11 Aug 2022 16:12:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A06BC433D7;
        Thu, 11 Aug 2022 16:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660234338;
        bh=TmKSVIiOroA3H2Jtidu6kQhyVrN7WLK70U0kV8Tfwrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n9N/gUr7Pr9KCRyFeZ6S0gyoMnbqs0C2jIfeNaEYzbx2mVNYZz8ZziumgY/0geQ7N
         G1vEOGR+Hzqi10YVSTHNwj0hYlHUFApWZAGdkPlyTLcg8W2gBJOycCSqvWoeXVa/Yh
         JsH8y+jpE0vmMuRb29zraeOpTVM/UmwN0b0CsOkEWIVa5UnGb2ucMDGEZsKBPHEUyM
         9w+flYY7BgMpPC2yWNWNjOVX1gIKOA4C4rG6rU4oDM4ToCG1KfBZQiZFIfkECeHGHE
         sZ0YXrfJLjSj+EYBMKrwADuzxhZxL1dOHAzTq/wETqHmX/Ebw237xtmDeMhSyWwg3e
         DgyRljDLG9/Jg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oleg.Karfich@wago.com, Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 12/12] fs/dcache: Disable preemption on i_dir_seq write side on PREEMPT_RT
Date:   Thu, 11 Aug 2022 12:11:38 -0400
Message-Id: <20220811161144.1543598-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811161144.1543598-1-sashal@kernel.org>
References: <20220811161144.1543598-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit cf634d540a29018e8d69ab1befb7e08182bc6594 ]

i_dir_seq is a sequence counter with a lock which is represented by the
lowest bit. The writer atomically updates the counter which ensures that it
can be modified by only one writer at a time. This requires preemption to
be disabled across the write side critical section.

On !PREEMPT_RT kernels this is implicit by the caller acquiring
dentry::lock. On PREEMPT_RT kernels spin_lock() does not disable preemption
which means that a preempting writer or reader would live lock. It's
therefore required to disable preemption explicitly.

An alternative solution would be to replace i_dir_seq with a seqlock_t for
PREEMPT_RT, but that comes with its own set of problems due to arbitrary
lock nesting. A pure sequence count with an associated spinlock is not
possible because the locks held by the caller are not necessarily related.

As the critical section is small, disabling preemption is a sensible
solution.

Reported-by: Oleg.Karfich@wago.com
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://lkml.kernel.org/r/20220613140712.77932-2-bigeasy@linutronix.de
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dcache.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index e42c715fc9e9..feb592bb7cbe 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2425,7 +2425,15 @@ EXPORT_SYMBOL(d_rehash);
 
 static inline unsigned start_dir_add(struct inode *dir)
 {
-
+	/*
+	 * The caller holds a spinlock (dentry::d_lock). On !PREEMPT_RT
+	 * kernels spin_lock() implicitly disables preemption, but not on
+	 * PREEMPT_RT.  So for RT it has to be done explicitly to protect
+	 * the sequence count write side critical section against a reader
+	 * or another writer preempting, which would result in a live lock.
+	 */
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_disable();
 	for (;;) {
 		unsigned n = dir->i_dir_seq;
 		if (!(n & 1) && cmpxchg(&dir->i_dir_seq, n, n + 1) == n)
@@ -2437,6 +2445,8 @@ static inline unsigned start_dir_add(struct inode *dir)
 static inline void end_dir_add(struct inode *dir, unsigned n)
 {
 	smp_store_release(&dir->i_dir_seq, n + 2);
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_enable();
 }
 
 static void d_wait_lookup(struct dentry *dentry)
-- 
2.35.1

