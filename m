Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECBCAA6FD6
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731033AbfICQf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:35:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730937AbfICQ1q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:27:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9480238C7;
        Tue,  3 Sep 2019 16:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528065;
        bh=e02ufRmgAN86RUGECAi/L5SoLpjKjenqfajH47AsiOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GTkOK3a+DFHhCE38xgIWU7YwUQOGljKsx1Ao3xuA4L8Z18gBP+jwu+UtEZUOREqr1
         sykhh0hhBHxk4m4hKsoxbmq2x4Dg3BZ5pp3JZpNLTQm6oVru9eGzk7SRJj/mQC5WQE
         mDqHkD4NXw01Q/Y7HfV8IAnFbt0uVj+Q+mSpvtCQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Robertson <dan@dlrobertson.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 080/167] btrfs: init csum_list before possible free
Date:   Tue,  3 Sep 2019 12:23:52 -0400
Message-Id: <20190903162519.7136-80-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Robertson <dan@dlrobertson.com>

[ Upstream commit e49be14b8d80e23bb7c53d78c21717a474ade76b ]

The scrub_ctx csum_list member must be initialized before scrub_free_ctx
is called. If the csum_list is not initialized beforehand, the
list_empty call in scrub_free_csums will result in a null deref if the
allocation fails in the for loop.

Fixes: a2de733c78fa ("btrfs: scrub")
CC: stable@vger.kernel.org # 3.0+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Dan Robertson <dan@dlrobertson.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index a08a4d6f540f9..916c397704679 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -592,6 +592,7 @@ static noinline_for_stack struct scrub_ctx *scrub_setup_ctx(
 	sctx->pages_per_rd_bio = SCRUB_PAGES_PER_RD_BIO;
 	sctx->curr = -1;
 	sctx->fs_info = fs_info;
+	INIT_LIST_HEAD(&sctx->csum_list);
 	for (i = 0; i < SCRUB_BIOS_PER_SCTX; ++i) {
 		struct scrub_bio *sbio;
 
@@ -616,7 +617,6 @@ static noinline_for_stack struct scrub_ctx *scrub_setup_ctx(
 	atomic_set(&sctx->workers_pending, 0);
 	atomic_set(&sctx->cancel_req, 0);
 	sctx->csum_size = btrfs_super_csum_size(fs_info->super_copy);
-	INIT_LIST_HEAD(&sctx->csum_list);
 
 	spin_lock_init(&sctx->list_lock);
 	spin_lock_init(&sctx->stat_lock);
-- 
2.20.1

