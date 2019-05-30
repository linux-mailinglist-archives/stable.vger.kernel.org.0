Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2E8B2EF3A
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732595AbfE3Dxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:53:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730540AbfE3DT2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:19:28 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D14182488A;
        Thu, 30 May 2019 03:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186367;
        bh=uXUyQnom1ZyT0LjF8TENhfFmRzHTBOF3OVN24+Bvjno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JeZHt450OifOtizEOFEUDOxF0VxcpPcEBKy0gUmAEhlIQh996blvYpu8FspOT7DPq
         5ladBs6tHJYbflLYy/qPc3dG2bKGgSqIjOqtrJw2lXcGvswQVIjPYAuvbjipOiguFT
         uzBGDh/KfDVHSkHI23GbkDl4kE3UbevyhJd5vHeM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 075/193] bcache: add failure check to run_cache_set() for journal replay
Date:   Wed, 29 May 2019 20:05:29 -0700
Message-Id: <20190530030459.667354211@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 175bab2d72067..85a5afe01d397 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1560,7 +1560,7 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 	return NULL;
 }
 
-static void run_cache_set(struct cache_set *c)
+static int run_cache_set(struct cache_set *c)
 {
 	const char *err = "cannot allocate memory";
 	struct cached_dev *dc, *t;
@@ -1652,7 +1652,9 @@ static void run_cache_set(struct cache_set *c)
 		if (j->version < BCACHE_JSET_VERSION_UUID)
 			__uuid_write(c);
 
-		bch_journal_replay(c, &journal);
+		err = "bcache: replay journal failed";
+		if (bch_journal_replay(c, &journal))
+			goto err;
 	} else {
 		pr_notice("invalidating existing data");
 
@@ -1720,11 +1722,13 @@ static void run_cache_set(struct cache_set *c)
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
@@ -1788,8 +1792,11 @@ static const char *register_cache_set(struct cache *ca)
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



