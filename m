Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C238E599E9
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 14:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfF1MCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 08:02:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:54908 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726807AbfF1MCN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jun 2019 08:02:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B07E2B627;
        Fri, 28 Jun 2019 12:02:11 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, stable@vger.kernel.org,
        Shenghui Wang <shhuiw@foxmail.com>
Subject: [PATCH 30/37] bcache: Revert "bcache: free heap cache_set->flush_btree in bch_journal_free"
Date:   Fri, 28 Jun 2019 19:59:53 +0800
Message-Id: <20190628120000.40753-31-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190628120000.40753-1-colyli@suse.de>
References: <20190628120000.40753-1-colyli@suse.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 6268dc2c4703aabfb0b35681be709acf4c2826c6.

This patch depends on commit c4dc2497d50d ("bcache: fix high CPU
occupancy during journal") which is reverted in previous patch. So
revert this one too.

Fixes: 6268dc2c4703 ("bcache: free heap cache_set->flush_btree in bch_journal_free")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org
Cc: Shenghui Wang <shhuiw@foxmail.com>
---
 drivers/md/bcache/journal.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 3d321bffddc9..11d8c93b88bb 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -884,7 +884,6 @@ void bch_journal_free(struct cache_set *c)
 	free_pages((unsigned long) c->journal.w[1].data, JSET_BITS);
 	free_pages((unsigned long) c->journal.w[0].data, JSET_BITS);
 	free_fifo(&c->journal.pin);
-	free_heap(&c->flush_btree);
 }
 
 int bch_journal_alloc(struct cache_set *c)
-- 
2.16.4

