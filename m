Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 263B373C45
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390661AbfGXUHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:07:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:54194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390764AbfGXUDj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 16:03:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F47D206BA;
        Wed, 24 Jul 2019 20:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998618;
        bh=Lqb720plAhnF/YmufVCIUF2Culua0WQPKVUrBJlh76Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZD89HKOqi8x8ygZHQRcesysVL7/E3bSmkkKQv6B8Sa2ebvOiNZQbOkoxwlLntJZl9
         kfs0iSiMoj0oF2TvZq1uFxXr/mgjxEaqjB5jGE5/WhbQqtRnvvnKWoLDEMtNl8flMG
         LQcS61+0E+as69G7CgIvwojjieeFk9/9lOJt40OU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Imre Deak <imre.deak@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 039/271] locking/lockdep: Fix merging of hlocks with non-zero references
Date:   Wed, 24 Jul 2019 21:18:28 +0200
Message-Id: <20190724191658.530756625@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 26b57e24476f..e810e8cb17e1 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -3326,17 +3326,17 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
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



