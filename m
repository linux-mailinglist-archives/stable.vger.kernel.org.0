Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B12CD599D4
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 14:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfF1MBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 08:01:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:54690 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726991AbfF1MBe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jun 2019 08:01:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E10E0B62B;
        Fri, 28 Jun 2019 12:01:32 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, stable@vger.kernel.org
Subject: [PATCH 21/37] bcache: destroy dc->writeback_write_wq if failed to create dc->writeback_thread
Date:   Fri, 28 Jun 2019 19:59:44 +0800
Message-Id: <20190628120000.40753-22-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190628120000.40753-1-colyli@suse.de>
References: <20190628120000.40753-1-colyli@suse.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 9baf30972b55 ("bcache: fix for gc and write-back race") added a
new work queue dc->writeback_write_wq, but forgot to destroy it in the
error condition when creating dc->writeback_thread failed.

This patch destroys dc->writeback_write_wq if kthread_create() returns
error pointer to dc->writeback_thread, then a memory leak is avoided.

Fixes: 9baf30972b55 ("bcache: fix for gc and write-back race")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org
---
 drivers/md/bcache/writeback.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 262f7ef20992..21081febcb59 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -833,6 +833,7 @@ int bch_cached_dev_writeback_start(struct cached_dev *dc)
 					      "bcache_writeback");
 	if (IS_ERR(dc->writeback_thread)) {
 		cached_dev_put(dc);
+		destroy_workqueue(dc->writeback_write_wq);
 		return PTR_ERR(dc->writeback_thread);
 	}
 	dc->writeback_running = true;
-- 
2.16.4

