Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B694B3EE139
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 02:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237274AbhHQAht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 20:37:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236593AbhHQAgp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 20:36:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E93060EBD;
        Tue, 17 Aug 2021 00:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629160573;
        bh=3LtPGqVFszrceez7FmDhpht4gkC4FP08zQUorIghOx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dshX430cm/vm94xZdTwnP5lNgE6lptZ1q+8oAc4PxGs4k5sAyzVJFO5Nsy9lLTlkg
         IOm4jUSkMArbdp5Xmt/Lwxv/Ws3wMXeLuoUZXf2yWdYVoEF1HSsgMmxsGJcnMch5Pf
         16rQ+Q0T0Y2nZwaZ3L4DklldlvVpD7/cvScIjL5jWYX1w4WTS5Pg4ZUCXg4qNaYhfl
         N5sNxn22K4kn+uonx3rzBO3vT6occwDqBzJDYg8AaL6GxY8lBFHyTcD788eanFlvRL
         IYpJloI+MlSGqSep1oCVXLWRrUR9M8UKt9R/mbPRps/kubAOHzOALBnt/KLU3uyG8L
         pn6WdSmayUwMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kefeng Wang <wangkefeng.wang@huawei.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Minmin chen <chenmingmin@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 4/5] once: Fix panic when module unload
Date:   Mon, 16 Aug 2021 20:36:06 -0400
Message-Id: <20210817003607.83340-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210817003607.83340-1-sashal@kernel.org>
References: <20210817003607.83340-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>

[ Upstream commit 1027b96ec9d34f9abab69bc1a4dc5b1ad8ab1349 ]

DO_ONCE
DEFINE_STATIC_KEY_TRUE(___once_key);
__do_once_done
  once_disable_jump(once_key);
    INIT_WORK(&w->work, once_deferred);
    struct once_work *w;
    w->key = key;
    schedule_work(&w->work);                     module unload
                                                   //*the key is
destroy*
process_one_work
  once_deferred
    BUG_ON(!static_key_enabled(work->key));
       static_key_count((struct static_key *)x)    //*access key, crash*

When module uses DO_ONCE mechanism, it could crash due to the above
concurrency problem, we could reproduce it with link[1].

Fix it by add/put module refcount in the once work process.

[1] https://lore.kernel.org/netdev/eaa6c371-465e-57eb-6be9-f4b16b9d7cbf@huawei.com/

Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Reported-by: Minmin chen <chenmingmin@huawei.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/once.h |  4 ++--
 lib/once.c           | 11 ++++++++---
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/once.h b/include/linux/once.h
index 9225ee6d96c7..ae6f4eb41cbe 100644
--- a/include/linux/once.h
+++ b/include/linux/once.h
@@ -7,7 +7,7 @@
 
 bool __do_once_start(bool *done, unsigned long *flags);
 void __do_once_done(bool *done, struct static_key_true *once_key,
-		    unsigned long *flags);
+		    unsigned long *flags, struct module *mod);
 
 /* Call a function exactly once. The idea of DO_ONCE() is to perform
  * a function call such as initialization of random seeds, etc, only
@@ -46,7 +46,7 @@ void __do_once_done(bool *done, struct static_key_true *once_key,
 			if (unlikely(___ret)) {				     \
 				func(__VA_ARGS__);			     \
 				__do_once_done(&___done, &___once_key,	     \
-					       &___flags);		     \
+					       &___flags, THIS_MODULE);	     \
 			}						     \
 		}							     \
 		___ret;							     \
diff --git a/lib/once.c b/lib/once.c
index 8b7d6235217e..59149bf3bfb4 100644
--- a/lib/once.c
+++ b/lib/once.c
@@ -3,10 +3,12 @@
 #include <linux/spinlock.h>
 #include <linux/once.h>
 #include <linux/random.h>
+#include <linux/module.h>
 
 struct once_work {
 	struct work_struct work;
 	struct static_key_true *key;
+	struct module *module;
 };
 
 static void once_deferred(struct work_struct *w)
@@ -16,10 +18,11 @@ static void once_deferred(struct work_struct *w)
 	work = container_of(w, struct once_work, work);
 	BUG_ON(!static_key_enabled(work->key));
 	static_branch_disable(work->key);
+	module_put(work->module);
 	kfree(work);
 }
 
-static void once_disable_jump(struct static_key_true *key)
+static void once_disable_jump(struct static_key_true *key, struct module *mod)
 {
 	struct once_work *w;
 
@@ -29,6 +32,8 @@ static void once_disable_jump(struct static_key_true *key)
 
 	INIT_WORK(&w->work, once_deferred);
 	w->key = key;
+	w->module = mod;
+	__module_get(mod);
 	schedule_work(&w->work);
 }
 
@@ -53,11 +58,11 @@ bool __do_once_start(bool *done, unsigned long *flags)
 EXPORT_SYMBOL(__do_once_start);
 
 void __do_once_done(bool *done, struct static_key_true *once_key,
-		    unsigned long *flags)
+		    unsigned long *flags, struct module *mod)
 	__releases(once_lock)
 {
 	*done = true;
 	spin_unlock_irqrestore(&once_lock, *flags);
-	once_disable_jump(once_key);
+	once_disable_jump(once_key, mod);
 }
 EXPORT_SYMBOL(__do_once_done);
-- 
2.30.2

