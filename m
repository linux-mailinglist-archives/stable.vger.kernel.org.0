Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7528F692A7
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391054AbfGOOiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:38:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:33274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730532AbfGOOiG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:38:06 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C2DC217F9;
        Mon, 15 Jul 2019 14:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563201485;
        bh=EndwOED/zXothbkS5aOnGiY67X2QIUWQA//v+Xg+h+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RyaVfc35n5MDFW535OM9GEWz/KOhETgs1d9iXQ0ZyZcoPPPVycl3EuZQ3/YH9fRvK
         jl5iVZe2HyD+ALFS4NhOMNgH42OIQzIc15+XCQeG4iYDnylrMVUJIMxHHPlTMgt8v4
         jU+LB6bONnRbGj0pm+XvC42M8U9Bgo44ejuX6jwU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Imre Deak <imre.deak@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 25/73] locking/lockdep: Fix merging of hlocks with non-zero references
Date:   Mon, 15 Jul 2019 10:35:41 -0400
Message-Id: <20190715143629.10893-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715143629.10893-1-sashal@kernel.org>
References: <20190715143629.10893-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit d9349850e188b8b59e5322fda17ff389a1c0cd7d ]

The sequence

	static DEFINE_WW_CLASS(test_ww_class);

	struct ww_acquire_ctx ww_ctx;
	struct ww_mutex ww_lock_a;
	struct ww_mutex ww_lock_b;
	struct ww_mutex ww_lock_c;
	struct mutex lock_c;

	ww_acquire_init(&ww_ctx, &test_ww_class);

	ww_mutex_init(&ww_lock_a, &test_ww_class);
	ww_mutex_init(&ww_lock_b, &test_ww_class);
	ww_mutex_init(&ww_lock_c, &test_ww_class);

	mutex_init(&lock_c);

	ww_mutex_lock(&ww_lock_a, &ww_ctx);

	mutex_lock(&lock_c);

	ww_mutex_lock(&ww_lock_b, &ww_ctx);
	ww_mutex_lock(&ww_lock_c, &ww_ctx);

	mutex_unlock(&lock_c);	(*)

	ww_mutex_unlock(&ww_lock_c);
	ww_mutex_unlock(&ww_lock_b);
	ww_mutex_unlock(&ww_lock_a);

	ww_acquire_fini(&ww_ctx); (**)

will trigger the following error in __lock_release() when calling
mutex_release() at **:

	DEBUG_LOCKS_WARN_ON(depth <= 0)

The problem is that the hlock merging happening at * updates the
references for test_ww_class incorrectly to 3 whereas it should've
updated it to 4 (representing all the instances for ww_ctx and
ww_lock_[abc]).

Fix this by updating the references during merging correctly taking into
account that we can have non-zero references (both for the hlock that we
merge into another hlock or for the hlock we are merging into).

Signed-off-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Link: https://lkml.kernel.org/r/20190524201509.9199-2-imre.deak@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/lockdep.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 26fc428476b9..4b27aaffdf35 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -3260,17 +3260,17 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	if (depth) {
 		hlock = curr->held_locks + depth - 1;
 		if (hlock->class_idx == class_idx && nest_lock) {
-			if (hlock->references) {
-				/*
-				 * Check: unsigned int references:12, overflow.
-				 */
-				if (DEBUG_LOCKS_WARN_ON(hlock->references == (1 << 12)-1))
-					return 0;
+			if (!references)
+				references++;
 
+			if (!hlock->references)
 				hlock->references++;
-			} else {
-				hlock->references = 2;
-			}
+
+			hlock->references += references;
+
+			/* Overflow */
+			if (DEBUG_LOCKS_WARN_ON(hlock->references < references))
+				return 0;
 
 			return 1;
 		}
-- 
2.20.1

