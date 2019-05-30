Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0565C2F636
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbfE3DKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:10:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728110AbfE3DKa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:30 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CB98244BD;
        Thu, 30 May 2019 03:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185828;
        bh=ViJJxfwoeOoIKdA6xR1sJeWRkJkUY+x4Dz0tnOwqoZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1+2st6eRmL0hcDLf5ZzXAz5RdlTj6/scWsTxhoVv1QDQb8i1RY7HG2G/YBFvHTM4F
         mamDtaaj2QccsJQxWoEvlJ0WK57Gdcj/Js4giOh61z9k/UZgJXlLUXD9tnIzigCQmt
         RFFe/k557yseJg6jAco7TYIX/vAcOm23LdkOY12o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Hannes Reinecke <hare@suse.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 130/405] bcache: return error immediately in bch_journal_replay()
Date:   Wed, 29 May 2019 20:02:08 -0700
Message-Id: <20190530030547.641187086@linuxfoundation.org>
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
index d3725c17ce3a6..9e557164209c1 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -330,9 +330,12 @@ int bch_journal_replay(struct cache_set *s, struct list_head *list)
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



