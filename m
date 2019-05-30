Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1789E2F550
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbfE3DLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:11:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728621AbfE3DLh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:37 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F85B244D2;
        Thu, 30 May 2019 03:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185897;
        bh=P3JTk7xVOJNuPEoVcNeajWlhbZPMJjIyXv67yz0Vxn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GimkMwz3G180jpbG+QHyPyvCDMhyLwDS8fjMw2EjJa7cU1US2DLSZW79ptf9RHPqq
         JitgTZ0RtdI0PiLsS5z3u466/qM5QLMwZ9EVeO3cEk/kPglo9nWWvKPwDrGoFbpEye
         v9ym+UY5ETYy/ExF6EnXBTEFAMb0raxHDQwhEF3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>, ard.biesheuvel@linaro.org,
        oss-drivers@netronome.com, pbonzini@redhat.com,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 263/405] locking/static_key: Fix false positive warnings on concurrent dec/inc
Date:   Wed, 29 May 2019 20:04:21 -0700
Message-Id: <20190530030554.247311160@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a1247d06d01045d7ab2882a9c074fbf21137c690 ]

Even though the atomic_dec_and_mutex_lock() in
__static_key_slow_dec_cpuslocked() can never see a negative value in
key->enabled the subsequent sanity check is re-reading key->enabled, which may
have been set to -1 in the meantime by static_key_slow_inc_cpuslocked().

                CPU  A                               CPU B

 __static_key_slow_dec_cpuslocked():          static_key_slow_inc_cpuslocked():
                               # enabled = 1
   atomic_dec_and_mutex_lock()
                               # enabled = 0
                                              atomic_read() == 0
                                              atomic_set(-1)
                               # enabled = -1
   val = atomic_read()
   # Oops - val == -1!

The test case is TCP's clean_acked_data_enable() / clean_acked_data_disable()
as tickled by KTLS (net/ktls).

Suggested-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reported-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Tested-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Cc: ard.biesheuvel@linaro.org
Cc: oss-drivers@netronome.com
Cc: pbonzini@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/jump_label.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index bad96b476eb6e..a799b1ac6b2fe 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -206,6 +206,8 @@ static void __static_key_slow_dec_cpuslocked(struct static_key *key,
 					   unsigned long rate_limit,
 					   struct delayed_work *work)
 {
+	int val;
+
 	lockdep_assert_cpus_held();
 
 	/*
@@ -215,17 +217,20 @@ static void __static_key_slow_dec_cpuslocked(struct static_key *key,
 	 * returns is unbalanced, because all other static_key_slow_inc()
 	 * instances block while the update is in progress.
 	 */
-	if (!atomic_dec_and_mutex_lock(&key->enabled, &jump_label_mutex)) {
-		WARN(atomic_read(&key->enabled) < 0,
-		     "jump label: negative count!\n");
+	val = atomic_fetch_add_unless(&key->enabled, -1, 1);
+	if (val != 1) {
+		WARN(val < 0, "jump label: negative count!\n");
 		return;
 	}
 
-	if (rate_limit) {
-		atomic_inc(&key->enabled);
-		schedule_delayed_work(work, rate_limit);
-	} else {
-		jump_label_update(key);
+	jump_label_lock();
+	if (atomic_dec_and_test(&key->enabled)) {
+		if (rate_limit) {
+			atomic_inc(&key->enabled);
+			schedule_delayed_work(work, rate_limit);
+		} else {
+			jump_label_update(key);
+		}
 	}
 	jump_label_unlock();
 }
-- 
2.20.1



