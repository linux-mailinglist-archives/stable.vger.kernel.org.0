Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4309A3285FD
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236617AbhCARCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:02:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:54866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235958AbhCAQzq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:55:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B0A264FD3;
        Mon,  1 Mar 2021 16:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616556;
        bh=FuseDVXj7uPs4R986ds/nEqPJ0f2+6eEryWP/n+yEO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1+1/DeKAPMkyeIof1mxeC4tK3v6CNx2PLHJOzmXYG+0okWxQCL64jHb9+x45ztARx
         n3OD97hlSU7QHCZjtSVt4uopKXGBHaEondYCocCgCzeBguLec94kjvp+M+KPsAan4f
         yzfYaFCFho55Uxl+fwYpc5tE71m1ATyk5rL+F1x8=
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
        Ingo Molnar <mingo@kernel.org>,
        Will McVicker <willmcvicker@google.com>
Subject: [PATCH 4.19 016/247] locking/static_key: Fix false positive warnings on concurrent dec/inc
Date:   Mon,  1 Mar 2021 17:10:36 +0100
Message-Id: <20210301161032.484926340@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit a1247d06d01045d7ab2882a9c074fbf21137c690 upstream.

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
Signed-off-by: Will McVicker <willmcvicker@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/jump_label.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -186,6 +186,8 @@ static void __static_key_slow_dec_cpuslo
 					   unsigned long rate_limit,
 					   struct delayed_work *work)
 {
+	int val;
+
 	lockdep_assert_cpus_held();
 
 	/*
@@ -195,17 +197,20 @@ static void __static_key_slow_dec_cpuslo
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


