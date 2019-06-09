Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2F63A90B
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388081AbfFIRGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:06:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388593AbfFIRGw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:06:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 049AB204EC;
        Sun,  9 Jun 2019 17:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560100011;
        bh=PPDd01SnKCTX+qaPrXkqMKAY1LtNfCiWQRkPUp2Nom0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=02s0jGg6livpjCUKqCzCjmHW4QYaMmi9/6+ZVOEcQE1rMPbsTWa+qZ17i36+YWdyK
         9X+Hi9pimro1wkuU6ViazxqbkyXXB4ZSXZpcYSTuckmVuAqd61xWOSAUSljNsY989K
         /ssW0dalrWXWvNU8QdvgZdQi92PU1RWu2EkEVlg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        stable@kernel.org, Boqun Feng <boqun.feng@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 234/241] rcu: locking and unlocking need to always be at least barriers
Date:   Sun,  9 Jun 2019 18:42:56 +0200
Message-Id: <20190609164155.511875733@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
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
@@ -297,14 +297,12 @@ void synchronize_rcu(void);
 
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


