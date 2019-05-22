Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A46226C35
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387712AbfEVTcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:32:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733262AbfEVTb5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:31:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15DC820879;
        Wed, 22 May 2019 19:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553516;
        bh=SOMs7+1znrI6ll6shOjumvZsM00dYP1PoUhwKlXFbmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ncbRpsZY0XMoOOAfsOM/bBSVcAB5WkF6FXM0lvkG7uxoRX6t9qhZNUigAV8PKkEq4
         aYJx1AeA9OvGwDl2ZZMmvGJIuPCcMQDz7g2J24U8tWN3jVgxvI5L6SLnHBxaDD+Qy3
         dPCbTKi5vLb/5GlaYQtanZJTA5YPtQ1PI/Yhfrdk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 20/92] bcache: add failure check to run_cache_set() for journal replay
Date:   Wed, 22 May 2019 15:30:15 -0400
Message-Id: <20190522193127.27079-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522193127.27079-1-sashal@kernel.org>
References: <20190522193127.27079-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

[ Upstream commit ce3e4cfb59cb382f8e5ce359238aa580d4ae7778 ]

Currently run_cache_set() has no return value, if there is failure in
bch_journal_replay(), the caller of run_cache_set() has no idea about
such failure and just continue to execute following code after
run_cache_set().  The internal failure is triggered inside
bch_journal_replay() and being handled in async way. This behavior is
inefficient, while failure handling inside bch_journal_replay(), cache
register code is still running to start the cache set. Registering and
unregistering code running as same time may introduce some rare race
condition, and make the code to be more hard to be understood.

This patch adds return value to run_cache_set(), and returns -EIO if
bch_journal_rreplay() fails. Then caller of run_cache_set() may detect
such failure and stop registering code flow immedidately inside
register_cache_set().

If journal replay fails, run_cache_set() can report error immediately
to register_cache_set(). This patch makes the failure handling for
bch_journal_replay() be in synchronized way, easier to understand and
debug, and avoid poetential race condition for register-and-unregister
in same time.

Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/super.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index ef28ddfff7c61..420877cabd2fc 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1558,7 +1558,7 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 	return NULL;
 }
 
-static void run_cache_set(struct cache_set *c)
+static int run_cache_set(struct cache_set *c)
 {
 	const char *err = "cannot allocate memory";
 	struct cached_dev *dc, *t;
@@ -1650,7 +1650,9 @@ static void run_cache_set(struct cache_set *c)
 		if (j->version < BCACHE_JSET_VERSION_UUID)
 			__uuid_write(c);
 
-		bch_journal_replay(c, &journal);
+		err = "bcache: replay journal failed";
+		if (bch_journal_replay(c, &journal))
+			goto err;
 	} else {
 		pr_notice("invalidating existing data");
 
@@ -1718,11 +1720,13 @@ static void run_cache_set(struct cache_set *c)
 	flash_devs_run(c);
 
 	set_bit(CACHE_SET_RUNNING, &c->flags);
-	return;
+	return 0;
 err:
 	closure_sync(&cl);
 	/* XXX: test this, it's broken */
 	bch_cache_set_error(c, "%s", err);
+
+	return -EIO;
 }
 
 static bool can_attach_cache(struct cache *ca, struct cache_set *c)
@@ -1786,8 +1790,11 @@ static const char *register_cache_set(struct cache *ca)
 	ca->set->cache[ca->sb.nr_this_dev] = ca;
 	c->cache_by_alloc[c->caches_loaded++] = ca;
 
-	if (c->caches_loaded == c->sb.nr_in_set)
-		run_cache_set(c);
+	if (c->caches_loaded == c->sb.nr_in_set) {
+		err = "failed to run cache set";
+		if (run_cache_set(c) < 0)
+			goto err;
+	}
 
 	return NULL;
 err:
-- 
2.20.1

