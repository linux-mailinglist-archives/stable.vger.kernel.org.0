Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10BC32EE4B
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732394AbfE3DqJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:46:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732304AbfE3DUn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:20:43 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CE1124953;
        Thu, 30 May 2019 03:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186443;
        bh=NqJj2wnZvb0IFFyMryiYTUFUXDNh3Tw4qJpTYYZ12lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=teeYMT3sJYSoXWmqcBrzczSMAvr7uxb1g3VtCvrjL96IUJOhnIzFPLeYMg6I088jk
         U6YCOU7KJ9jTBKjcNjJz9FkQpqf+K3x8xWTN2+D9J/fe0ph+Osc5kgxuO5xchD1EuR
         qxEfKAlP+FsfP/hB91VT1PlXpsTGiHrF3xPMJv0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tang Junhui <tang.junhui.linux@gmail.com>,
        Dennis Schridde <devurandom@gmx.net>, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 047/128] bcache: fix failure in journal relplay
Date:   Wed, 29 May 2019 20:06:19 -0700
Message-Id: <20190530030443.174490450@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030432.977908967@linuxfoundation.org>
References: <20190530030432.977908967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 631207314d88e9091be02fbdd1fdadb1ae2ed79a ]

journal replay failed with messages:
Sep 10 19:10:43 ceph kernel: bcache: error on
bb379a64-e44e-4812-b91d-a5599871a3b1: bcache: journal entries
2057493-2057567 missing! (replaying 2057493-2076601), disabling
caching

The reason is in journal_reclaim(), when discard is enabled, we send
discard command and reclaim those journal buckets whose seq is old
than the last_seq_now, but before we write a journal with last_seq_now,
the machine is restarted, so the journal with the last_seq_now is not
written to the journal bucket, and the last_seq_wrote in the newest
journal is old than last_seq_now which we expect to be, so when we doing
replay, journals from last_seq_wrote to last_seq_now are missing.

It's hard to write a journal immediately after journal_reclaim(),
and it harmless if those missed journal are caused by discarding
since those journals are already wrote to btree node. So, if miss
seqs are started from the beginning journal, we treat it as normal,
and only print a message to show the miss journal, and point out
it maybe caused by discarding.

Patch v2 add a judgement condition to ignore the missed journal
only when discard enabled as Coly suggested.

(Coly Li: rebase the patch with other changes in bch_journal_replay())

Signed-off-by: Tang Junhui <tang.junhui.linux@gmail.com>
Tested-by: Dennis Schridde <devurandom@gmx.net>
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/journal.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index f8ae7ce29809d..6ee5370eb9169 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -309,6 +309,18 @@ void bch_journal_mark(struct cache_set *c, struct list_head *list)
 	}
 }
 
+bool is_discard_enabled(struct cache_set *s)
+{
+	struct cache *ca;
+	unsigned int i;
+
+	for_each_cache(ca, s, i)
+		if (ca->discard)
+			return true;
+
+	return false;
+}
+
 int bch_journal_replay(struct cache_set *s, struct list_head *list)
 {
 	int ret = 0, keys = 0, entries = 0;
@@ -323,10 +335,15 @@ int bch_journal_replay(struct cache_set *s, struct list_head *list)
 		BUG_ON(i->pin && atomic_read(i->pin) != 1);
 
 		if (n != i->j.seq) {
-			pr_err("bcache: journal entries %llu-%llu missing! (replaying %llu-%llu)",
-			n, i->j.seq - 1, start, end);
-			ret = -EIO;
-			goto err;
+			if (n == start && is_discard_enabled(s))
+				pr_info("bcache: journal entries %llu-%llu may be discarded! (replaying %llu-%llu)",
+					n, i->j.seq - 1, start, end);
+			else {
+				pr_err("bcache: journal entries %llu-%llu missing! (replaying %llu-%llu)",
+					n, i->j.seq - 1, start, end);
+				ret = -EIO;
+				goto err;
+			}
 		}
 
 		for (k = i->j.start;
-- 
2.20.1



