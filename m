Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCFD2EB29
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbfE3DK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:10:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727394AbfE3DK3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:29 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25E04244B0;
        Thu, 30 May 2019 03:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185828;
        bh=rvfR1R9LhqYoocQOPnB7UbHAO0dewm2JT9fMJSFrmb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gofkOhRbsoaUXZCN1JkMx3XiQ/j7vZjT8ykZMz2uNer+VKcDTVczjSlNr2OwcWt77
         lgTwjcx9k1EzxdweyjqJGnPUDVrUyG2x1wqB/l1QIalFxcbpvo8wXXabr3rf9B+R6H
         waYOvUni6lkHvZB69Y1iQWIz/5oo7VRgC2JM7xms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shenghui Wang <shhuiw@foxmail.com>,
        Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 129/405] bcache: avoid potential memleak of list of journal_replay(s) in the CACHE_SYNC branch of run_cache_set
Date:   Wed, 29 May 2019 20:02:07 -0700
Message-Id: <20190530030547.587748800@linuxfoundation.org>
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
index 171d5e0f698ba..5c9751e9a76a4 100644
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



