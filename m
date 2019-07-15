Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6F9568F64
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389287AbfGOOOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:14:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388947AbfGOOOG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:14:06 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BE592081C;
        Mon, 15 Jul 2019 14:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200045;
        bh=TfVJwqEhKVcrhrXorGrG1M0YxCr2T8aqpxLOONU0Ry8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NnVekSI5uzDF/uNeL0ayeA17UZzHaziK0JLyiFhEz5qww5OUAz+j/rPlO6LN9FMui
         MJqsEv5B2+de1mApEAB389/tTMVAEK60Y7jmeD+eKCSqRuynqNFphF7xoYMJkOrRgu
         Q8UakOVRxYcV0aSS8deqSQ/3oyJqs7bIVA5PPOFE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 169/219] bcache: check CACHE_SET_IO_DISABLE bit in bch_journal()
Date:   Mon, 15 Jul 2019 10:02:50 -0400
Message-Id: <20190715140341.6443-169-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
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
index 6c94fa007796..ac3cec56ec19 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -810,6 +810,10 @@ atomic_t *bch_journal(struct cache_set *c,
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

