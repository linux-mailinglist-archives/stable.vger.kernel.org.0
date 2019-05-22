Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C716F26C81
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729752AbfEVTfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:35:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731454AbfEVTbB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:31:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31AC72177E;
        Wed, 22 May 2019 19:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553460;
        bh=EzDvjiOKCt9srdFonuBsCOG/U/jBGJTpvtnrW2mvkZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NEfUks34yZ75Vwqd5lwtcHgmFlt1ExjRtSzbD7QyrkOwHUmZiYVSim5wZo+Y5EWIX
         LHcTX/3gD+xtG0/VaYWpIR6VNZ1TmzLoPrvwws58cUdIOjFmRX9z1M3fRq+9zs7RK3
         kI+fKsmlmcN7xPkF8qxEdjW1xv2q9LJlM5PFfRc0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, Hannes Reinecke <hare@suse.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 028/114] bcache: return error immediately in bch_journal_replay()
Date:   Wed, 22 May 2019 15:28:51 -0400
Message-Id: <20190522193017.26567-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522193017.26567-1-sashal@kernel.org>
References: <20190522193017.26567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

[ Upstream commit 68d10e6979a3b59e3cd2e90bfcafed79c4cf180a ]

When failure happens inside bch_journal_replay(), calling
cache_set_err_on() and handling the failure in async way is not a good
idea. Because after bch_journal_replay() returns, registering code will
continue to execute following steps, and unregistering code triggered
by cache_set_err_on() is running in same time. First it is unnecessary
to handle failure and unregister cache set in an async way, second there
might be potential race condition to run register and unregister code
for same cache set.

So in this patch, if failure happens in bch_journal_replay(), we don't
call cache_set_err_on(), and just print out the same error message to
kernel message buffer, then return -EIO immediately caller. Then caller
can detect such failure and handle it in synchrnozied way.

Signed-off-by: Coly Li <colyli@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/journal.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 08f20b7cd1999..8b3f76e1075ea 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -322,9 +322,12 @@ int bch_journal_replay(struct cache_set *s, struct list_head *list)
 	list_for_each_entry(i, list, list) {
 		BUG_ON(i->pin && atomic_read(i->pin) != 1);
 
-		cache_set_err_on(n != i->j.seq, s,
-"bcache: journal entries %llu-%llu missing! (replaying %llu-%llu)",
-				 n, i->j.seq - 1, start, end);
+		if (n != i->j.seq) {
+			pr_err("bcache: journal entries %llu-%llu missing! (replaying %llu-%llu)",
+			n, i->j.seq - 1, start, end);
+			ret = -EIO;
+			goto err;
+		}
 
 		for (k = i->j.start;
 		     k < bset_bkey_last(&i->j);
-- 
2.20.1

