Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA4DBA6FF5
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730939AbfICQ1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:27:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730429AbfICQ1n (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:27:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6724238CD;
        Tue,  3 Sep 2019 16:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528062;
        bh=5ZT2XI1WUbOsdYDUfs/eoI2vbKjG89YMBIlt1zsysqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FD2+wtMvMtBJgBnHkZbDtRB39Sh+xxvkadK01PQU1z8LnyEB7liS+RHGENWvoMw3i
         2hImcR8xDuGIA32LDj0O9tt/JT6kgvmQmz9qYxodN/nKIpyl1wdjjfPm5aiUgGS5DK
         XgSmRlZFAVSRpbLM6DT20CLwMzmvFjGBPJMMvOy8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>,
        Nikolay Borisov <nborisov@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 077/167] btrfs: scrub: pass fs_info to scrub_setup_ctx
Date:   Tue,  3 Sep 2019 12:23:49 -0400
Message-Id: <20190903162519.7136-77-sashal@kernel.org>
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

From: David Sterba <dsterba@suse.com>

[ Upstream commit 92f7ba434f51e8e9317f1d166105889aa230abd2 ]

We can pass fs_info directly as this is the only member of btrfs_device
that's bing used inside scrub_setup_ctx.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 5a2d10ba747f7..efaad3e1b295a 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -578,12 +578,11 @@ static void scrub_put_ctx(struct scrub_ctx *sctx)
 		scrub_free_ctx(sctx);
 }
 
-static noinline_for_stack
-struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
+static noinline_for_stack struct scrub_ctx *scrub_setup_ctx(
+		struct btrfs_fs_info *fs_info, int is_dev_replace)
 {
 	struct scrub_ctx *sctx;
 	int		i;
-	struct btrfs_fs_info *fs_info = dev->fs_info;
 
 	sctx = kzalloc(sizeof(*sctx), GFP_KERNEL);
 	if (!sctx)
@@ -592,7 +591,7 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
 	sctx->is_dev_replace = is_dev_replace;
 	sctx->pages_per_rd_bio = SCRUB_PAGES_PER_RD_BIO;
 	sctx->curr = -1;
-	sctx->fs_info = dev->fs_info;
+	sctx->fs_info = fs_info;
 	for (i = 0; i < SCRUB_BIOS_PER_SCTX; ++i) {
 		struct scrub_bio *sbio;
 
@@ -3881,7 +3880,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		return ret;
 	}
 
-	sctx = scrub_setup_ctx(dev, is_dev_replace);
+	sctx = scrub_setup_ctx(fs_info, is_dev_replace);
 	if (IS_ERR(sctx)) {
 		mutex_unlock(&fs_info->scrub_lock);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
-- 
2.20.1

