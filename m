Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85DC3696F2
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733148AbfGON61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:58:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732354AbfGON6Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:58:24 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E8CE21530;
        Mon, 15 Jul 2019 13:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199103;
        bh=n9OB8C/QSgsmASsTcku7ms9C85frcTqSO2uTo7P4BuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FBYG/98Vd/shnBqKlqm9HWiDNg9PD3ZWGsoWckrl+GrBmFnkr1NaKiadzspv7vQ6X
         zcs5WQ+u7IJGSlsyvFvP20Dol+ATK3TmYvaI5uM1EknViU0Xf/umFMuCBaPA3W7K/8
         +0Gnw1/B/i07kXuWGIAH/UIe4ApimVmyA2q2AeGk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 194/249] bcache: check CACHE_SET_IO_DISABLE bit in bch_journal()
Date:   Mon, 15 Jul 2019 09:45:59 -0400
Message-Id: <20190715134655.4076-194-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

[ Upstream commit 383ff2183ad16a8842d1fbd9dd3e1cbd66813e64 ]

When too many I/O errors happen on cache set and CACHE_SET_IO_DISABLE
bit is set, bch_journal() may continue to work because the journaling
bkey might be still in write set yet. The caller of bch_journal() may
believe the journal still work but the truth is in-memory journal write
set won't be written into cache device any more. This behavior may
introduce potential inconsistent metadata status.

This patch checks CACHE_SET_IO_DISABLE bit at the head of bch_journal(),
if the bit is set, bch_journal() returns NULL immediately to notice
caller to know journal does not work.

Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/journal.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 4e5fc05720fc..54f8886b6177 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -811,6 +811,10 @@ atomic_t *bch_journal(struct cache_set *c,
 	struct journal_write *w;
 	atomic_t *ret;
 
+	/* No journaling if CACHE_SET_IO_DISABLE set already */
+	if (unlikely(test_bit(CACHE_SET_IO_DISABLE, &c->flags)))
+		return NULL;
+
 	if (!CACHE_SYNC(&c->sb))
 		return NULL;
 
-- 
2.20.1

