Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B071B3A779
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729369AbfFIQuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:50:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731593AbfFIQt7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:49:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C726E2070B;
        Sun,  9 Jun 2019 16:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098999;
        bh=dM1jV9RXHFxkmlsmc7CL6SGnB+Hs2a6Uc6Z8zwyXHnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tw4gMOqWnE7EQoRbfHrJfCDW8XijW1rwuNRt16PNLYK06jo3KjAKdFsyaYNW4oD5G
         6+EM8xdIL2wsRorpJC4rGkNeAtzuOsUjfWce+HnHcMhkqCopqeWe7NORHy+MdrT6OI
         cbqyLF1SUpaUWYTw/vap9TfxprWpLQJ5Dc6VjmZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        stable@kernel.org, Boqun Feng <boqun.feng@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 13/35] rcu: locking and unlocking need to always be at least barriers
Date:   Sun,  9 Jun 2019 18:42:19 +0200
Message-Id: <20190609164126.264742013@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164125.377368385@linuxfoundation.org>
References: <20190609164125.377368385@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 66be4e66a7f422128748e3c3ef6ee72b20a6197b upstream.

Herbert Xu pointed out that commit bb73c52bad36 ("rcu: Don't disable
preemption for Tiny and Tree RCU readers") was incorrect in making the
preempt_disable/enable() be conditional on CONFIG_PREEMPT_COUNT.

If CONFIG_PREEMPT_COUNT isn't enabled, the preemption enable/disable is
a no-op, but still is a compiler barrier.

And RCU locking still _needs_ that compiler barrier.

It is simply fundamentally not true that RCU locking would be a complete
no-op: we still need to guarantee (for example) that things that can
trap and cause preemption cannot migrate into the RCU locked region.

The way we do that is by making it a barrier.

See for example commit 386afc91144b ("spinlocks and preemption points
need to be at least compiler barriers") from back in 2013 that had
similar issues with spinlocks that become no-ops on UP: they must still
constrain the compiler from moving other operations into the critical
region.

Now, it is true that a lot of RCU operations already use READ_ONCE() and
WRITE_ONCE() (which in practice likely would never be re-ordered wrt
anything remotely interesting), but it is also true that that is not
globally the case, and that it's not even necessarily always possible
(ie bitfields etc).

Reported-by: Herbert Xu <herbert@gondor.apana.org.au>
Fixes: bb73c52bad36 ("rcu: Don't disable preemption for Tiny and Tree RCU readers")
Cc: stable@kernel.org
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/rcupdate.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -79,14 +79,12 @@ void synchronize_rcu(void);
 
 static inline void __rcu_read_lock(void)
 {
-	if (IS_ENABLED(CONFIG_PREEMPT_COUNT))
-		preempt_disable();
+	preempt_disable();
 }
 
 static inline void __rcu_read_unlock(void)
 {
-	if (IS_ENABLED(CONFIG_PREEMPT_COUNT))
-		preempt_enable();
+	preempt_enable();
 }
 
 static inline void synchronize_rcu(void)


