Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 228B326DAE
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbfEVTnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:43:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732525AbfEVT2S (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:28:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27EF92173C;
        Wed, 22 May 2019 19:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553297;
        bh=ERZHVPM/ipiu+I2dsGckhp1IVNN9leiDrXwceRtLsZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mbg8SKGWIr3C5TRiIyA1Z1cpUwghmpIzcayZaIzzsNplmJVldTZbeJehHaMCU/Ien
         CXofsBG3OPNuHiaprEZ1BT/1NnJLwW3KH8Ad6PjWjjTxU9C99Di1MZP9139pld5UkN
         AYZQ2V9I89NkPrNQrqwiFYiTK9YE7y3DVRNQvS1I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tang Junhui <tang.junhui.linux@gmail.com>,
        Dennis Schridde <devurandom@gmx.net>, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 068/244] bcache: fix failure in journal relplay
Date:   Wed, 22 May 2019 15:23:34 -0400
Message-Id: <20190522192630.24917-68-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192630.24917-1-sashal@kernel.org>
References: <20190522192630.24917-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tang Junhui <tang.junhui.linux@gmail.com>

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
index 3e9bc9776951b..db3010750f0b9 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -317,6 +317,18 @@ void bch_journal_mark(struct cache_set *c, struct list_head *list)
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
@@ -331,10 +343,15 @@ int bch_journal_replay(struct cache_set *s, struct list_head *list)
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

