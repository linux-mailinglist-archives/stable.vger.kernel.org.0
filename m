Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21F2226EE1
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731802AbfEVTZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:25:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731795AbfEVTZ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:25:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1165217D9;
        Wed, 22 May 2019 19:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553156;
        bh=hBlKe4K4XFUtSs9+ogjc+xptZwgqZ4x7JVDLIJz+5so=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0EeycQYkAzVFfGpAXmEWtoJ5Gyaq2LBH3FlWFH+5YeeVX16X+OW3vT5+FllDUsQM8
         WbRF3nAPj5iQ7ZkiM1/ZA5R456eGpl9XizjqbRzu/4zYzVGwFEgXb5VKpGqv6IjnKc
         U7VDsQVTgIGV9qn/pzKhiBGWEae7GGokOCGgQlmo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shenghui Wang <shhuiw@foxmail.com>, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 083/317] bcache: avoid potential memleak of list of journal_replay(s) in the CACHE_SYNC branch of run_cache_set
Date:   Wed, 22 May 2019 15:19:44 -0400
Message-Id: <20190522192338.23715-83-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192338.23715-1-sashal@kernel.org>
References: <20190522192338.23715-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shenghui Wang <shhuiw@foxmail.com>

[ Upstream commit 95f18c9d1310730d075499a75aaf13bcd60405a7 ]

In the CACHE_SYNC branch of run_cache_set(), LIST_HEAD(journal) is used
to collect journal_replay(s) and filled by bch_journal_read().

If all goes well, bch_journal_replay() will release the list of
jounal_replay(s) at the end of the branch.

If something goes wrong, code flow will jump to the label "err:" and leave
the list unreleased.

This patch will release the list of journal_replay(s) in the case of
error detected.

v1 -> v2:
* Move the release code to the location after label 'err:' to
  simply the change.

Signed-off-by: Shenghui Wang <shhuiw@foxmail.com>
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/super.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 4dee119c36646..7adafe8488273 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1782,6 +1782,8 @@ static void run_cache_set(struct cache_set *c)
 	struct cache *ca;
 	struct closure cl;
 	unsigned int i;
+	LIST_HEAD(journal);
+	struct journal_replay *l;
 
 	closure_init_stack(&cl);
 
@@ -1939,6 +1941,12 @@ static void run_cache_set(struct cache_set *c)
 	set_bit(CACHE_SET_RUNNING, &c->flags);
 	return;
 err:
+	while (!list_empty(&journal)) {
+		l = list_first_entry(&journal, struct journal_replay, list);
+		list_del(&l->list);
+		kfree(l);
+	}
+
 	closure_sync(&cl);
 	/* XXX: test this, it's broken */
 	bch_cache_set_error(c, "%s", err);
-- 
2.20.1

